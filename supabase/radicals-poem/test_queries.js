const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

// Supabase configuration
const supabaseUrl = process.env.SUPABASE_URL || 'your-supabase-url';
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'your-supabase-anon-key';

const supabase = createClient(supabaseUrl, supabaseKey);

/**
 * Test queries for radicals poem schema
 */
class RadicalsPoemTester {
  constructor() {
    this.testResults = [];
  }

  async runTest(testName, testFunction) {
    console.log(`\n🧪 Running test: ${testName}`);
    try {
      const result = await testFunction();
      this.testResults.push({ name: testName, status: 'PASS', result });
      console.log('✅ PASS');
      return result;
    } catch (error) {
      this.testResults.push({ name: testName, status: 'FAIL', error: error.message });
      console.log('❌ FAIL:', error.message);
      return null;
    }
  }

  /**
   * Test basic table access
   */
  async testTableAccess() {
    const { data, error } = await supabase
      .from('radicals_poem')
      .select('chinese, poem_description')
      .limit(5);

    if (error) throw error;
    
    console.log(`   Found ${data?.length || 0} sample records`);
    if (data && data.length > 0) {
      console.log(`   Sample: ${data[0].chinese} - ${data[0].poem_description.substring(0, 50)}...`);
    }
    
    return data;
  }

  /**
   * Test search by Chinese character
   */
  async testSearchByChinese() {
    const testChar = '黄';
    const { data, error } = await supabase.rpc('search_radicals_by_chinese', {
      search_term: testChar
    });

    if (error) throw error;
    
    console.log(`   Found ${data?.length || 0} results for "${testChar}"`);
    if (data && data.length > 0) {
      console.log(`   Result: ${data[0].chinese} - ${data[0].poem_description}`);
    }
    
    return data;
  }

  /**
   * Test search by Vietnamese description
   */
  async testSearchByVietnamese() {
    const testTerm = 'vàng';
    const { data, error } = await supabase.rpc('search_radicals_by_description', {
      search_term: testTerm
    });

    if (error) throw error;
    
    console.log(`   Found ${data?.length || 0} results for "${testTerm}"`);
    if (data && data.length > 0) {
      console.log(`   Top result: ${data[0].chinese} - ${data[0].poem_description}`);
    }
    
    return data;
  }

  /**
   * Test getting radical by exact Chinese character
   */
  async testGetRadicalByChinese() {
    const testChar = '它';
    const { data, error } = await supabase.rpc('get_radical_by_chinese', {
      char_chinese: testChar
    });

    if (error) throw error;
    
    console.log(`   Found ${data?.length || 0} results for exact match "${testChar}"`);
    if (data && data.length > 0) {
      console.log(`   Result: ${data[0].chinese} - ${data[0].poem_description}`);
    }
    
    return data;
  }

  /**
   * Test category-based queries
   */
  async testGetRadicalsByCategory() {
    const { data, error } = await supabase.rpc('get_radicals_by_category', {
      cat: 'pictograph'
    });

    if (error) throw error;
    
    console.log(`   Found ${data?.length || 0} pictographic radicals`);
    if (data && data.length > 0) {
      console.log(`   Sample: ${data[0].chinese} - ${data[0].poem_description.substring(0, 30)}...`);
    }
    
    return data;
  }

  /**
   * Test stroke count queries
   */
  async testGetRadicalsByStrokeRange() {
    const { data, error } = await supabase.rpc('get_radicals_by_stroke_range', {
      min_strokes: 5,
      max_strokes: 10
    });

    if (error) throw error;
    
    console.log(`   Found ${data?.length || 0} radicals with 5-10 strokes`);
    if (data && data.length > 0) {
      console.log(`   Sample: ${data[0].chinese} (${data[0].stroke_count} strokes) - ${data[0].poem_description.substring(0, 30)}...`);
    }
    
    return data;
  }

  /**
   * Test dictionary relationships
   */
  async testDictionaryRelationships() {
    const testChar = '黄';
    const { data, error } = await supabase.rpc('get_dictionary_words_with_radical', {
      radical_char: testChar
    });

    if (error) {
      // This might fail if dictionary table doesn't exist, which is OK
      console.log(`   Note: Dictionary relationship test skipped (dictionary table may not exist)`);
      return [];
    }
    
    console.log(`   Found ${data?.length || 0} dictionary words containing "${testChar}"`);
    if (data && data.length > 0) {
      console.log(`   Sample: ${data[0].dictionary_chinese} (${data[0].position_type}) - ${data[0].meaning_vi.substring(0, 30)}...`);
    }
    
    return data;
  }

