const { ChineseTextProcessor, HSKAnalyzer, PinyinGenerator, DataMerger } = require('./index');

/**
 * Test the Chinese Text Processor package
 */
async function runTests() {
  console.log('🧪 Running Chinese Text Processor Tests');
  console.log('=====================================\n');

  // Test 1: Text Processing
  console.log('📝 Test 1: Chinese Text Processing');
  const processor = new ChineseTextProcessor();
  const sampleText = "别人在熬夜的时候，你在睡觉";
  const words = processor.segmentText(sampleText);
  console.log(`Input: ${sampleText}`);
  console.log(`Words: ${words.join(', ')}`);
  console.log(`Stats:`, processor.getTextStatistics(sampleText));

  // Test 2: HSK Analysis
  console.log('\n🎯 Test 2: HSK Level Analysis');
  const hskAnalyzer = new HSKAnalyzer();
  const hskResult = hskAnalyzer.analyzeWords(words);
  console.log('HSK Analysis:', hskResult);
  console.log('Statistics:', hskAnalyzer.getStatistics(hskResult));

  // Test 3: Pinyin Generation
  console.log('\n🔤 Test 3: Pinyin Generation');
  const pinyinGenerator = new PinyinGenerator();
  const pinyin = pinyinGenerator.generatePinyin(sampleText);
  console.log(`Input: ${sampleText}`);
  console.log(`Pinyin: ${pinyin}`);

  // Test 4: Data Merger
  console.log('\n🔀 Test 4: Data Merger');
  const merger = new DataMerger();
  const testData = [
    {
      original: sampleText,
      vietnamese: "Trong lúc người khác thức khuya, bạn đi ngủ"
    }
  ];
  
  const result = await merger.processData(testData, './output/test_output.json');
  console.log('Merge Result:', {
    processed: result.metadata.successfulItems,
    totalWords: result.summary.totalWords,
    outputPath: result.outputPath
  });

  // Test 5: Process import.json
  console.log('\n📁 Test 5: Processing import.json with HSK levels and pinyin');
  const fs = require('fs').promises;
  
  try {
    // Read import.json
    const importData = JSON.parse(await fs.readFile('./import.json', 'utf8'));
    console.log(`Loaded ${importData.length} items from import.json`);
    
    // Process the data with HSK levels and pinyin
    const importResult = await merger.processData(importData, './output/import_processed.json');
    console.log('Import.json Processing Result:', {
      processed: importResult.metadata.successfulItems,
      totalWords: importResult.metadata.summary.totalWords,
      outputPath: importResult.outputPath,
      hskDistribution: Object.keys(importResult.metadata.summary.hskDistribution).map(level => ({
        level,
        count: importResult.metadata.summary.hskDistribution[level],
        percentage: importResult.metadata.summary.hskPercentages[level] + '%'
      }))
    });
    
    // Display sample of processed data
    console.log('\nSample processed item:');
    const sampleItem = importResult.data[0];
    console.log({
      original: sampleItem.original.substring(0, 50) + '...',
      vietnamese: sampleItem.vietnamese.substring(0, 50) + '...',
      pinyin: sampleItem.pinyin.substring(0, 50) + '...',
      totalWords: Object.values(sampleItem.words).flat().length,
      hskLevelsFound: Object.keys(sampleItem.words).filter(level => sampleItem.words[level].length > 0)
    });
    
    console.log('\n📋 Summary: import.json successfully processed with HSK levels and pinyin!');
    console.log(`   • ${importResult.metadata.successfulItems} items processed`);
    console.log(`   • ${importResult.metadata.summary.totalWords} Chinese words analyzed`);
    console.log(`   • Output saved to ${importResult.outputPath}`);
    
  } catch (error) {
    console.error('Error processing import.json:', error.message);
  }

  console.log('\n✅ All tests completed!');
}

// Run tests if this file is executed directly
if (require.main === module) {
  runTests().catch(console.error);
}

module.exports = runTests;
