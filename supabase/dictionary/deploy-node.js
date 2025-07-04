import { Client } from 'pg';
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
 * Deploys dictionary SQL files directly to Supabase with proper role management
 */

class SupabaseDeployer {
  constructor(config = {}) {
    this.config = {
      projectId: config.projectId || process.env.SUPABASE_PROJECT_ID,
      password: config.password || process.env.SUPABASE_DB_PASSWORD,
      host: config.host || process.env.SUPABASE_HOST || `db.${config.projectId || process.env.SUPABASE_PROJECT_ID}.supabase.co`,
      port: config.port || process.env.SUPABASE_PORT || 5432,
      database: config.database || process.env.SUPABASE_DATABASE || 'postgres',
      user: config.user || process.env.SUPABASE_USER || 'postgres',
      ssl: config.ssl !== false, // Enable SSL by default for Supabase
      ...config
    };
    
    this.client = null;
  }

  /**
   * Create database connection
   */
  async connect() {
    try {
      console.log('🔌 Connecting to Supabase database...');
      console.log(`   Host: ${this.config.host}`);
      console.log(`   Database: ${this.config.database}`);
      console.log(`   User: ${this.config.user}`);
      
      this.client = new Client({
        host: this.config.host,
        port: this.config.port,
        database: this.config.database,
        user: this.config.user,
        password: this.config.password,
        ssl: this.config.ssl ? { rejectUnauthorized: false } : false,
        connectionTimeoutMillis: 30000,
        query_timeout: 300000, // 5 minutes for large imports
      });
      
      await this.client.connect();
      
      // Test connection and get basic info
      const result = await this.client.query(`
        SELECT 
          version() as version,
          current_database() as database,
          current_user as user,
          current_timestamp as connected_at
      `);
      
      console.log('✅ Connected successfully to Supabase');
      console.log(`   PostgreSQL: ${result.rows[0].version.split(' ')[1]}`);
      console.log(`   Connected at: ${result.rows[0].connected_at}`);
      
      return true;
    } catch (error) {
      console.error('❌ Failed to connect to Supabase:', error.message);
      return false;
    }
  }

  /**
   * Disconnect from database
   */
  async disconnect() {
    if (this.client) {
      await this.client.end();
      console.log('🔌 Disconnected from Supabase');
    }
  }

  /**
   * Execute SQL file with proper error handling
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
      await this.client.query(sql);
      const executionTime = ((Date.now() - startTime) / 1000).toFixed(2);
      
      console.log(`✅ Executed successfully in ${executionTime}s`);
      return true;
      
    } catch (error) {
      console.error(`❌ Failed to execute ${path.basename(filePath)}:`, error.message);
      return false;
    }
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
   * Setup Supabase roles and permissions before deployment
   */
  async setupSupabaseRoles() {
    try {
      console.log('🔐 Setting up Supabase roles and permissions...');
      
      // Check current user and available roles
      const userCheck = await this.client.query(`
        SELECT 
          current_user as current_user,
          session_user as session_user,
          current_role as current_role
      `);
      
      console.log(`   Current user: ${userCheck.rows[0].current_user}`);
      console.log(`   Session user: ${userCheck.rows[0].session_user}`);
      console.log(`   Current role: ${userCheck.rows[0].current_role}`);
      
      // Check available roles
      const roleCheck = await this.client.query(`
        SELECT rolname 
        FROM pg_roles 
        WHERE rolname IN ('postgres', 'authenticated', 'anon', 'service_role')
        ORDER BY rolname
      `);
      
      const availableRoles = roleCheck.rows.map(r => r.rolname);
      console.log(`   Available roles: ${availableRoles.join(', ')}`);
      
      // Attempt to set postgres role if available
      if (availableRoles.includes('postgres')) {
        try {
          await this.client.query('SET ROLE postgres');
          console.log('✅ Successfully set postgres role');
        } catch (error) {
          console.log('⚠️  Cannot set postgres role, continuing with current role');
        }
      }
      
      // Check table permissions
      if (await this.tableExists('dictionary')) {
        const permCheck = await this.client.query(`
          SELECT 
            has_table_privilege('dictionary', 'SELECT') as can_select,
            has_table_privilege('dictionary', 'INSERT') as can_insert,
            has_table_privilege('dictionary', 'UPDATE') as can_update,
            has_table_privilege('dictionary', 'DELETE') as can_delete
        `);
        
        const perms = permCheck.rows[0];
        console.log(`   Dictionary table permissions:`);
        console.log(`     SELECT: ${perms.can_select ? '✅' : '❌'}`);
        console.log(`     INSERT: ${perms.can_insert ? '✅' : '❌'}`);
        console.log(`     UPDATE: ${perms.can_update ? '✅' : '❌'}`);
        console.log(`     DELETE: ${perms.can_delete ? '✅' : '❌'}`);
        
        if (!perms.can_insert) {
          console.log('⚠️  Warning: No INSERT permission on dictionary table');
        }
      }
      
      return true;
    } catch (error) {
      console.error('❌ Role setup failed:', error.message);
      console.log('Continuing with current permissions...');
      return false;
    }
  }

