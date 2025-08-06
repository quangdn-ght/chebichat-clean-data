import fs from 'fs/promises';
import { readFileSync } from 'fs';

async function main() {
    try {
        console.log('=== DEDUPLICATING DICTIONARY ITEMS ===');
        
        const totalProcesses = 30;
        const allUniqueItems = new Map(); // word -> item (keep first occurrence)
        const duplicateStats = {
            totalItemsBefore: 0,
            duplicatesRemoved: 0,
            totalItemsAfter: 0,
            duplicatesByProcess: {}
        };
        
        console.log('Reading all process files and identifying duplicates...');
        
        // First pass: collect all items and identify duplicates
        for (let processId = 1; processId <= totalProcesses; processId++) {
            const processFile = `./output/dict-processed-process-${processId}.json`;
            
            try {
                const processData = JSON.parse(readFileSync(processFile, 'utf8'));
                duplicateStats.totalItemsBefore += processData.length;
                
                const uniqueItems = [];
                let duplicatesInThisProcess = 0;
                
                for (const item of processData) {
                    const word = item.chinese || item.word;
                    
                    if (word) {
                        if (!allUniqueItems.has(word)) {
                            // First occurrence - keep it
                            allUniqueItems.set(word, {
                                item: item,
                                originalProcess: processId
                            });
                            uniqueItems.push(item);
                        } else {
                            // Duplicate - skip it
                            duplicatesInThisProcess++;
                            duplicateStats.duplicatesRemoved++;
                        }
                    } else {
                        // Item without word/chinese field - keep it
                        uniqueItems.push(item);
                    }
                }
                
                duplicateStats.duplicatesByProcess[processId] = {
                    originalCount: processData.length,
                    uniqueCount: uniqueItems.length,
                    duplicatesRemoved: duplicatesInThisProcess
                };
                
                console.log(`Process ${processId}: ${processData.length} → ${uniqueItems.length} items (${duplicatesInThisProcess} duplicates removed)`);
                
            } catch (error) {
                console.log(`Process ${processId}: File not found or error reading`);
                duplicateStats.duplicatesByProcess[processId] = {
                    originalCount: 0,
                    uniqueCount: 0,
                    duplicatesRemoved: 0,
                    error: error.message
                };
            }
        }
        
        console.log('\\n=== DEDUPLICATION STATISTICS ===');
        console.log(`Total items before deduplication: ${duplicateStats.totalItemsBefore}`);
        console.log(`Total duplicates removed: ${duplicateStats.duplicatesRemoved}`);
        console.log(`Total unique items: ${allUniqueItems.size}`);
        
        // Create backup directory
        await fs.mkdir('./output-backup-dedup', { recursive: true });
        console.log('\\nCreating backups of original files...');
        
        // Second pass: write deduplicated files
        console.log('\\nWriting deduplicated files...');
        
        for (let processId = 1; processId <= totalProcesses; processId++) {
            const processFile = `./output/dict-processed-process-${processId}.json`;
            const backupFile = `./output-backup-dedup/dict-processed-process-${processId}-backup-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
            
            try {
                const originalData = readFileSync(processFile, 'utf8');
                const processData = JSON.parse(originalData);
                
                // Create backup
                await fs.writeFile(backupFile, originalData, 'utf8');
                
                // Create deduplicated version
                const uniqueItems = [];
                const seenWords = new Set();
                
                for (const item of processData) {
                    const word = item.chinese || item.word;
                    
                    if (word) {
                        if (!seenWords.has(word)) {
                            seenWords.add(word);
                            uniqueItems.push(item);
                        }
                        // Skip duplicates within this process
                    } else {
                        // Item without word - keep it
                        uniqueItems.push(item);
                    }
                }
                
                // Write deduplicated file
                await fs.writeFile(processFile, JSON.stringify(uniqueItems, null, 2), 'utf8');
                
                duplicateStats.totalItemsAfter += uniqueItems.length;
                
            } catch (error) {
                console.log(`Process ${processId}: Error processing file - ${error.message}`);
            }
        }
        
        // Final statistics
        console.log('\\n=== FINAL STATISTICS ===');
        console.log(`Total items before: ${duplicateStats.totalItemsBefore}`);
        console.log(`Total items after: ${duplicateStats.totalItemsAfter}`);
        console.log(`Duplicates removed: ${duplicateStats.duplicatesRemoved}`);
        console.log(`Expected input total: 98,053`);
        console.log(`Coverage: ${(duplicateStats.totalItemsAfter / 98053 * 100).toFixed(1)}%`);
        
        if (duplicateStats.totalItemsAfter === 98053) {
            console.log('\\n🎉 SUCCESS: Perfect match with input total!');
        } else if (duplicateStats.totalItemsAfter > 98053) {
            console.log(`\\n⚠️  Still ${duplicateStats.totalItemsAfter - 98053} items over expected total`);
        } else {
            console.log(`\\n⚠️  Still missing ${98053 - duplicateStats.totalItemsAfter} items`);
        }
        
        // Save deduplication report
        const report = {
            timestamp: new Date().toISOString(),
            ...duplicateStats,
            finalCoverage: (duplicateStats.totalItemsAfter / 98053 * 100).toFixed(1),
            expectedTotal: 98053
        };
        
        await fs.writeFile('./deduplication-report.json', JSON.stringify(report, null, 2), 'utf8');
        console.log('\\nDetailed report saved to ./deduplication-report.json');
        
        // If we still have the wrong count, suggest next steps
        if (duplicateStats.totalItemsAfter !== 98053) {
            console.log('\\n=== NEXT STEPS ===');
            if (duplicateStats.totalItemsAfter < 98053) {
                console.log('Some items are still missing. Consider:');
                console.log('1. Running identify_missing_items.js again');
                console.log('2. Reprocessing the remaining missing items');
            } else {
                console.log('There are still duplicates. Consider:');
                console.log('1. Manual review of duplicate-analysis.json');
                console.log('2. More aggressive deduplication strategies');
            }
        }
        
    } catch (error) {
        console.error('Error in deduplication:', error);
        process.exit(1);
    }
}

main();
