const { DataMerger } = require('./index');

/**
 * Main application entry point
 * Demonstrates usage of the Chinese Text Processor package
 */
async function main() {
  console.log('🌟 Chinese Text Processor - Main Application');
  console.log('============================================\n');

  try {
    // Initialize the DataMerger with custom options
    const processor = new DataMerger({
      defaultCategory: 'life',
      defaultSource: '999 letters to yourself',
      includeStatistics: true
    });

    // Step 6: Process result.json (Chinese + Vietnamese) to extract HSK words and pinyin
    console.log('📝 Step 6: Processing Chinese text with Vietnamese translations...');
    const step6Result = await processor.processData('./result.json', './output/step6_hsk_analysis.json');
    
    console.log('\n📊 Step 6 Results:');
    console.log(`   ✅ Processed: ${step6Result.metadata.successfulItems} items`);
    console.log(`   ❌ Failed: ${step6Result.metadata.failedItems} items`);
    console.log(`   📚 Total words: ${step6Result.summary.totalWords}`);
    console.log(`   🎯 HSK 1-3: ${(parseFloat(step6Result.summary.hskPercentages.hsk1) + parseFloat(step6Result.summary.hskPercentages.hsk2) + parseFloat(step6Result.summary.hskPercentages.hsk3)).toFixed(1)}%`);
    console.log(`   🚀 HSK 4-6: ${(parseFloat(step6Result.summary.hskPercentages.hsk4) + parseFloat(step6Result.summary.hskPercentages.hsk5) + parseFloat(step6Result.summary.hskPercentages.hsk6)).toFixed(1)}%`);

    // Step 7: Merge with existing level.json if available
    console.log('\n🔀 Step 7: Merging with existing data (if available)...');
    try {
      const step7Result = await processor.mergeDatasets(
        './level.json',      // Base dataset
        './result.json',     // Data to merge
        './output/step7_final_merged.json'  // Output
      );
      
      console.log('\n📊 Step 7 Results:');
      console.log(`   ✅ Merged: ${step7Result.metadata.successfulItems} items`);
      console.log(`   💾 Output: ${step7Result.outputPath}`);
    } catch (error) {
      console.log('   ⚠️ Merge skipped (level.json not found or error):', error.message);
    }

    // Generate sample output for demonstration
    console.log('\n🎨 Generating sample output...');
    await generateSampleOutput(processor);

    console.log('\n🎉 Processing completed successfully!');
    console.log('📂 Check the ./output/ directory for results');

  } catch (error) {
    console.error('\n❌ Application error:', error.message);
    process.exit(1);
  }
}

/**
 * Generate sample output to demonstrate the expected format
 */
async function generateSampleOutput(processor) {
  const sampleInput = [
    {
      "original": "别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。你有很多想法，但脑袋热了就过了，别人却一件事坚持到底。你连一本书都要看很久，该工作的时候就刷起手机，肯定也不能早晨起来背单词，晚上加班到深夜。很多时候不是你平凡，碌碌无为，而是你没有别人付出得多。",
      "vietnamese": "Khi người khác đang thức khuya, bạn lại đi ngủ; khi người khác đã thức dậy, bạn vẫn cố gắng nán lại thêm vài phút. Bạn có rất nhiều ý tưởng, nhưng chỉ trong chốc lát nhiệt huyết qua đi, người khác lại kiên trì đến cùng với một việc. Bạn đọc một cuốn sách cũng mất rất nhiều thời gian, khi cần làm việc thì lại lướt điện thoại, chắc chắn cũng không thể dậy sớm để học từ vựng, hay làm thêm đến khuya. Đôi khi, không phải bạn tầm thường hay vô dụng, mà chỉ đơn giản là bạn không nỗ lực nhiều như người khác."
    }
  ];

  const result = await processor.processData(sampleInput, './output/sample_output.json');
  
  // Display the first processed item as an example
  if (result.metadata.successfulItems > 0) {
    const fs = require('fs');
    const sampleItem = JSON.parse(fs.readFileSync('./output/sample_output.json', 'utf8')).data[0];
    
    if (sampleItem) {
      console.log('\n📋 Sample Output Format:');
      console.log('```json');
      console.log(JSON.stringify({
        original: sampleItem.original,
        words: sampleItem.words,
        pinyin: sampleItem.pinyin,
        vietnamese: sampleItem.vietnamese,
        category: sampleItem.category,
        source: sampleItem.source
      }, null, 2));
      console.log('```');
    }
  }
}

// Run the application
if (require.main === module) {
  main();
}

module.exports = main;
