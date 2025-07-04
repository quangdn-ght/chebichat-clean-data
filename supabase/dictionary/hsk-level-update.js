#!/usr/bin/env node

/**
 * HSK Level Update Script for Chinese-Vietnamese Dictionary
 * Updates Supabase dictionary table with HSK level information
 * Reads from ./import/hsk-complete.json and maps HSK levels to Chinese words
 * 
 * Supports both Supabase JavaScript client and direct PostgreSQL connection
 */

import { createClient } from '@supabase/supabase-js';
import pg from 'pg';
import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Configure dotenv to read environment variables from .env file
dotenv.config();

// Get current directory path for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Constants for batch processing
const DEFAULT_BATCH_SIZE = 1000;
const HSK_DATA_FILE = path.join(__dirname, 'import', 'hsk-complete.json');

// Connection clients
let supabase = null;
let pgClient = null;

/**
 * Initialize database connection (Supabase JS client or direct PostgreSQL)
 */
async function initializeDatabase() {
  const useDirectPg = process.env.USE_DIRECT_PG === 'true';
  
  if (useDirectPg) {
    return await initializePostgreSQL();
  } else {
    return await initializeSupabase();
  }
}

/**
 * Initialize direct PostgreSQL connection
 */
async function initializePostgreSQL() {
  try {
    console.log('🐘 Initializing direct PostgreSQL connection...');
    
    const projectId = process.env.SUPABASE_PROJECT_ID;
    const password = process.env.SUPABASE_DB_PASSWORD;
    
    if (!projectId || !password) {
      throw new Error('Missing SUPABASE_PROJECT_ID or SUPABASE_DB_PASSWORD for PostgreSQL connection');
    }

    const connectionConfig = {
      host: process.env.SUPABASE_HOST || `db.${projectId}.supabase.co`,
      port: process.env.SUPABASE_PORT || 5432,
      database: process.env.SUPABASE_DATABASE || 'postgres',
      user: process.env.SUPABASE_USER || 'postgres',
      password: password,
      ssl: { rejectUnauthorized: false }
    };

    pgClient = new pg.Client(connectionConfig);
    await pgClient.connect();
    
    console.log('✅ PostgreSQL connection established');
    return 'postgresql';
  } catch (error) {
    console.error('❌ PostgreSQL connection failed:', error.message);
    throw error;
  }
}
/**
 * Initialize Supabase client with proper role management
 */
async function initializeSupabase() {
  if (!process.env.SUPABASE_URL) {
    throw new Error('❌ Missing SUPABASE_URL in .env file');
  }
  
  if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
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
    process.exit(1);
  }

  supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      },
      db: {
        schema: 'public'
      }
    }
  );

  console.log('✅ Supabase client initialized successfully');
  return 'supabase';
}

/**
 * Check if HSK level column exists in dictionary table
 */
async function checkHskColumnExists(connectionType) {
  try {
    console.log('🔍 Checking if HSK level column exists...');
    
    if (connectionType === 'postgresql') {
      const result = await pgClient.query(`
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = 'dictionary' 
        AND column_name = 'hsk_level'
        AND table_schema = 'public';
      `);
      return result.rows.length > 0;
    } else {
      // Supabase client method
      const { data: checkData, error: checkError } = await supabase
        .from('dictionary')
        .select('hsk_level')
        .limit(1);
      
      if (checkError && checkError.message.includes('column "hsk_level" does not exist')) {
        return false;
      } else if (checkError) {
        throw checkError;
      }
      return true;
    }
  } catch (error) {
    console.log('⚠️  HSK column check failed, assuming column does not exist');
    return false;
  }
}

/**
 * Add HSK level column to dictionary table
 */
