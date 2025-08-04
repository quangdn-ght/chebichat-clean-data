import fs from 'fs/promises';
import { readFileSync } from 'fs';

async function main() {
    try {
        console.log('=== MERGING REPROCESSED MISSING ITEMS ===');
        
        // Read the reprocessed items
        const processedDir = './missing-items-processed';
        const files = await fs.readdir(processedDir);
        const processedFile = files.find(f => f.startsWith('all_missing_items_processed_'));
        
        if (!processedFile) {
            console.error('No processed file found. Please run reprocess_missing_items.js first.');
            process.exit(1);
        }
        
        const reprocessedItems = JSON.parse(await fs.readFile(`${processedDir}/${processedFile}`, 'utf8'));
        console.log(`Found ${reprocessedItems.length} reprocessed items`);
        
        // Filter out error items
        const validItems = reprocessedItems.filter(item => !item.error);
        const errorItems = reprocessedItems.filter(item => item.error);
        
        console.log(`Valid items: ${validItems.length}`);
        console.log(`Error items: ${errorItems.length}`);
        
        if (errorItems.length > 0) {
            console.log('\\nItems with errors (will not be merged):');
            errorItems.slice(0, 10).forEach(item => {
                console.log(`  - ${item.chinese || item.word}: ${item.error}`);
            });
            if (errorItems.length > 10) {
                console.log(`  ... and ${errorItems.length - 10} more`);
            }
        }
        
        // Group valid items by the process they should belong to
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
        for (const item of validItems) {
            const word = item.chinese || item.word;
            const processId = wordToProcessMap[word];
            
            if (processId) {
                if (!itemsByProcess[processId]) {
                    itemsByProcess[processId] = [];
                }
                itemsByProcess[processId].push(item);
            } else {
                console.warn(`Warning: Could not find process for word: ${word}`);
            }
        }
        
        console.log('\\n=== MERGING ITEMS INTO PROCESS FILES ===');
        
        // Create backup directory
        await fs.mkdir('./output-backup', { recursive: true });
        
        let totalMerged = 0;
        
        for (const [processId, items] of Object.entries(itemsByProcess)) {
            const processFile = `./output/dict-processed-process-${processId}.json`;
            const backupFile = `./output-backup/dict-processed-process-${processId}-backup-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
            
            try {
                // Read existing process file
                const existingData = JSON.parse(await fs.readFile(processFile, 'utf8'));
                
                // Create backup
                await fs.writeFile(backupFile, JSON.stringify(existingData, null, 2), 'utf8');
                console.log(`Backed up process ${processId} to ${backupFile}`);
                
                // Merge new items
                const mergedData = [...existingData, ...items];
                
                // Write merged data back
                await fs.writeFile(processFile, JSON.stringify(mergedData, null, 2), 'utf8');
                
                console.log(`Process ${processId}: merged ${items.length} items (${existingData.length} -> ${mergedData.length})`);
                totalMerged += items.length;
                
            } catch (error) {
                console.error(`Error processing file for process ${processId}:`, error.message);
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
                console.log(`Process ${processId}: ${processData.length} items`);
            } catch (e) {
                console.log(`Process ${processId}: No file found`);
            }
        }
        
        console.log(`\\nTotal items before merge: 83152`);
        console.log(`Items merged: ${totalMerged}`);
        console.log(`Total items after merge: ${totalAfterMerge}`);
        console.log(`Input total: 98053`);
        console.log(`Remaining gap: ${98053 - totalAfterMerge}`);
        
        if (totalAfterMerge >= 98053) {
            console.log('\\n🎉 SUCCESS: All items have been processed!');
        } else {
            console.log('\\n⚠️  Some items are still missing. You may need to investigate further.');
        }
        
        // Save merge report
        const mergeReport = {
            timestamp: new Date().toISOString(),
            totalItemsBefore: 83152,
            itemsMerged: totalMerged,
            totalItemsAfter: totalAfterMerge,
            inputTotal: 98053,
            remainingGap: 98053 - totalAfterMerge,
            processedFile: processedFile,
            itemsByProcess: Object.fromEntries(
                Object.entries(itemsByProcess).map(([processId, items]) => [processId, items.length])
            )
        };
        
        await fs.writeFile('./merge-report.json', JSON.stringify(mergeReport, null, 2), 'utf8');
        console.log('\\nMerge report saved to ./merge-report.json');
        
    } catch (error) {
        console.error('Error in main function:', error);
        process.exit(1);
    }
}

main();
