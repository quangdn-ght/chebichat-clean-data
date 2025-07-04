const fs = require('fs').promises;
const path = require('path');

// Configuration optimized for Supabase
const config = {
  batchSize: 500, // Smaller batches for better Supabase performance
  inputDir: './import',
  outputDir: './output',
  maxRecordsPerFile: 5000, // Split large imports for Supabase
  enableUpsert: true, // Handle duplicate entries
  logFile: 'import_log.txt'
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
  
  const requiredFields = ['chinese', 'pinyin', 'meaning_vi', 'meaning_en', 'example_cn', 'example_vi', 'example_en'];
  
  requiredFields.forEach(field => {
    if (!entry[field] || entry[field].trim() === '') {
      errors.push(`Entry ${index}: Missing or empty '${field}' field`);
    }
  });
  
  return errors;
}

/**
 * Generates a batch INSERT statement optimized for Supabase
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
 * Generates Supabase-optimized SQL header
 */
function generateSupabaseSQL(entries, fileStats, validationStats) {
  const timestamp = new Date().toISOString();
  
  return `-- Supabase Dictionary Import
-- Generated: ${timestamp}
-- Source files: ${fileStats.length} JSON files
-- Total entries: ${entries.length}
-- Optimized for Supabase online database

-- Supabase connection and performance settings
\\timing on
\\echo 'Starting dictionary import to Supabase...'

-- Create unique constraint for upsert if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'dictionary_chinese_pinyin_unique'
  ) THEN
    ALTER TABLE dictionary 
    ADD CONSTRAINT dictionary_chinese_pinyin_unique 
    UNIQUE (chinese, pinyin);
  END IF;
END $$;

-- Import statistics
${generateDetailedStats(entries, fileStats, validationStats)}

-- Begin transaction with Supabase optimization
BEGIN;

-- Temporarily disable triggers for faster import
SELECT 'Disabling triggers for import...' as status;
ALTER TABLE dictionary DISABLE TRIGGER ALL;

-- Set session parameters for Supabase
SET session_replication_role = replica;
SET work_mem = '64MB';
SET maintenance_work_mem = '256MB';

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
    console.log(`📂 Loading ${filePaths.length} JSON files...`);
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
SET session_replication_role = DEFAULT;

-- Commit transaction
COMMIT;

-- Update statistics
ANALYZE dictionary;

-- Part ${partNum} completion summary
SELECT 
  'Part ${partNum}/${totalParts} completed!' as status,
  COUNT(*) as total_records,
  COUNT(DISTINCT type) as unique_types,
  MAX(created_at) as latest_import
FROM dictionary 
WHERE created_at >= NOW() - INTERVAL '10 minutes';

\\echo 'Part ${partNum}/${totalParts} imported successfully!'
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

\\timing on
\\echo 'Starting master import process...'

-- Pre-import checks
SELECT 'Starting master import...' as status, NOW() as start_time;

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
 * Generates verification script
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

-- Search function tests
SELECT 'Search function tests:' as info;
SELECT 'Vietnamese search test:' as test_name, chinese, meaning_vi 
FROM search_dictionary_vietnamese('yêu') LIMIT 3;

SELECT 'Chinese search test:' as test_name, chinese, pinyin, meaning_vi 
FROM search_dictionary_chinese('爱') LIMIT 3;

\\echo 'Verification completed!'
`;
  
  await fs.writeFile(filepath, sql, 'utf8');
  console.log(`✅ Generated verification script: ${filename}`);
}

/**
 * CLI interface
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

Usage Instructions:
1. Place your JSON files in ./import folder
2. Run: node dictionayImport.js bulk
3. Apply schema: psql -d your_db -f ../db/dictionary_schema.sql
4. Import data: psql -d your_db -f output/dictionary_supabase_*.sql
5. Verify: psql -d your_db -f output/dictionary_supabase_verify_*.sql
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
 * Single file import for backward compatibility
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