async function addHskLevelColumn(connectionType) {
  try {
    console.log('📝 Adding HSK level column to dictionary table...');
    
    const sql = `
      ALTER TABLE dictionary 
      ADD COLUMN IF NOT EXISTS hsk_level VARCHAR(20);
      
      CREATE INDEX IF NOT EXISTS idx_dictionary_hsk_level 
      ON dictionary (hsk_level);
    `;

    if (connectionType === 'postgresql') {
      await pgClient.query(sql);
    } else {
      const { data, error } = await supabase.rpc('exec', { sql });
      if (error) {
        console.error('❌ Failed to add HSK level column:', error);
        throw error;
      }
    }

    console.log('✅ HSK level column added successfully');
    return true;
  } catch (error) {
    console.error('❌ Error adding HSK level column:', error.message);
    throw error;
  }
}

/**
 * Load HSK complete data from JSON file
 */
async function loadHskData() {
  try {
    console.log('📖 Loading HSK data from:', HSK_DATA_FILE);
    
    if (!fs.existsSync(HSK_DATA_FILE)) {
      throw new Error(`HSK data file not found: ${HSK_DATA_FILE}`);
    }

    const fileContent = fs.readFileSync(HSK_DATA_FILE, 'utf8');
    const hskData = JSON.parse(fileContent);
    
    console.log(`✅ Loaded ${hskData.length} HSK entries`);
    
    // Validate data structure
    if (!Array.isArray(hskData) || hskData.length === 0) {
      throw new Error('Invalid HSK data format: expected non-empty array');
    }

    // Check first few entries for required structure
    const sampleEntry = hskData[0];
    if (!sampleEntry.chinese || !sampleEntry.level) {
      throw new Error('Invalid HSK data structure: missing chinese or level fields');
    }

    return hskData;
  } catch (error) {
    console.error('❌ Error loading HSK data:', error.message);
    throw error;
  }
}

/**
 * Update dictionary with HSK levels in batches
 */
async function updateDictionaryWithHskLevels(hskData, connectionType, batchSize = DEFAULT_BATCH_SIZE) {
  try {
    console.log(`🔄 Starting HSK level updates in batches of ${batchSize}...`);
    
    let updatedCount = 0;
    let notFoundCount = 0;
    let errorCount = 0;
    
    if (connectionType === 'postgresql') {
      // Use more efficient bulk update for PostgreSQL
      return await updateWithPostgreSQL(hskData, batchSize);
    } else {
      // Use Supabase client method
      return await updateWithSupabaseClient(hskData, batchSize);
    }
  } catch (error) {
    console.error('❌ Error during HSK level updates:', error.message);
    throw error;
  }
}

/**
 * Update using direct PostgreSQL connection (more efficient)
 */
async function updateWithPostgreSQL(hskData, batchSize) {
  let updatedCount = 0;
  let notFoundCount = 0;
  let errorCount = 0;

  // Process in batches
  for (let i = 0; i < hskData.length; i += batchSize) {
    const batch = hskData.slice(i, i + batchSize);
    console.log(`\n📦 Processing batch ${Math.floor(i / batchSize) + 1}/${Math.ceil(hskData.length / batchSize)} (${batch.length} entries)`);
    
    try {
      // Create a temporary table with the data
      const values = batch.map(entry => 
        `('${entry.chinese.replace(/'/g, "''")}', '${entry.level.replace(/'/g, "''")}')`
      ).join(',\n');

      const updateQuery = `
        WITH hsk_updates (chinese, hsk_level) AS (
          VALUES ${values}
        )
        UPDATE dictionary 
        SET hsk_level = hsk_updates.hsk_level,
            updated_at = NOW()
        FROM hsk_updates 
        WHERE dictionary.chinese = hsk_updates.chinese;
      `;

      const result = await pgClient.query(updateQuery);
      const batchUpdated = result.rowCount;
      updatedCount += batchUpdated;
      notFoundCount += (batch.length - batchUpdated);

      console.log(`   ✅ Updated: ${batchUpdated}/${batch.length} in this batch`);
      
    } catch (error) {
      errorCount += batch.length;
      console.error(`❌ Error in batch ${Math.floor(i / batchSize) + 1}:`, error.message);
    }

    // Small delay between batches
    if (i + batchSize < hskData.length) {
      await new Promise(resolve => setTimeout(resolve, 50));
    }
  }

  console.log('\n📊 Final Results:');
  console.log(`   ✅ Successfully updated: ${updatedCount} entries`);
  console.log(`   ⚠️  Words not found in dictionary: ${notFoundCount} entries`);
  console.log(`   ❌ Errors encountered: ${errorCount} entries`);
  console.log(`   📈 Success rate: ${((updatedCount / hskData.length) * 100).toFixed(2)}%`);

  return {
    total: hskData.length,
    updated: updatedCount,
    notFound: notFoundCount,
    errors: errorCount
  };
}

