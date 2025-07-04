import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Initialize Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

/**
 * Execute predefined Supabase queries
 */
async function runSpecificQuery(queryName, queryFunction) {
  try {
    console.log(`\n🔍 ${queryName}`);
    console.log('─'.repeat(60));
    
    const startTime = Date.now();
    const result = await queryFunction();
    const executionTime = Date.now() - startTime;
    
    if (result.error) {
      console.error(`❌ Error: ${result.error.message}`);
      return;
    }
    
    console.log(`⏱️  Execution time: ${executionTime}ms`);
    
    // Handle different types of results
    let data;
    if (result.count !== undefined && result.count !== null) {
      // This is a count query
      data = [{ count: result.count }];
    } else if (result.data) {
      // This is a data query
      data = result.data;
    } else {
      data = [];
    }
    
    if (data && data.length > 0) {
      console.log(`✅ Results (${data.length} rows):`);
      
      // Display differently based on result size
      if (data.length === 1 && Object.keys(data[0]).length <= 3) {
        // Single row with few columns - display as key-value
        Object.entries(data[0]).forEach(([key, value]) => {
          console.log(`   ${key}: ${value}`);
        });
      } else if (data.length <= 10) {
        // Small result set - show as table
        console.table(data);
      } else {
        // Large result set - show first few rows
        console.table(data.slice(0, 5));
        console.log(`   ... and ${data.length - 5} more rows`);
      }
    } else {
      console.log('📭 No results found');
    }
    
  } catch (error) {
    console.error(`❌ Execution error: ${error.message}`);
  }
}

/**
 * Run predefined test queries using Supabase client
 */
async function runPredefinedTests() {
  console.log('🚀 Running Dictionary Test Queries...\n');
  
  // 1. Total count
  await runSpecificQuery(
    'Total Dictionary Entries',
    async () => {
      return await supabase
        .from('dictionary')
        .select('*', { count: 'exact', head: true });
    }
  );
  
  // 2. Sample entries
  await runSpecificQuery(
    'Sample Dictionary Entries',
    async () => {
      return await supabase
        .from('dictionary')
        .select('chinese, pinyin, type, meaning_vi')
        .order('chinese')
        .limit(5);
    }
  );
  
  // 3. Search for specific word
  await runSpecificQuery(
    'Word: "爱" (Love)',
    async () => {
      return await supabase
        .from('dictionary')
        .select('chinese, pinyin, meaning_vi, meaning_en')
        .eq('chinese', '爱');
    }
  );
  
  // 4. Search by pinyin
  await runSpecificQuery(
    'Words with Pinyin containing "ai"',
    async () => {
      return await supabase
        .from('dictionary')
        .select('chinese, pinyin, meaning_vi')
        .ilike('pinyin', '%ai%')
        .limit(5);
    }
  );
  
  // 5. Search Vietnamese meaning
  await runSpecificQuery(
    'Words meaning "yêu" in Vietnamese',
    async () => {
      return await supabase
        .from('dictionary')
        .select('chinese, pinyin, meaning_vi')
        .ilike('meaning_vi', '%yêu%')
        .limit(5);
    }
  );
  
  // 6. Filter by word type
  await runSpecificQuery(
    'Sample Nouns (danh từ)',
    async () => {
      return await supabase
        .from('dictionary')
        .select('chinese, pinyin, meaning_vi')
        .eq('type', 'danh từ')
        .limit(5);
    }
  );
  
  // 7. Recent entries
  await runSpecificQuery(
    'Most Recent Entries',
    async () => {
      return await supabase
        .from('dictionary')
        .select('chinese, pinyin, meaning_vi, created_at')
        .order('created_at', { ascending: false })
        .limit(5);
    }
  );
  
  // 8. Complex search with multiple conditions
  await runSpecificQuery(
    'Love-related Words (Chinese or Vietnamese)',
    async () => {
      return await supabase
        .from('dictionary')
        .select('chinese, pinyin, meaning_vi, meaning_en')
        .or('chinese.eq.爱,meaning_vi.ilike.%yêu%,meaning_en.ilike.%love%')
        .limit(5);
    }
  );
}

