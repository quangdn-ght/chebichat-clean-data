import fs from "fs/promises";
import path from "path";

// Function to extract process ID from filename
function extractProcessId(filename) {
    const match = filename.match(/dict_batch_\d+_of_\d+_process_(\d+)\.json/);
    return match ? parseInt(match[1]) : null;
}

// Function to read and parse JSON file safely
async function readJsonFile(filePath) {
    try {
        const content = await fs.readFile(filePath, 'utf8');
        return JSON.parse(content);
    } catch (error) {
        console.warn(`⚠ Could not read ${filePath}: ${error.message}`);
        return null;
    }
}

// Function to normalize Chinese text for comparison
function normalizeChinese(text) {
    return text ? text.trim().toLowerCase() : '';
}

// Function to check if an item is valid dictionary data (not error)
function isValidDictionaryItem(item) {
    return item && 
           typeof item === 'object' && 
           item.chinese && 
           !item.error && 
           !item.errorMessage;
}

// Function to get all batch files for a specific process
async function getBatchFilesForProcess(processId) {
    try {
        const outputFiles = await fs.readdir('./output');
        const batchFiles = outputFiles.filter(file => 
            file.match(/^dict_batch_\d+_of_\d+_process_\d+\.json$/) &&
            extractProcessId(file) === processId
        );
        
        return batchFiles.sort((a, b) => {
            const aMatch = a.match(/dict_batch_(\d+)_of_\d+_process_\d+\.json/);
            const bMatch = b.match(/dict_batch_(\d+)_of_\d+_process_\d+\.json/);
            const aBatch = aMatch ? parseInt(aMatch[1]) : 0;
            const bBatch = bMatch ? parseInt(bMatch[1]) : 0;
            return aBatch - bBatch;
        });
    } catch (error) {
        console.error(`Error reading output directory: ${error.message}`);
        return [];
    }
}