/**
 * Update using Supabase client (slower but more compatible)
 */
async function updateWithSupabaseClient(hskData, batchSize) {
  let updatedCount = 0;
  let notFoundCount = 0;
  let errorCount = 0;
  
  // Process in batches
  for (let i = 0; i < hskData.length; i += batchSize) {
    const batch = hskData.slice(i, i + batchSize);
    console.log(`\n📦 Processing batch ${Math.floor(i / batchSize) + 1}/${Math.ceil(hskData.length / batchSize)} (${batch.length} entries)`);
    
    const batchResults = await Promise.allSettled(
      batch.map(async (entry) => {
        try {
          const { data, error } = await supabase
            .from('dictionary')
            .update({ hsk_level: entry.level })
            .eq('chinese', entry.chinese)
            .select('chinese');

          if (error) {
            throw error;
          }

          if (data && data.length > 0) {
            return { success: true, chinese: entry.chinese, level: entry.level };
          } else {
            return { success: false, chinese: entry.chinese, reason: 'not_found' };
          }
        } catch (error) {
          return { success: false, chinese: entry.chinese, error: error.message };
        }
      })
    );

    // Process batch results
    batchResults.forEach((result, index) => {
      if (result.status === 'fulfilled') {
        if (result.value.success) {
          updatedCount++;
        } else if (result.value.reason === 'not_found') {
          notFoundCount++;
        } else {
          errorCount++;
          console.error(`❌ Error updating ${result.value.chinese}:`, result.value.error);
        }
      } else {
        errorCount++;
        console.error(`❌ Promise failed for entry ${i + index}:`, result.reason);
      }
    });

    // Progress update
    console.log(`   ✅ Updated: ${updatedCount} | ⚠️  Not found: ${notFoundCount} | ❌ Errors: ${errorCount}`);
    
    // Small delay between batches to avoid overwhelming the database
    if (i + batchSize < hskData.length) {
      await new Promise(resolve => setTimeout(resolve, 100));
    }
  }

  console.log('\n📊 Final Results:');
  console.log(`   ✅ Successfully updated: ${updatedCount} entries`);
  console.log(`   ⚠️  Words not found in dictionary: ${notFoundCount} entries`);
  console.log(`   ❌ Errors encountered: ${errorCount} entries`);
  console.log(`   📈 Success rate: ${((updatedCount / hskData.length) * 100).toFixed(2)}%`);

  return {
    total: hskData.length,
    updated: updatedCount,
    notFound: notFoundCount,
    errors: errorCount
  };
}

/**
 * Verify HSK level updates
 */
