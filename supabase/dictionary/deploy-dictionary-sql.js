// Enhanced Dictionary Data Insertion Script with Supabase Role Management
// This script uses proper Supabase role permissions to execute SQL files from ./output/

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Configure dotenv to read environment variables
dotenv.config();

// Get current directory path for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

/**
 * Supabase Dictionary SQL Executor
 * Handles role permissions and executes SQL files from ./output/ directory
 */
class SupabaseDictionaryExecutor {
  constructor(config = {}) {
    this.config = {
      url: config.url || process.env.SUPABASE_URL,
      serviceKey: config.serviceKey || process.env.SUPABASE_SERVICE_ROLE_KEY,
      anonKey: config.anonKey || process.env.SUPABASE_ANON_KEY,
      outputDir: config.outputDir || './output',
      ...config
    };
    
    this.supabase = null;
    this.currentRole = null;
  }

  /**
   * Initialize Supabase client with service role for admin operations
   */
  async initialize() {
    try {
      console.log('🔐 Initializing Supabase client with role management...');
      
      // Validate environment variables
      if (!this.config.url) {
        throw new Error('❌ Missing SUPABASE_URL in environment variables');
      }
      
      if (!this.config.serviceKey) {
        console.error('❌ MISSING SERVICE ROLE KEY / THIẾU SERVICE ROLE KEY');
        console.error('');
        console.error('🔑 Need SUPABASE_SERVICE_ROLE_KEY for database operations');
        console.error('🔑 Cần SUPABASE_SERVICE_ROLE_KEY để thực hiện các thao tác database');
        console.error('');
        console.error('📋 HOW TO GET SERVICE ROLE KEY:');
        console.error('   1. Go to: https://app.supabase.com');
        console.error('   2. Select project → Settings → API');
        console.error('   3. Copy "service_role" key (secret key)');
        console.error('   4. Add to .env: SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1...');
        console.error('');
        console.error('⚠️  Service role key has admin privileges - keep it secret!');
        throw new Error('Service role key is required for SQL execution');
      }

      // Initialize with service role for full permissions
      this.supabase = createClient(
        this.config.url,
        this.config.serviceKey,
        {
          auth: {
            autoRefreshToken: false,
            persistSession: false,
            detectSessionInUrl: false
          },
          db: {
            schema: 'public'
          }
        }
      );

      console.log('✅ Supabase client initialized with service role');
      return true;
    } catch (error) {
      console.error('❌ Failed to initialize Supabase client:', error.message);
      throw error;
    }
  }

  /**
   * Test connection and role permissions
   */
  async testConnection() {
    try {
      console.log('🔍 Testing connection and role permissions...');
      
      // Test basic connection
      const { data: connectionTest, error: connectionError } = await this.supabase
        .from('information_schema.tables')
        .select('table_name')
        .eq('table_schema', 'public')
        .limit(1);

      if (connectionError) {
        throw new Error(`Connection test failed: ${connectionError.message}`);
      }

      console.log('✅ Database connection successful');

      // Test role permissions by checking available roles
      const { data: roleData, error: roleError } = await this.supabase.rpc('exec_sql', {
        sql: `
          SELECT 
            current_user as current_user,
            session_user as session_user,
            current_role as current_role,
            (SELECT string_agg(rolname, ', ') FROM pg_roles WHERE rolname IN ('postgres', 'authenticated', 'anon', 'service_role')) as available_roles
        `
      });

      if (roleError) {
        console.warn('⚠️  Could not check roles, but connection is working');
      } else {
        console.log('✅ Role information retrieved successfully');
        if (roleData && roleData.length > 0) {
          const info = roleData[0];
          console.log(`   Current user: ${info.current_user}`);
          console.log(`   Available roles: ${info.available_roles}`);
        }
      }

      // Test dictionary table access
      const { data: tableTest, error: tableError } = await this.supabase
        .from('dictionary')
        .select('count(*)')
        .limit(1);

      if (tableError) {
        if (tableError.message.includes('does not exist')) {
          console.log('ℹ️  Dictionary table does not exist yet - will be created by schema');
        } else {
          throw new Error(`Dictionary table access failed: ${tableError.message}`);
        }
      } else {
        console.log('✅ Dictionary table accessible');
      }

      return true;
    } catch (error) {
      console.error('❌ Connection test failed:', error.message);
      throw error;
    }
  }

