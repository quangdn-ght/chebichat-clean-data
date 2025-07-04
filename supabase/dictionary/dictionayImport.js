const fs = require('fs').promises;
const path = require('path');

// Configuration optimized for Supabase
const config = {
  batchSize: 500, // Smaller batches for better Supabase performance
  inputDir: './import',
  outputDir: './output',
  sqlOutputFile: 'dictionary_supabase_import.sql',
  logFile: 'import_log.txt',
  maxRecordsPerFile: 5000, // Split large imports for Supabase
  enableUpsert: true, // Handle duplicate entries
  supabaseOptimized: true
};

/**
 * Escapes single quotes in SQL strings
 */
function escapeSqlString(str) {
  if (str === null || str === undefined) return 'NULL';
  return "'" + str.toString().replace(/'/g, "''") + "'";
}

/**
 * Validates and normalizes word type to match enum
 */
function normalizeWordType(type) {
  const validTypes = [
    'danh từ', 'động từ', 'tính từ', 'trạng từ', 'đại từ', 'giới từ', 
    'liên từ', 'thán từ', 'số từ', 'lượng từ', 'phó từ', 'other'
  ];
  
  if (!type || typeof type !== 'string') return 'other';
  
  const normalizedType = type.trim().toLowerCase();
  const found = validTypes.find(t => t.toLowerCase() === normalizedType);
  return found || 'other';
}

/**
 * Validates a dictionary entry
 */
function validateEntry(entry, index) {
  const errors = [];
  
  if (!entry.chinese || entry.chinese.trim() === '') {
    errors.push(`Entry ${index}: Missing or empty 'chinese' field`);
  }
  
  if (!entry.pinyin || entry.pinyin.trim() === '') {
    errors.push(`Entry ${index}: Missing or empty 'pinyin' field`);
  }
  
  if (!entry.meaning_vi || entry.meaning_vi.trim() === '') {
    errors.push(`Entry ${index}: Missing or empty 'meaning_vi' field`);
  }
  
  if (!entry.meaning_en || entry.meaning_en.trim() === '') {
    errors.push(`Entry ${index}: Missing or empty 'meaning_en' field`);
  }
  
  if (!entry.example_cn || entry.example_cn.trim() === '') {
    errors.push(`Entry ${index}: Missing or empty 'example_cn' field`);
  }
  
  if (!entry.example_vi || entry.example_vi.trim() === '') {
    errors.push(`Entry ${index}: Missing or empty 'example_vi' field`);
  }
  
  if (!entry.example_en || entry.example_en.trim() === '') {
    errors.push(`Entry ${index}: Missing or empty 'example_en' field`);
  }
  
  return errors;
}

/**
 * Generates a single INSERT statement for a batch of entries (Supabase optimized)
 */
function generateBatchInsert(entries, batchNumber) {
  const values = entries.map(entry => {
    const chinese = escapeSqlString(entry.chinese?.trim());
    const pinyin = escapeSqlString(entry.pinyin?.trim());
    const type = escapeSqlString(normalizeWordType(entry.type));
    const meaning_vi = escapeSqlString(entry.meaning_vi?.trim());
    const meaning_en = escapeSqlString(entry.meaning_en?.trim());
    const example_cn = escapeSqlString(entry.example_cn?.trim());
    const example_vi = escapeSqlString(entry.example_vi?.trim());
    const example_en = escapeSqlString(entry.example_en?.trim());
    const grammar = escapeSqlString(entry.grammar?.trim() || '');
    
    return `(${chinese}, ${pinyin}, ${type}, ${meaning_vi}, ${meaning_en}, ${example_cn}, ${example_vi}, ${example_en}, ${grammar})`;
  }).join(',\n  ');

  if (config.enableUpsert) {
    return `-- Batch ${batchNumber} (${entries.length} records) - UPSERT mode
INSERT INTO dictionary (chinese, pinyin, type, meaning_vi, meaning_en, example_cn, example_vi, example_en, grammar)
VALUES
  ${values}
ON CONFLICT (chinese, pinyin) 
DO UPDATE SET
  type = EXCLUDED.type,
  meaning_vi = EXCLUDED.meaning_vi,
  meaning_en = EXCLUDED.meaning_en,
  example_cn = EXCLUDED.example_cn,
  example_vi = EXCLUDED.example_vi,
  example_en = EXCLUDED.example_en,
  grammar = EXCLUDED.grammar,
  updated_at = NOW();

`;
  } else {
    return `-- Batch ${batchNumber} (${entries.length} records)
INSERT INTO dictionary (chinese, pinyin, type, meaning_vi, meaning_en, example_cn, example_vi, example_en, grammar)
VALUES
  ${values};

`;
  }
}

/**
 * Scans import directory for JSON files
 */
async function scanImportDirectory() {
  try {
    await fs.mkdir(config.inputDir, { recursive: true });
    const files = await fs.readdir(config.inputDir);
    const jsonFiles = files.filter(file => path.extname(file).toLowerCase() === '.json');
    
    console.log(`📁 Found ${jsonFiles.length} JSON files in ${config.inputDir}:`);
    jsonFiles.forEach(file => console.log(`   - ${file}`));
    
    return jsonFiles.map(file => path.join(config.inputDir, file));
  } catch (error) {
    console.error(`❌ Error scanning import directory: ${error.message}`);
    return [];
  }
}

/**
 * Loads and merges all JSON files
 */
async function loadAllJsonFiles(filePaths) {
  const allEntries = [];
  const fileStats = [];
  
  for (const filePath of filePaths) {
    try {
      console.log(`📖 Loading: ${path.basename(filePath)}`);
      const rawData = await fs.readFile(filePath, 'utf8');
      const entries = JSON.parse(rawData);
      
      if (!Array.isArray(entries)) {
        console.warn(`⚠️  Skipping ${filePath}: Not an array`);
        continue;
      }
      
      allEntries.push(...entries);
      fileStats.push({
        file: path.basename(filePath),
        count: entries.length,
        size: rawData.length
      });
      
      console.log(`   ✓ Loaded ${entries.length} entries`);
    } catch (error) {
      console.error(`❌ Error loading ${filePath}: ${error.message}`);
    }
  }
  
  return { allEntries, fileStats };
}

/**
 * Generates Supabase-optimized SQL with role permissions and connection handling
 */
function generateSupabaseSQL(entries, fileStats, validationStats) {
  const timestamp = new Date().toISOString();
  
  return `-- Supabase Dictionary Import
-- Generated: ${timestamp}
-- Source files: ${fileStats.length} JSON files
-- Total entries: ${entries.length}
-- Optimized for Supabase online database with role permissions

-- Supabase connection and role setup
\\timing on
\\echo 'Starting dictionary import to Supabase...'

-- Check current user and role
SELECT 
  'Import starting as user: ' || current_user as info,
  'Current database: ' || current_database() as db_info,
  NOW() as start_time;

-- Set role to postgres for full permissions (Supabase)
DO $$
BEGIN
  -- Check if postgres role exists and we can switch to it
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'postgres') THEN
    -- For Supabase, we typically connect as postgres user
    EXECUTE 'SET ROLE postgres';
    RAISE NOTICE 'Switched to postgres role for import operations';
  ELSE
    -- Fallback for non-postgres environments
    RAISE NOTICE 'Using current role: %', current_user;
  END IF;
EXCEPTION
  WHEN insufficient_privilege THEN
    RAISE NOTICE 'Cannot switch to postgres role, using current role: %', current_user;
  WHEN OTHERS THEN
    RAISE NOTICE 'Role switch failed, proceeding with current role: %', current_user;
END $$;

-- Verify we have necessary permissions
DO $$
BEGIN
  -- Check if we can create constraints
  IF NOT has_table_privilege('dictionary', 'REFERENCES') THEN
    RAISE EXCEPTION 'Insufficient permissions for dictionary table operations';
  END IF;
  
  -- Check if we can insert data
  IF NOT has_table_privilege('dictionary', 'INSERT') THEN
    RAISE EXCEPTION 'Insufficient permissions to insert into dictionary table';
  END IF;
END $$;

-- Create unique constraint for upsert if not exists (with proper permissions)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'dictionary_chinese_pinyin_unique'
  ) THEN
    ALTER TABLE dictionary 
    ADD CONSTRAINT dictionary_chinese_pinyin_unique 
    UNIQUE (chinese, pinyin);
    RAISE NOTICE 'Created unique constraint for upsert operations';
  END IF;
END $$;

-- Setup Supabase-specific session configuration
SELECT 'Configuring Supabase session for optimal import...' as status;

-- Call setup function if available
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'setup_import_session') THEN
    PERFORM setup_import_session();
    RAISE NOTICE 'Import session optimizations applied';
  ELSE
    -- Manual session setup for Supabase
    SET work_mem = '64MB';
    SET maintenance_work_mem = '256MB';
    SET checkpoint_completion_target = 0.9;
    RAISE NOTICE 'Manual session optimization applied';
  END IF;
END $$;

-- Import statistics and metadata
${generateDetailedStats(entries, fileStats, validationStats)}

-- Begin transaction with Supabase-specific optimizations
BEGIN;

-- Temporarily disable RLS for import performance (Supabase specific)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_class c 
    JOIN pg_namespace n ON n.oid = c.relnamespace 
    WHERE c.relname = 'dictionary' AND n.nspname = 'public'
  ) THEN
    ALTER TABLE dictionary DISABLE ROW LEVEL SECURITY;
    RAISE NOTICE 'RLS disabled for import performance';
  END IF;
END $$;

-- Disable triggers for faster import
SELECT 'Disabling triggers for bulk import...' as status;
ALTER TABLE dictionary DISABLE TRIGGER ALL;

-- Set Supabase session parameters for bulk import
SET session_replication_role = replica;

-- Grant temporary permissions if needed
DO $$
BEGIN
  -- Ensure we have all necessary permissions for this session
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    GRANT SELECT, INSERT, UPDATE ON dictionary TO authenticated;
  END IF;
END $$;

`;
}


/**
 * Generates detailed import statistics
 */
function generateDetailedStats(entries, fileStats, validationStats) {
  const typeCount = {};
  entries.forEach(entry => {
    const type = normalizeWordType(entry.type);
    typeCount[type] = (typeCount[type] || 0) + 1;
  });
  
  const totalSize = fileStats.reduce((sum, stat) => sum + stat.size, 0);
  
  return `/*
📊 IMPORT STATISTICS
====================

Source Files:
${fileStats.map(stat => `  - ${stat.file}: ${stat.count} entries (${(stat.size/1024).toFixed(1)}KB)`).join('\n')}

Total Data:
  - Files processed: ${fileStats.length}
  - Total entries: ${entries.length}
  - Valid entries: ${validationStats.validCount}
  - Invalid entries: ${validationStats.invalidCount}
  - Success rate: ${((validationStats.validCount / entries.length) * 100).toFixed(1)}%
  - Total size: ${(totalSize/1024/1024).toFixed(2)}MB

Entries by Type:
${Object.entries(typeCount).map(([type, count]) => `  - ${type}: ${count} (${((count/entries.length)*100).toFixed(1)}%)`).join('\n')}

Database Impact:
  - Estimated storage: ${((totalSize * 1.5)/1024/1024).toFixed(2)}MB
  - Estimated import time: ${Math.ceil(entries.length / 1000)} minutes
  - Recommended batch size: ${config.batchSize}
*/

`;
}

/**
 * Generates statistics about the import (legacy function - kept for compatibility)
 */
function generateStats(entries, validEntries, errors) {
  const typeCount = {};
  validEntries.forEach(entry => {
    const type = normalizeWordType(entry.type);
    typeCount[type] = (typeCount[type] || 0) + 1;
  });
  
  const avgLengths = {
    chinese: validEntries.reduce((sum, e) => sum + (e.chinese?.length || 0), 0) / validEntries.length,
    pinyin: validEntries.reduce((sum, e) => sum + (e.pinyin?.length || 0), 0) / validEntries.length,
    meaning_vi: validEntries.reduce((sum, e) => sum + (e.meaning_vi?.length || 0), 0) / validEntries.length,
    meaning_en: validEntries.reduce((sum, e) => sum + (e.meaning_en?.length || 0), 0) / validEntries.length
  };
  
  return `-- Import Statistics
-- Total entries processed: ${entries.length}
-- Valid entries: ${validEntries.length}
-- Invalid entries: ${entries.length - validEntries.length}
-- Validation errors: ${errors.length}
--
-- Entries by type:
${Object.entries(typeCount).map(([type, count]) => `--   ${type}: ${count}`).join('\n')}
--
-- Average field lengths:
--   Chinese: ${avgLengths.chinese.toFixed(1)} characters
--   Pinyin: ${avgLengths.pinyin.toFixed(1)} characters
--   Vietnamese meaning: ${avgLengths.meaning_vi.toFixed(1)} characters
--   English meaning: ${avgLengths.meaning_en.toFixed(1)} characters
--

`;
}

/**
 * Main import function - optimized for multiple files and Supabase
 */
async function importAllDictionaries() {
  try {
    console.log('🚀 Starting bulk dictionary import for Supabase...');
    
    // Ensure directories exist
    await fs.mkdir(config.outputDir, { recursive: true });
    
    // Scan for JSON files
    const filePaths = await scanImportDirectory();
    if (filePaths.length === 0) {
      throw new Error(`No JSON files found in ${config.inputDir}`);
    }
    
    // Load all JSON files
    console.log(`� Loading ${filePaths.length} JSON files...`);
    const { allEntries, fileStats } = await loadAllJsonFiles(filePaths);
    
    if (allEntries.length === 0) {
      throw new Error('No valid entries found in any JSON files');
    }
    
    console.log(`📊 Total entries loaded: ${allEntries.length}`);
    
    // Validate all entries
    console.log('🔍 Validating all entries...');
    const allErrors = [];
    const validEntries = [];
    
    allEntries.forEach((entry, index) => {
      const errors = validateEntry(entry, index + 1);
      if (errors.length > 0) {
        allErrors.push(...errors);
      } else {
        validEntries.push(entry);
      }
    });
    
    const validationStats = {
      validCount: validEntries.length,
      invalidCount: allEntries.length - validEntries.length,
      errorCount: allErrors.length
    };
    
    console.log(`✅ Valid entries: ${validEntries.length}`);
    console.log(`❌ Invalid entries: ${validationStats.invalidCount}`);
    
    if (allErrors.length > 0) {
      console.log(`⚠️  Found ${allErrors.length} validation errors`);
      
      // Write errors to log file
      const errorLog = `Import Error Log - ${new Date().toISOString()}\n` +
                      `Source files: ${fileStats.map(s => s.file).join(', ')}\n\n` +
                      allErrors.join('\n') + '\n';
      await fs.writeFile(path.join(config.outputDir, config.logFile), errorLog, 'utf8');
      console.log(`📝 Errors logged to: ${path.join(config.outputDir, config.logFile)}`);
    }
    
    if (validEntries.length === 0) {
      throw new Error('No valid entries found to import');
    }
    
    // Generate SQL files
    await generateSupabaseImportFiles(validEntries, fileStats, validationStats);
    
    return {
      totalFiles: filePaths.length,
      totalEntries: allEntries.length,
      validEntries: validEntries.length,
      invalidEntries: validationStats.invalidCount,
      errors: allErrors.length,
      fileStats: fileStats
    };
    
  } catch (error) {
    console.error('❌ Bulk import failed:', error.message);
    throw error;
  }
}

/**
 * Generates multiple SQL files optimized for Supabase
 */
async function generateSupabaseImportFiles(entries, fileStats, validationStats) {
  console.log('🔧 Generating Supabase-optimized SQL files...');
  
  // Split into multiple files if too large
  const filesNeeded = Math.ceil(entries.length / config.maxRecordsPerFile);
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  
  if (filesNeeded > 1) {
    console.log(`📦 Splitting into ${filesNeeded} files (max ${config.maxRecordsPerFile} records each)`);
    
    for (let fileIndex = 0; fileIndex < filesNeeded; fileIndex++) {
      const startIdx = fileIndex * config.maxRecordsPerFile;
      const endIdx = Math.min(startIdx + config.maxRecordsPerFile, entries.length);
      const fileEntries = entries.slice(startIdx, endIdx);
      
      const filename = `dictionary_supabase_part_${fileIndex + 1}_of_${filesNeeded}_${timestamp}.sql`;
      await generateSingleSupabaseFile(fileEntries, fileStats, validationStats, filename, fileIndex + 1, filesNeeded);
    }
    
    // Generate master script
    await generateMasterScript(filesNeeded, timestamp);
  } else {
    // Single file
    const filename = `dictionary_supabase_complete_${timestamp}.sql`;
    await generateSingleSupabaseFile(entries, fileStats, validationStats, filename, 1, 1);
  }
  
  // Generate verification script
  await generateVerificationScript(timestamp, entries.length);
}

/**
 * Generates a single Supabase SQL file
 */
async function generateSingleSupabaseFile(entries, fileStats, validationStats, filename, partNum, totalParts) {
  const filepath = path.join(config.outputDir, filename);
  
  let sql = generateSupabaseSQL(entries, fileStats, validationStats);
  
  sql += `-- Part ${partNum} of ${totalParts}
-- Records: ${entries.length}
SELECT 'Processing part ${partNum}/${totalParts} - ${entries.length} records...' as status;

`;
  
  // Process in batches
  const totalBatches = Math.ceil(entries.length / config.batchSize);
  console.log(`📦 Part ${partNum}: Processing ${entries.length} entries in ${totalBatches} batches...`);
  
  for (let i = 0; i < entries.length; i += config.batchSize) {
    const batch = entries.slice(i, i + config.batchSize);
    const batchNumber = Math.floor(i / config.batchSize) + 1;
    
    sql += generateBatchInsert(batch, batchNumber);
    
    // Add progress indicator every 10 batches
    if (batchNumber % 10 === 0) {
      sql += `SELECT 'Completed ${batchNumber}/${totalBatches} batches...' as progress;\n\n`;
    }
  }
  
  sql += `-- Re-enable triggers and complete part ${partNum}
SELECT 'Re-enabling triggers for part ${partNum}...' as status;
ALTER TABLE dictionary ENABLE TRIGGER ALL;

-- Re-enable RLS (Supabase specific)
DO $$
BEGIN
  ALTER TABLE dictionary ENABLE ROW LEVEL SECURITY;
  RAISE NOTICE 'RLS re-enabled for security';
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'RLS re-enable skipped (may not be configured)';
END $$;

-- Reset session parameters
SET session_replication_role = DEFAULT;

-- Cleanup session optimization
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'cleanup_import_session') THEN
    PERFORM cleanup_import_session();
    RAISE NOTICE 'Import session cleanup completed';
  ELSE
    -- Manual cleanup
    RESET work_mem;
    RESET maintenance_work_mem;
    RESET checkpoint_completion_target;
    RAISE NOTICE 'Manual session cleanup completed';
  END IF;
END $$;

-- Reset role to default (restore original session role)
DO $$
BEGIN
  -- Reset to default role for Supabase
  RESET ROLE;
  RAISE NOTICE 'Session role reset to: %', current_user;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Role reset completed (with warnings)';
END $$;

-- Commit transaction
COMMIT;

-- Update table statistics for Supabase query planner
ANALYZE dictionary;

-- Grant final permissions to Supabase roles (with error handling)
DO $$
BEGIN
  -- Grant read access to authenticated users
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    BEGIN
      GRANT SELECT ON dictionary TO authenticated;
      GRANT USAGE ON SCHEMA public TO authenticated;
      RAISE NOTICE 'Read permissions granted to authenticated users';
    EXCEPTION
      WHEN insufficient_privilege THEN
        RAISE NOTICE 'Cannot grant permissions to authenticated role (managed instance)';
      WHEN OTHERS THEN
        RAISE NOTICE 'Permission grant to authenticated role failed: %', SQLERRM;
    END;
  END IF;
  
  -- Grant limited access to anon users (optional - customize as needed)
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    BEGIN
      GRANT SELECT ON dictionary TO anon;
      GRANT USAGE ON SCHEMA public TO anon;
      RAISE NOTICE 'Read permissions granted to anonymous users';
    EXCEPTION
      WHEN insufficient_privilege THEN
        RAISE NOTICE 'Cannot grant permissions to anon role (managed instance)';
      WHEN OTHERS THEN
        RAISE NOTICE 'Permission grant to anon role failed: %', SQLERRM;
    END;
  END IF;
  
  -- Log final permission status
  RAISE NOTICE 'Permission setup completed for Supabase roles';
END $$;

-- Part ${partNum} completion summary with Supabase-specific checks
SELECT 
  'Part ${partNum}/${totalParts} completed!' as status,
  COUNT(*) as total_records,
  COUNT(DISTINCT type) as unique_types,
  MAX(created_at) as latest_import,
  current_user as import_user,
  current_database() as target_database
FROM dictionary 
WHERE created_at >= NOW() - INTERVAL '10 minutes';

-- Verify permissions are properly set
SELECT 
  'Permission verification:' as info,
  has_table_privilege('authenticated', 'dictionary', 'SELECT') as auth_can_read,
  has_table_privilege('anon', 'dictionary', 'SELECT') as anon_can_read;

\\echo 'Part ${partNum}/${totalParts} imported successfully to Supabase!'
`;
  
  await fs.writeFile(filepath, sql, 'utf8');
  console.log(`✅ Generated: ${filename} (${(sql.length / 1024 / 1024).toFixed(2)} MB)`);
}

/**
 * Generates master import script
 */
async function generateMasterScript(totalParts, timestamp) {
  const filename = `dictionary_supabase_master_${timestamp}.sql`;
  const filepath = path.join(config.outputDir, filename);
  
  let sql = `-- Supabase Dictionary Master Import Script
-- Generated: ${new Date().toISOString()}
-- Total parts: ${totalParts}
-- 
-- This script coordinates the import of all dictionary parts
-- Run this OR run individual part files

\\timing on
\\echo 'Starting master import process...'

-- Pre-import checks
SELECT 
  'Starting master import...' as status,
  NOW() as start_time;

-- Check if dictionary table exists
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'dictionary') THEN
    RAISE EXCEPTION 'Dictionary table does not exist. Please run the schema setup first.';
  END IF;
END $$;

-- Show current state
SELECT 'Current dictionary state:' as info;
SELECT COUNT(*) as existing_records FROM dictionary;

`;

  for (let i = 1; i <= totalParts; i++) {
    sql += `-- Import part ${i}
\\echo 'Importing part ${i}/${totalParts}...'
\\i dictionary_supabase_part_${i}_of_${totalParts}_${timestamp}.sql

`;
  }
  
  sql += `-- Final summary
SELECT 'Master import completed!' as status;
SELECT 
  COUNT(*) as total_records,
  COUNT(DISTINCT type) as unique_types,
  COUNT(DISTINCT chinese) as unique_chinese_words,
  MIN(created_at) as earliest_entry,
  MAX(created_at) as latest_entry
FROM dictionary;

\\echo 'All parts imported successfully!'
`;
  
  await fs.writeFile(filepath, sql, 'utf8');
  console.log(`✅ Generated master script: ${filename}`);
}

/**
 * Generates verification and statistics script
 */
async function generateVerificationScript(timestamp, expectedRecords) {
  const filename = `dictionary_supabase_verify_${timestamp}.sql`;
  const filepath = path.join(config.outputDir, filename);
  
  const sql = `-- Supabase Dictionary Import Verification
-- Generated: ${new Date().toISOString()}
-- Expected records: ${expectedRecords}

\\timing on
\\echo 'Running import verification...'

-- Basic counts
SELECT 'Import verification results:' as info;

SELECT 
  'Total Records' as metric,
  COUNT(*) as value,
  '${expectedRecords}' as expected,
  CASE 
    WHEN COUNT(*) = ${expectedRecords} THEN '✅ PASS'
    ELSE '❌ FAIL'
  END as status
FROM dictionary
UNION ALL
SELECT 
  'Unique Chinese Words' as metric,
  COUNT(DISTINCT chinese)::text as value,
  'N/A' as expected,
  '✅ INFO' as status
FROM dictionary
UNION ALL
SELECT 
  'Word Types' as metric,
  COUNT(DISTINCT type)::text as value,
  'N/A' as expected,
  '✅ INFO' as status
FROM dictionary;

-- Type distribution
SELECT 'Word type distribution:' as info;
SELECT 
  type,
  COUNT(*) as count,
  ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()), 2) as percentage
FROM dictionary 
GROUP BY type 
ORDER BY count DESC;

-- Data quality checks
SELECT 'Data quality checks:' as info;

-- Check for empty required fields
SELECT 
  'Empty Chinese fields' as check_type,
  COUNT(*) as count,
  CASE WHEN COUNT(*) = 0 THEN '✅ PASS' ELSE '❌ FAIL' END as status
FROM dictionary WHERE chinese IS NULL OR chinese = ''
UNION ALL
SELECT 
  'Empty Pinyin fields' as check_type,
  COUNT(*) as count,
  CASE WHEN COUNT(*) = 0 THEN '✅ PASS' ELSE '❌ FAIL' END as status
FROM dictionary WHERE pinyin IS NULL OR pinyin = ''
UNION ALL
SELECT 
  'Empty Vietnamese meanings' as check_type,
  COUNT(*) as count,
  CASE WHEN COUNT(*) = 0 THEN '✅ PASS' ELSE '❌ FAIL' END as status
FROM dictionary WHERE meaning_vi IS NULL OR meaning_vi = '';

-- Index performance check
SELECT 'Index usage verification:' as info;
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM dictionary WHERE chinese ILIKE '%爱%' LIMIT 5;

-- Search function tests
SELECT 'Search function tests:' as info;
SELECT 'Vietnamese search test:' as test_name, chinese, meaning_vi 
FROM search_dictionary_vietnamese('yêu') LIMIT 3;

SELECT 'Chinese search test:' as test_name, chinese, pinyin, meaning_vi 
FROM search_dictionary_chinese('爱') LIMIT 3;

-- Performance stats
SELECT 'Performance statistics:' as info;
SELECT * FROM dictionary_stats LIMIT 10;

\\echo 'Verification completed!'
`;
  
  await fs.writeFile(filepath, sql, 'utf8');
  console.log(`✅ Generated verification script: ${filename}`);
}

/**
 * CLI usage - enhanced for bulk import
 */
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];
  
  if (!command || command === 'help' || command === '--help') {
    console.log(`
📚 Supabase Dictionary Import Tool (Enhanced)

Commands:
  bulk              Import all JSON files from ./import folder (recommended)
  single <file>     Import a single JSON file
  config            Show current configuration
  help              Show this help

Examples:
  node dictionayImport.js bulk
  node dictionayImport.js single ./test_data.json
  node dictionayImport.js config

Features:
✅ Bulk import from ./import folder
✅ Supabase optimization (smaller batches, upsert support)
✅ Multiple file output for large datasets
✅ Comprehensive validation and error logging
✅ Import verification scripts
✅ Master import coordination

Configuration:
- Input directory: ${config.inputDir}
- Output directory: ${config.outputDir}
- Batch size: ${config.batchSize} (optimized for Supabase)
- Max records per file: ${config.maxRecordsPerFile}
- Upsert mode: ${config.enableUpsert ? 'enabled' : 'disabled'}

Generated Files:
- dictionary_supabase_complete_[timestamp].sql (single file) or
- dictionary_supabase_part_X_of_Y_[timestamp].sql (multiple parts)
- dictionary_supabase_master_[timestamp].sql (coordinates multiple parts)
- dictionary_supabase_verify_[timestamp].sql (verification script)
`);
    process.exit(1);
  }
  
  try {
    switch (command) {
      case 'bulk':
        console.log('🚀 Starting bulk import from ./import folder...');
        const result = await importAllDictionaries();
        console.log('\n📊 Bulk Import Summary:');
        console.log(`   Files processed: ${result.totalFiles}`);
        console.log(`   Total entries: ${result.totalEntries}`);
        console.log(`   Valid entries: ${result.validEntries}`);
        console.log(`   Invalid entries: ${result.invalidEntries}`);
        console.log(`   Validation errors: ${result.errors}`);
        console.log(`   Success rate: ${((result.validEntries / result.totalEntries) * 100).toFixed(1)}%`);
        console.log('\n📁 File breakdown:');
        result.fileStats.forEach(stat => {
          console.log(`   ${stat.file}: ${stat.count} entries`);
        });
        console.log('\n🎯 Next steps:');
        console.log('1. Apply schema: psql -d your_db -f ../db/dictionary_schema.sql');
        console.log('2. Import data: psql -d your_db -f output/dictionary_supabase_*.sql');
        console.log('3. Verify: psql -d your_db -f output/dictionary_supabase_verify_*.sql');
        break;
        
      case 'single':
        if (!args[1]) {
          throw new Error('Please provide a file path: node dictionayImport.js single <file>');
        }
        console.log(`🚀 Starting single file import: ${args[1]}`);
        const singleResult = await importSingleFile(args[1]);
        console.log('\n📊 Import Summary:');
        console.log(`   Total entries: ${singleResult.totalEntries}`);
        console.log(`   Valid entries: ${singleResult.validEntries}`);
        console.log(`   Success rate: ${((singleResult.validEntries / singleResult.totalEntries) * 100).toFixed(1)}%`);
        break;
        
      case 'config':
        console.log('\n⚙️  Current Configuration:');
        Object.entries(config).forEach(([key, value]) => {
          console.log(`   ${key}: ${value}`);
        });
        break;
        
      default:
        throw new Error(`Unknown command: ${command}. Use 'help' for available commands.`);
    }
  } catch (error) {
    console.error('\n💥 Fatal error:', error.message);
    process.exit(1);
  }
}

