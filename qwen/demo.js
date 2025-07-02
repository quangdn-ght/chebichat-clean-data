#!/usr/bin/env node

const { DataMerger } = require('./index');
const fs = require('fs').promises;
const path = require('path');

async function demonstrateWorkflow() {
  console.log('🚀 Chinese Text Processor - Complete Workflow Demonstration');
  console.log('===========================================================\n');

  try {
    const merger = new DataMerger();
    
    // Check available input files
    console.log('📂 Available input files:');
    const files = ['result.json', 'import.json'];
    for (const file of files) {
      try {
        const stats = await fs.stat(file);
        const data = JSON.parse(await fs.readFile(file, 'utf8'));
        console.log(`   ✅ ${file}: ${data.length} items (${(stats.size / 1024).toFixed(1)} KB)`);
      } catch (error) {
        console.log(`   ❌ ${file}: Not found`);
      }
    }

    // Process import.json if available
    console.log('\n🔄 Processing import.json...');
    const importData = JSON.parse(await fs.readFile('./import.json', 'utf8'));
    const result = await merger.processData(importData, './output/workflow_demo.json');
    
    console.log('\n📊 Processing Results:');
    console.log(`   • Processed: ${result.metadata.successfulItems}/${result.metadata.totalItems} items`);
    console.log(`   • Total words: ${result.metadata.summary.totalWords}`);
    console.log(`   • Output: ${result.outputPath}`);
    
    console.log('\n🎯 HSK Distribution:');
    Object.entries(result.metadata.summary.hskDistribution).forEach(([level, count]) => {
      const percentage = result.metadata.summary.hskPercentages[level];
      console.log(`   • ${level.toUpperCase()}: ${count} words (${percentage}%)`);
    });

    // Show sample item
    console.log('\n📝 Sample Processed Item:');
    const sample = result.data[0];
    console.log(`   Original: ${sample.original.substring(0, 60)}...`);
    console.log(`   Pinyin: ${sample.pinyin.substring(0, 60)}...`);
    console.log(`   Vietnamese: ${sample.vietnamese.substring(0, 60)}...`);
    console.log(`   HSK words found: ${Object.keys(sample.words).filter(k => sample.words[k].length > 0).join(', ')}`);

    console.log('\n✨ Output Features:');
    console.log('   ✓ Chinese text segmentation');
    console.log('   ✓ HSK level categorization');
    console.log('   ✓ Pinyin generation');
    console.log('   ✓ Statistical analysis');
    console.log('   ✓ Structured JSON format');

    console.log('\n🎉 Workflow completed successfully!');
    console.log('   📁 Check ./output/workflow_demo.json for the complete results');

  } catch (error) {
    console.error('❌ Error in workflow demonstration:', error.message);
    process.exit(1);
  }
}

// Run the demonstration
if (require.main === module) {
  demonstrateWorkflow();
}

module.exports = demonstrateWorkflow;
