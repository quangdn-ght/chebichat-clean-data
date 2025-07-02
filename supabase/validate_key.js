#!/usr/bin/env node

// Script để giúp setup service role key
// Script to help setup service role key

import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fs from 'fs';

dotenv.config();

async function validateServiceRoleKey() {
  console.log('🔍 Kiểm tra Service Role Key... / Checking Service Role Key...\n');

  // Check if .env exists
  if (!fs.existsSync('.env')) {
    console.log('📝 Tạo file .env từ template... / Creating .env from template...');
    if (fs.existsSync('.env.template')) {
      fs.copyFileSync('.env.template', '.env');
      console.log('✅ Đã tạo file .env / Created .env file');
    } else {
      console.error('❌ Không tìm thấy .env.template');
      process.exit(1);
    }
  }

  // Check environment variables
  if (!process.env.SUPABASE_URL) {
    console.error('❌ Thiếu SUPABASE_URL trong .env');
    console.log('   Thêm: SUPABASE_URL=https://your-project.supabase.co');
    process.exit(1);
  }

  if (process.env.SUPABASE_URL.includes('your-project')) {
    console.error('❌ SUPABASE_URL chưa được cập nhật');
    console.log('   Cần thay "your-project-id" bằng project ID thực tế');
    process.exit(1);
  }

  if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
    console.error('❌ Thiếu SUPABASE_SERVICE_ROLE_KEY trong .env');
    printServiceRoleKeyInstructions();
    process.exit(1);
  }

  if (process.env.SUPABASE_SERVICE_ROLE_KEY.includes('your-service-role-key')) {
    console.error('❌ SUPABASE_SERVICE_ROLE_KEY chưa được cập nhật');
    printServiceRoleKeyInstructions();
    process.exit(1);
  }

  // Test the service role key
  console.log('🧪 Testing service role key...');
  
  try {
    const supabase = createClient(
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

    // Test read permissions
    const { data: readTest, error: readError } = await supabase
      .from('categories')
      .select('count(*)')
      .limit(1);

    if (readError) {
      console.error('❌ Lỗi đọc dữ liệu:', readError.message);
      if (readError.message.includes('JWT')) {
        console.log('💡 Service role key có thể không hợp lệ hoặc đã hết hạn');
      }
      process.exit(1);
    }

    console.log('✅ Quyền đọc OK');

    // Test write permissions
    const testBatch = {
      total_items: 0,
      successful_items: 0,
      failed_items: 0,
      status: 'pending',
      summary: { test: true, timestamp: new Date().toISOString() }
    };

    const { data: writeTest, error: writeError } = await supabase
      .from('processing_batches')
      .insert(testBatch)
      .select('id')
      .single();

    if (writeError) {
      console.error('❌ Lỗi quyền ghi:', writeError.message);
      process.exit(1);
    }

    console.log('✅ Quyền ghi OK');

    // Clean up test record
    await supabase.from('processing_batches').delete().eq('id', writeTest.id);
    console.log('✅ Test record đã được xóa');

    console.log('\n🎉 Service Role Key hoạt động hoàn hảo!');
    console.log('🎉 Service Role Key works perfectly!');
    console.log('\n📊 Bây giờ bạn có thể chạy:');
    console.log('📊 Now you can run:');
    console.log('   npm run insert');
    console.log('   npm run insert-admin');

  } catch (error) {
    console.error('❌ Lỗi test:', error.message);
    process.exit(1);
  }
}

function printServiceRoleKeyInstructions() {
  console.log('\n🔑 HƯỚNG DẪN LẤY SERVICE ROLE KEY:');
  console.log('🔑 HOW TO GET SERVICE ROLE KEY:');
  console.log('');
  console.log('1. 🌐 Đi đến: https://app.supabase.com');
  console.log('2. 📁 Chọn project của bạn');
  console.log('3. ⚙️  Đi đến: Settings → API');
  console.log('4. 🔍 Tìm "Project API keys" section');
  console.log('5. 📋 Copy "service_role" key (dài ~200+ ký tự)');
  console.log('6. 📝 Thêm vào .env:');
  console.log('');
  console.log('   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
  console.log('');
  console.log('⚠️  LƯU Ý: Service role key có quyền admin - giữ bí mật!');
  console.log('⚠️  NOTE: Service role key has admin privileges - keep it secret!');
}

// Run validation
validateServiceRoleKey().catch(console.error);
