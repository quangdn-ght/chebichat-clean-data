const { createClient } = require('@supabase/supabase-js');
const fs = require('fs').promises;
const path = require('path');
require('dotenv').config();

// Configuration
const supabaseUrl = process.env.SUPABASE_URL || 'your-supabase-url';
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'your-supabase-anon-key';

/**
 * Setup script for radicals poem schema
 */
class RadicalsPoemSetup {
  constructor() {
    this.supabase = createClient(supabaseUrl, supabaseKey);
  }

  /**
   * Check if environment variables are set
   */
  checkEnvironment() {
    console.log('🔍 Checking environment configuration...');
    
    if (!process.env.SUPABASE_URL || process.env.SUPABASE_URL === 'your-supabase-url') {
      throw new Error('SUPABASE_URL environment variable is not set');
    }
    
    if (!process.env.SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY === 'your-supabase-anon-key') {
      throw new Error('SUPABASE_ANON_KEY environment variable is not set');
    }
    
    console.log('✅ Environment variables configured');
  }

  /**
   * Test database connection
   */
  async testConnection() {
    console.log('🔗 Testing database connection...');
    
    try {
      const { data, error } = await this.supabase
        .from('pg_tables')
        .select('tablename')
        .limit(1);

      if (error) {
        throw new Error(`Connection failed: ${error.message}`);
      }

      console.log('✅ Database connection successful');
    } catch (error) {
      throw new Error(`Database connection failed: ${error.message}`);
    }
  }

  /**
   * Check if schema exists
   */
  async checkSchema() {
    console.log('📋 Checking schema status...');
    
    try {
      const { data, error } = await this.supabase
        .from('radicals_poem')
        .select('chinese')
        .limit(1);

      if (error && error.code === 'PGRST116') {
        console.log('⚠️  Schema not found. Please run the schema creation script first.');
        console.log('   1. Open Supabase SQL Editor');
        console.log('   2. Run db/radicals_poem_schema.sql');
        console.log('   3. Run db/import_functions.sql');
        return false;
      }

      if (error) {
        throw new Error(`Schema check failed: ${error.message}`);
      }

      console.log('✅ Schema exists and accessible');
      return true;
    } catch (error) {
      throw new Error(`Schema check error: ${error.message}`);
    }
  }

  /**
   * Check data status
   */
  async checkData() {
    console.log('📊 Checking data status...');
    
    try {
      const { data, error } = await this.supabase
        .from('radicals_poem')
        .select('chinese, created_at', { count: 'exact' });

      if (error) {
        throw new Error(`Data check failed: ${error.message}`);
      }

      console.log(`📈 Found ${data?.length || 0} radicals in database`);
      
      if (data && data.length > 0) {
        const oldestEntry = new Date(Math.min(...data.map(d => new Date(d.created_at))));
        const newestEntry = new Date(Math.max(...data.map(d => new Date(d.created_at))));
        
        console.log(`   Oldest entry: ${oldestEntry.toLocaleDateString()}`);
        console.log(`   Newest entry: ${newestEntry.toLocaleDateString()}`);
      }

      return data?.length || 0;
    } catch (error) {
      throw new Error(`Data check error: ${error.message}`);
    }
  }

  /**
   * Check source file
   */
  async checkSourceFile() {
    console.log('📁 Checking source data file...');
    
    const jsonPath = path.join(__dirname, 'import/merged_radicals.json');
    
    try {
      await fs.access(jsonPath);
      const content = await fs.readFile(jsonPath, 'utf8');
      const data = JSON.parse(content);
      
      console.log(`✅ Source file found: ${Object.keys(data).length} entries`);
      console.log(`   File path: ${jsonPath}`);
      
      // Show sample entries
      const samples = Object.entries(data).slice(0, 3);
      samples.forEach(([char, desc]) => {
        console.log(`   Sample: ${char} - ${desc.substring(0, 30)}...`);
      });
      
      return Object.keys(data).length;
    } catch (error) {
      if (error.code === 'ENOENT') {
        console.log('⚠️  Source file not found:');
        console.log(`   Expected: ${jsonPath}`);
        console.log('   Please ensure merged_radicals.json exists in the import directory');
        return 0;
      }
      throw new Error(`Source file check failed: ${error.message}`);
    }
  }

  /**
   * Provide setup recommendations
   */
  async getRecommendations(schemaExists, dataCount, sourceCount) {
    console.log('\n💡 Setup Recommendations:');
    
    if (!schemaExists) {
      console.log('1. 🚨 Create database schema first:');
      console.log('   - Open Supabase SQL Editor');
      console.log('   - Run: db/radicals_poem_schema.sql');
      console.log('   - Run: db/import_functions.sql');
      return;
    }

    if (dataCount === 0 && sourceCount > 0) {
      console.log('1. 📥 Import data:');
      console.log('   - Run: npm run import');
    } else if (dataCount > 0 && sourceCount > dataCount) {
      console.log('1. 🔄 Update data (source has more entries):');
      console.log('   - Run: npm run import');
    } else if (dataCount > 0) {
      console.log('1. ✅ Data is up to date');
    }

    console.log('2. 🧪 Test the setup:');
    console.log('   - Run: npm test');
    
    if (dataCount > 0) {
      console.log('3. 🔍 Try some queries:');
      console.log('   - Search by description: search_radicals_by_description(\'vàng\')');
      console.log('   - Get by character: get_radical_by_chinese(\'黄\')');
      console.log('   - View statistics: SELECT * FROM radicals_poem_stats;');
    }
  }

  /**
   * Run complete setup check
   */
  async run() {
    console.log('🚀 Radicals Poem Schema Setup Check');
    console.log('===================================\n');

    try {
      // Environment check
      this.checkEnvironment();
      
      // Connection test
      await this.testConnection();
      
      // Schema check
      const schemaExists = await this.checkSchema();
      
      // Data check
      const dataCount = await this.checkData();
      
      // Source file check
      const sourceCount = await this.checkSourceFile();
      
      // Recommendations
      await this.getRecommendations(schemaExists, dataCount, sourceCount);
      
      console.log('\n🎉 Setup check completed successfully!');
      
      return {
        schemaExists,
        dataCount,
        sourceCount,
        ready: schemaExists && dataCount > 0
      };
      
    } catch (error) {
      console.error('\n💥 Setup check failed:', error.message);
      console.log('\n🛠️  Troubleshooting:');
      console.log('1. Check your .env file has correct Supabase credentials');
      console.log('2. Ensure your Supabase project is active');
      console.log('3. Verify you have the necessary permissions');
      process.exit(1);
    }
  }
}

// Main execution
async function main() {
  const setup = new RadicalsPoemSetup();
  await setup.run();
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = RadicalsPoemSetup;