/**
 * Legacy single file import (backward compatibility)
 */
async function importSingleFile(inputFile) {
  const filePaths = [inputFile];
  const { allEntries, fileStats } = await loadAllJsonFiles(filePaths);
  
  if (allEntries.length === 0) {
    throw new Error('No valid entries found in file');
  }
  
  // Validate entries
  const allErrors = [];
  const validEntries = [];
  
  allEntries.forEach((entry, index) => {
    const errors = validateEntry(entry, index + 1);
    if (errors.length > 0) {
      allErrors.push(...errors);
    } else {
      validEntries.push(entry);
    }
  });
  
  const validationStats = {
    validCount: validEntries.length,
    invalidCount: allEntries.length - validEntries.length,
    errorCount: allErrors.length
  };
  
  if (validEntries.length > 0) {
    await generateSupabaseImportFiles(validEntries, fileStats, validationStats);
  }
  
  return {
    totalEntries: allEntries.length,
    validEntries: validEntries.length,
    invalidEntries: validationStats.invalidCount,
    errors: allErrors.length
  };
}

// Export for use as module
module.exports = {
  importAllDictionaries,
  importSingleFile,
  generateBatchInsert,
  validateEntry,
  normalizeWordType,
  escapeSqlString,
  config
};

// Run if called directly
if (require.main === module) {
  main();
}
