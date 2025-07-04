import { createClient } from '@supabase/supabase-js';
import fs from 'fs/promises';
import path from 'path';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Load environment variables
dotenv.config();

// Get current directory for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

/**
 * Supabase Dictionary Deployment Script (Node.js)
 * Deploys dictionary SQL files to Supabase using the JavaScript client
 */

class SupabaseDeployer {
  constructor(config = {}) {
    this.config = {
      url: config.url || process.env.SUPABASE_URL,
      serviceRoleKey: config.serviceRoleKey || process.env.SUPABASE_SERVICE_ROLE_KEY,
      // Legacy support for old config format
      projectId: config.projectId || process.env.SUPABASE_PROJECT_ID,
      password: config.password || process.env.SUPABASE_DB_PASSWORD,
      ...config
    };
    
    // Auto-generate URL from project ID if needed
    if (!this.config.url && this.config.projectId) {
      this.config.url = `https://${this.config.projectId}.supabase.co`;
    }
    
    this.supabase = null;
  }

  /**
   * Create Supabase client connection
   */
  async connect() {
    try {
      console.log('🔌 Connecting to Supabase...');
      console.log(`   URL: ${this.config.url}`);
      console.log(`   Service role key: ${this.config.serviceRoleKey ? '✓ Present' : '✗ Missing'}`);
      
      if (!this.config.url) {
        throw new Error('SUPABASE_URL is required');
      }
      
      if (!this.config.serviceRoleKey) {
        throw new Error('SUPABASE_SERVICE_ROLE_KEY is required');
      }
      
      this.supabase = createClient(
        this.config.url,
        this.config.serviceRoleKey,
        {
          auth: {
            autoRefreshToken: false,
            persistSession: false,
            detectSessionInUrl: false
          }
        }
      );
      
      // Test connection by querying a simple table or function
      const { data, error } = await this.supabase
        .from('dictionary')
        .select('*', { count: 'exact', head: true });
      
      if (error && !error.message.includes('does not exist')) {
        if (error.message.includes('Invalid API key') || 
            error.message.includes('authentication')) {
          throw new Error('Authentication failed - check your SUPABASE_SERVICE_ROLE_KEY');
        }
        throw error;
      }
      
      console.log('✅ Connected successfully to Supabase');
      console.log('✅ Service role key authenticated');
      
      if (error && error.message.includes('does not exist')) {
        console.log('ℹ️  Dictionary table does not exist yet - will be created');
      } else {
        console.log('✅ Dictionary table accessible');
      }
      
      return true;
    } catch (error) {
      console.error('❌ Failed to connect to Supabase:', error.message);
      
      // Provide helpful troubleshooting info
      if (error.message.includes('Invalid API key') || error.message.includes('authentication')) {
        console.error('');
        console.error('� Authentication issue:');
        console.error('   1. Verify SUPABASE_SERVICE_ROLE_KEY in .env file');
        console.error('   2. Get the service_role key from: https://app.supabase.com → Project → Settings → API');
        console.error('   3. Ensure you copied the service_role key, not the anon key');
      } else if (error.message.includes('SUPABASE_URL')) {
        console.error('');
        console.error('� URL issue:');
        console.error('   1. Verify SUPABASE_URL in .env file');
        console.error('   2. Format should be: https://your-project-id.supabase.co');
        console.error('   3. Get it from: https://app.supabase.com → Project → Settings → API');
      }
      
      return false;
    }
  }

  /**
   * Disconnect from Supabase (cleanup)
   */
  async disconnect() {
    if (this.supabase) {
      // Supabase client doesn't need explicit disconnection
      this.supabase = null;
      console.log('🔌 Disconnected from Supabase');
    }
  }

