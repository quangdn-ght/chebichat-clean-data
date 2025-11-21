import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
dotenv.config({ path: path.join(__dirname, '../../.env') });

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

async function testSupabaseConnection() {
  console.log('🧪 Testing Supabase Connection\n');
  console.log('=' .repeat(60));
  
  // Check credentials
  if (!supabaseUrl || !supabaseKey) {
    console.error('❌ Missing Supabase credentials in .env file');
    console.log('\nRequired environment variables:');
    console.log('  - SUPABASE_URL');
    console.log('  - SUPABASE_SERVICE_ROLE_KEY');
    process.exit(1);
  }
  
  console.log(`✅ Supabase URL: ${supabaseUrl}`);
  console.log(`✅ API Key: ${supabaseKey.substring(0, 20)}...`);
  console.log('=' .repeat(60));
  
  // Initialize client
  const supabase = createClient(supabaseUrl, supabaseKey);
  
  try {
    // Test 1: Check table existence and count
    console.log('\n📊 Test 1: Fetching attractions count...');
    const { count, error: countError } = await supabase
      .from('attractions')
      .select('*', { count: 'exact', head: true });
    
    if (countError) {
      throw new Error(`Failed to count attractions: ${countError.message}`);
    }
    
    console.log(`✅ Found ${count} attractions in database`);
    
    // Test 2: Fetch sample record
    console.log('\n📊 Test 2: Fetching sample attraction...');
    const { data, error: fetchError } = await supabase
      .from('attractions')
      .select('id, attraction_code, name, description, province_id, region_id, category_id')
      .not('description', 'is', null)
      .limit(1)
      .single();
    
    if (fetchError) {
      throw new Error(`Failed to fetch attraction: ${fetchError.message}`);
    }
    
    if (!data) {
      console.log('⚠️  No attractions with descriptions found');
    } else {
      console.log('✅ Sample attraction fetched successfully:');
      console.log(`   ID: ${data.id}`);
      console.log(`   Code: ${data.attraction_code}`);
      console.log(`   Name: ${data.name}`);
      console.log(`   Description length: ${data.description?.length || 0} characters`);
      console.log(`   Province ID: ${data.province_id}`);
      console.log(`   Region ID: ${data.region_id}`);
      console.log(`   Category ID: ${data.category_id}`);
    }
    
    // Test 3: Check for multilingual columns
    console.log('\n📊 Test 3: Checking multilingual columns...');
    const { data: columnData, error: columnError } = await supabase
      .from('attractions')
      .select('name_vi, name_en, description_vi, short_description_zh, short_description_vi')
      .limit(1)
      .maybeSingle();
    
    if (columnError) {
      console.log('⚠️  Multilingual columns not found or error:', columnError.message);
      console.log('\n💡 Run this SQL to add multilingual columns:');
      console.log('   See: add-multilingual-columns.sql');
    } else {
      console.log('✅ Multilingual columns exist in table');
      if (columnData) {
        const hasContent = Object.values(columnData).some(val => val !== null);
        if (hasContent) {
          console.log('✅ Found existing multilingual content');
        } else {
          console.log('ℹ️  Multilingual columns exist but are empty');
        }
      }
    }
    
    // Test 4: Check attractions with descriptions
    console.log('\n📊 Test 4: Counting attractions ready for processing...');
    const { count: readyCount, error: readyError } = await supabase
      .from('attractions')
      .select('*', { count: 'exact', head: true })
      .not('description', 'is', null);
    
    if (readyError) {
      throw new Error(`Failed to count ready attractions: ${readyError.message}`);
    }
    
    console.log(`✅ ${readyCount} attractions have descriptions and are ready for processing`);
    
    // Summary
    console.log('\n' + '='.repeat(60));
    console.log('📋 SUMMARY');
    console.log('='.repeat(60));
    console.log(`Total attractions: ${count}`);
    console.log(`Ready for processing: ${readyCount}`);
    console.log(`Missing descriptions: ${count - readyCount}`);
    console.log('='.repeat(60));
    console.log('\n✅ All tests passed! Connection is working.\n');
    
    console.log('💡 Next steps:');
    console.log('   1. If multilingual columns are missing, run: add-multilingual-columns.sql');
    console.log('   2. Test with single attraction: node supabase-attraction-processor.js --code <code>');
    console.log('   3. Process batch: node supabase-attraction-processor.js --limit 10');
    
  } catch (error) {
    console.error('\n❌ Test failed:', error.message);
    console.log('\n💡 Troubleshooting tips:');
    console.log('   1. Verify your .env file has correct SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY');
    console.log('   2. Check that the attractions table exists in your Supabase project');
    console.log('   3. Ensure your service role key has read permissions');
    process.exit(1);
  }
}

// Run test
testSupabaseConnection();
