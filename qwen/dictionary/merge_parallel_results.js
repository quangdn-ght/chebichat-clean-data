import fs from 'fs/promises';
import { readFileSync } from 'fs';

async function main() {
    try {
        console.log('=== MERGING PARALLEL PROCESSED RESULTS ===');
        
        // Read the successful parallel processed items
        const successfulFile = './missing-items-processed-parallel/successful_items_for_merge.json';
        
        let reprocessedItems;
        try {
            reprocessedItems = JSON.parse(await fs.readFile(successfulFile, 'utf8'));
        } catch (error) {
            console.error('Could not read successful items file. Run combine_parallel_results.js first.');
            process.exit(1);
        }
        
        console.log(`Found ${reprocessedItems.length} successfully reprocessed items`);
        
        // Group items by the process they should belong to
        const inputData = JSON.parse(readFileSync('./input/DICTIONARY.json', 'utf8'));
        const batchSize = 20;
        const totalBatches = Math.ceil(inputData.length / batchSize);
        const totalProcesses = 30;
        const batchesPerProcess = Math.ceil(totalBatches / totalProcesses);
        
        // Create a mapping from word to expected process
        const wordToProcessMap = {};
        
        for (let i = 0; i < inputData.length; i++) {
            const batchIndex = Math.floor(i / batchSize);
            const expectedProcessId = Math.floor(batchIndex / batchesPerProcess) + 1;
            if (expectedProcessId <= totalProcesses) {
                wordToProcessMap[inputData[i].word] = expectedProcessId;
            }
        }
        
        // Group reprocessed items by process
        const itemsByProcess = {};
        let unmappedItems = 0;
        
        for (const item of reprocessedItems) {
            const word = item.chinese || item.word;
            const processId = wordToProcessMap[word];
            
            if (processId) {
                if (!itemsByProcess[processId]) {
                    itemsByProcess[processId] = [];
                }
                itemsByProcess[processId].push(item);
            } else {
                unmappedItems++;
                console.warn(`Warning: Could not find process for word: ${word}`);
            }
        }
        
        if (unmappedItems > 0) {
            console.log(`Warning: ${unmappedItems} items could not be mapped to processes`);
        }
        
        console.log('\\n=== MERGING ITEMS INTO PROCESS FILES ===');
        
        // Create backup directory
        await fs.mkdir('./output-backup-parallel', { recursive: true });
        
        let totalMerged = 0;
        const mergeResults = {};
        
        for (const [processId, items] of Object.entries(itemsByProcess)) {
            const processFile = `./output/dict-processed-process-${processId}.json`;
            const backupFile = `./output-backup-parallel/dict-processed-process-${processId}-backup-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
            
            try {
                // Read existing process file
                const existingData = JSON.parse(await fs.readFile(processFile, 'utf8'));
                
                // Create backup
                await fs.writeFile(backupFile, JSON.stringify(existingData, null, 2), 'utf8');
                
                // Create a set of existing words to avoid duplicates
                const existingWords = new Set(existingData.map(item => item.chinese || item.word).filter(Boolean));
                
                // Filter out items that already exist
                const newItems = items.filter(item => {
                    const word = item.chinese || item.word;
                    return word && !existingWords.has(word);
                });
                
                // Merge new items
                const mergedData = [...existingData, ...newItems];
                
                // Write merged data back
                await fs.writeFile(processFile, JSON.stringify(mergedData, null, 2), 'utf8');
                
                mergeResults[processId] = {
                    originalCount: existingData.length,
                    newItemsAdded: newItems.length,
                    duplicatesSkipped: items.length - newItems.length,
                    finalCount: mergedData.length
                };
                
                console.log(`Process ${processId}: ${existingData.length} + ${newItems.length} = ${mergedData.length} items`);
                if (items.length - newItems.length > 0) {
                    console.log(`  (${items.length - newItems.length} duplicates skipped)`);
                }
                
                totalMerged += newItems.length;
                
            } catch (error) {
                console.error(`Error processing file for process ${processId}:`, error.message);
                mergeResults[processId] = { error: error.message };
            }
        }
        
        // Calculate final statistics
        console.log('\\n=== FINAL STATISTICS ===');
        let totalAfterMerge = 0;
        
        for (let processId = 1; processId <= totalProcesses; processId++) {
            const processFile = `./output/dict-processed-process-${processId}.json`;
            try {
                const processData = JSON.parse(await fs.readFile(processFile, 'utf8'));
                totalAfterMerge += processData.length;
            } catch (e) {
                console.log(`Process ${processId}: No file found`);
            }
        }
        
        console.log(`Items merged: ${totalMerged}`);
        console.log(`Total items after merge: ${totalAfterMerge}`);
        console.log(`Input total: 98053`);
        console.log(`Coverage: ${(totalAfterMerge / 98053 * 100).toFixed(1)}%`);
        
        if (totalAfterMerge >= 98053) {
            console.log('\\n🎉 SUCCESS: All items have been processed!');
        } else {
            console.log(`\\n⚠️  Gap remaining: ${98053 - totalAfterMerge} items`);
        }
        
        // Save detailed merge report
        const mergeReport = {
            timestamp: new Date().toISOString(),
            processingType: 'parallel',
            itemsMerged: totalMerged,
            totalItemsAfter: totalAfterMerge,
            inputTotal: 98053,
            coverage: (totalAfterMerge / 98053 * 100).toFixed(1),
            unmappedItems: unmappedItems,
            mergeResults: mergeResults,
            successfulItemsFile: successfulFile
        };
        
        await fs.writeFile('./parallel-merge-report.json', JSON.stringify(mergeReport, null, 2), 'utf8');
        console.log('\\nDetailed merge report saved to ./parallel-merge-report.json');
        
    } catch (error) {
        console.error('Error in main function:', error);
        process.exit(1);
    }
}

main();
