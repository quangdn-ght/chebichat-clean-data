import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Initialize Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

console.log('🔍 Testing Simple Dictionary Queries...\n');

// Test 1: Count total entries
try {
  console.log('1. Total entries:');
  const { count, error: countError } = await supabase
    .from('dictionary')
    .select('*', { count: 'exact', head: true });
  
  if (countError) {
    console.error('Error:', countError.message);
  } else {
    console.log(`   ✅ Total: ${count} entries\n`);
  }
} catch (error) {
  console.error('Count error:', error.message);
}

// Test 2: Get sample entries
try {
  console.log('2. Sample entries:');
  const { data, error } = await supabase
    .from('dictionary')
    .select('chinese, pinyin, type, meaning_vi')
    .order('chinese')
    .limit(3);
  
  if (error) {
    console.error('Error:', error.message);
  } else {
    console.table(data);
    console.log('');
  }
} catch (error) {
  console.error('Sample error:', error.message);
}

// Test 3: Search for specific word
try {
  console.log('3. Search for "爱":');
  const { data, error } = await supabase
    .from('dictionary')
    .select('chinese, pinyin, meaning_vi, meaning_en')
    .eq('chinese', '爱');
  
  if (error) {
    console.error('Error:', error.message);
  } else if (data && data.length > 0) {
    console.table(data);
  } else {
    console.log('   No results found');
  }
  console.log('');
} catch (error) {
  console.error('Search error:', error.message);
}

// Test 4: Search by pinyin
try {
  console.log('4. Words with pinyin containing "ai":');
  const { data, error } = await supabase
    .from('dictionary')
    .select('chinese, pinyin, meaning_vi')
    .ilike('pinyin', '%ai%')
    .limit(5);
  
  if (error) {
    console.error('Error:', error.message);
  } else if (data && data.length > 0) {
    console.table(data);
  } else {
    console.log('   No results found');
  }
  console.log('');
} catch (error) {
  console.error('Pinyin search error:', error.message);
}

// Test 5: Search Vietnamese meaning
try {
  console.log('5. Vietnamese search "yêu":');
  const { data, error } = await supabase
    .from('dictionary')
    .select('chinese, pinyin, meaning_vi')
    .ilike('meaning_vi', '%yêu%')
    .limit(3);
  
  if (error) {
    console.error('Error:', error.message);
  } else if (data && data.length > 0) {
    console.table(data);
  } else {
    console.log('   No results found');
  }
  console.log('');
} catch (error) {
  console.error('Vietnamese search error:', error.message);
}

console.log('✅ Test completed!');
