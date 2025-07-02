const fs = require('fs');

// Function to merge level.json with result.json
function mergeData() {
  try {
    // Read level.json (HSK words data)
    const levelData = JSON.parse(fs.readFileSync('./level.json', 'utf-8'));
    
    // Read result.json (Vietnamese translations)
    const resultData = JSON.parse(fs.readFileSync('./result.json', 'utf-8'));
    
    console.log(`📖 Loaded ${levelData.length} items from level.json`);
    console.log(`🔤 Loaded ${resultData.length} items from result.json`);
    
    // Create a map of original text to result data for faster lookup
    const resultMap = new Map();
    resultData.forEach(item => {
      if (item.chinese) {
        resultMap.set(item.chinese.trim(), item);
      }
    });
    
    console.log(`🗺️ Created lookup map with ${resultMap.size} entries`);
    
    // Merge data
    const mergedData = levelData.map((levelItem, index) => {
      const original = levelItem.original?.trim() || '';
      const matchedResult = resultMap.get(original);
      
      if (matchedResult) {
        console.log(`✅ Match found for item ${index + 1}: ${original.substring(0, 50)}...`);
        
        return {
          original: original,
          words: levelItem.words || {},
          pinyin: levelItem.pinyin || matchedResult.pinyin || null,
          vietnamese: matchedResult.vietnamese || null,
          category: matchedResult.category || 'life',
          source: matchedResult.source || '999 letters to yourself'
        };
      } else {
        console.log(`❌ No match found for item ${index + 1}: ${original.substring(0, 50)}...`);
        
        return {
          original: original,
          words: levelItem.words || {},
          pinyin: levelItem.pinyin || null,
          vietnamese: null,
          category: 'life',
          source: '999 letters to yourself'
        };
      }
    });
    
    // Write merged data back to level.json
    fs.writeFileSync('./level.json', JSON.stringify(mergedData, null, 2), 'utf-8');
    
    const matchedCount = mergedData.filter(item => item.vietnamese !== null).length;
    
    console.log(`🎉 Merge completed!`);
    console.log(`📊 Statistics:`);
    console.log(`   - Total items: ${mergedData.length}`);
    console.log(`   - Matched items: ${matchedCount}`);
    console.log(`   - Unmatched items: ${mergedData.length - matchedCount}`);
    console.log(`   - Match rate: ${((matchedCount / mergedData.length) * 100).toFixed(1)}%`);
    console.log(`💾 Updated level.json with merged data`);
    
    return mergedData;
    
  } catch (error) {
    console.error('❌ Error during merge:', error.message);
    return null;
  }
}

// Function to prepare data for Supabase insertion
function prepareForSupabase(mergedData) {
  if (!mergedData) {
    console.error('❌ No merged data provided');
    return;
  }
  
  console.log('🔄 Preparing data for Supabase insertion...');
  
  // Extract unique categories and sources
  const categories = new Set();
  const sources = new Set();
  
  mergedData.forEach(item => {
    if (item.category) categories.add(item.category);
    if (item.source) sources.add(item.source);
  });
  
  // Prepare SQL statements
  const sqlStatements = [];
  
  // Categories insert statements
  categories.forEach(category => {
    sqlStatements.push(`INSERT INTO categories (name, description) VALUES ('${category}', '${category} related content') ON CONFLICT (name) DO NOTHING;`);
  });
  
  // Sources insert statements
  sources.forEach(source => {
    sqlStatements.push(`INSERT INTO sources (name, description) VALUES ('${source}', 'Source: ${source}') ON CONFLICT (name) DO NOTHING;`);
  });
  
  // Letters and related data
  mergedData.forEach((item, index) => {
    const escapedOriginal = item.original.replace(/'/g, "''");
    const escapedPinyin = item.pinyin ? item.pinyin.replace(/'/g, "''") : null;
    const escapedVietnamese = item.vietnamese ? item.vietnamese.replace(/'/g, "''") : null;
    
    // Insert letter
    sqlStatements.push(`
INSERT INTO letters (original, pinyin, vietnamese, category_id, source_id) 
VALUES (
  '${escapedOriginal}',
  ${escapedPinyin ? `'${escapedPinyin}'` : 'NULL'},
  ${escapedVietnamese ? `'${escapedVietnamese}'` : 'NULL'},
  (SELECT id FROM categories WHERE name = '${item.category}'),
  (SELECT id FROM sources WHERE name = '${item.source}')
) ON CONFLICT (original) DO UPDATE SET
  pinyin = EXCLUDED.pinyin,
  vietnamese = EXCLUDED.vietnamese,
  category_id = EXCLUDED.category_id,
  source_id = EXCLUDED.source_id,
  updated_at = NOW();`);
    
    // Insert HSK words
    if (item.words) {
      Object.entries(item.words).forEach(([level, words]) => {
        if (level.startsWith('hsk') && words.length > 0) {
          const hskLevel = parseInt(level.replace('hsk', ''));
          const wordsArray = words.map(w => w.replace(/'/g, "''")).join("','");
          
          sqlStatements.push(`
INSERT INTO letter_hsk_words (letter_id, hsk_level, words)
VALUES (
  (SELECT id FROM letters WHERE original = '${escapedOriginal}'),
  ${hskLevel},
  ARRAY['${wordsArray}']
) ON CONFLICT (letter_id, hsk_level) DO UPDATE SET
  words = EXCLUDED.words;`);
        } else if (level === 'other' && words.length > 0) {
          const wordsArray = words.map(w => w.replace(/'/g, "''")).join("','");
          
          sqlStatements.push(`
INSERT INTO letter_other_words (letter_id, words)
VALUES (
  (SELECT id FROM letters WHERE original = '${escapedOriginal}'),
  ARRAY['${wordsArray}']
) ON CONFLICT (letter_id) DO UPDATE SET
  words = EXCLUDED.words;`);
        }
      });
    }
  });
  
  // Write SQL file
  const sqlContent = sqlStatements.join('\n\n');
  fs.writeFileSync('./db/insert_letters_data.sql', sqlContent, 'utf-8');
  
  console.log(`💾 Created insert_letters_data.sql with ${sqlStatements.length} statements`);
  console.log(`📊 Prepared data:`);
  console.log(`   - Categories: ${categories.size}`);
  console.log(`   - Sources: ${sources.size}`);
  console.log(`   - Letters: ${mergedData.length}`);
}

// Run the merge and preparation
console.log('🚀 Starting data merge process...');
const mergedData = mergeData();

if (mergedData) {
  prepareForSupabase(mergedData);
  console.log('✅ Process completed successfully!');
} else {
  console.log('❌ Process failed!');
}