  /**
   * Check if table exists
   */
  async tableExists(tableName) {
    try {
      const result = await this.client.query(`
        SELECT EXISTS (
          SELECT 1 FROM information_schema.tables 
          WHERE table_schema = 'public' 
          AND table_name = $1
        )
      `, [tableName]);
      
      return result.rows[0].exists;
    } catch (error) {
      return false;
    }
  }

  /**
   * Setup Supabase roles and permissions
   */
  async setupRoles() {
    console.log('🔧 Setting up Supabase roles and permissions...');
    
    // First setup role permissions
    await this.setupSupabaseRoles();
    
    const setupSql = `
      -- Supabase Role Setup for Dictionary Import
      
      -- Enable required extensions
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      CREATE EXTENSION IF NOT EXISTS "pg_trgm";
      CREATE EXTENSION IF NOT EXISTS "unaccent";
      
      -- Grant permissions to Supabase roles
      DO $$
      BEGIN
        -- Grant to authenticated users
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
          GRANT USAGE ON SCHEMA public TO authenticated;
          GRANT CREATE ON SCHEMA public TO authenticated;
        END IF;
        
        -- Grant to service role
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
          GRANT ALL ON SCHEMA public TO service_role;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE NOTICE 'Permission grants completed with warnings: %', SQLERRM;
      END $$;
      
      -- Create import optimization functions
      CREATE OR REPLACE FUNCTION setup_import_session()
      RETURNS void AS $func$
      BEGIN
          SET work_mem = '256MB';
          SET maintenance_work_mem = '1GB';
          SET checkpoint_completion_target = 0.9;
          SET wal_buffers = '16MB';
          SET log_statement = 'none';
          SET log_min_duration_statement = -1;
      END;
      $func$ LANGUAGE plpgsql;
      
      CREATE OR REPLACE FUNCTION cleanup_import_session()
      RETURNS void AS $func$
      BEGIN
          RESET work_mem;
          RESET maintenance_work_mem;
          RESET checkpoint_completion_target;
          RESET wal_buffers;
          RESET log_statement;
          RESET log_min_duration_statement;
      END;
      $func$ LANGUAGE plpgsql;
      
      -- Grant permissions to Supabase default roles
      DO $$
      BEGIN
          IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
              GRANT USAGE ON SCHEMA public TO authenticated;
              GRANT SELECT ON ALL TABLES IN SCHEMA public TO authenticated;
          END IF;
          
          IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
              GRANT USAGE ON SCHEMA public TO anon;
          END IF;
      END $$;
      
      SELECT 'Supabase roles setup completed' as status;
    `;
    
    try {
      await this.client.query(setupSql);
      console.log('✅ Roles and permissions configured');
      return true;
    } catch (error) {
      console.error('❌ Failed to setup roles:', error.message);
      return false;
    }
  }

