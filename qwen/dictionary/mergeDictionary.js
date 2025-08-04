import fs from "fs/promises";
import path from "path";

async function mergeProcessResults() {
    try {
        const outputDir = './output';
        const hanvietDictPath = './input/tudienhanviet.json';
        
        // Ensure output directory exists
        await fs.mkdir(outputDir, { recursive: true });
        
        const files = await fs.readdir(outputDir);
        
        // Find all JSON files with pattern "dict-processed-process-*.json"
        const jsonFiles = files.filter(file => 
            file.match(/^dict-processed-process-\d+\.json$/)
        );
        
        console.log(`🔍 Found ${jsonFiles.length} dict-processed-process-*.json files to merge`);
        
        if (jsonFiles.length === 0) {
            console.log('❌ No dict-processed-process-*.json files found to merge');
            return;
        }
        
        // Load Han-Viet dictionary
        console.log(`📂 Loading Han-Viet dictionary: ${hanvietDictPath}`);
        let hanvietDict = {};
        try {
            const hanvietData = await fs.readFile(hanvietDictPath, 'utf8');
            hanvietDict = JSON.parse(hanvietData);
            console.log(`✅ Loaded ${Object.keys(hanvietDict).length} entries from Han-Viet dictionary`);
        } catch (error) {
            console.warn(`⚠️  Warning: Could not load Han-Viet dictionary: ${error.message}`);
            console.log('📝 Proceeding without Han-Viet data...');
        }
        
        const uniqueResults = new Map(); // Use Map to ensure uniqueness by "chinese" key
        let totalItems = 0;
        let duplicatesFound = 0;
        let hanvietMatched = 0;
        
        // Read and merge all JSON files
        for (const file of jsonFiles.sort()) {
            const filePath = path.join(outputDir, file);
            try {
                console.log(`📄 Processing ${file}...`);
                const content = await fs.readFile(filePath, 'utf8');
                const data = JSON.parse(content);
                
                if (Array.isArray(data)) {
                    let fileItemCount = 0;
                    let fileDuplicateCount = 0;
                    let fileHanvietMatched = 0;
                    
                    for (const item of data) {
                        if (item && item.chinese) {
                            const chineseKey = item.chinese;
                            
                            if (uniqueResults.has(chineseKey)) {
                                duplicatesFound++;
                                fileDuplicateCount++;
                                console.log(`  🔄 Duplicate found: "${chineseKey}" (skipping)`);
                            } else {
                                // Merge with Han-Viet data
                                const hanviet = hanvietDict[chineseKey] || null;
                                if (hanviet) {
                                    hanvietMatched++;
                                    fileHanvietMatched++;
                                }
                                
                                const mergedItem = {
                                    chinese: item.chinese,
                                    pinyin: item.pinyin,
                                    hanviet: hanviet,
                                    type: item.type,
                                    meaning_vi: item.meaning_vi,
                                    meaning_en: item.meaning_en,
                                    example_cn: item.example_cn,
                                    example_vi: item.example_vi,
                                    example_en: item.example_en,
                                    grammar: item.grammar,
                                    hsk_level: item.hsk_level,
                                    meaning_cn: item.meaning_cn
                                };
                                
                                uniqueResults.set(chineseKey, mergedItem);
                                fileItemCount++;
                            }
                            totalItems++;
                        } else {
                            console.log(`  ⚠️  Warning: Item without 'chinese' key in ${file}`);
                        }
                    }
                    
                    console.log(`✅ Processed ${file}: ${fileItemCount} unique items, ${fileDuplicateCount} duplicates, ${fileHanvietMatched} Han-Viet matches`);
                } else {
                    console.log(`⚠️  Skipped ${file} - not an array`);
                }
            } catch (error) {
                console.error(`❌ Error reading ${file}:`, error.message);
            }
        }
        
        // Convert Map to Array
        const allResults = Array.from(uniqueResults.values());
        
        console.log(`\n📊 MERGE SUMMARY:`);
        console.log(`   Total items processed: ${totalItems}`);
        console.log(`   Unique items: ${allResults.length}`);
        console.log(`   Duplicates removed: ${duplicatesFound}`);
        console.log(`   Han-Viet matches: ${hanvietMatched} (${(hanvietMatched/allResults.length*100).toFixed(1)}%)`);
        console.log(`   Unmatched: ${allResults.length - hanvietMatched} (${((allResults.length - hanvietMatched)/allResults.length*100).toFixed(1)}%)`);
        
        // Sort by Chinese characters for better organization
        allResults.sort((a, b) => {
            return a.chinese.localeCompare(b.chinese, 'zh-CN');
        });
        
        // Save merged results with Han-Viet data
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const finalOutputPath = path.join(outputDir, `dictionary-final-merged-${timestamp}.json`);
        
        await fs.writeFile(finalOutputPath, JSON.stringify(allResults, null, 2), 'utf8');
        
        console.log(`\n🎉 Successfully merged ${allResults.length} unique items with Han-Viet data to ${finalOutputPath}`);
        
        // Create detailed summary statistics
        const summary = {
            totalItemsProcessed: totalItems,
            uniqueItems: allResults.length,
            duplicatesRemoved: duplicatesFound,
            sourceFiles: jsonFiles.length,
            hanvietMatches: hanvietMatched,
            hanvietMatchPercentage: parseFloat((hanvietMatched/allResults.length*100).toFixed(1)),
            mergedAt: new Date().toISOString(),
            outputFile: finalOutputPath,
            sourceFilePattern: "dict-processed-process-*.json",
            hanvietDictionaryUsed: Object.keys(hanvietDict).length > 0,
            fileBreakdown: {}
        };
        
        // Count items per file type/process
        jsonFiles.forEach(file => {
            const processMatch = file.match(/dict-processed-process-(\d+)\.json/);
            const processId = processMatch ? processMatch[1] : 'unknown';
            if (!summary.fileBreakdown[`process_${processId}`]) {
                summary.fileBreakdown[`process_${processId}`] = 0;
            }
            summary.fileBreakdown[`process_${processId}`]++;
        });
        
        const summaryPath = path.join(outputDir, `merge-summary-final-${timestamp}.json`);
        await fs.writeFile(summaryPath, JSON.stringify(summary, null, 2), 'utf8');
        
        console.log(`📄 Summary saved to ${summaryPath}`);
        console.log('\n🎯 FINAL SUMMARY:');
        console.log(`   Source files: ${jsonFiles.length} (dict-processed-process-*.json)`);
        console.log(`   Total items processed: ${totalItems}`);
        console.log(`   Unique items: ${allResults.length}`);
        console.log(`   Duplicates removed: ${duplicatesFound}`);
        console.log(`   Han-Viet matches: ${hanvietMatched} (${(hanvietMatched/allResults.length*100).toFixed(1)}%)`);
        console.log(`   Final output file: ${finalOutputPath}`);
        console.log(`   Summary file: ${summaryPath}`);
        
    } catch (error) {
        console.error('❌ Error merging results:', error);
        process.exit(1);
    }
}

// Check if script is run directly
if (import.meta.url === `file://${process.argv[1]}`) {
    mergeProcessResults();
}

export default mergeProcessResults;