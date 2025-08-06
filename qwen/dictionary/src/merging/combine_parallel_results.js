import fs from 'fs/promises';

async function main() {
    try {
        console.log('=== COMBINING PARALLEL PROCESSED RESULTS ===');
        
        const resultsDir = './missing-items-processed-parallel';
        
        // Find all chunk result files
        const files = await fs.readdir(resultsDir);
        const chunkFiles = files.filter(f => f.startsWith('chunk_') && f.endsWith('_results.json')).sort();
        
        console.log(`Found ${chunkFiles.length} chunk result files`);
        
        const allResults = [];
        let totalSuccessful = 0;
        let totalErrors = 0;
        
        // Combine all chunk results
        for (const file of chunkFiles) {
            const chunkResults = JSON.parse(await fs.readFile(`${resultsDir}/${file}`, 'utf8'));
            
            const successfulItems = chunkResults.filter(item => !item.error);
            const errorItems = chunkResults.filter(item => item.error);
            
            allResults.push(...chunkResults);
            totalSuccessful += successfulItems.length;
            totalErrors += errorItems.length;
            
            console.log(`${file}: ${successfulItems.length} successful, ${errorItems.length} errors`);
        }
        
        // Save combined results
        const combinedFile = './missing-items-processed-parallel/all_parallel_results.json';
        await fs.writeFile(combinedFile, JSON.stringify(allResults, null, 2), 'utf8');
        
        // Save only successful items for merging
        const successfulItems = allResults.filter(item => !item.error);
        const successfulFile = './missing-items-processed-parallel/successful_items_for_merge.json';
        await fs.writeFile(successfulFile, JSON.stringify(successfulItems, null, 2), 'utf8');
        
        console.log('\\n=== PARALLEL PROCESSING SUMMARY ===');
        console.log(`Total items processed: ${allResults.length}`);
        console.log(`Successful items: ${totalSuccessful}`);
        console.log(`Error items: ${totalErrors}`);
        console.log(`Success rate: ${(totalSuccessful / allResults.length * 100).toFixed(1)}%`);
        console.log(`\\nCombined results saved to: ${combinedFile}`);
        console.log(`Successful items for merge: ${successfulFile}`);
        
        // Create summary for next steps
        const summary = {
            timestamp: new Date().toISOString(),
            totalProcessed: allResults.length,
            successful: totalSuccessful,
            errors: totalErrors,
            successRate: (totalSuccessful / allResults.length * 100).toFixed(1),
            combinedFile: combinedFile,
            successfulFile: successfulFile,
            nextStep: 'Run merge_parallel_results.js to merge successful items back into process files'
        };
        
        await fs.writeFile('./missing-items-processed-parallel/processing_summary.json', JSON.stringify(summary, null, 2), 'utf8');
        
        console.log('\\n✓ Ready for merging. Run: node merge_parallel_results.js');
        
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

main();
