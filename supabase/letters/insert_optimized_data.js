// Script chèn dữ liệu cho schema Supabase tối ưu hóa
// Script này xử lý cấu trúc dữ liệu JSON và chèn vào database một cách hiệu quả
// Data insertion script for the optimized Supabase schema
// This script processes the JSON data structure and inserts it efficiently

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fs from 'fs';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Cấu hình dotenv để đọc biến môi trường từ file .env
// Configure dotenv to read environment variables from .env file
dotenv.config();

// Lấy đường dẫn thư mục hiện tại cho ES modules
// Get current directory path for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Khởi tạo client Supabase với service role key để có full permissions
// Initialize Supabase client with service role key for full permissions
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY, // Sử dụng service role key trực tiếp / Use service role key directly
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false
    }
  }
);

// Kiểm tra service role key / Check service role key
if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
  console.error('❌ THIẾU SERVICE ROLE KEY / MISSING SERVICE ROLE KEY');
  console.error('');
  console.error('🔑 Cần SUPABASE_SERVICE_ROLE_KEY để có quyền ghi vào database');
  console.error('🔑 Need SUPABASE_SERVICE_ROLE_KEY for database write permissions');
  console.error('');
  console.error('📋 HƯỚNG DẪN LẤY SERVICE ROLE KEY:');
  console.error('📋 HOW TO GET SERVICE ROLE KEY:');
  console.error('   1. Đi đến: https://app.supabase.com');
  console.error('   2. Chọn project → Settings → API');
  console.error('   3. Copy "service_role" key (secret key)');
  console.error('   4. Thêm vào .env: SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1...');
  console.error('');
  console.error('⚠️  Service role key có quyền admin - giữ bí mật!');
  console.error('⚠️  Service role key has admin privileges - keep it secret!');
  console.error('');
  process.exit(1);
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

// Ví dụ sử dụng / Example usage
async function main() {
  try {
    // Test kết nối trước khi chèn dữ liệu / Test connection before inserting data
    console.log('🔍 Kiểm tra kết nối và quyền truy cập... / Testing connection and permissions...');
    
    // Kiểm tra các biến môi trường / Check environment variables
    if (!process.env.SUPABASE_URL) {
      throw new Error('❌ Thiếu SUPABASE_URL trong file .env / Missing SUPABASE_URL in .env file');
    }
    
    if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
      throw new Error('❌ Thiếu SUPABASE_SERVICE_ROLE_KEY trong file .env / Missing SUPABASE_SERVICE_ROLE_KEY in .env file');
    }
    
    console.log('✅ Service role key detected - có full database permissions / has full database permissions');
    
    // Test quyền đọc / Test read permissions
    try {
      const { data: categories, error: readError } = await supabase
        .from('categories')
        .select('count(*)')
        .limit(1);
      
      if (readError) {
        console.error('❌ Lỗi đọc dữ liệu:', readError.message);
      } else {
        console.log('✅ Quyền đọc OK / Read permissions OK');
      }
    } catch (err) {
      console.warn('⚠️  Không thể test quyền đọc:', err.message);
    }
    
    // Test quyền ghi vào processing_batches / Test write permissions to processing_batches
    try {
      const testBatch = {
        total_items: 0,
        successful_items: 0,
        failed_items: 0,
        status: 'pending',
        summary: { test: true }
      };
      
      const { data: testResult, error: writeError } = await supabase
        .from('processing_batches')
        .insert(testBatch)
        .select('id')
        .single();
      
      if (writeError) {
        console.error('❌ Lỗi quyền ghi:', writeError.message);
        console.log('💡 GIẢI PHÁP:');
        console.log('   1. Thêm SUPABASE_SERVICE_ROLE_KEY vào file .env');
        console.log('   2. Hoặc chạy: npm run insert-admin');
        console.log('   3. Hoặc xem file TROUBLESHOOTING.md');
        throw new Error('Không có quyền ghi vào database. Cần service role key.');
      } else {
        console.log('✅ Quyền ghi OK / Write permissions OK');
        // Xóa test record / Delete test record
        await supabase.from('processing_batches').delete().eq('id', testResult.id);
      }
    } catch (err) {
      if (err.message.includes('row-level security')) {
        console.error('❌ RLS Policy Error detected!');
        console.log('');
        console.log('🔧 CÁCH SỬA NHANH / QUICK FIX:');
        console.log('   1. Lấy Service Role Key từ Supabase Dashboard');
        console.log('   2. Thêm vào file .env: SUPABASE_SERVICE_ROLE_KEY=your-key');
        console.log('   3. Chạy lại script này');
        console.log('');
        console.log('📖 Chi tiết trong file TROUBLESHOOTING.md');
        throw err;
      }
      throw err;
    }
    
    console.log('✅ Kết nối thành công! Bắt đầu chèn dữ liệu... / Connection successful! Starting data insertion...\n');

    // Ví dụ 1: Tải và chèn dữ liệu của bạn
    // Example 1: Load and insert your data
    // Bỏ comment dòng này khi bạn đã có file dữ liệu JSON sẵn sàng
    // Uncomment this when you have your JSON data ready
    
    const jsonData = JSON.parse(fs.readFileSync('./import-json/ketqua.json', 'utf8'));
    const result = await insertCompleteDataBatch(jsonData);
    console.log('Kết quả chèn / Insertion result:', result);
    

    // Ví dụ 2: Truy vấn letters thân thiện với người mới bắt đầu
    // Example 2: Query beginner-friendly letters
    const beginnerLetters = await getLettersByDifficulty('beginner');
    console.log('Tìm thấy letters cho người mới bắt đầu / Beginner letters found:', beginnerLetters.length);

    // Ví dụ 3: Tìm kiếm nội dung cụ thể
    // Example 3: Search for specific content
    const searchResults = await queryLetters({
      category: 'life',                           // Danh mục: cuộc sống / Category: life
      maxDifficulty: 3.0,                        // Độ khó tối đa / Maximum difficulty
      characterCountRange: { min: 50, max: 200 }, // Khoảng số ký tự / Character count range
      limit: 10                                   // Giới hạn kết quả / Result limit
    });
    console.log('Kết quả tìm kiếm / Search results:', searchResults.length);

    // Ví dụ 4: Lấy thống kê HSK
    // Example 4: Get HSK statistics
    // const stats = await getHSKStatistics();
    // console.log('Thống kê HSK / HSK Statistics:', stats);

  } catch (error) {
    console.error('Lỗi thực thi chính / Main execution error:', error);
  }
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
