import fs from "fs/promises";
import path from "path";

async function mergeFinalTranslations() {
    try {
        console.log('=== MERGING FINAL TRANSLATIONS INTO COMPLETE DICTIONARY ===');
        
        // Read the current complete dictionary
        console.log('📖 Loading current complete dictionary...');
        const currentDict = JSON.parse(await fs.readFile('./output-final/complete-dictionary-perfect.json', 'utf8'));
        console.log(`Current dictionary: ${currentDict.length} items`);
        
        // Find the latest final translations file
        console.log('🔍 Finding latest final translations file...');
        const finalProcessedDir = './final-missing-processed';
        const files = await fs.readdir(finalProcessedDir);
        const completeFiles = files.filter(file => file.startsWith('final_missing_complete_') && file.endsWith('.json'));
        
        if (completeFiles.length === 0) {
            throw new Error('No final translations file found. Please run process_final_missing_items.js first.');
        }
        
        // Get the most recent file
        const latestFile = completeFiles.sort().pop();
        const finalTranslationsPath = path.join(finalProcessedDir, latestFile);
        
        console.log(`📁 Using translations file: ${latestFile}`);
        
        // Read the final translations
        const finalTranslations = JSON.parse(await fs.readFile(finalTranslationsPath, 'utf8'));
        console.log(`Final translations: ${finalTranslations.length} items`);
        
        // Create a lookup map for quick access
        const translationMap = new Map();
        finalTranslations.forEach(item => {
            const word = item.chinese || item.word;
            if (word) {
                translationMap.set(word, item);
            }
        });
        
        console.log(`Created translation lookup for ${translationMap.size} words`);
        
        // Merge translations into the dictionary
        console.log('🔄 Merging translations...');
        let updatedCount = 0;
        let alreadyTranslatedCount = 0;
        
        const updatedDict = currentDict.map(item => {
            const word = item.chinese || item.word;
            const existingTranslation = item.meaning_vi && item.meaning_vi.trim();
            
            if (!existingTranslation) {
                const newTranslation = translationMap.get(word);
                if (newTranslation) {
                    updatedCount++;
                    return {
                        ...item,
                        chinese: word,
                        pinyin: newTranslation.pinyin || item.pinyin || "unknown",
                        type: newTranslation.type || item.type || "unknown",
                        meaning_vi: newTranslation.meaning_vi || "Cần dịch thủ công",
                        meaning_en: newTranslation.meaning_en || "",
                        meaning_cn: newTranslation.meaning_cn || item.meaning || "",
                        example_cn: newTranslation.example_cn || "",
                        example_vi: newTranslation.example_vi || "",
                        example_en: newTranslation.example_en || "",
                        grammar: newTranslation.grammar || "",
                        hsk_level: newTranslation.hsk_level || item.hsk_level || null,
                        source: "final_missing_processing",
                        updated_at: new Date().toISOString()
                    };
                }
            } else {
                alreadyTranslatedCount++;
            }
            
            return item;
        });
        
        console.log(`✓ Updated ${updatedCount} items with new translations`);
        console.log(`✓ ${alreadyTranslatedCount} items already had translations`);
        
        // Verify the merge
        const finalStats = {
            totalItems: updatedDict.length,
            withVietnameseTranslations: 0,
            withoutVietnameseTranslations: 0,
            needManualReview: 0
        };
        
        updatedDict.forEach(item => {
            if (item.meaning_vi && item.meaning_vi.trim()) {
                if (item.meaning_vi === 'Cần dịch thủ công' || item.meaning_vi === 'Lỗi xử lý API') {
                    finalStats.needManualReview++;
                } else {
                    finalStats.withVietnameseTranslations++;
                }
            } else {
                finalStats.withoutVietnameseTranslations++;
            }
        });
        
        console.log('\\n📊 FINAL DICTIONARY STATISTICS:');
        console.log(`📝 Total items: ${finalStats.totalItems}`);
        console.log(`✅ With Vietnamese translations: ${finalStats.withVietnameseTranslations}`);
        console.log(`❌ Without translations: ${finalStats.withoutVietnameseTranslations}`);
        console.log(`⚠️  Need manual review: ${finalStats.needManualReview}`);
        
        const coveragePercent = (finalStats.withVietnameseTranslations / finalStats.totalItems * 100).toFixed(2);
        console.log(`📈 Coverage: ${coveragePercent}%`);
        
        // Create backup of current dictionary
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const backupPath = `./output-final/complete-dictionary-perfect-backup-${timestamp}.json`;
        
        console.log('💾 Creating backup...');
        await fs.copyFile('./output-final/complete-dictionary-perfect.json', backupPath);
        console.log(`Backup saved: ${backupPath}`);
        
        // Save the updated dictionary
        console.log('💾 Saving updated dictionary...');
        await fs.writeFile('./output-final/complete-dictionary-perfect.json', JSON.stringify(updatedDict, null, 2), 'utf8');
        
        // Create a summary report
        const report = {
            mergeTimestamp: new Date().toISOString(),
            sourceTranslationsFile: latestFile,
            sourceTranslationsCount: finalTranslations.length,
            itemsUpdated: updatedCount,
            finalStatistics: finalStats,
            coveragePercent: parseFloat(coveragePercent),
            backupFile: backupPath,
            nextSteps: finalStats.withoutVietnameseTranslations > 0 || finalStats.needManualReview > 0 ? 
                'Manual review needed for remaining items' : 
                'Dictionary is complete with 100% coverage!'
        };
        
        await fs.writeFile(`./final-missing-processed/merge-report-${timestamp}.json`, JSON.stringify(report, null, 2), 'utf8');
        
        console.log('\\n🎉 MERGE COMPLETED SUCCESSFULLY! 🎉');
        console.log(`📁 Updated dictionary: ./output-final/complete-dictionary-perfect.json`);
        console.log(`📊 Merge report: ./final-missing-processed/merge-report-${timestamp}.json`);
        
        if (finalStats.totalItems === 98053) {
            console.log('\\n✅ PERFECT! Dictionary has exactly 98,053 items as expected!');
        } else {
            console.log(`\\n⚠️  WARNING: Expected 98,053 items but got ${finalStats.totalItems}`);
        }
        
        if (coveragePercent >= 99.5) {
            console.log('🏆 EXCELLENT COVERAGE! Dictionary is ready for production use.');
        } else if (finalStats.needManualReview > 0) {
            console.log(`🔧 ${finalStats.needManualReview} items need manual review for optimal quality.`);
        }
        
    } catch (error) {
        console.error('❌ Error merging final translations:', error);
        console.error('Full error:', error.stack);
        process.exit(1);
    }
}

// Run the merge
mergeFinalTranslations();
