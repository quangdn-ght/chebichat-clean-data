// Script chèn dữ liệu cho schema Supabase tối ưu hóa (Admin version - sử dụng service role key)
// Admin version of data insertion script using service role key to bypass RLS

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fs from 'fs';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Cấu hình dotenv để đọc biến môi trường từ file .env
dotenv.config();

// Lấy đường dẫn thư mục hiện tại cho ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Khởi tạo Supabase client với service role key để bypass RLS
// Initialize Supabase client with service role key to bypass RLS
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false
    }
  }
);

// Kiểm tra xem có service role key không
if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
  console.warn('⚠️  CẢNH BÁO: Đang sử dụng anon key thay vì service role key');
  console.warn('⚠️  WARNING: Using anon key instead of service role key');
  console.warn('   Có thể gặp lỗi RLS policy. Thêm SUPABASE_SERVICE_ROLE_KEY vào file .env');
  console.warn('   May encounter RLS policy errors. Add SUPABASE_SERVICE_ROLE_KEY to .env file');
}

/**
 * Tạo hoặc cập nhật RLS policies để cho phép chèn dữ liệu
 * Create or update RLS policies to allow data insertion
 */
async function setupRLSPolicies() {
  try {
    console.log('🔧 Thiết lập RLS policies... / Setting up RLS policies...');
    
    // Tạm thời disable RLS cho việc chèn dữ liệu
    const policies = [
      // Policy cho processing_batches
      `
      DO $$ 
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_policies 
          WHERE tablename = 'processing_batches' 
          AND policyname = 'Allow insert for data import'
        ) THEN
          CREATE POLICY "Allow insert for data import" ON processing_batches
            FOR INSERT WITH CHECK (true);
        END IF;
      END $$;
      `,
      
      // Policy cho letters
      `
      DO $$ 
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_policies 
          WHERE tablename = 'letters' 
          AND policyname = 'Allow insert for data import'
        ) THEN
          CREATE POLICY "Allow insert for data import" ON letters
            FOR INSERT WITH CHECK (true);
        END IF;
      END $$;
      `,
      
      // Policy cho letter_words
      `
      DO $$ 
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_policies 
          WHERE tablename = 'letter_words' 
          AND policyname = 'Allow insert for data import'
        ) THEN
          CREATE POLICY "Allow insert for data import" ON letter_words
            FOR INSERT WITH CHECK (true);
        END IF;
      END $$;
      `,
      
      // Policy cho vocabulary_frequency
      `
      DO $$ 
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_policies 
          WHERE tablename = 'vocabulary_frequency' 
          AND policyname = 'Allow insert for data import'
        ) THEN
          CREATE POLICY "Allow insert for data import" ON vocabulary_frequency
            FOR INSERT WITH CHECK (true);
        END IF;
      END $$;
      `
    ];

    for (const policy of policies) {
      const { error } = await supabase.rpc('exec_sql', { sql: policy });
      if (error) {
        console.warn(`Cảnh báo tạo policy: ${error.message}`);
      }
    }
    
    console.log('✅ RLS policies đã được thiết lập / RLS policies setup complete');
  } catch (error) {
    console.warn('⚠️  Không thể thiết lập RLS policies:', error.message);
    console.warn('   Tiếp tục với cấu hình hiện tại...');
  }
}

/**
 * Chèn một batch hoàn chỉnh các letter với tất cả dữ liệu liên quan
 * @param {Object} dataStructure - Cấu trúc dữ liệu hoàn chỉnh từ JSON
 */
async function insertCompleteDataBatch(dataStructure) {
  try {
    console.log('🚀 Bắt đầu quá trình chèn dữ liệu... / Starting data insertion process...');
    
    // Thiết lập RLS policies trước
    await setupRLSPolicies();
    
    // 1. Tạo bản ghi batch xử lý
    console.log('📝 Tạo processing batch record...');
    const { data: batchData, error: batchError } = await supabase
      .from('processing_batches')
      .insert({
        total_items: dataStructure.metadata.totalItems,
        successful_items: dataStructure.metadata.successfulItems,
        failed_items: dataStructure.metadata.failedItems,
        status: 'processing',
        summary: dataStructure.metadata.summary
      })
      .select('id')
      .single();

    if (batchError) {
      console.error('❌ Lỗi tạo batch:', batchError);
      throw new Error(`Tạo batch thất bại: ${batchError.message}`);
    }

    const batchId = batchData.id;
    console.log(`✅ Đã tạo batch: ${batchId}`);

    // 2. Xử lý từng letter
    const letters = dataStructure.data;
    const batchSize = 5; // Giảm batch size để tránh timeout
    let processed = 0;
    let errors = [];

    console.log(`📊 Tổng số letters cần xử lý: ${letters.length}`);

    for (let i = 0; i < letters.length; i += batchSize) {
      const batch = letters.slice(i, i + batchSize);
      const batchNum = Math.floor(i/batchSize) + 1;
      const totalBatches = Math.ceil(letters.length/batchSize);
      
      console.log(`🔄 Xử lý batch ${batchNum}/${totalBatches} (letters ${i + 1}-${Math.min(i + batchSize, letters.length)})...`);
      
      // Xử lý tuần tự thay vì song song để tránh lỗi
      for (const letter of batch) {
        try {
          await insertSingleLetter(letter, batchId);
          processed++;
          process.stdout.write('✓');
        } catch (error) {
          errors.push({
            index: i + batch.indexOf(letter),
            error: error.message,
            letter: letter.original?.substring(0, 50) + '...'
          });
          process.stdout.write('✗');
          console.error(`\n❌ Lỗi letter ${i + batch.indexOf(letter)}: ${error.message}`);
        }
      }
      
      console.log(`\n📈 Tiến độ: ${processed}/${letters.length} (${Math.round(processed/letters.length*100)}%)`);
      
      // Delay giữa các batch
      await new Promise(resolve => setTimeout(resolve, 200));
    }

    console.log(`\n🎉 Xử lý hoàn thành! Thành công: ${processed}, Lỗi: ${errors.length}`);
    
    // 3. Cập nhật trạng thái batch
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
      errors,
      successRate: Math.round((processed / letters.length) * 100)
    };

  } catch (error) {
    console.error('💥 Chèn batch dữ liệu thất bại:', error);
    throw error;
  }
}