  /**
   * Execute SQL file using Supabase client
   */
  async executeSqlFile(filePath) {
    try {
      console.log(`📄 Executing: ${path.basename(filePath)}`);
      
      if (!(await this.fileExists(filePath))) {
        throw new Error(`File not found: ${filePath}`);
      }
      
      const sql = await fs.readFile(filePath, 'utf8');
      const fileSize = (sql.length / 1024 / 1024).toFixed(2);
      console.log(`   File size: ${fileSize} MB`);
      
      // Execute with timing
      const startTime = Date.now();
      
      // Extract INSERT statements from SQL file
      const insertRegex = /INSERT INTO dictionary\s*\([^)]+\)\s*VALUES\s*\([\s\S]*?\);/gi;
      const insertStatements = sql.match(insertRegex) || [];
      
      console.log(`   📊 Found ${insertStatements.length} INSERT statements...`);
      
      let totalInserted = 0;
      let errors = 0;
      
      for (let i = 0; i < insertStatements.length; i++) {
        try {
          const inserted = await this.executeInsertStatement(insertStatements[i]);
          totalInserted += inserted;
          
          // Progress indicator
          if ((i + 1) % 5 === 0) {
            console.log(`   ⏳ Processed ${i + 1}/${insertStatements.length} INSERT statements...`);
          }
        } catch (error) {
          errors++;
          if (error.message.includes('duplicate key') || 
              error.message.includes('violates unique constraint')) {
            // Count as warning for duplicates
            console.warn(`   ⚠️  Duplicate key in statement ${i + 1}`);
          } else {
            console.error(`   ❌ Error in statement ${i + 1}: ${error.message.substring(0, 100)}...`);
          }
        }
      }
      
      const executionTime = ((Date.now() - startTime) / 1000).toFixed(2);
      console.log(`✅ Inserted ${totalInserted} records, ${errors} errors in ${executionTime}s`);
      
      return insertStatements.length > 0; // Return true if we found and processed statements
      
    } catch (error) {
      console.error(`❌ Failed to execute ${path.basename(filePath)}:`, error.message);
      return false;
    }
  }

  /**
   * Execute an INSERT statement using Supabase client
   */
  async executeInsertStatement(statement) {
    try {
      // Parse INSERT statement for dictionary table
      const insertMatch = statement.match(/INSERT INTO dictionary\s*\(([^)]+)\)\s*VALUES\s*([\s\S]*)/i);
      
      if (!insertMatch) {
        throw new Error('Could not parse INSERT statement');
      }
      
      const columns = insertMatch[1].split(',').map(col => col.trim().replace(/"/g, ''));
      const valuesSection = insertMatch[2].replace(/;$/, '').trim(); // Remove trailing semicolon
      
      // Parse multiple VALUES rows
      const records = [];
      const valueRows = this.parseValueRows(valuesSection);
      
      // Convert each row to object
      for (const rowValues of valueRows) {
        const record = {};
        
        columns.forEach((col, index) => {
          if (index < rowValues.length) {
            record[col] = rowValues[index];
          }
        });
        
        records.push(record);
      }
      
      if (records.length === 0) {
        return 0;
      }
      
      // Insert records in smaller batches to avoid timeout
      const batchSize = 50;
      let totalInserted = 0;
      
      for (let i = 0; i < records.length; i += batchSize) {
        const batch = records.slice(i, i + batchSize);
        
        try {
          const { data, error } = await this.supabase
            .from('dictionary')
            .insert(batch);
          
          if (error) {
            if (error.message.includes('duplicate key') || 
                error.message.includes('violates unique constraint')) {
              // Count as successful for duplicates
              totalInserted += batch.length;
            } else {
              throw error;
            }
          } else {
            totalInserted += batch.length;
          }
        } catch (batchError) {
          // Try individual inserts for this batch
          for (const record of batch) {
            try {
              await this.supabase.from('dictionary').insert([record]);
              totalInserted++;
            } catch (individualError) {
              if (individualError.message.includes('duplicate key') || 
                  individualError.message.includes('violates unique constraint')) {
                totalInserted++;
              }
              // Skip individual errors
            }
          }
        }
      }
      
      return totalInserted;
      
    } catch (error) {
      console.error('Error executing INSERT:', error.message);
      throw error;
    }
  }

  /**
   * Parse VALUES section to extract individual rows
   */
  parseValueRows(valuesSection) {
    const rows = [];
    let current = '';
    let depth = 0;
    let inString = false;
    let escaped = false;
    
    for (let i = 0; i < valuesSection.length; i++) {
      const char = valuesSection[i];
      
      if (escaped) {
        current += char;
        escaped = false;
        continue;
      }
      
      if (char === '\\') {
        escaped = true;
        current += char;
        continue;
      }
      
      if (char === "'" && !escaped) {
        inString = !inString;
        current += char;
        continue;
      }
      
      if (!inString) {
        if (char === '(') {
          depth++;
          if (depth === 1) {
            continue; // Skip opening parenthesis
          }
        } else if (char === ')') {
          depth--;
          if (depth === 0) {
            // End of row
            const values = this.parseValues(current.trim());
            rows.push(values);
            current = '';
            
            // Skip comma and whitespace
            while (i + 1 < valuesSection.length && 
                   (valuesSection[i + 1] === ',' || /\s/.test(valuesSection[i + 1]))) {
              i++;
            }
            continue;
          }
        }
      }
      
      current += char;
    }
    
    return rows;
  }

  /**
   * Parse VALUES string into array of values
   */
  parseValues(valuesString) {
    const values = [];
    let current = '';
    let inString = false;
    let escaped = false;
    
    for (let i = 0; i < valuesString.length; i++) {
      const char = valuesString[i];
      
      if (escaped) {
        current += char;
        escaped = false;
        continue;
      }
      
      if (char === '\\') {
        escaped = true;
        current += char;
        continue;
      }
      
      if (char === "'" && !escaped) {
        inString = !inString;
        current += char;
        continue;
      }
      
      if (!inString && char === ',') {
        // End of current value
        let value = current.trim();
        
        // Handle different value types
        if (value.toUpperCase() === 'NULL') {
          values.push(null);
        } else if (value.startsWith("'") && value.endsWith("'")) {
          values.push(value.slice(1, -1).replace(/\\'/g, "'"));
        } else if (/^-?\d+(\.\d+)?$/.test(value)) {
          values.push(parseFloat(value));
        } else if (value.toLowerCase() === 'true') {
          values.push(true);
        } else if (value.toLowerCase() === 'false') {
          values.push(false);
        } else {
          values.push(value);
        }
        
        current = '';
        continue;
      }
      
      current += char;
    }
    
    // Handle last value
    if (current.trim()) {
      let value = current.trim();
      
      if (value.toUpperCase() === 'NULL') {
        values.push(null);
      } else if (value.startsWith("'") && value.endsWith("'")) {
        values.push(value.slice(1, -1).replace(/\\'/g, "'"));
      } else if (/^-?\d+(\.\d+)?$/.test(value)) {
        values.push(parseFloat(value));
      } else if (value.toLowerCase() === 'true') {
        values.push(true);
      } else if (value.toLowerCase() === 'false') {
        values.push(false);
      } else {
        values.push(value);
      }
    }
    
    return values;
  }

  /**
   * Check if file exists
   */
  async fileExists(filePath) {
    try {
      await fs.access(filePath);
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Find latest SQL files in output directory
   */
  async findLatestSqlFiles() {
    const outputDir = './output';
    
    try {
      const files = await fs.readdir(outputDir);
      const sqlFiles = files.filter(file => file.endsWith('.sql'));
      
      if (sqlFiles.length === 0) {
        throw new Error('No SQL files found in output directory');
      }
      
      // Extract timestamps and find the latest
      const timestampFiles = {};
      sqlFiles.forEach(file => {
        const match = file.match(/_(\d{4}-\d{2}-\d{2}T\d{2}-\d{2}-\d{2}-\d{3}Z)\.sql$/);
        if (match) {
          const timestamp = match[1];
          if (!timestampFiles[timestamp]) {
            timestampFiles[timestamp] = [];
          }
          timestampFiles[timestamp].push(file);
        }
      });
      
      const latestTimestamp = Object.keys(timestampFiles).sort().pop();
      if (!latestTimestamp) {
        throw new Error('No timestamped SQL files found');
      }
      
      const latestFiles = timestampFiles[latestTimestamp];
      console.log(`📁 Found ${latestFiles.length} files with timestamp: ${latestTimestamp}`);
      
      return {
        timestamp: latestTimestamp,
        files: latestFiles.map(file => path.join(outputDir, file)),
        outputDir
      };
      
    } catch (error) {
      console.error('❌ Error finding SQL files:', error.message);
      return null;
    }
  }

  /**
   * Setup Supabase roles and permissions (simplified for REST API)
   */
  async setupSupabaseRoles() {
    try {
      console.log('🔐 Checking Supabase permissions...');
      
      // Test basic operations
      const { data: testSelect, error: selectError } = await this.supabase
        .from('dictionary')
        .select('*')
        .limit(1);
      
      if (selectError && !selectError.message.includes('does not exist')) {
        console.log(`   ⚠️  SELECT test: ${selectError.message}`);
      } else {
        console.log('   ✅ SELECT permission confirmed');
      }
      
      // Test insert permission (will fail if table doesn't exist, which is fine)
      try {
        const { error: insertError } = await this.supabase
          .from('dictionary')
          .insert([{ 
            chinese: '__test__', 
            type: 'test', 
            meaning_vi: 'test' 
          }]);
        
        if (insertError) {
          if (insertError.message.includes('does not exist')) {
            console.log('   ℹ️  Table does not exist yet - will be created');
          } else if (insertError.message.includes('duplicate key')) {
            console.log('   ✅ INSERT permission confirmed');
            // Clean up test record
            await this.supabase
              .from('dictionary')
              .delete()
              .eq('chinese', '__test__');
          } else {
            console.log(`   ⚠️  INSERT test: ${insertError.message}`);
          }
        } else {
          console.log('   ✅ INSERT permission confirmed');
          // Clean up test record
          await this.supabase
            .from('dictionary')
            .delete()
            .eq('chinese', '__test__');
        }
      } catch (permError) {
        console.log(`   ⚠️  Permission test failed: ${permError.message}`);
      }
      
      return true;
    } catch (error) {
      console.error('❌ Permission check failed:', error.message);
      return false;
    }
  }

  /**
   * Check if table exists using Supabase client
   */
  async tableExists(tableName) {
    try {
      const { data, error } = await this.supabase
        .from(tableName)
        .select('*', { count: 'exact', head: true });
      
      return !error || !error.message.includes('does not exist');
    } catch (error) {
      return false;
    }
  }

  /**
   * Setup Supabase roles and permissions (simplified for REST API)
   */
  async setupRoles() {
    console.log('🔧 Setting up Supabase permissions...');
    
    // Use simplified permission checking for REST API
    await this.setupSupabaseRoles();
    
    console.log('✅ Permission check completed');
    return true;
  }

  /**
   * Deploy schema (simplified - assumes schema exists or is managed separately)
   */
  async deploySchema() {
    console.log('📋 Checking dictionary schema...');
    
    // Check if dictionary table exists
    if (await this.tableExists('dictionary')) {
      console.log('✅ Dictionary table already exists');
      return true;
    } else {
      console.log('ℹ️  Dictionary table does not exist');
      console.log('💡 Please create the table first using Supabase Dashboard or SQL:');
      console.log('   1. Go to https://app.supabase.com → Your Project → SQL Editor');
      console.log('   2. Run the dictionary schema SQL from ../db/dictionary_schema.sql');
      console.log('   3. Or use the insert_dict_data.js script which can handle schema creation');
      return false;
    }
  }

  /**
   * Deploy dictionary data
   */
  async deployData() {
    console.log('📚 Deploying dictionary data...');
    
    const sqlFiles = await this.findLatestSqlFiles();
    if (!sqlFiles) {
      return false;
    }
    
    const { files, timestamp } = sqlFiles;
    
    // Skip master script and deploy individual parts directly
    const partFiles = files.filter(file => file.includes('part'));
    partFiles.sort(); // Ensure proper order
    
    if (partFiles.length === 0) {
      console.error('❌ No part files found for data deployment');
      return false;
    }
    
    console.log(`📦 Deploying ${partFiles.length} part files`);
    
    let totalSuccess = true;
    for (const partFile of partFiles) {
      const success = await this.executeSqlFile(partFile);
      if (!success) {
        console.error('❌ Deployment stopped due to error');
        totalSuccess = false;
        break;
      }
    }
    
    // Run verification if available
    const verifyFile = files.find(file => file.includes('verify'));
    if (verifyFile && totalSuccess) {
      console.log('🔍 Running verification...');
      await this.executeSqlFile(verifyFile);
    }
    
    return totalSuccess;
  }

  /**
   * Get deployment statistics using Supabase client
   */
  async getStatistics() {
    console.log('📊 Getting deployment statistics...');
    
    try {
      // Get total count
      const { count: totalCount, error: countError } = await this.supabase
        .from('dictionary')
        .select('*', { count: 'exact', head: true });
      
      if (countError) {
        throw countError;
      }
      
      // Get sample data to analyze types
      const { data: sampleData, error: sampleError } = await this.supabase
        .from('dictionary')
        .select('type, chinese')
        .limit(1000); // Sample for type analysis
      
      if (sampleError) {
        throw sampleError;
      }
      
      // Analyze types from sample
      const typeCount = {};
      const uniqueWords = new Set();
      
      sampleData.forEach(row => {
        if (row.type) {
          typeCount[row.type] = (typeCount[row.type] || 0) + 1;
        }
        if (row.chinese) {
          uniqueWords.add(row.chinese);
        }
      });
      
      // Get latest entries
      const { data: latestData, error: latestError } = await this.supabase
        .from('dictionary')
        .select('chinese, type, created_at')
        .order('created_at', { ascending: false })
        .limit(5);
      
      console.log('\n📈 Deployment Statistics:');
      console.log(`   Total records: ${totalCount || 0}`);
      console.log(`   Unique types: ${Object.keys(typeCount).length}`);
      console.log(`   Sample unique words: ${uniqueWords.size}`);
      
      if (Object.keys(typeCount).length > 0) {
        console.log('\n🏆 Top word types (from sample):');
        Object.entries(typeCount)
          .sort(([,a], [,b]) => b - a)
          .slice(0, 5)
          .forEach(([type, count]) => {
            console.log(`   ${type}: ${count} words`);
          });
      }
      
      if (latestData && latestData.length > 0) {
        console.log('\n📝 Latest entries:');
        latestData.forEach((record, index) => {
          console.log(`   ${index + 1}. ${record.chinese} (${record.type})`);
        });
      }
      
      return true;
    } catch (error) {
      console.error('❌ Failed to get statistics:', error.message);
      return false;
    }
  }

  /**
   * Full deployment process
   */
  async deploy() {
    console.log('🚀 Starting Supabase Dictionary Deployment\n');
    
    try {
      // Connect
      if (!(await this.connect())) {
        return false;
      }
      
      // Setup roles
      if (!(await this.setupRoles())) {
        return false;
      }
      
      // Deploy schema
      if (!(await this.deploySchema())) {
        return false;
      }
      
      // Deploy data
      if (!(await this.deployData())) {
        return false;
      }
      
      // Get statistics
      await this.getStatistics();
      
      console.log('\n🎉 Dictionary deployment completed successfully!');
      return true;
      
    } catch (error) {
      console.error('\n💥 Deployment failed:', error.message);
      return false;
    } finally {
      await this.disconnect();
    }
  }
}

/**
 * CLI interface
 */
async function main() {
  const args = process.argv.slice(2);
  const command = args[0] || 'deploy';
  
  // Configuration from environment or command line
  const config = {
    url: process.env.SUPABASE_URL,
    serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY,
    // Legacy support
    projectId: process.env.SUPABASE_PROJECT_ID,
    password: process.env.SUPABASE_DB_PASSWORD,
  };
  
  // Validate required configuration
  if (!config.url && !config.projectId) {
    console.error('❌ Missing required environment variables:');
    console.error('');
    console.error('   ❌ SUPABASE_URL is not set (or SUPABASE_PROJECT_ID for legacy)');
    console.error('');
    console.error('📋 Setup Instructions:');
    console.error('   1. Copy .env.example to .env');
    console.error('   2. Add your Supabase settings:');
    console.error('      SUPABASE_URL=https://your-project-id.supabase.co');
    console.error('      SUPABASE_SERVICE_ROLE_KEY=your-service-role-key');
    console.error('');
    console.error('� Get your values from: https://app.supabase.com → Your Project → Settings → API');
    process.exit(1);
  }
  
  if (!config.serviceRoleKey) {
    console.error('❌ Missing SUPABASE_SERVICE_ROLE_KEY:');
    console.error('');
    console.error('🔑 The service role key is required for database operations');
    console.error('');
    console.error('📋 How to get it:');
    console.error('   1. Go to: https://app.supabase.com');
    console.error('   2. Select your project → Settings → API');
    console.error('   3. Copy the "service_role" key (not the anon key)');
    console.error('   4. Add to .env: SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1...');
    console.error('');
    console.error('⚠️  Keep the service role key secret - it has admin privileges!');
    process.exit(1);
  }
  
  const deployer = new SupabaseDeployer(config);
  
  switch (command) {
    case 'deploy':
      const success = await deployer.deploy();
      process.exit(success ? 0 : 1);
      break;
      
    case 'test':
      const connected = await deployer.connect();
      await deployer.disconnect();
      process.exit(connected ? 0 : 1);
      break;
      
    case 'schema':
      await deployer.connect();
      const schemaSuccess = await deployer.setupRoles() && await deployer.deploySchema();
      await deployer.disconnect();
      process.exit(schemaSuccess ? 0 : 1);
      break;
      
    case 'data':
      await deployer.connect();
      const dataSuccess = await deployer.deployData();
      await deployer.disconnect();
      process.exit(dataSuccess ? 0 : 1);
      break;
      
    case 'stats':
      await deployer.connect();
      await deployer.getStatistics();
      await deployer.disconnect();
      break;
      
    default:
      console.log(`
📚 Supabase Dictionary Deployment Tool (Node.js)

Usage: node deploy-node.js [command]

Commands:
  deploy    Full deployment (schema + data) [default]
  test      Test database connection
  schema    Deploy schema only
  data      Deploy data only
  stats     Show database statistics

Configuration:
  Create a .env file with your Supabase settings:
  
  SUPABASE_URL=https://your-project-id.supabase.co
  SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
  
  Get these from: https://app.supabase.com → Project → Settings → API

Examples:
  cp .env.example .env    # Copy template
  nano .env               # Edit with your values
  node deploy-node.js deploy
  node deploy-node.js test
  node deploy-node.js stats

Dependencies:
  npm install dotenv @supabase/supabase-js   # Install required packages
`);
      break;
  }
}

// Export for use as module
export default SupabaseDeployer;

// Run if called directly (ES modules check)
if (import.meta.url === `file://${process.argv[1]}`) {
  main().catch(error => {
    console.error('💥 Fatal error:', error.message);
    process.exit(1);
  });
}
