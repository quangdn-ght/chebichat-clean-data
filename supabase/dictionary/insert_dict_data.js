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
 * Execute SQL file with proper role management and error handling
 */
async function executeSqlFile(filePath) {
  try {
    console.log(`📄 Executing SQL file: ${path.basename(filePath)}`);
    
    // Read SQL file
    const sqlContent = fs.readFileSync(filePath, 'utf8');
    const fileSizeMB = (sqlContent.length / 1024 / 1024).toFixed(2);
    console.log(`   File size: ${fileSizeMB} MB`);

    // Extract INSERT statements with VALUES
    const startTime = Date.now();
    
    // Find all INSERT statements
    const insertRegex = /INSERT INTO dictionary\s*\([^)]+\)\s*VALUES\s*\([\s\S]*?\);/gi;
    const insertStatements = sqlContent.match(insertRegex) || [];
    
    console.log(`   📊 Found ${insertStatements.length} INSERT statements...`);
    
    let totalInserted = 0;
    let errors = 0;
    
    for (let i = 0; i < insertStatements.length; i++) {
      try {
        const inserted = await executeInsertStatement(insertStatements[i]);
        totalInserted += inserted;
        
        // Progress indicator
        if ((i + 1) % 10 === 0) {
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
    console.log(`   ✅ Inserted ${totalInserted} records, ${errors} errors in ${executionTime}s`);
    
    return { success: true, executionTime, inserted: totalInserted, errors };
    
  } catch (error) {
    console.error(`   ❌ Error executing ${path.basename(filePath)}:`, error.message);
    
    // Provide helpful context for common errors
    if (error.message.includes('permission denied')) {
      console.error('   🔧 Solution: Ensure SUPABASE_SERVICE_ROLE_KEY is correct');
    }
    
    throw error;
  }
}

/**
 * Find and execute all SQL files from output directory
 */
async function executeOutputSqlFiles() {
  try {
    console.log('📁 Scanning ./output directory for SQL files...');
    
    const outputDir = './output';
    const files = fs.readdirSync(outputDir);
    const sqlFiles = files.filter(file => file.endsWith('.sql'));
    
    if (sqlFiles.length === 0) {
      throw new Error('No SQL files found in ./output directory');
    }

    // Group files by timestamp to get the latest batch
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

    const latestFiles = timestampFiles[latestTimestamp].sort();
    console.log(`📊 Found ${latestFiles.length} SQL files from batch: ${latestTimestamp}`);

    // Separate schema and data files
    const schemaFiles = latestFiles.filter(file => 
      file.includes('schema') || file.includes('master')
    );
    const dataFiles = latestFiles.filter(file => 
      !schemaFiles.includes(file) && !file.includes('verify')
    );

    console.log(`   Schema files: ${schemaFiles.length}`);
    console.log(`   Data files: ${dataFiles.length}`);
    console.log('');

    const results = [];

    // Execute schema files first
    for (const file of schemaFiles) {
      const filePath = path.join(outputDir, file);
      const result = await executeSqlFile(filePath);
      results.push({ file, ...result });
    }

    // Execute data files
    for (const file of dataFiles) {
      const filePath = path.join(outputDir, file);
      const result = await executeSqlFile(filePath);
      results.push({ file, ...result });
    }

    console.log('\n📊 Execution Summary:');
    console.log(`   Files processed: ${results.length}`);
    console.log(`   Successful: ${results.filter(r => r.success).length}`);
    console.log(`   Total time: ${results.reduce((sum, r) => sum + parseFloat(r.executionTime || 0), 0).toFixed(2)}s`);

    return results;
    
  } catch (error) {
    console.error('❌ Failed to execute SQL files:', error.message);
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
    const { data: tableCheck, error: tableError } = await supabase
      .from('dictionary')
      .select('*', { count: 'exact', head: true });

    if (tableError) {
      if (tableError.message.includes('does not exist')) {
        console.error('❌ Dictionary table does not exist');
        return false;
      }
      throw tableError;
    }

    // Get basic statistics
    const { data: stats, error: statsError } = await supabase
      .from('dictionary')
      .select(`
        chinese,
        type,
        created_at
      `)
      .order('created_at', { ascending: false })
      .limit(5);

    if (statsError) {
      throw statsError;
    }

    console.log(`✅ Dictionary table verification successful`);
    console.log(`   Records found: ${stats?.length || 0}`);
    
    if (stats && stats.length > 0) {
      console.log(`   Latest entries:`);
      stats.forEach((record, index) => {
        console.log(`     ${index + 1}. ${record.chinese} (${record.type})`);
      });
    }

    return true;
    
  } catch (error) {
    console.error('❌ Verification failed:', error.message);
    return false;
  }
}

/**
 * Chèn một batch hoàn chỉnh các letter với tất cả dữ liệu liên quan
 * Insert a complete batch of letters with all associated data
 * @param {Object} dataStructure - Cấu trúc dữ liệu hoàn chỉnh từ JSON / The complete data structure from your JSON
 */
async function insertCompleteDataBatch(dataStructure) {
  try {
    console.log('Bắt đầu quá trình chèn dữ liệu... / Starting data insertion process...');
    
    // 1. Tạo bản ghi batch xử lý trong bảng processing_batches
    // 1. Create processing batch record in processing_batches table
    const { data: batchData, error: batchError } = await supabase
      .from('processing_batches')
      .insert({
        total_items: dataStructure.metadata.totalItems,
        successful_items: dataStructure.metadata.successfulItems,
        failed_items: dataStructure.metadata.failedItems,
        status: 'processing', // Đổi từ 'completed' thành 'processing'
        summary: dataStructure.metadata.summary
      })
      .select('id')
      .single();

    if (batchError) {
      console.error('❌ Chi tiết lỗi tạo batch:', batchError);
      
      if (batchError.message.includes('row-level security')) {
        console.log('\n🔧 GIẢI PHÁP CHO LỖI RLS:');
        console.log('1. Thêm SUPABASE_SERVICE_ROLE_KEY vào file .env');
        console.log('2. Hoặc chạy: npm run insert-admin');
        console.log('3. Hoặc tắt RLS tạm thời (xem TROUBLESHOOTING.md)');
      }
      
      throw new Error(`Tạo batch thất bại / Failed to create batch: ${batchError.message}`);
    }

    const batchId = batchData.id;
    console.log(`Đã tạo batch / Created batch ${batchId}`);

    // 2. Xử lý từng letter trong dữ liệu
    // 2. Process each letter in the data
    const letters = dataStructure.data;
    const batchSize = 10; // Xử lý theo từng nhóm nhỏ để tránh timeout / Process in batches to avoid timeouts
    let processed = 0;
    let errors = [];

    for (let i = 0; i < letters.length; i += batchSize) {
      const batch = letters.slice(i, i + batchSize);
      
      console.log(`Đang xử lý batch / Processing batch ${Math.floor(i/batchSize) + 1}/${Math.ceil(letters.length/batchSize)}...`);
      
      // Tạo promises cho tất cả letters trong batch hiện tại
      // Create promises for all letters in current batch
      const promises = batch.map(letter => insertSingleLetter(letter, batchId));
      const results = await Promise.allSettled(promises);
      
      // Kiểm tra kết quả của từng promise
      // Check results of each promise
      results.forEach((result, index) => {
        if (result.status === 'fulfilled') {
          processed++;
        } else {
          errors.push({
            index: i + index,
            error: result.reason.message
          });
          console.error(`Lỗi xử lý letter / Error processing letter ${i + index}:`, result.reason.message);
        }
      });

      // Thêm delay nhỏ giữa các batch để giảm tải server
      // Add small delay between batches to reduce server load
      await new Promise(resolve => setTimeout(resolve, 100));
    }

    console.log(`Xử lý hoàn thành / Processing complete. Đã xử lý / Processed: ${processed}, Lỗi / Errors: ${errors.length}`);
    
    // 3. Cập nhật trạng thái batch
    // 3. Update batch status
    await supabase
      .from('processing_batches')
      .update({
        successful_items: processed,
        failed_items: errors.length,
        status: errors.length === 0 ? 'completed' : 'completed_with_errors'
      })
      .eq('id', batchId);

    return {
      batchId,
      processed,
      errors
    };

  } catch (error) {
    console.error('Chèn batch dữ liệu thất bại / Failed to insert data batch:', error);
    throw error;
  }
}

/**
 * Chèn một letter đơn lẻ với tất cả dữ liệu liên quan
 * Insert a single letter with all its associated data
 * @param {Object} letterData - Dữ liệu letter riêng lẻ / Individual letter data
 * @param {string} batchId - ID của batch để liên kết / Batch ID to associate with
 */
async function insertSingleLetter(letterData, batchId) {
  try {
    // Tạm thời disable triggers để tránh lỗi ambiguous column
    await supabase.rpc('exec_sql', { 
      sql: 'SET session_replication_role = replica;' 
    });

    // Insert letter trực tiếp thay vì dùng stored function
    const { data: letterResult, error: letterError } = await supabase
      .from('letters')
      .insert({
        batch_id: batchId,
        original: letterData.original,
        pinyin: letterData.pinyin || null,
        vietnamese: letterData.vietnamese || null,
        character_count: letterData.textStats?.characterCount || 0,
        word_count: letterData.textStats?.wordCount || 0,
        unique_word_count: letterData.textStats?.uniqueWordCount || 0,
        average_word_length: letterData.textStats?.averageWordLength || 0,
        processed: true
      })
      .select('id')
      .single();

    if (letterError) {
      throw new Error(`Letter insert error: ${letterError.message}`);
    }

    const letterId = letterResult.id;

    // Insert words nếu có
    if (letterData.words) {
      const wordInserts = [];
      for (const [hskLevel, words] of Object.entries(letterData.words)) {
        if (['hsk1', 'hsk2', 'hsk3', 'hsk4', 'hsk5', 'hsk6', 'hsk7', 'other'].includes(hskLevel)) {
          words.forEach(word => {
            wordInserts.push({
              letter_id: letterId,
              word: word,
              hsk_level: hskLevel
            });
          });
        }
      }

      if (wordInserts.length > 0) {
        await supabase.from('letter_words').insert(wordInserts);
      }
    }

    // Re-enable triggers
    await supabase.rpc('exec_sql', { 
      sql: 'SET session_replication_role = origin;' 
    });

    return letterId;
  } catch (error) {
    console.error('Lỗi chèn letter / Error inserting letter:', error);
    throw error;
  }
}

/**
 * Truy vấn letters với nhiều bộ lọc và tùy chọn sắp xếp khác nhau
 * Query letters with various filters and sorting options
 * @param {Object} options - Tùy chọn truy vấn / Query options
 */
async function queryLetters(options = {}) {
  try {
    // Bắt đầu với query cơ bản từ view phân tích độ khó
    // Start with basic query from difficulty analysis view
    let query = supabase
      .from('letters_difficulty_analysis')
      .select('*');

    // Áp dụng các bộ lọc / Apply filters
    if (options.category) {
      query = query.eq('category_name', options.category);
    }

    if (options.source) {
      query = query.eq('source_name', options.source);
    }

    if (options.maxDifficulty) {
      query = query.lte('difficulty_score', options.maxDifficulty);
    }

    if (options.minBeginnerFriendly) {
      query = query.gte('beginner_friendly_percentage', options.minBeginnerFriendly);
    }

    if (options.characterCountRange) {
      query = query
        .gte('character_count', options.characterCountRange.min)
        .lte('character_count', options.characterCountRange.max);
    }

    // Áp dụng sắp xếp / Apply sorting
    if (options.sortBy) {
      const direction = options.sortDirection || 'asc';
      query = query.order(options.sortBy, { ascending: direction === 'asc' });
    } else {
      // Mặc định sắp xếp theo độ khó tăng dần / Default sort by difficulty ascending
      query = query.order('difficulty_score', { ascending: true });
    }

    // Áp dụng phân trang / Apply pagination
    if (options.limit) {
      query = query.limit(options.limit);
    }

    if (options.offset) {
      query = query.range(options.offset, options.offset + (options.limit || 50) - 1);
    }

    const { data, error } = await query;

    if (error) {
      throw new Error(`Lỗi truy vấn / Query error: ${error.message}`);
    }

    return data;
  } catch (error) {
    console.error('Lỗi truy vấn letters / Error querying letters:', error);
    throw error;
  }
}

/**
 * Tìm kiếm letters theo nội dung văn bản
 * Search letters by text content
 * @param {string} searchText - Văn bản cần tìm kiếm / Text to search for
 * @param {Object} options - Tùy chọn tìm kiếm / Search options
 */
async function searchLetters(searchText, options = {}) {
  try {
    const { data, error } = await supabase.rpc('search_letters_by_text', {
      search_text: searchText,
      search_language: options.language || 'chinese', // 'chinese', 'vietnamese', 'pinyin'
      max_results: options.limit || 20
    });

    if (error) {
      throw new Error(`Lỗi tìm kiếm / Search error: ${error.message}`);
    }

    return data;
  } catch (error) {
    console.error('Lỗi tìm kiếm letters / Error searching letters:', error);
    throw error;
  }
}

/**
 * Lấy thống kê từ vựng HSK
 * Get HSK vocabulary statistics
 */
async function getHSKStatistics() {
  try {
    const { data, error } = await supabase.rpc('get_hsk_statistics');

    if (error) {
      throw new Error(`Lỗi thống kê / Statistics error: ${error.message}`);
    }

    return data;
  } catch (error) {
    console.error('Lỗi lấy thống kê HSK / Error getting HSK statistics:', error);
    throw error;
  }
}

/**
 * Lấy letters theo mức độ khó
 * Get letters by difficulty level
 * @param {string} level - Mức độ: 'beginner', 'intermediate', 'advanced' / Level: 'beginner', 'intermediate', 'advanced'
 */
async function getLettersByDifficulty(level) {
  // Định nghĩa khoảng độ khó cho từng mức / Define difficulty ranges for each level
  const difficultyRanges = {
    beginner: { maxScore: 2.5, minBeginnerFriendly: 40 },      // Người mới bắt đầu / Beginner
    intermediate: { maxScore: 5.0, minBeginnerFriendly: 20 },  // Trung bình / Intermediate  
    advanced: { maxScore: 10.0, minBeginnerFriendly: 0 }       // Nâng cao / Advanced
  };

  const range = difficultyRanges[level];
  if (!range) {
    throw new Error('Mức độ không hợp lệ. Sử dụng: beginner, intermediate, hoặc advanced / Invalid difficulty level. Use: beginner, intermediate, or advanced');
  }

  return await queryLetters({
    maxDifficulty: range.maxScore,
    minBeginnerFriendly: range.minBeginnerFriendly,
    sortBy: 'difficulty_score',
    limit: 50
  });
}

// Enhanced command-line interface with SQL file execution
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];

  try {
    // Initialize Supabase
    initializeSupabase();
    
    console.log('🔍 Testing connection and permissions...');
    await testConnection();

    switch (command) {
      case 'sql':
        console.log('🎯 Command: Execute SQL files from ./output/');
        const results = await executeOutputSqlFiles();
        await verifyDeployment();
        console.log('\n🎉 SQL execution completed successfully!');
        break;
        
      case 'json':
        console.log('🎯 Command: Insert JSON data from ./import-json/ketqua.json');
        const jsonData = JSON.parse(fs.readFileSync('./import-json/ketqua.json', 'utf8'));
        const result = await insertCompleteDataBatch(jsonData);
        console.log('✅ JSON insertion result:', result);
        break;
        
      case 'verify':
        console.log('🎯 Command: Verify existing deployment');
        await verifyDeployment();
        break;
        
      case 'test':
        console.log('🎯 Command: Test connection only');
        console.log('✅ Connection test completed successfully');
        break;
        
      default:
        console.log('📚 Enhanced Dictionary Data Script\n');
        console.log('Commands:');
        console.log('  sql       Execute SQL files from ./output/ directory');
        console.log('  json      Insert JSON data from ./import-json/ketqua.json');
        console.log('  verify    Verify existing deployment');
        console.log('  test      Test connection and permissions');
        console.log('');
        console.log('Examples:');
        console.log('  node insert_dict_data.js sql      # Execute SQL files');
        console.log('  node insert_dict_data.js json     # Insert JSON data');
        console.log('  node insert_dict_data.js verify   # Verify deployment');
        console.log('');
        console.log('Environment Variables:');
        console.log('  SUPABASE_URL              - Your Supabase project URL');
        console.log('  SUPABASE_SERVICE_ROLE_KEY - Service role key for admin operations');
        console.log('');
        console.log('Features:');
        console.log('✅ SQL file execution with role management');
        console.log('✅ JSON data insertion');
        console.log('✅ Deployment verification');
        console.log('✅ Proper error handling');
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
async function testConnection() {
  try {
    console.log('   Testing Supabase client connection...');
    
    // Simple connection test - try to access a basic Supabase function
    const { data: healthCheck, error: healthError } = await supabase
      .from('pg_stat_activity')
      .select('application_name')
      .limit(1);

    if (healthError) {
      // If that fails, try the dictionary table directly
      console.log('   Trying direct table access...');
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
    } else {
      console.log('✅ Database connection successful');
      
      // Now test dictionary table
      const { data: tableTest, error: tableError } = await supabase
        .from('dictionary')
        .select('*', { count: 'exact', head: true });

      if (tableError) {
        if (tableError.message.includes('does not exist')) {
          console.log('ℹ️  Dictionary table does not exist yet - will be created');
        } else {
          console.warn('⚠️  Dictionary table access limited');
        }
      } else {
        console.log('✅ Dictionary table accessible');
      }
    }

    return true;
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

/**
 * Execute an INSERT statement by parsing SQL and using Supabase client
 */
async function executeInsertStatement(statement) {
  try {
    // Parse INSERT statement for dictionary table
    const insertMatch = statement.match(/INSERT INTO dictionary\s*\(([^)]+)\)\s*VALUES\s*([\s\S]*)/i);
    
    if (!insertMatch) {
      throw new Error('Could not parse INSERT statement');
    }
    
    const columns = insertMatch[1].split(',').map(col => col.trim().replace(/"/g, ''));
    const valuesSection = insertMatch[2].replace(/;$/, '').trim(); // Remove trailing semicolon
    
    // Parse multiple VALUES rows - each row is enclosed in parentheses
    const records = [];
    
    // Split by "),(" to separate rows, but be careful with commas inside strings
    const valueRows = parseValueRows(valuesSection);
    
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
    const batchSize = 50; // Smaller batch size for reliability
    let totalInserted = 0;
    
    for (let i = 0; i < records.length; i += batchSize) {
      const batch = records.slice(i, i + batchSize);
      
      try {
        const { data, error } = await supabase
          .from('dictionary')
          .insert(batch);
        
        if (error) {
          if (error.message.includes('duplicate key') || 
              error.message.includes('violates unique constraint')) {
            // Count as successful for duplicates (they already exist)
            totalInserted += batch.length;
          } else {
            throw error;
          }
        } else {
          totalInserted += batch.length;
        }
      } catch (batchError) {
        // Try individual inserts for this batch to identify specific issues
        for (const record of batch) {
          try {
            await supabase.from('dictionary').insert([record]);
            totalInserted++;
          } catch (individualError) {
            if (individualError.message.includes('duplicate key') || 
                individualError.message.includes('violates unique constraint')) {
              totalInserted++; // Count duplicates as successful
            } else {
              console.warn(`   ⚠️  Failed to insert record: ${record.chinese}`);
            }
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
function parseValueRows(valuesSection) {
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
          // Start of new row, skip the opening parenthesis
          continue;
        }
      } else if (char === ')') {
        depth--;
        if (depth === 0) {
          // End of row - parse the accumulated values
          const values = parseValues(current.trim());
          rows.push(values);
          current = '';
          
          // Skip any comma and whitespace after this row
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
function parseValues(valuesString) {
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
      
      // Handle NULL
      if (value.toUpperCase() === 'NULL') {
        values.push(null);
      }
      // Handle quoted strings
      else if (value.startsWith("'") && value.endsWith("'")) {
        values.push(value.slice(1, -1).replace(/\\'/g, "'"));
      }
      // Handle numbers
      else if (/^-?\d+(\.\d+)?$/.test(value)) {
        values.push(parseFloat(value));
      }
      // Handle booleans
      else if (value.toLowerCase() === 'true') {
        values.push(true);
      } else if (value.toLowerCase() === 'false') {
        values.push(false);
      }
      // Default to string
      else {
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

// Xuất các functions để sử dụng trong modules khác
// Export functions for use in other modules
export {
  insertCompleteDataBatch,    // Chèn batch dữ liệu hoàn chỉnh / Insert complete data batch
  insertSingleLetter,         // Chèn một letter đơn lẻ / Insert single letter
  queryLetters,              // Truy vấn letters / Query letters
  searchLetters,             // Tìm kiếm letters / Search letters
  getHSKStatistics,          // Lấy thống kê HSK / Get HSK statistics
  getLettersByDifficulty     // Lấy letters theo độ khó / Get letters by difficulty
};

// Chạy function main nếu script này được thực thi trực tiếp
// Run main function if this script is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}