async function verifyHskUpdates(connectionType) {
  try {
    console.log('\n🔍 Verifying HSK level updates...');
    
    let stats, totalDictionary;
    
    if (connectionType === 'postgresql') {
      // Direct PostgreSQL queries
      const statsResult = await pgClient.query(`
        SELECT hsk_level, COUNT(*) as count 
        FROM dictionary 
        WHERE hsk_level IS NOT NULL 
        GROUP BY hsk_level 
        ORDER BY hsk_level;
      `);
      
      const totalResult = await pgClient.query('SELECT COUNT(*) as total FROM dictionary;');
      
      stats = statsResult.rows;
      totalDictionary = parseInt(totalResult.rows[0].total);
      
    } else {
      // Supabase client queries
      const { data: statsData, error } = await supabase
        .from('dictionary')
        .select('hsk_level')
        .not('hsk_level', 'is', null);

      if (error) {
        throw error;
      }

      const levelCounts = {};
      statsData.forEach(entry => {
        const level = entry.hsk_level;
        levelCounts[level] = (levelCounts[level] || 0) + 1;
      });

      stats = Object.entries(levelCounts).map(([hsk_level, count]) => ({ hsk_level, count }));
      
      const { data: totalEntries, error: countError } = await supabase
        .from('dictionary')
        .select('chinese', { count: 'exact' });

      if (countError) {
        throw countError;
      }

      totalDictionary = totalEntries.length;
    }

    console.log('📊 HSK Level Distribution:');
    stats
      .sort((a, b) => a.hsk_level.localeCompare(b.hsk_level))
      .forEach(({ hsk_level, count }) => {
        console.log(`   ${hsk_level}: ${count} entries`);
      });

    const totalWithHsk = stats.reduce((sum, { count }) => sum + parseInt(count), 0);
    console.log(`\n📈 Coverage: ${totalWithHsk}/${totalDictionary} dictionary entries have HSK levels (${((totalWithHsk/totalDictionary)*100).toFixed(2)}%)`);

    return stats.reduce((acc, { hsk_level, count }) => {
      acc[hsk_level] = parseInt(count);
      return acc;
    }, {});
  } catch (error) {
    console.error('❌ Error verifying HSK updates:', error.message);
    throw error;
  }
}

/**
 * Main execution function
 */
async function main() {
  let connectionType = null;
  
  try {
    console.log('🚀 Starting HSK Level Update Process');
    console.log('====================================\n');

    // Initialize database connection
    connectionType = await initializeDatabase();
    console.log(`📡 Using connection type: ${connectionType}\n`);

    // Check if HSK column exists, add if not
    const hskColumnExists = await checkHskColumnExists(connectionType);
    if (!hskColumnExists) {
      await addHskLevelColumn(connectionType);
    } else {
      console.log('✅ HSK level column already exists');
    }

    // Load HSK data
    const hskData = await loadHskData();

    // Get batch size from environment or use default
    const batchSize = parseInt(process.env.BATCH_SIZE) || DEFAULT_BATCH_SIZE;
    console.log(`📦 Using batch size: ${batchSize}`);

    // Update dictionary with HSK levels
    const results = await updateDictionaryWithHskLevels(hskData, connectionType, batchSize);

    // Verify updates
    await verifyHskUpdates(connectionType);

    console.log('\n🎉 HSK Level Update Process Completed Successfully!');
    console.log('================================================\n');

  } catch (error) {
    console.error('\n💥 Fatal Error:', error.message);
    console.error('Stack trace:', error.stack);
    process.exit(1);
  } finally {
    // Clean up connections
    await cleanup();
  }
}

/**
 * Clean up database connections
 */
async function cleanup() {
  try {
    if (pgClient) {
      await pgClient.end();
      console.log('🔌 PostgreSQL connection closed');
    }
    // Supabase client doesn't need explicit cleanup
  } catch (error) {
    console.error('⚠️  Error during cleanup:', error.message);
  }
}

// Handle process termination gracefully
process.on('SIGINT', async () => {
  console.log('\n⚠️  Process interrupted. Cleaning up...');
  await cleanup();
  process.exit(1);
});

process.on('SIGTERM', async () => {
  console.log('\n⚠️  Process terminated. Cleaning up...');
  await cleanup();
  process.exit(1);
});

// Execute main function if this script is run directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main().catch(async (error) => {
    console.error('💥 Unhandled error:', error);
    await cleanup();
    process.exit(1);
  });
}

export {
  initializeDatabase,
  initializeSupabase,
  initializePostgreSQL,
  loadHskData,
  updateDictionaryWithHskLevels,
  verifyHskUpdates,
  addHskLevelColumn,
  checkHskColumnExists,
  cleanup
};