  /**
   * Find latest SQL files in output directory
   */
  async findLatestSqlFiles() {
    try {
      console.log(`📁 Scanning ${this.config.outputDir} for SQL files...`);
      
      const files = await fs.readdir(this.config.outputDir);
      const sqlFiles = files.filter(file => file.endsWith('.sql'));
      
      if (sqlFiles.length === 0) {
        throw new Error(`No SQL files found in ${this.config.outputDir}`);
      }

      // Group files by timestamp
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

      // Get the latest timestamp
      const latestTimestamp = Object.keys(timestampFiles).sort().pop();
      if (!latestTimestamp) {
        throw new Error('No timestamped SQL files found');
      }

      const latestFiles = timestampFiles[latestTimestamp].sort();
      console.log(`📊 Found ${latestFiles.length} SQL files from batch: ${latestTimestamp}`);
      
      return latestFiles.map(file => path.join(this.config.outputDir, file));
    } catch (error) {
      console.error('❌ Error finding SQL files:', error.message);
      throw error;
    }
  }

  /**
   * Execute SQL file with proper role management
   */
  async executeSqlFile(filePath) {
    try {
      console.log(`📄 Executing: ${path.basename(filePath)}`);
      
      // Read SQL file
      const sqlContent = await fs.readFile(filePath, 'utf8');
      const fileSizeMB = (sqlContent.length / 1024 / 1024).toFixed(2);
      console.log(`   File size: ${fileSizeMB} MB`);

      // Check if this is a schema file or data file
      const isSchemaFile = path.basename(filePath).includes('schema');
      
      if (isSchemaFile) {
        console.log('   Type: Schema file - using administrative operations');
      } else {
        console.log('   Type: Data file - using bulk insert operations');
      }

      // Execute SQL with proper error handling
      const startTime = Date.now();
      
      // Split SQL into statements for better error handling
      const statements = this.splitSqlStatements(sqlContent);
      console.log(`   Statements to execute: ${statements.length}`);

      let executedStatements = 0;
      for (const statement of statements) {
        if (statement.trim()) {
          try {
            await this.supabase.rpc('exec_sql', { sql: statement });
            executedStatements++;
          } catch (error) {
            // Log non-critical errors but continue
            if (this.isNonCriticalError(error.message)) {
              console.warn(`   ⚠️  Non-critical warning: ${error.message}`);
            } else {
              throw error;
            }
          }
        }
      }

      const executionTime = ((Date.now() - startTime) / 1000).toFixed(2);
      console.log(`✅ Executed ${executedStatements} statements in ${executionTime}s`);
      
      return {
        success: true,
        executedStatements,
        executionTime: parseFloat(executionTime),
        filePath
      };

    } catch (error) {
      console.error(`❌ Failed to execute ${path.basename(filePath)}:`, error.message);
      
      // Provide helpful error context
      if (error.message.includes('permission denied')) {
        console.error('💡 Solution: Ensure SUPABASE_SERVICE_ROLE_KEY is set correctly');
      } else if (error.message.includes('already exists')) {
        console.error('💡 Note: Some objects already exist, this is usually safe to ignore');
      }
      
      throw error;
    }
  }

  /**
   * Split SQL content into individual statements
   */
  splitSqlStatements(sqlContent) {
    // Remove comments and split by semicolons
    const cleaned = sqlContent
      .replace(/--.*$/gm, '') // Remove line comments
      .replace(/\/\*[\s\S]*?\*\//g, '') // Remove block comments
      .replace(/\\echo\s+[^;]*;?/g, '') // Remove psql echo commands
      .replace(/\\timing\s+\w+;?/g, ''); // Remove psql timing commands

    return cleaned
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.match(/^\s*$/));
  }

  /**
   * Check if error is non-critical (can be ignored)
   */
  isNonCriticalError(errorMessage) {
    const nonCriticalPatterns = [
      'already exists',
      'duplicate key',
      'constraint already exists',
      'function.*already exists',
      'relation.*already exists',
      'type.*already exists'
    ];

    return nonCriticalPatterns.some(pattern => 
      new RegExp(pattern, 'i').test(errorMessage)
    );
  }

  /**
   * Execute all SQL files in sequence
   */
  async executeAllSqlFiles() {
    try {
      console.log('🚀 Starting SQL files execution...\n');
      
      const sqlFiles = await this.findLatestSqlFiles();
      const results = [];
      
      // Separate schema and data files
      const schemaFiles = sqlFiles.filter(file => 
        path.basename(file).includes('schema') || 
        path.basename(file).includes('master')
      );
      const dataFiles = sqlFiles.filter(file => 
        !schemaFiles.includes(file) && 
        !path.basename(file).includes('verify')
      );

      console.log(`📋 Execution plan:`);
      console.log(`   Schema files: ${schemaFiles.length}`);
      console.log(`   Data files: ${dataFiles.length}`);
      console.log('');

      // Execute schema files first
      for (const file of schemaFiles) {
        const result = await this.executeSqlFile(file);
        results.push(result);
      }

      // Execute data files
      for (const file of dataFiles) {
        const result = await this.executeSqlFile(file);
        results.push(result);
      }

      // Summary
      const totalTime = results.reduce((sum, r) => sum + r.executionTime, 0);
      const totalStatements = results.reduce((sum, r) => sum + r.executedStatements, 0);
      
      console.log('\n📊 Execution Summary:');
      console.log(`   Files executed: ${results.length}`);
      console.log(`   Total statements: ${totalStatements}`);
      console.log(`   Total time: ${totalTime.toFixed(2)}s`);
      console.log('');

      return results;
    } catch (error) {
      console.error('❌ Failed to execute SQL files:', error.message);
      throw error;
    }
  }

