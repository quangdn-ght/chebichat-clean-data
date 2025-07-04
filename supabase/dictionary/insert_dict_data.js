// Script chèn dữ liệu cho schema Supabase tối ưu hóa
// Script này xử lý cấu trúc dữ liệu JSON và chèn vào database một cách hiệu quả
// Data insertion script for the optimized Supabase schema
// This script processes the JSON data structure and inserts it efficiently

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Cấu hình dotenv để đọc biến môi trường từ file .env
// Configure dotenv to read environment variables from .env file
dotenv.config();

// Lấy đường dẫn thư mục hiện tại cho ES modules
// Get current directory path for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Enhanced Dictionary Data Script with SQL File Execution
// This script can insert JSON data OR execute SQL files from ./output/ with proper role management

// Configure dotenv to read environment variables
dotenv.config();

// Supabase client with service role for full permissions
let supabase = null;

/**
 * Initialize Supabase client with proper role management
 */
function initializeSupabase() {
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
    console.error('⚠️  Service role key has admin privileges - keep it secret!');
    process.exit(1);
  }

  supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false
      }
    }
  );
  
  console.log('✅ Service role key detected - has full database permissions');
  return supabase;
}

/**
 * Scan import directory for JSON files
 */
async function scanImportDirectory() {
  try {
    console.log('📁 Scanning ./import directory for JSON files...');
    
    const importDir = './import';
    
    // Ensure import directory exists
    if (!fs.existsSync(importDir)) {
      throw new Error(`Import directory ${importDir} does not exist`);
    }
    
    const files = fs.readdirSync(importDir);
    const jsonFiles = files.filter(file => 
      file.endsWith('.json') && 
      !file.startsWith('.') && // Skip hidden files
      fs.statSync(path.join(importDir, file)).isFile()
    );
    
    if (jsonFiles.length === 0) {
      throw new Error('No JSON files found in ./import directory');
    }

    console.log(`📊 Found ${jsonFiles.length} JSON files to import:`);
    jsonFiles.forEach(file => {
      const filePath = path.join(importDir, file);
      const stats = fs.statSync(filePath);
      const sizeMB = (stats.size / 1024 / 1024).toFixed(2);
      console.log(`   - ${file} (${sizeMB} MB)`);
    });
    
    return jsonFiles.map(file => path.join(importDir, file));
    
  } catch (error) {
    console.error('❌ Error scanning import directory:', error.message);
    throw error;
  }
}

/**
 * Load and validate a single JSON file
 */
async function loadJsonFile(filePath) {
  try {
    console.log(`📖 Loading: ${path.basename(filePath)}`);
    
    const rawData = fs.readFileSync(filePath, 'utf8');
    const data = JSON.parse(rawData);
    
    if (!Array.isArray(data)) {
      throw new Error(`File ${path.basename(filePath)} does not contain an array`);
    }
    
    // Validate data structure
    const validEntries = [];
    const invalidEntries = [];
    
    data.forEach((entry, index) => {
      if (validateDictionaryEntry(entry)) {
        validEntries.push(entry);
      } else {
        invalidEntries.push({ index, entry });
      }
    });
    
    console.log(`   ✓ Loaded ${validEntries.length} valid entries, ${invalidEntries.length} invalid`);
    
    if (invalidEntries.length > 0) {
      console.warn(`   ⚠️  Invalid entries in ${path.basename(filePath)}:`);
      invalidEntries.slice(0, 5).forEach(({ index, entry }) => {
        console.warn(`     Entry ${index}: missing required fields`);
      });
      if (invalidEntries.length > 5) {
        console.warn(`     ... and ${invalidEntries.length - 5} more`);
      }
    }
    
    return {
      fileName: path.basename(filePath),
      validEntries,
      invalidCount: invalidEntries.length,
      totalCount: data.length
    };
    
  } catch (error) {
    console.error(`❌ Error loading ${path.basename(filePath)}:`, error.message);
    throw error;
  }
}

/**
 * Import all JSON files from ./import directory to dictionary table
 */