// Function to merge data from batch files for a process
async function mergeProcessData(processId) {
    console.log(`\n🔄 Processing data for process ${processId}...`);
    
    const batchFiles = await getBatchFilesForProcess(processId);
    if (batchFiles.length === 0) {
        console.log(`  No batch files found for process ${processId}`);
        return;
    }
    
    console.log(`  Found ${batchFiles.length} batch files`);
    
    // Map to track unique Chinese words with their data
    const mergedData = new Map();
    let totalItems = 0;
    let validItems = 0;
    let errorFallbackUsed = 0;
    let duplicatesFound = 0;
    
    // Process each batch file
    for (const batchFile of batchFiles) {
        const batchPath = path.join('./output', batchFile);
        const errorBackupPath = batchPath.replace('.json', '.error-backup.json');
        
        // Read the current processed data
        const batchData = await readJsonFile(batchPath);
        let errorBackupData = null;
        
        // Check if error backup exists
        try {
            await fs.access(errorBackupPath);
            errorBackupData = await readJsonFile(errorBackupPath);
        } catch {
            // No error backup file, which is fine
        }
        
        if (!batchData) {
            console.warn(`    ⚠ Skipping ${batchFile} - could not read data`);
            continue;
        }
        
        // Handle both array and single object responses
        const items = Array.isArray(batchData) ? batchData : [batchData];
        
        for (const item of items) {
            if (!item || typeof item !== 'object') continue;
            
            totalItems++;
            
            // Skip metadata entries
            if (item._metadata) continue;
            
            const chinese = item.chinese;
            if (!chinese) continue;
            
            const normalizedChinese = normalizeChinese(chinese);
            
            // Check if this Chinese word already exists in our merged data
            if (mergedData.has(normalizedChinese)) {
                duplicatesFound++;
                const existing = mergedData.get(normalizedChinese);
                
                // If current item is valid and existing is error, or if we should use error fallback
                if (isValidDictionaryItem(item) && !isValidDictionaryItem(existing)) {
                    mergedData.set(normalizedChinese, item);
                    console.log(`    🔄 Updated ${chinese} with valid data`);
                } else if (!isValidDictionaryItem(item) && errorBackupData) {
                    // Try to find this word in error backup data
                    const backupItems = Array.isArray(errorBackupData) ? errorBackupData : [errorBackupData];
                    const fallbackItem = backupItems.find(backup => 
                        backup && backup.chinese && 
                        normalizeChinese(backup.chinese) === normalizedChinese
                    );
                    
                    if (fallbackItem && !isValidDictionaryItem(existing)) {
                        mergedData.set(normalizedChinese, fallbackItem);
                        errorFallbackUsed++;
                        console.log(`    📋 Used fallback data for ${chinese}`);
                    }
                }
                // If existing is valid, keep it
            } else {
                // New word, add it
                if (isValidDictionaryItem(item)) {
                    mergedData.set(normalizedChinese, item);
                    validItems++;
                } else if (errorBackupData) {
                    // Try to find valid data in error backup
                    const backupItems = Array.isArray(errorBackupData) ? errorBackupData : [errorBackupData];
                    const fallbackItem = backupItems.find(backup => 
                        backup && backup.chinese && 
                        normalizeChinese(backup.chinese) === normalizedChinese
                    );
                    
                    if (fallbackItem) {
                        mergedData.set(normalizedChinese, fallbackItem);
                        errorFallbackUsed++;
                        console.log(`    📋 Used fallback data for ${chinese}`);
                    } else {
                        // Add even invalid item if no fallback available
                        mergedData.set(normalizedChinese, item);
                    }
                } else {
                    // No backup, add the item as is
                    mergedData.set(normalizedChinese, item);
                }
            }
        }
    }
    
    // Convert map to array
    const finalData = Array.from(mergedData.values());
    
    // Sort by Chinese characters for consistency
    finalData.sort((a, b) => {
        const aChines = a.chinese || '';
        const bChinese = b.chinese || '';
        return aChines.localeCompare(bChinese);
    });
    
    // Add metadata
    const metadata = {
        processId: processId,
        totalBatchFiles: batchFiles.length,
        totalItems: totalItems,
        validItems: validItems,
        duplicatesFound: duplicatesFound,
        errorFallbackUsed: errorFallbackUsed,
        finalUniqueWords: finalData.length,
        timestamp: new Date().toISOString(),
        generatedBy: 'mergeReprocessedData.js'
    };
    
    finalData._metadata = metadata;
    
    // Save merged data
    const outputFileName = `dict-processed-process-${processId}.json`;
    const outputPath = path.join('./output', outputFileName);
    
    try {
        await fs.writeFile(outputPath, JSON.stringify(finalData, null, 2), 'utf8');
        console.log(`  ✅ Saved ${finalData.length} unique words to ${outputFileName}`);
        console.log(`     📊 Stats: ${validItems} valid, ${duplicatesFound} duplicates, ${errorFallbackUsed} fallback used`);
    } catch (error) {
        console.error(`  ❌ Error saving ${outputFileName}: ${error.message}`);
    }
}

// Function to get all unique process IDs from batch files
async function getAllProcessIds() {
    try {
        const outputFiles = await fs.readdir('./output');
        const processIds = new Set();
        
        for (const file of outputFiles) {
            if (file.match(/^dict_batch_\d+_of_\d+_process_\d+\.json$/)) {
                const processId = extractProcessId(file);
                if (processId !== null) {
                    processIds.add(processId);
                }
            }
        }
        
        return Array.from(processIds).sort((a, b) => a - b);
    } catch (error) {
        console.error(`Error reading output directory: ${error.message}`);
        return [];
    }
}

