import fs from "fs/promises";
import path from "path";

async function mergeProcessResults() {
    try {
        const outputDir = './output';
        
        // Ensure output directory exists
        await fs.mkdir(outputDir, { recursive: true });
        
        const files = await fs.readdir(outputDir);
        
        // Find all JSON files in output directory (excluding merged files)
        const jsonFiles = files.filter(file => 
            file.endsWith('.json') && 
            !file.startsWith('dict-processed-merged-') &&
            !file.startsWith('merge-summary-')
        );
        
        console.log(`Found ${jsonFiles.length} JSON files to merge`);
        
        if (jsonFiles.length === 0) {
            console.log('No JSON files found to merge');
            return;
        }
        
        const uniqueResults = new Map(); // Use Map to ensure uniqueness by "chinese" key
        let totalItems = 0;
        let duplicatesFound = 0;
        
        // Read and merge all JSON files
        for (const file of jsonFiles.sort()) {
            const filePath = path.join(outputDir, file);
            try {
                const content = await fs.readFile(filePath, 'utf8');
                const data = JSON.parse(content);
                
                if (Array.isArray(data)) {
                    let fileItemCount = 0;
                    let fileDuplicateCount = 0;
                    
                    for (const item of data) {
                        if (item && item.chinese) {
                            const chineseKey = item.chinese;
                            
                            if (uniqueResults.has(chineseKey)) {
                                duplicatesFound++;
                                fileDuplicateCount++;
                                console.log(`  Duplicate found: "${chineseKey}" (skipping)`);
                            } else {
                                uniqueResults.set(chineseKey, item);
                                fileItemCount++;
                            }
                            totalItems++;
                        } else {
                            console.log(`  Warning: Item without 'chinese' key in ${file}`);
                        }
                    }
                    
                    console.log(`✓ Processed ${file}: ${fileItemCount} unique items, ${fileDuplicateCount} duplicates`);
                } else {
                    console.log(`⚠ Skipped ${file} - not an array`);
                }
            } catch (error) {
                console.error(`✗ Error reading ${file}:`, error.message);
            }
        }
        
        // Convert Map to Array
        const allResults = Array.from(uniqueResults.values());
        
        console.log(`\nTotal items processed: ${totalItems}`);
        console.log(`Unique items: ${allResults.length}`);
        console.log(`Duplicates removed: ${duplicatesFound}`);
        
        // Sort by Chinese characters for better organization
        allResults.sort((a, b) => {
            return a.chinese.localeCompare(b.chinese, 'zh-CN');
        });
        
        // Save merged results
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const mergedPath = path.join(outputDir, `dictionary-merged-${timestamp}.json`);
        
        await fs.writeFile(mergedPath, JSON.stringify(allResults, null, 2), 'utf8');
        
        console.log(`\n✓ Successfully merged ${allResults.length} unique items to ${mergedPath}`);
        
        // Create summary statistics
        const summary = {
            totalItemsProcessed: totalItems,
            uniqueItems: allResults.length,
            duplicatesRemoved: duplicatesFound,
            sourceFiles: jsonFiles.length,
            mergedAt: new Date().toISOString(),
            outputFile: mergedPath,
            fileBreakdown: {}
        };
        
        // Count items per file type
        jsonFiles.forEach(file => {
            const processMatch = file.match(/dict_batch_\d+_of_\d+_process_(\d+)\.json/);
            const processId = processMatch ? processMatch[1] : 'unknown';
            if (!summary.fileBreakdown[`process_${processId}`]) {
                summary.fileBreakdown[`process_${processId}`] = 0;
            }
            summary.fileBreakdown[`process_${processId}`]++;
        });
        
        const summaryPath = path.join(outputDir, `merge-summary-${timestamp}.json`);
        await fs.writeFile(summaryPath, JSON.stringify(summary, null, 2), 'utf8');
        
        console.log(`✓ Summary saved to ${summaryPath}`);
        console.log('\nSummary:');
        console.log(`  Source files: ${jsonFiles.length}`);
        console.log(`  Total items processed: ${totalItems}`);
        console.log(`  Unique items: ${allResults.length}`);
        console.log(`  Duplicates removed: ${duplicatesFound}`);
        console.log(`  Output file: ${mergedPath}`);
        
    } catch (error) {
        console.error('Error merging results:', error);
        process.exit(1);
    }
}

// Check if script is run directly
if (import.meta.url === `file://${process.argv[1]}`) {
    mergeProcessResults();
}

export default mergeProcessResults;