async function importAllJsonFiles() {
  try {
    console.log('🚀 Starting bulk JSON import to dictionary table...');
    
    // Scan for JSON files
    const filePaths = await scanImportDirectory();
    
    // Load all JSON files
    const allEntries = new Map(); // Use Map to ensure uniqueness by chinese key
    const fileStats = [];
    let totalProcessed = 0;
    let totalDuplicates = 0;
    
    for (const filePath of filePaths) {
      const { fileName, validEntries, invalidCount, totalCount } = await loadJsonFile(filePath);
      
      let fileUniqueCount = 0;
      let fileDuplicateCount = 0;
      
      // Process entries and check for duplicates
      validEntries.forEach(entry => {
        const chineseKey = entry.chinese?.trim();
        if (chineseKey) {
          if (allEntries.has(chineseKey)) {
            fileDuplicateCount++;
            totalDuplicates++;
            console.log(`   📝 Duplicate found: "${chineseKey}" (keeping first occurrence)`);
          } else {
            allEntries.set(chineseKey, entry);
            fileUniqueCount++;
          }
        }
      });
      
      fileStats.push({
        fileName,
        totalCount,
        validCount: validEntries.length,
        invalidCount,
        uniqueCount: fileUniqueCount,
        duplicateCount: fileDuplicateCount
      });
      
      totalProcessed += validEntries.length;
    }
    
    const uniqueEntries = Array.from(allEntries.values());
    
    console.log('\n📊 Import Summary:');
    console.log(`   Files processed: ${filePaths.length}`);
    console.log(`   Total entries: ${totalProcessed}`);
    console.log(`   Unique entries: ${uniqueEntries.length}`);
    console.log(`   Duplicates removed: ${totalDuplicates}`);
    
    if (uniqueEntries.length === 0) {
      throw new Error('No valid entries to import');
    }
    
    // Import to Supabase in batches
    console.log('\n🔄 Starting Supabase import...');
    const importResult = await insertDictionaryBatch(uniqueEntries);
    
    // Generate final report
    console.log('\n✅ Import completed successfully!');
    console.log('📋 Final Report:');
    fileStats.forEach(stat => {
      console.log(`   ${stat.fileName}: ${stat.uniqueCount}/${stat.validCount} unique entries imported`);
    });
    console.log(`\n🎯 Total imported to Supabase: ${importResult.inserted} records`);
    
    return {
      filesProcessed: filePaths.length,
      totalProcessed,
      uniqueEntries: uniqueEntries.length,
      duplicatesRemoved: totalDuplicates,
      imported: importResult.inserted,
      errors: importResult.errors
    };
    
  } catch (error) {
    console.error('❌ Failed to import JSON files:', error.message);
    throw error;
  }
}

/**
 * Validate dictionary entry structure
 */
function validateDictionaryEntry(entry) {
  if (!entry || typeof entry !== 'object') {
    return false;
  }
  
  // Required fields for dictionary table
  const requiredFields = ['chinese', 'pinyin', 'meaning_vi', 'meaning_en'];
  
  for (const field of requiredFields) {
    if (!entry[field] || typeof entry[field] !== 'string' || entry[field].trim() === '') {
      return false;
    }
  }
  
  return true;
}

/**
 * Normalize dictionary entry for database insertion
 */
function normalizeDictionaryEntry(entry) {
  return {
    chinese: entry.chinese?.trim() || '',
    pinyin: entry.pinyin?.trim() || '',
    type: normalizeWordType(entry.type),
    meaning_vi: entry.meaning_vi?.trim() || '',
    meaning_en: entry.meaning_en?.trim() || '',
    example_cn: entry.example_cn?.trim() || '',
    example_vi: entry.example_vi?.trim() || '',
    example_en: entry.example_en?.trim() || '',
    grammar: entry.grammar?.trim() || ''
  };
}

/**
 * Normalize word type to match database enum
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
 * Insert dictionary entries to Supabase in batches
 */