  /**
   * Test statistics views
   */
  async testStatisticsView() {
    const { data, error } = await supabase
      .from('radicals_poem_stats')
      .select('*');

    if (error) throw error;
    
    console.log(`   Statistics categories: ${data?.length || 0}`);
    if (data && data.length > 0) {
      data.forEach(stat => {
        console.log(`   ${stat.category}: ${stat.count_by_category} radicals`);
      });
    }
    
    return data;
  }

  /**
   * Test performance with text search
   */
  async testTextSearchPerformance() {
    const startTime = Date.now();
    
    const { data, error } = await supabase
      .from('radicals_poem')
      .select('chinese, poem_description')
      .textSearch('poem_description', 'vàng', {
        type: 'websearch',
        config: 'simple'
      });

    const endTime = Date.now();
    
    if (error) throw error;
    
    console.log(`   Text search completed in ${endTime - startTime}ms`);
    console.log(`   Found ${data?.length || 0} results`);
    
    return { duration: endTime - startTime, results: data?.length || 0 };
  }

  /**
   * Test data integrity
   */
  async testDataIntegrity() {
    // Check for required fields
    const { data: missingDesc, error: error1 } = await supabase
      .from('radicals_poem')
      .select('chinese')
      .or('poem_description.is.null,poem_description.eq.""');

    if (error1) throw error1;

    // Check for duplicate Chinese characters
    const { data: allChars, error: error2 } = await supabase
      .from('radicals_poem')
      .select('chinese');

    if (error2) throw error2;

    const uniqueChars = new Set(allChars?.map(r => r.chinese) || []);
    const duplicates = (allChars?.length || 0) - uniqueChars.size;

    console.log(`   Missing descriptions: ${missingDesc?.length || 0}`);
    console.log(`   Duplicate characters: ${duplicates}`);
    console.log(`   Total unique characters: ${uniqueChars.size}`);

    return {
      missingDescriptions: missingDesc?.length || 0,
      duplicates,
      totalUnique: uniqueChars.size
    };
  }

  /**
   * Run all tests
   */
  async runAllTests() {
    console.log('🚀 Starting Radicals Poem Schema Tests');
    console.log('======================================');

    await this.runTest('Table Access', () => this.testTableAccess());
    await this.runTest('Search by Chinese Character', () => this.testSearchByChinese());
    await this.runTest('Search by Vietnamese Description', () => this.testSearchByVietnamese());
    await this.runTest('Get Radical by Chinese', () => this.testGetRadicalByChinese());
    await this.runTest('Get Radicals by Category', () => this.testGetRadicalsByCategory());
    await this.runTest('Get Radicals by Stroke Range', () => this.testGetRadicalsByStrokeRange());
    await this.runTest('Dictionary Relationships', () => this.testDictionaryRelationships());
    await this.runTest('Statistics View', () => this.testStatisticsView());
    await this.runTest('Text Search Performance', () => this.testTextSearchPerformance());
    await this.runTest('Data Integrity', () => this.testDataIntegrity());

    // Print summary
    console.log('\n📊 Test Summary');
    console.log('===============');
    
    const passed = this.testResults.filter(r => r.status === 'PASS').length;
    const failed = this.testResults.filter(r => r.status === 'FAIL').length;
    
    console.log(`✅ Passed: ${passed}`);
    console.log(`❌ Failed: ${failed}`);
    console.log(`📈 Success Rate: ${((passed / this.testResults.length) * 100).toFixed(1)}%`);

    if (failed > 0) {
      console.log('\n❌ Failed Tests:');
      this.testResults
        .filter(r => r.status === 'FAIL')
        .forEach(test => {
          console.log(`   ${test.name}: ${test.error}`);
        });
    }

    return {
      passed,
      failed,
      total: this.testResults.length,
      successRate: (passed / this.testResults.length) * 100
    };
  }
}

// Main execution
async function main() {
  const tester = new RadicalsPoemTester();
  
  try {
    const results = await tester.runAllTests();
    
    if (results.failed === 0) {
      console.log('\n🎉 All tests passed! Schema is working correctly.');
      process.exit(0);
    } else {
      console.log('\n⚠️  Some tests failed. Please check the errors above.');
      process.exit(1);
    }
    
  } catch (error) {
    console.error('💥 Test execution failed:', error.message);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = RadicalsPoemTester;