/**
 * Run a custom Supabase query
 */
async function runCustomQuery(queryDescription) {
  console.log('📋 Custom Query Examples:');
  console.log('1. Search by Chinese: node simple_query.js chinese 爱');
  console.log('2. Search by pinyin: node simple_query.js pinyin ai');
  console.log('3. Search Vietnamese: node simple_query.js vietnamese yêu');
  console.log('4. Search English: node simple_query.js english love');
  console.log('5. Get by type: node simple_query.js type "danh từ"');
  console.log('6. Random sample: node simple_query.js random');
}

/**
 * Main function
 */
async function main() {
  const args = process.argv.slice(2);
  
  console.log('📊 Dictionary Query Runner');
  console.log('═'.repeat(60));
  
  if (args.length === 0) {
    await runPredefinedTests();
  } else {
    const [command, ...params] = args;
    const searchTerm = params.join(' ');
    
    switch (command.toLowerCase()) {
      case 'chinese':
        await runSpecificQuery(
          `Search Chinese: "${searchTerm}"`,
          async () => {
            return await supabase
              .from('dictionary')
              .select('chinese, pinyin, meaning_vi, meaning_en')
              .eq('chinese', searchTerm);
          }
        );
        break;
        
      case 'pinyin':
        await runSpecificQuery(
          `Search Pinyin: "${searchTerm}"`,
          async () => {
            return await supabase
              .from('dictionary')
              .select('chinese, pinyin, meaning_vi')
              .ilike('pinyin', `%${searchTerm}%`)
              .limit(10);
          }
        );
        break;
        
      case 'vietnamese':
        await runSpecificQuery(
          `Search Vietnamese: "${searchTerm}"`,
          async () => {
            return await supabase
              .from('dictionary')
              .select('chinese, pinyin, meaning_vi')
              .ilike('meaning_vi', `%${searchTerm}%`)
              .limit(10);
          }
        );
        break;
        
      case 'english':
        await runSpecificQuery(
          `Search English: "${searchTerm}"`,
          async () => {
            return await supabase
              .from('dictionary')
              .select('chinese, pinyin, meaning_en')
              .ilike('meaning_en', `%${searchTerm}%`)
              .limit(10);
          }
        );
        break;
        
      case 'type':
        await runSpecificQuery(
          `Word Type: "${searchTerm}"`,
          async () => {
            return await supabase
              .from('dictionary')
              .select('chinese, pinyin, meaning_vi')
              .eq('type', searchTerm)
              .limit(10);
          }
        );
        break;
        
      case 'random':
        // Note: Supabase doesn't support ORDER BY RANDOM(), so we'll get a sample differently
        await runSpecificQuery(
          'Random Sample',
          async () => {
            const { count } = await supabase
              .from('dictionary')
              .select('*', { count: 'exact', head: true });
            
            const randomOffset = Math.floor(Math.random() * (count - 5));
            return await supabase
              .from('dictionary')
              .select('chinese, pinyin, meaning_vi')
              .range(randomOffset, randomOffset + 4);
          }
        );
        break;
        
      case 'count':
        await runSpecificQuery(
          'Word Type Count',
          async () => {
            // This requires a manual aggregation since Supabase doesn't support GROUP BY directly
            const types = ['danh từ', 'động từ', 'tính từ', 'trạng từ', 'đại từ', 'giới từ', 'liên từ', 'thán từ', 'số từ', 'lượng từ', 'phó từ', 'other'];
            const results = [];
            
            for (const type of types) {
              const { count } = await supabase
                .from('dictionary')
                .select('*', { count: 'exact', head: true })
                .eq('type', type);
              
              if (count > 0) {
                results.push({ type, count });
              }
            }
            
            return { data: results };
          }
        );
        break;
        
      default:
        await runCustomQuery('help');
        break;
    }
  }
  
  console.log('\n✅ Query execution completed!');
}

// Run if executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}

export { runSpecificQuery, runPredefinedTests, runCustomQuery };
