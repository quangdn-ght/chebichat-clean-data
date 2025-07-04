import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import fs from 'fs';

// Load environment variables
dotenv.config();

// Initialize Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

/**
 * Execute a test query and display results
 */
async function executeTestQuery(queryName, query) {
  try {
    console.log(`\n🔍 ${queryName}`);
    console.log('─'.repeat(60));
    
    const { data, error } = await supabase.rpc('exec_sql', { sql: query });
    
    if (error) {
      console.error('❌ Error:', error.message);
      return;
    }
    
    if (data && data.length > 0) {
      console.log(`✅ Found ${data.length} results:`);
      console.table(data.slice(0, 5)); // Show first 5 results
      if (data.length > 5) {
        console.log(`... and ${data.length - 5} more results`);
      }
    } else {
      console.log('📭 No results found');
    }
    
  } catch (error) {
    console.error('❌ Execution error:', error.message);
  }
}

/**
 * Run basic test queries
 */
async function runBasicTests() {
  console.log('🚀 Running Basic Dictionary Tests...\n');
  
  // Test 1: Count total entries
  await executeTestQuery(
    'Total Dictionary Entries',
    'SELECT COUNT(*) as total_entries FROM dictionary'
  );
  
  // Test 2: Sample entries
  await executeTestQuery(
    'Sample Dictionary Entries',
    'SELECT chinese, pinyin, type, meaning_vi FROM dictionary ORDER BY chinese LIMIT 5'
  );
  
  // Test 3: Word types distribution
  await executeTestQuery(
    'Word Types Distribution',
    'SELECT type, COUNT(*) as count FROM dictionary GROUP BY type ORDER BY count DESC'
  );
  
  // Test 4: Search for specific word
  await executeTestQuery(
    'Search for "爱" (love)',
    "SELECT chinese, pinyin, meaning_vi, meaning_en FROM dictionary WHERE chinese = '爱'"
  );
  
  // Test 5: Pinyin search
  await executeTestQuery(
    'Pinyin Search: words containing "ai"',
    "SELECT chinese, pinyin, meaning_vi FROM dictionary WHERE pinyin ILIKE '%ai%' LIMIT 5"
  );
  
  // Test 6: Vietnamese meaning search
  await executeTestQuery(
    'Vietnamese Search: words meaning "yêu"',
    "SELECT chinese, pinyin, meaning_vi FROM dictionary WHERE meaning_vi ILIKE '%yêu%' LIMIT 5"
  );
}

/**
 * Run advanced test queries
 */
async function runAdvancedTests() {
  console.log('\n🔬 Running Advanced Dictionary Tests...\n');
  
  // Test custom functions if they exist
  try {
    await executeTestQuery(
      'Vietnamese Search Function',
      "SELECT * FROM search_dictionary_vietnamese('yêu') LIMIT 3"
    );
  } catch (error) {
    console.log('⚠️  Custom search function not available');
  }
  
  // Test data quality
  await executeTestQuery(
    'Data Completeness Check',
    `SELECT 
      COUNT(*) as total,
      COUNT(CASE WHEN pinyin IS NOT NULL AND pinyin != '' THEN 1 END) as has_pinyin,
      COUNT(CASE WHEN meaning_vi IS NOT NULL AND meaning_vi != '' THEN 1 END) as has_meaning_vi,
      COUNT(CASE WHEN meaning_en IS NOT NULL AND meaning_en != '' THEN 1 END) as has_meaning_en
    FROM dictionary`
  );
  
  // Test for longest words
  await executeTestQuery(
    'Longest Chinese Words',
    'SELECT chinese, pinyin, meaning_vi, LENGTH(chinese) as length FROM dictionary ORDER BY LENGTH(chinese) DESC LIMIT 5'
  );
}

/**
 * Test specific dictionary operations
 */
async function testDictionaryOperations() {
  console.log('\n📚 Testing Dictionary Operations...\n');
  
  // Test direct Supabase client queries
  try {
    console.log('🔍 Testing Direct Supabase Queries');
    console.log('─'.repeat(60));
    
    // Simple select
    const { data: sampleData, error: sampleError } = await supabase
      .from('dictionary')
      .select('chinese, pinyin, meaning_vi')
      .limit(3);
    
    if (sampleError) {
      console.error('❌ Error:', sampleError.message);
    } else {
      console.log('✅ Sample entries:');
      console.table(sampleData);
    }
    
    // Count entries
    const { count, error: countError } = await supabase
      .from('dictionary')
      .select('*', { count: 'exact', head: true });
    
    if (countError) {
      console.error('❌ Count error:', countError.message);
    } else {
      console.log(`✅ Total entries: ${count}`);
    }
    
    // Search specific word
    const { data: searchData, error: searchError } = await supabase
      .from('dictionary')
      .select('*')
      .eq('chinese', '爱')
      .single();
    
    if (searchError) {
      console.log('⚠️  Word "爱" not found or error:', searchError.message);
    } else {
      console.log('✅ Found word "爱":');
      console.log(searchData);
    }
    
    // Type filter
    const { data: typeData, error: typeError } = await supabase
      .from('dictionary')
      .select('chinese, pinyin, meaning_vi')
      .eq('type', 'danh từ')
      .limit(3);
    
    if (typeError) {
      console.error('❌ Type filter error:', typeError.message);
    } else {
      console.log('✅ Sample nouns (danh từ):');
      console.table(typeData);
    }
    
  } catch (error) {
    console.error('❌ Supabase client test failed:', error.message);
  }
}

/**
 * Main test runner
 */
async function main() {
  const args = process.argv.slice(2);
  const testType = args[0] || 'basic';
  
  try {
    console.log('📊 Dictionary Test Runner');
    console.log('═'.repeat(60));
    console.log(`🎯 Running: ${testType} tests`);
    
    switch (testType) {
      case 'basic':
        await runBasicTests();
        break;
        
      case 'advanced':
        await runAdvancedTests();
        break;
        
      case 'operations':
        await testDictionaryOperations();
        break;
        
      case 'all':
        await runBasicTests();
        await runAdvancedTests();
        await testDictionaryOperations();
        break;
        
      default:
        console.log('\n📚 Available test types:');
        console.log('  basic      - Basic queries and statistics');
        console.log('  advanced   - Advanced queries and functions');
        console.log('  operations - Supabase client operations');
        console.log('  all        - Run all tests');
        console.log('');
        console.log('Usage: node test_queries.js [test_type]');
        break;
    }
    
    console.log('\n✅ Test execution completed!');
    
  } catch (error) {
    console.error('❌ Test execution failed:', error.message);
    process.exit(1);
  }
}

// Run if executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}

export { executeTestQuery, runBasicTests, runAdvancedTests, testDictionaryOperations };
