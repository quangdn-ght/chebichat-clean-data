const { DataMerger } = require('./index');
const fs = require('fs').promises;

async function testImportJson() {
  console.log('📁 Testing import.json processing with HSK levels and pinyin');
  console.log('===========================================================\n');
  
  const merger = new DataMerger();
  
  try {
    // Read import.json
    const importData = JSON.parse(await fs.readFile('./import.json', 'utf8'));
    console.log(`✅ Loaded ${importData.length} items from import.json`);
    
    // Process the data with HSK levels and pinyin
    const importResult = await merger.processData(importData, './output/import_processed.json');
    
    console.log('\n📊 Processing Results:');
    console.log('===================================');
    console.log(`• Processed: ${importResult.metadata.successfulItems}/${importResult.metadata.totalItems} items`);
    console.log(`• Total Words: ${importResult.metadata.summary.totalWords}`);
    console.log(`• Output Path: ${importResult.outputPath}`);
    
    console.log('\n🎯 HSK Level Distribution:');
    console.log('===========================');
    Object.keys(importResult.metadata.summary.hskDistribution).forEach(level => {
      const count = importResult.metadata.summary.hskDistribution[level];
      const percentage = importResult.metadata.summary.hskPercentages[level];
      console.log(`• ${level.toUpperCase()}: ${count} words (${percentage}%)`);
    });
    
    // Display sample of processed data
    console.log('\n📝 Sample Processed Item:');
    console.log('=========================');
    const sampleItem = importResult.data[0];
    console.log(`Original: ${sampleItem.original.substring(0, 80)}...`);
    console.log(`Vietnamese: ${sampleItem.vietnamese.substring(0, 80)}...`);
    console.log(`Pinyin: ${sampleItem.pinyin.substring(0, 80)}...`);
    console.log(`Total Words: ${Object.values(sampleItem.words).flat().length}`);
    console.log(`HSK Levels Found: ${Object.keys(sampleItem.words).filter(level => sampleItem.words[level].length > 0).join(', ')}`);
    
    console.log('\n✅ Import.json processing completed successfully!');
    
  } catch (error) {
    console.error('❌ Error processing import.json:', error.message);
  }
}

testImportJson();
