const fs = require('fs').promises;

async function showResults() {
  try {
    const data = JSON.parse(await fs.readFile('./output/import_processed.json', 'utf8'));
    
    console.log('🎉 IMPORT.JSON PROCESSING RESULTS SUMMARY');
    console.log('==========================================\n');
    
    console.log('📊 Overview:');
    console.log(`✅ Successfully processed: ${data.metadata.successfulItems}/${data.metadata.totalItems} items`);
    console.log(`📝 Total Chinese words extracted: ${data.metadata.summary.totalWords}`);
    console.log(`📁 Output saved to: ./output/import_processed.json`);
    
    console.log('\n🎯 HSK Level Distribution:');
    const hskData = data.metadata.summary.hskDistribution;
    const hskPercentages = data.metadata.summary.hskPercentages;
    Object.keys(hskData).forEach(level => {
      console.log(`   ${level.toUpperCase()}: ${hskData[level]} words (${hskPercentages[level]}%)`);
    });
    
    console.log('\n📝 Sample Item (First processed entry):');
    const sample = data.data[0];
    console.log(`   Original: ${sample.original.substring(0, 80)}...`);
    console.log(`   Vietnamese: ${sample.vietnamese.substring(0, 80)}...`);
    console.log(`   Pinyin: ${sample.pinyin.substring(0, 80)}...`);
    console.log(`   Words found: ${Object.values(sample.words).flat().length} total`);
    
    console.log('\n✨ File Structure:');
    console.log('   Each item contains:');
    console.log('   • original: Original Chinese text');
    console.log('   • vietnamese: Vietnamese translation');
    console.log('   • pinyin: Romanized pronunciation');
    console.log('   • words: Chinese words grouped by HSK level');
    console.log('   • statistics: Word count analysis');
    
    console.log('\n🎊 SUCCESS! The import.json file has been processed with:');
    console.log('   ✓ Chinese text segmentation');
    console.log('   ✓ HSK level analysis');
    console.log('   ✓ Pinyin generation');
    console.log('   ✓ Statistical analysis');
    console.log('   ✓ Structured JSON output');
    
  } catch (error) {
    console.error('Error reading results:', error.message);
  }
}

showResults();