// Function to create a final merged file from all processes
async function createFinalMergedFile() {
    console.log(`\n🔄 Creating final merged file from all processes...`);
    
    const processIds = await getAllProcessIds();
    if (processIds.length === 0) {
        console.log(`  No process files found`);
        return;
    }
    
    const allData = new Map();
    let totalProcessed = 0;
    let totalDuplicatesAcrossProcesses = 0;
    
    for (const processId of processIds) {
        const processFileName = `dict-processed-process-${processId}.json`;
        const processFilePath = path.join('./output', processFileName);
        
        const processData = await readJsonFile(processFilePath);
        if (!processData || !Array.isArray(processData)) {
            console.warn(`  ⚠ Skipping ${processFileName} - invalid data format`);
            continue;
        }
        
        console.log(`  📂 Processing ${processFileName} (${processData.length} items)...`);
        
        for (const item of processData) {
            if (!item || typeof item !== 'object' || item._metadata) continue;
            
            const chinese = item.chinese;
            if (!chinese) continue;
            
            const normalizedChinese = normalizeChinese(chinese);
            
            if (allData.has(normalizedChinese)) {
                totalDuplicatesAcrossProcesses++;
                // Keep the first valid item, or replace if current is better
                const existing = allData.get(normalizedChinese);
                if (isValidDictionaryItem(item) && !isValidDictionaryItem(existing)) {
                    allData.set(normalizedChinese, item);
                }
            } else {
                allData.set(normalizedChinese, item);
                totalProcessed++;
            }
        }
    }
    
    const finalMergedData = Array.from(allData.values());
    finalMergedData.sort((a, b) => {
        const aChines = a.chinese || '';
        const bChinese = b.chinese || '';
        return aChines.localeCompare(bChinese);
    });
    
    // Add final metadata
    finalMergedData._metadata = {
        totalProcesses: processIds.length,
        totalUniqueWords: finalMergedData.length,
        duplicatesAcrossProcesses: totalDuplicatesAcrossProcesses,
        timestamp: new Date().toISOString(),
        generatedBy: 'mergeReprocessedData.js - final merge'
    };
    
    // Save final merged file
    const finalFileName = `dictionary-final-merged-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
    const finalPath = path.join('./output', finalFileName);
    
    try {
        await fs.writeFile(finalPath, JSON.stringify(finalMergedData, null, 2), 'utf8');
        console.log(`  ✅ Final merged file saved: ${finalFileName}`);
        console.log(`     📊 Total unique words: ${finalMergedData.length}`);
        console.log(`     🔄 Cross-process duplicates resolved: ${totalDuplicatesAcrossProcesses}`);
    } catch (error) {
        console.error(`  ❌ Error saving final merged file: ${error.message}`);
    }
}

// Main function
async function main() {
    try {
        console.log('🚀 Starting merge of reprocessed dictionary data...');
        
        // Ensure output directory exists
        await fs.mkdir('./output', { recursive: true });
        
        // Get all process IDs
        const processIds = await getAllProcessIds();
        
        if (processIds.length === 0) {
            console.log('❌ No batch files found in output directory');
            return;
        }
        
        console.log(`📋 Found data for ${processIds.length} processes: ${processIds.join(', ')}`);
        
        // Parse command line arguments
        const args = process.argv.slice(2);
        let targetProcessId = null;
        let skipFinalMerge = false;
        
        for (const arg of args) {
            if (arg.startsWith('--process-id=')) {
                targetProcessId = parseInt(arg.split('=')[1]);
            } else if (arg === '--skip-final-merge') {
                skipFinalMerge = true;
            }
        }
        
        if (targetProcessId !== null) {
            // Process only specific process ID
            if (processIds.includes(targetProcessId)) {
                await mergeProcessData(targetProcessId);
            } else {
                console.log(`❌ Process ID ${targetProcessId} not found. Available: ${processIds.join(', ')}`);
            }
        } else {
            // Process all process IDs
            for (const processId of processIds) {
                await mergeProcessData(processId);
            }
        }
        
        // Create final merged file unless skipped
        if (!skipFinalMerge) {
            await createFinalMergedFile();
        }
        
        console.log('\n✅ Merge process completed successfully!');
        
    } catch (error) {
        console.error('❌ Error in main function:', error);
        process.exit(1);
    }
}

// Run the script
main();