  /**
   * Deploy schema
   */
  async deploySchema() {
    console.log('📋 Deploying dictionary schema...');
    
    const schemaPath = '../db/dictionary_schema.sql';
    if (!(await this.fileExists(schemaPath))) {
      console.error('❌ Schema file not found:', schemaPath);
      return false;
    }
    
    return await this.executeSqlFile(schemaPath);
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
    
    // Look for master script first
    const masterFile = files.find(file => file.includes('master'));
    
    if (masterFile) {
      console.log('🎯 Using master script for coordinated deployment');
      return await this.executeSqlFile(masterFile);
    } else {
      // Deploy individual parts
      const partFiles = files.filter(file => file.includes('part'));
      partFiles.sort(); // Ensure proper order
      
      console.log(`📦 Deploying ${partFiles.length} part files`);
      
      for (const partFile of partFiles) {
        const success = await this.executeSqlFile(partFile);
        if (!success) {
          console.error('❌ Deployment stopped due to error');
          return false;
        }
      }
      
      // Run verification if available
      const verifyFile = files.find(file => file.includes('verify'));
      if (verifyFile) {
        console.log('🔍 Running verification...');
        await this.executeSqlFile(verifyFile);
      }
      
      return true;
    }
  }

  /**
   * Get deployment statistics
   */
  async getStatistics() {
    console.log('📊 Getting deployment statistics...');
    
    try {
      const result = await this.client.query(`
        SELECT 
          'Dictionary Statistics' as info,
          COUNT(*) as total_records,
          COUNT(DISTINCT type) as unique_types,
          COUNT(DISTINCT chinese) as unique_words,
          pg_size_pretty(pg_total_relation_size('dictionary')) as table_size
        FROM dictionary;
      `);
      
      const typeResult = await this.client.query(`
        SELECT type, COUNT(*) as count 
        FROM dictionary 
        GROUP BY type 
        ORDER BY count DESC 
        LIMIT 5;
      `);
      
      console.log('\n📈 Deployment Statistics:');
      console.log(`   Total records: ${result.rows[0].total_records}`);
      console.log(`   Unique types: ${result.rows[0].unique_types}`);
      console.log(`   Unique words: ${result.rows[0].unique_words}`);
      console.log(`   Table size: ${result.rows[0].table_size}`);
      
      console.log('\n🏆 Top word types:');
      typeResult.rows.forEach(row => {
        console.log(`   ${row.type}: ${row.count} words`);
      });
      
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
    projectId: process.env.SUPABASE_PROJECT_ID,
    password: process.env.SUPABASE_DB_PASSWORD,
  };
  
  // Validate required configuration
  if (!config.projectId || !config.password) {
    console.error('❌ Missing required environment variables:');
    console.error('');
    
    if (!config.projectId) {
      console.error('   ❌ SUPABASE_PROJECT_ID is not set');
    } else {
      console.error('   ✅ SUPABASE_PROJECT_ID is set');
    }
    
    if (!config.password) {
      console.error('   ❌ SUPABASE_DB_PASSWORD is not set');
    } else {
      console.error('   ✅ SUPABASE_DB_PASSWORD is set');
    }
    
    console.error('');
    console.error('📋 Setup Instructions:');
    console.error('   1. Copy .env.example to .env');
    console.error('   2. Fill in your Supabase project details');
    console.error('   3. Run the script again');
    console.error('');
    console.error('💡 Quick setup:');
    console.error('   cp .env.example .env');
    console.error('   nano .env  # Edit with your values');
    console.error('');
    console.error('🔗 Get your values from: https://app.supabase.com → Your Project → Settings');
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
  
  SUPABASE_PROJECT_ID=your-project-id
  SUPABASE_DB_PASSWORD=your-database-password
  
  Use .env.example as a template.

Examples:
  cp .env.example .env    # Copy template
  nano .env               # Edit with your values
  node deploy-node.js deploy
  node deploy-node.js test
  node deploy-node.js stats

Dependencies:
  npm install dotenv pg   # Install required packages
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