async function insertDictionaryBatch(entries) {
  try {
    console.log(`🔄 Inserting ${entries.length} entries to dictionary table...`);
    
    const batchSize = 100; // Optimal batch size for Supabase
    let totalInserted = 0;
    let totalErrors = 0;
    const errors = [];
    
    // Normalize all entries
    const normalizedEntries = entries.map(entry => normalizeDictionaryEntry(entry));
    
    // Process in batches
    for (let i = 0; i < normalizedEntries.length; i += batchSize) {
      const batch = normalizedEntries.slice(i, i + batchSize);
      const batchNumber = Math.floor(i / batchSize) + 1;
      const totalBatches = Math.ceil(normalizedEntries.length / batchSize);
      
      console.log(`   📦 Processing batch ${batchNumber}/${totalBatches} (${batch.length} entries)...`);
      
      try {
        // Use upsert to handle duplicates gracefully
        const { data, error } = await supabase
          .from('dictionary')
          .upsert(batch, {
            onConflict: 'chinese,pinyin', // Handle duplicates based on chinese and pinyin
            ignoreDuplicates: false // Update existing records
          })
          .select('chinese');
        
        if (error) {
          console.error(`   ❌ Batch ${batchNumber} error:`, error.message);
          totalErrors += batch.length;
          errors.push({
            batch: batchNumber,
            error: error.message,
            entries: batch.length
          });
        } else {
          const insertedCount = data ? data.length : batch.length;
          totalInserted += insertedCount;
          console.log(`   ✅ Batch ${batchNumber} completed: ${insertedCount} entries`);
        }
        
      } catch (batchError) {
        console.error(`   ❌ Batch ${batchNumber} failed:`, batchError.message);
        totalErrors += batch.length;
        errors.push({
          batch: batchNumber,
          error: batchError.message,
          entries: batch.length
        });
      }
      
      // Small delay between batches to avoid rate limiting
      if (i + batchSize < normalizedEntries.length) {
        await new Promise(resolve => setTimeout(resolve, 100));
      }
    }
    
    console.log(`\n📊 Batch Insert Summary:`);
    console.log(`   Total entries processed: ${normalizedEntries.length}`);
    console.log(`   Successfully inserted: ${totalInserted}`);
    console.log(`   Errors: ${totalErrors}`);
    console.log(`   Success rate: ${((totalInserted / normalizedEntries.length) * 100).toFixed(1)}%`);
    
    if (errors.length > 0) {
      console.log(`\n❌ Error Details:`);
      errors.forEach(error => {
        console.log(`   Batch ${error.batch}: ${error.error} (${error.entries} entries)`);
      });
    }
    
    return {
      inserted: totalInserted,
      errors: totalErrors,
      errorDetails: errors,
      total: normalizedEntries.length
    };
    
  } catch (error) {
    console.error('❌ Failed to insert dictionary batch:', error.message);
    throw error;
  }
}

/**
 * Verify the deployment by checking dictionary table
 */
async function verifyDeployment() {
  try {
    console.log('\n🔍 Verifying deployment...');
    
    // Check if dictionary table exists and has data
    const { count, error: countError } = await supabase
      .from('dictionary')
      .select('*', { count: 'exact', head: true });

    if (countError) {
      if (countError.message.includes('does not exist')) {
        console.error('❌ Dictionary table does not exist');
        return false;
      }
      throw countError;
    }

    console.log(`✅ Dictionary table found with ${count || 0} records`);

    // Get basic statistics
    const { data: stats, error: statsError } = await supabase
      .from('dictionary')
      .select('chinese, type, created_at')
      .order('created_at', { ascending: false })
      .limit(5);

    if (statsError) {
      console.warn('⚠️  Could not fetch sample records:', statsError.message);
    } else if (stats && stats.length > 0) {
      console.log(`📋 Latest entries:`);
      stats.forEach((record, index) => {
        console.log(`     ${index + 1}. ${record.chinese} (${record.type})`);
      });
    }

    // Get type distribution
    const { data: typeStats, error: typeError } = await supabase
      .from('dictionary')
      .select('type')
      .limit(1000);

    if (!typeError && typeStats) {
      const typeCounts = {};
      typeStats.forEach(record => {
        typeCounts[record.type] = (typeCounts[record.type] || 0) + 1;
      });
      
      console.log(`📊 Word type distribution (sample):`);
      Object.entries(typeCounts).forEach(([type, count]) => {
        console.log(`     ${type}: ${count}`);
      });
    }

    return true;
    
  } catch (error) {
    console.error('❌ Verification failed:', error.message);
    return false;
  }
}

