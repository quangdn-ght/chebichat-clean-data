import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Merge results from all workers into a single file
 */
async function mergeResults() {
  console.log('🔄 Merging worker results...\n');

  const outputDir = path.join(__dirname, 'output');
  const files = await fs.readdir(outputDir);
  
  // Find all worker result files
  const workerFiles = files.filter(f => f.match(/^worker-\d+-results\.json$/));
  
  if (workerFiles.length === 0) {
    console.log('⚠️  No worker result files found');
    return;
  }

  console.log(`📁 Found ${workerFiles.length} worker result files:`);
  workerFiles.forEach(f => console.log(`   - ${f}`));
  console.log('');

  // Load all results
  const allResults = [];
  let totalProcessed = 0;
  let totalSuccessful = 0;
  let totalFailed = 0;

  for (const file of workerFiles) {
    const filePath = path.join(outputDir, file);
    const content = await fs.readFile(filePath, 'utf-8');
    const workerResult = JSON.parse(content);
    
    console.log(`📊 Worker ${workerResult.workerId}:`);
    console.log(`   Total: ${workerResult.total}`);
    console.log(`   Successful: ${workerResult.successful}`);
    console.log(`   Failed: ${workerResult.failed}`);
    console.log(`   Success rate: ${((workerResult.successful / workerResult.total) * 100).toFixed(1)}%`);
    console.log('');

    allResults.push(...workerResult.items);
    totalProcessed += workerResult.processed;
    totalSuccessful += workerResult.successful;
    totalFailed += workerResult.failed;
  }

  // Create merged result
  const mergedResult = {
    merged_at: new Date().toISOString(),
    workers: workerFiles.length,
    summary: {
      total: totalProcessed,
      successful: totalSuccessful,
      failed: totalFailed,
      success_rate: ((totalSuccessful / totalProcessed) * 100).toFixed(2) + '%'
    },
    items: allResults
  };

  // Save merged result
  const mergedPath = path.join(outputDir, 'merged-results.json');
  await fs.writeFile(mergedPath, JSON.stringify(mergedResult, null, 2), 'utf-8');
  
  console.log('💾 Merged results saved to: merged-results.json\n');

  // Save errors separately if any
  const errors = allResults.filter(item => !item.success);
  if (errors.length > 0) {
    const errorsPath = path.join(outputDir, 'merged-errors.json');
    await fs.writeFile(errorsPath, JSON.stringify(errors, null, 2), 'utf-8');
    console.log(`⚠️  ${errors.length} errors saved to: merged-errors.json\n`);
  }

  // Print summary
  console.log('='.repeat(60));
  console.log('📊 FINAL SUMMARY');
  console.log('='.repeat(60));
  console.log(`Workers: ${workerFiles.length}`);
  console.log(`Total processed: ${totalProcessed}`);
  console.log(`Successful: ${totalSuccessful} ✅`);
  console.log(`Failed: ${totalFailed} ❌`);
  console.log(`Success rate: ${((totalSuccessful / totalProcessed) * 100).toFixed(1)}%`);
  console.log('='.repeat(60));
  console.log('');

  // Save summary
  const summaryPath = path.join(outputDir, 'processing-summary.json');
  await fs.writeFile(summaryPath, JSON.stringify(mergedResult.summary, null, 2), 'utf-8');
  console.log('✅ Summary saved to: processing-summary.json\n');
}

// Run merger
mergeResults().catch(error => {
  console.error('❌ Error merging results:', error.message);
  process.exit(1);
});
