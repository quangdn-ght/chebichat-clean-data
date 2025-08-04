import fs from 'fs/promises';
import path from 'path';

// Get input file from command line arguments
const args = process.argv.slice(2);
if (args.length === 0) {
    console.error('Usage: node hanviet.js <input-json-file>');
    console.error('Example: node hanviet.js input.json');
    process.exit(1);
}

const inputFile = args[0];
const hanvietDictPath = './input/tudienhanviet.json';
const outputFile = inputFile.replace('.json', '_with_hanviet.json');

async function mergeHanVietData() {
    try {
        console.log('🚀 Starting Han-Viet merger...');
        
        // Load input JSON file
        console.log(`📂 Loading input file: ${inputFile}`);
        const inputData = JSON.parse(await fs.readFile(inputFile, 'utf8'));
        console.log(`✅ Loaded ${inputData.length} entries from input file`);
        
        // Load Han-Viet dictionary
        console.log(`📂 Loading Han-Viet dictionary: ${hanvietDictPath}`);
        const hanvietDict = JSON.parse(await fs.readFile(hanvietDictPath, 'utf8'));
        console.log(`✅ Loaded ${Object.keys(hanvietDict).length} entries from Han-Viet dictionary`);
        
        // Merge data
        console.log('🔄 Merging data...');
        let matchedCount = 0;
        let unmatchedCount = 0;
        
        const mergedData = inputData.map((entry, index) => {
            const chinese = entry.chinese;
            const hanviet = hanvietDict[chinese] || null;
            
            if (hanviet) {
                matchedCount++;
            } else {
                unmatchedCount++;
            }
            
            // Progress indicator
            if ((index + 1) % 10000 === 0) {
                console.log(`   Processed ${index + 1}/${inputData.length} entries...`);
            }
            
            return {
                chinese: entry.chinese,
                pinyin: entry.pinyin,
                hanviet: hanviet,
                type: entry.type,
                meaning_vi: entry.meaning_vi,
                meaning_en: entry.meaning_en,
                example_cn: entry.example_cn,
                example_vi: entry.example_vi,
                example_en: entry.example_en,
                grammar: entry.grammar,
                hsk_level: entry.hsk_level,
                meaning_cn: entry.meaning_cn
            };
        });
        
        // Save merged data
        console.log(`💾 Saving merged data to: ${outputFile}`);
        await fs.writeFile(outputFile, JSON.stringify(mergedData, null, 2), 'utf8');
        
        // Summary
        console.log('✅ Merge completed successfully!');
        console.log('📊 Summary:');
        console.log(`   Total entries: ${inputData.length}`);
        console.log(`   Matched Han-Viet: ${matchedCount} (${(matchedCount/inputData.length*100).toFixed(1)}%)`);
        console.log(`   Unmatched: ${unmatchedCount} (${(unmatchedCount/inputData.length*100).toFixed(1)}%)`);
        console.log(`   Output file: ${outputFile}`);
        
    } catch (error) {
        console.error('❌ Error during merge:', error.message);
        
        if (error.code === 'ENOENT') {
            if (error.path === inputFile) {
                console.error(`   Input file not found: ${inputFile}`);
            } else if (error.path === hanvietDictPath) {
                console.error(`   Han-Viet dictionary not found: ${hanvietDictPath}`);
            }
        } else if (error instanceof SyntaxError) {
            console.error('   Invalid JSON format in one of the files');
        }
        
        process.exit(1);
    }
}

// Run the merger
mergeHanVietData();