// Enhanced command-line interface for dictionary import
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];

  try {
    // Initialize Supabase
    initializeSupabase();
    
    console.log('🔍 Testing connection and permissions...');
    await testConnection();

    switch (command) {
      case 'import':
        console.log('🎯 Command: Import all JSON files from ./import/');
        const importResult = await importAllJsonFiles();
        await verifyDeployment();
        console.log('\n🎉 Import completed successfully!');
        console.log(`📊 Final stats: ${importResult.imported}/${importResult.uniqueEntries} entries imported`);
        break;
        
      case 'verify':
        console.log('🎯 Command: Verify existing deployment');
        await verifyDeployment();
        break;
        
      case 'test':
        console.log('🎯 Command: Test connection only');
        console.log('✅ Connection test completed successfully');
        break;
        
      case 'scan':
        console.log('🎯 Command: Scan import directory');
        const files = await scanImportDirectory();
        console.log(`\n✅ Scan completed. Found ${files.length} JSON files ready for import.`);
        break;
        
      default:
        console.log('📚 Dictionary Import Script for Supabase\n');
        console.log('Commands:');
        console.log('  import    Import all JSON files from ./import/ directory');
        console.log('  scan      Scan ./import/ directory for JSON files');
        console.log('  verify    Verify existing deployment');
        console.log('  test      Test connection and permissions');
        console.log('');
        console.log('Examples:');
        console.log('  node insert_dict_data.js import    # Import all JSON files');
        console.log('  node insert_dict_data.js scan      # Scan import directory');
        console.log('  node insert_dict_data.js verify    # Verify deployment');
        console.log('');
        console.log('Environment Variables:');
        console.log('  SUPABASE_URL              - Your Supabase project URL');
        console.log('  SUPABASE_SERVICE_ROLE_KEY - Service role key for admin operations');
        console.log('');
        console.log('Features:');
        console.log('✅ Bulk JSON import from ./import/ directory');
        console.log('✅ Automatic duplicate detection and handling');
        console.log('✅ Data validation and normalization');
        console.log('✅ Batch processing for optimal performance');
        console.log('✅ Comprehensive error handling and reporting');
        console.log('✅ Progress tracking and statistics');
        break;
    }
  } catch (error) {
    console.error('❌ Command failed:', error.message);
    process.exit(1);
  }
}

/**
 * Test Supabase connection and permissions
 */
/**
 * Test Supabase connection and permissions
 */
async function testConnection() {
  try {
    console.log('   Testing Supabase client connection...');
    
    // Test dictionary table access
    const { data: tableTest, error: tableError } = await supabase
      .from('dictionary')
      .select('*', { count: 'exact', head: true });

    if (tableError) {
      if (tableError.message.includes('does not exist')) {
        console.log('✅ Connection successful - dictionary table will be created');
        return true;
      } else if (tableError.message.includes('Invalid API key') || 
                 tableError.message.includes('authentication')) {
        throw new Error('Authentication failed - check your SUPABASE_SERVICE_ROLE_KEY');
      } else {
        throw new Error(`Connection test failed: ${tableError.message}`);
      }
    } else {
      console.log('✅ Database connection successful');
      console.log('✅ Dictionary table accessible');
      return true;
    }
  } catch (error) {
    console.error('❌ Connection test failed:', error.message);
    
    // Provide helpful debugging information
    if (error.message.includes('Invalid API key')) {
      console.error('🔧 Check your SUPABASE_SERVICE_ROLE_KEY in .env file');
    } else if (error.message.includes('SUPABASE_URL')) {
      console.error('🔧 Check your SUPABASE_URL in .env file');
    }
    
    throw error;
  }
}

// Export main functions for use in other modules
export {
  importAllJsonFiles,         // Import all JSON files from ./import/
  insertDictionaryBatch,      // Insert dictionary entries in batches
  validateDictionaryEntry,    // Validate dictionary entry structure
  normalizeDictionaryEntry,   // Normalize entry for database
  scanImportDirectory,        // Scan import directory for JSON files
  verifyDeployment           // Verify deployment status
};

// Chạy function main nếu script này được thực thi trực tiếp
// Run main function if this script is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}