/**
 * Chèn một letter đơn lẻ với xử lý lỗi chi tiết
 */
async function insertSingleLetter(letterData, batchId) {
  try {
    // Validate dữ liệu đầu vào
    if (!letterData.original) {
      throw new Error('Missing original text');
    }

    const functionArgs = {
      p_original: letterData.original,
      p_batch_id: batchId,
      p_pinyin: letterData.pinyin || null,
      p_vietnamese: letterData.vietnamese || null,
      p_category_name: letterData.category || null,
      p_source_name: letterData.source || null,
      p_words: letterData.words || null,
      p_vocabulary: letterData.textStats?.vocabulary || null,
      p_text_stats: {
        characterCount: letterData.textStats?.characterCount || 0,
        wordCount: letterData.textStats?.wordCount || 0,
        uniqueWordCount: letterData.textStats?.uniqueWordCount || 0,
        averageWordLength: letterData.textStats?.averageWordLength || 0
      }
    };

    const { data, error } = await supabase.rpc('insert_complete_letter', functionArgs);

    if (error) {
      throw new Error(`Database error: ${error.message}`);
    }

    return data;
  } catch (error) {
    console.error(`Lỗi chèn letter "${letterData.original?.substring(0, 30)}...":`, error.message);
    throw error;
  }
}

// Test connection function
async function testConnection() {
  try {
    console.log('🔍 Kiểm tra kết nối Supabase...');
    
    if (!process.env.SUPABASE_URL || !process.env.SUPABASE_ANON_KEY) {
      throw new Error('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file');
    }

    // Test simple query
    const { data, error } = await supabase
      .from('categories')
      .select('count(*)')
      .limit(1);

    if (error) {
      throw new Error(`Connection test failed: ${error.message}`);
    }

    console.log('✅ Kết nối Supabase thành công!');
    
    // Check if service role key is available
    if (process.env.SUPABASE_SERVICE_ROLE_KEY) {
      console.log('🔑 Service role key detected - có thể bypass RLS');
    } else {
      console.log('⚠️  Chỉ có anon key - có thể cần thiết lập RLS policies');
    }
    
    return true;
  } catch (error) {
    console.error('❌ Lỗi kết nối:', error.message);
    return false;
  }
}

// Main function với error handling tốt hơn
async function main() {
  try {
    // Test connection trước
    const connected = await testConnection();
    if (!connected) {
      console.error('💥 Không thể kết nối đến Supabase. Kiểm tra file .env');
      process.exit(1);
    }

    // Load và chèn dữ liệu
    const dataPath = './import-json/ketqua.json';
    
    if (!fs.existsSync(dataPath)) {
      console.error(`❌ Không tìm thấy file dữ liệu: ${dataPath}`);
      console.log('📁 Các file JSON có sẵn:');
      const files = fs.readdirSync('.').filter(f => f.endsWith('.json'));
      files.forEach(f => console.log(`   - ${f}`));
      process.exit(1);
    }

    console.log(`📂 Đọc dữ liệu từ: ${dataPath}`);
    const jsonData = JSON.parse(fs.readFileSync(dataPath, 'utf8'));
    
    // Validate data structure
    if (!jsonData.metadata || !jsonData.data) {
      throw new Error('Invalid data structure. Expected: { metadata: {...}, data: [...] }');
    }

    console.log(`📊 Dữ liệu: ${jsonData.data.length} letters`);
    
    const result = await insertCompleteDataBatch(jsonData);
    
    console.log('\n🎯 KẾT QUẢ CUỐI CÙNG:');
    console.log(`   Batch ID: ${result.batchId}`);
    console.log(`   Thành công: ${result.processed}/${jsonData.data.length} (${result.successRate}%)`);
    console.log(`   Lỗi: ${result.errors.length}`);
    
    if (result.errors.length > 0) {
      console.log('\n❌ CHI TIẾT LỖI:');
      result.errors.slice(0, 5).forEach((error, index) => {
        console.log(`   ${index + 1}. ${error.letter}: ${error.error}`);
      });
      if (result.errors.length > 5) {
        console.log(`   ... và ${result.errors.length - 5} lỗi khác`);
      }
    }

  } catch (error) {
    console.error('💥 Lỗi thực thi:', error.message);
    process.exit(1);
  }
}

// Export functions
export {
  insertCompleteDataBatch,
  insertSingleLetter,
  testConnection
};

// Chạy main nếu được thực thi trực tiếp
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}