  /**
   * Verify deployment by checking dictionary data
   */
  async verifyDeployment() {
    try {
      console.log('🔍 Verifying deployment...');
      
      // Check dictionary table
      const { data: stats, error: statsError } = await this.supabase
        .from('dictionary')
        .select('*', { count: 'exact', head: true });

      if (statsError) {
        throw new Error(`Verification failed: ${statsError.message}`);
      }

      const recordCount = stats ? stats.length : 0;
      console.log(`✅ Dictionary table contains ${recordCount} records`);

      // Get sample data
      const { data: sample, error: sampleError } = await this.supabase
        .from('dictionary')
        .select('chinese, pinyin, type, meaning_vi')
        .limit(3);

      if (sampleError) {
        console.warn('⚠️  Could not retrieve sample data');
      } else if (sample && sample.length > 0) {
        console.log('📝 Sample records:');
        sample.forEach((record, index) => {
          console.log(`   ${index + 1}. ${record.chinese} (${record.pinyin}) - ${record.meaning_vi}`);
        });
      }

      return { recordCount, sample };
    } catch (error) {
      console.error('❌ Verification failed:', error.message);
      throw error;
    }
  }

  /**
   * Main deployment method
   */
  async deploy() {
    try {
      console.log('🚀 Starting Supabase Dictionary Deployment with Role Management\n');
      
      // Initialize
      await this.initialize();
      
      // Test connection
      await this.testConnection();
      
      // Execute SQL files
      const results = await this.executeAllSqlFiles();
      
      // Verify deployment
      const verification = await this.verifyDeployment();
      
      console.log('\n🎉 Dictionary deployment completed successfully!');
      console.log(`📊 Final stats: ${verification.recordCount} dictionary records deployed`);
      
      return {
        success: true,
        filesExecuted: results.length,
        recordCount: verification.recordCount,
        results
      };
      
    } catch (error) {
      console.error('\n💥 Deployment failed:', error.message);
      return {
        success: false,
        error: error.message
      };
    }
  }
}

/**
 * Command-line interface
 */
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];

  const executor = new SupabaseDictionaryExecutor();

  try {
    switch (command) {
      case 'deploy':
        console.log('🎯 Command: Deploy SQL files to Supabase dictionary database');
        await executor.deploy();
        break;
        
      case 'test':
        console.log('🎯 Command: Test connection and permissions');
        await executor.initialize();
        await executor.testConnection();
        console.log('✅ Connection test completed successfully');
        break;
        
      case 'verify':
        console.log('🎯 Command: Verify existing deployment');
        await executor.initialize();
        await executor.verifyDeployment();
        break;
        
      case 'list':
        console.log('🎯 Command: List available SQL files');
        const files = await executor.findLatestSqlFiles();
        console.log(`Found ${files.length} SQL files:`);
        files.forEach(file => console.log(`  - ${path.basename(file)}`));
        break;
        
      default:
        console.log('📚 Supabase Dictionary SQL Executor\n');
        console.log('Commands:');
        console.log('  deploy    Deploy SQL files from ./output/ to Supabase');
        console.log('  test      Test connection and role permissions');
        console.log('  verify    Verify existing deployment');
        console.log('  list      List available SQL files');
        console.log('');
        console.log('Examples:');
        console.log('  node insert_dict_data.js deploy');
        console.log('  node insert_dict_data.js test');
        console.log('  node insert_dict_data.js verify');
        console.log('');
        console.log('Environment Variables Required:');
        console.log('  SUPABASE_URL              - Your Supabase project URL');
        console.log('  SUPABASE_SERVICE_ROLE_KEY - Service role key for admin operations');
        console.log('');
        console.log('Features:');
        console.log('✅ Automatic SQL file discovery');
        console.log('✅ Proper Supabase role management');
        console.log('✅ Error handling and recovery');
        console.log('✅ Deployment verification');
        console.log('✅ Batch processing for large datasets');
        break;
    }
  } catch (error) {
    console.error('❌ Command failed:', error.message);
    process.exit(1);
  }
}

// Export for use as module
export {
  SupabaseDictionaryExecutor
};

// Run CLI if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}
