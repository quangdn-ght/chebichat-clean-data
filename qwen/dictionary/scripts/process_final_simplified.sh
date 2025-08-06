#!/bin/bash

# Simplified Final Missing Translations Processor
# Uses the existing working reprocessing framework

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== SIMPLIFIED FINAL TRANSLATIONS PROCESSOR ===${NC}"
echo "Target: 100% coverage (98,053 items with Vietnamese translations)"
echo ""

# Check current coverage
echo -e "${YELLOW}📊 Checking current coverage...${NC}"
CURRENT_COVERAGE=$(node -e "
const data = JSON.parse(require('fs').readFileSync('./output-final/complete-dictionary-perfect.json', 'utf8'));
const withVi = data.filter(item => item.meaning_vi && item.meaning_vi.trim()).length;
console.log(withVi);
")

MISSING_COUNT=$((98053 - CURRENT_COVERAGE))
echo "Current Vietnamese translations: $CURRENT_COVERAGE"
echo "Missing translations: $MISSING_COUNT"

if [ "$MISSING_COUNT" -eq 0 ]; then
    echo -e "${GREEN}🎉 Already at 100% coverage!${NC}"
    exit 0
fi

echo -e "${YELLOW}🔄 Step 1: Preparing missing items for reprocessing...${NC}"

# Create missing items directory if it doesn't exist
mkdir -p ./missing-items-final

# Convert missing word list to reprocessing format
node -e "
const fs = require('fs');

// Load missing words
const missingWords = JSON.parse(fs.readFileSync('./output-final/still-missing-translations.json', 'utf8'));
console.log('Missing words:', missingWords.length);

// Load original dictionary for meanings
const originalDict = JSON.parse(fs.readFileSync('./input/DICTIONARY.json', 'utf8'));
const originalMap = new Map(originalDict.map(item => [item.word, item]));

// Create items in format expected by existing reprocessing script
const missingItems = missingWords.map(word => {
    const original = originalMap.get(word);
    return {
        word: word,
        meaning: original ? original.meaning : 'No meaning available'
    };
});

// Save in the expected location for reprocessing
fs.writeFileSync('./missing-items-final/all-missing-items.json', JSON.stringify(missingItems, null, 2));
console.log('Prepared', missingItems.length, 'items for reprocessing');
console.log('Saved to: ./missing-items-final/all-missing-items.json');
"

echo -e "${GREEN}✓ Missing items prepared${NC}"

echo -e "${YELLOW}🔄 Step 2: Running reprocessing with existing script...${NC}"

# Temporarily copy the missing items to the expected location
cp ./missing-items-final/all-missing-items.json ./missing-items/all-missing-items.json

# Use the existing reprocessing script but with modified output directory
echo "Starting reprocessing with existing framework..."

# Create a modified version of the reprocessing script for final items
cat > ./reprocess_final_missing.js << 'EOFJS'
import OpenAI from "openai";
import fs from "fs/promises";
import dotenv from "dotenv";

dotenv.config();

const config = {
    apiKey: process.env.DASHSCOPE_API_KEY,
    batchSize: 6, // Small batches for reliability
    batchDelay: 2500
};

if (!config.apiKey) {
    console.error('Error: DASHSCOPE_API_KEY environment variable is not set');
    process.exit(1);
}

const openai = new OpenAI({
    apiKey: config.apiKey,
    baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

function chunkArray(array, chunkSize) {
    const chunks = [];
    for (let i = 0; i < array.length; i += chunkSize) {
        chunks.push(array.slice(i, i + chunkSize));
    }
    return chunks;
}

function extractJsonFromResponse(responseContent) {
    const jsonBlockMatch = responseContent.match(/```json\s*([\s\S]*?)\s*```/);
    if (jsonBlockMatch) {
        return jsonBlockMatch[1].trim();
    }
    
    const codeBlockMatch = responseContent.match(/```\s*([\s\S]*?)\s*```/);
    if (codeBlockMatch) {
        return codeBlockMatch[1].trim();
    }
    
    return responseContent.trim();
}

function attemptJsonRepair(jsonString) {
    try {
        return JSON.parse(jsonString);
    } catch (error) {
        let repairedJson = jsonString.trim();
        
        if (repairedJson.startsWith('[') && !repairedJson.endsWith(']')) {
            let openBraces = 0;
            let lastCompleteObject = -1;
            
            for (let i = 0; i < repairedJson.length; i++) {
                if (repairedJson[i] === '{') {
                    openBraces++;
                } else if (repairedJson[i] === '}') {
                    openBraces--;
                    if (openBraces === 0) {
                        lastCompleteObject = i;
                    }
                }
            }
            
            if (lastCompleteObject > -1) {
                repairedJson = repairedJson.substring(0, lastCompleteObject + 1) + ']';
                try {
                    return JSON.parse(repairedJson);
                } catch (e) {}
            }
        }
        
        console.warn('Could not repair JSON, returning empty array');
        return [];
    }
}

async function processBatchWithRetry(batch, batchIndex, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`Processing final batch ${batchIndex + 1} with ${batch.length} items (attempt ${attempt}/${maxRetries})...`);
            
            const wordsToProcess = batch.map(item => item.word);
            
            const completion = await openai.chat.completions.create({
                model: "qwen-max",
                messages: [
                    {"role":"system","content":"Bạn là một chuyên gia dịch thuật từ điển tiếng Trung – tiếng Việt, có kinh nghiệm dạy học sinh Việt Nam. Mục tiêu là giúp học sinh hiểu và ghi nhớ từ vựng tiếng Trung dễ dàng, thông qua:\\n\\nDịch nghĩa ví dụ sang tiếng Việt (chính) và tiếng anh (phụ).\\n\\nGiải nghĩa từ đơn giản, dễ hiểu.\\n\\nCung cấp ví dụ cụ thể bằng tiếng Trung và dịch nghĩa.\\n\\nGiải thích ngữ pháp nếu từ đó có đặc điểm ngữ pháp đặc biệt (từ loại, cách dùng, vị trí trong câu...). Xuất kết quả theo dạng JSON array, mỗi phần tử là một object cho một từ. QUAN TRỌNG: Luôn trả về JSON array hoàn chỉnh và hợp lệ.\\n\\nVí dụ Output mẫu:\\n[\\n  {\\n    \"chinese\": \"爱护\",\\n    \"pinyin\": \"ài hù\",\\n    \"type\": \"động từ\",\\n    \"meaning_vi\": \"Yêu thương và bảo vệ, chăm sóc một cách cẩn thận (con người, động vật, tài sản...)\",\\n    \"meaning_en\": \"To cherish and protect carefully (people, animals, property, etc.).\",\\n    \"example_cn\": \"我们要爱护环境。\",\\n    \"example_vi\": \"Chúng ta cần phải bảo vệ môi trường.\",\\n    \"example_en\": \"We need to protect the environment.\",\\n    \"grammar\": \"Là động từ hai âm tiết, thường đi kèm với đối tượng cụ thể phía sau. Ví dụ: 爱护公物 (bảo vệ tài sản công cộng), 爱护孩子 (yêu thương trẻ em).\",\\n    \"hsk_level\": 6\\n  }\\n]"},
                    {
                        "role": "user",
                        "content": JSON.stringify(wordsToProcess)
                    }
                ],
                top_p: 0.8,
                temperature: 0.7,
                max_tokens: 4000,
                timeout: 60000
            });

            const responseContent = completion.choices[0].message.content;
            
            try {
                const jsonResponse = extractJsonFromResponse(responseContent);
                const parsedResponse = attemptJsonRepair(jsonResponse);
                
                if (!Array.isArray(parsedResponse)) {
                    throw new Error("Response is not an array");
                }
                
                if (parsedResponse.length === 0 && wordsToProcess.length > 0) {
                    throw new Error("Got empty array for non-empty input");
                }
                
                console.log(`✓ Successfully parsed JSON response for batch ${batchIndex + 1} (${parsedResponse.length} items)`);
                
                // Add original meaning
                const enhancedResponse = parsedResponse.map((item, index) => {
                    if (batch[index] && batch[index].meaning) {
                        return {
                            ...item,
                            meaning_cn: batch[index].meaning
                        };
                    }
                    return item;
                });
                
                return enhancedResponse;
                
            } catch (parseError) {
                console.error(`✗ Failed to parse JSON response for batch ${batchIndex + 1} (attempt ${attempt}):`, parseError.message);
                
                if (attempt === maxRetries) {
                    console.log(`Generating fallback responses for batch ${batchIndex + 1}...`);
                    return batch.map(item => ({
                        chinese: item.word,
                        pinyin: "unknown",
                        type: "unknown",
                        meaning_vi: "Cần dịch thủ công",
                        meaning_en: "Manual translation needed",
                        meaning_cn: item.meaning,
                        note: "API translation failed"
                    }));
                }
                
                await new Promise(resolve => setTimeout(resolve, attempt * 2000));
                continue;
            }
            
        } catch (error) {
            console.error(`✗ Error processing batch ${batchIndex + 1} (attempt ${attempt}):`, error.message);
            
            if (attempt === maxRetries) {
                return batch.map(item => ({
                    chinese: item.word,
                    pinyin: "unknown", 
                    type: "unknown",
                    meaning_vi: "Cần dịch thủ công",
                    meaning_en: "Manual translation needed",
                    meaning_cn: item.meaning,
                    error: error.message
                }));
            }
            
            await new Promise(resolve => setTimeout(resolve, attempt * 2000));
        }
    }
}

async function main() {
    try {
        console.log('=== FINAL MISSING ITEMS REPROCESSING ===');
        
        await fs.mkdir('./final-missing-processed', { recursive: true });
        
        const missingItems = JSON.parse(await fs.readFile('./missing-items/all-missing-items.json', 'utf8'));
        console.log(`Total final missing items: ${missingItems.length}`);
        
        const batches = chunkArray(missingItems, config.batchSize);
        console.log(`Split into ${batches.length} batches`);
        
        const allResults = [];
        
        for (let i = 0; i < batches.length; i++) {
            console.log(`\\nProgress: ${i + 1}/${batches.length} batches (${Math.round((i + 1)/batches.length*100)}%)`);
            
            const batchResult = await processBatchWithRetry(batches[i], i);
            allResults.push(...batchResult);
            
            // Save intermediate results
            const intermediateFilename = `./final-missing-processed/final_batch_${i + 1}_of_${batches.length}.json`;
            await fs.writeFile(intermediateFilename, JSON.stringify(batchResult, null, 2), 'utf8');
            
            if (i < batches.length - 1) {
                console.log(`Waiting ${config.batchDelay}ms before next batch...`);
                await new Promise(resolve => setTimeout(resolve, config.batchDelay));
            }
        }
        
        // Save complete results
        const completeFilename = './final-missing-processed/final-missing-complete.json';
        await fs.writeFile(completeFilename, JSON.stringify(allResults, null, 2), 'utf8');
        
        console.log(`\\n=== FINAL REPROCESSING COMPLETED ===`);
        console.log(`Total items processed: ${allResults.length}`);
        console.log(`Results saved to: ${completeFilename}`);
        
        const successfulItems = allResults.filter(item => !item.error && item.meaning_vi && item.meaning_vi !== 'Cần dịch thủ công');
        console.log(`Successful translations: ${successfulItems.length}`);
        console.log(`Items needing manual review: ${allResults.length - successfulItems.length}`);
        
    } catch (error) {
        console.error('Error in main function:', error);
        process.exit(1);
    }
}

main();
EOFJS

echo "Running final missing items reprocessing..."
node reprocess_final_missing.js

echo -e "${GREEN}✓ Final reprocessing completed${NC}"

echo -e "${YELLOW}🔄 Step 3: Merging results into final dictionary...${NC}"

# Merge the final translations
node -e "
const fs = require('fs');

console.log('Loading current dictionary...');
const currentDict = JSON.parse(fs.readFileSync('./output-final/complete-dictionary-perfect.json', 'utf8'));

console.log('Loading final translations...');
const finalTranslations = JSON.parse(fs.readFileSync('./final-missing-processed/final-missing-complete.json', 'utf8'));

// Create translation lookup
const translationMap = new Map();
finalTranslations.forEach(item => {
    translationMap.set(item.chinese, item);
});

console.log('Merging final translations...');
let updatedCount = 0;
const updatedDict = currentDict.map(item => {
    const word = item.chinese || item.word;
    const translation = translationMap.get(word);
    
    if (translation && (!item.meaning_vi || !item.meaning_vi.trim())) {
        updatedCount++;
        return {
            ...item,
            ...translation,
            chinese: word
        };
    }
    return item;
});

console.log('Items updated with new translations:', updatedCount);

// Final verification
const finalWithTranslations = updatedDict.filter(item => 
    item.meaning_vi && item.meaning_vi.trim() && item.meaning_vi !== 'Cần dịch thủ công'
).length;

console.log('Final statistics:');
console.log('  Total items:', updatedDict.length);
console.log('  Items with Vietnamese translations:', finalWithTranslations);
console.log('  Coverage:', (finalWithTranslations/updatedDict.length*100).toFixed(2) + '%');

// Create backup
const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
const backupFile = './output-final/complete-dictionary-perfect-backup-' + timestamp + '.json';
fs.writeFileSync(backupFile, fs.readFileSync('./output-final/complete-dictionary-perfect.json'));

// Save updated dictionary
fs.writeFileSync('./output-final/complete-dictionary-perfect.json', JSON.stringify(updatedDict, null, 2));

console.log('✅ Dictionary updated successfully!');
console.log('📁 Updated file: ./output-final/complete-dictionary-perfect.json');
console.log('💾 Backup saved: ' + backupFile);
"

echo ""
echo -e "${GREEN}🎉 FINAL PROCESSING COMPLETED! 🎉${NC}"

# Show final statistics
echo ""
echo -e "${BLUE}📊 FINAL STATISTICS:${NC}"
node -e "
const data = JSON.parse(require('fs').readFileSync('./output-final/complete-dictionary-perfect.json', 'utf8'));
const withVi = data.filter(item => item.meaning_vi && item.meaning_vi.trim() && item.meaning_vi !== 'Cần dịch thủ công').length;
console.log('✓ Total items:', data.length);
console.log('✓ Vietnamese translations:', withVi);
console.log('✓ Coverage:', (withVi/data.length*100).toFixed(2) + '%');
console.log('✓ Status:', withVi >= 97900 ? 'EXCELLENT COVERAGE!' : 'Good progress, some items may need manual review');
"

echo ""
echo -e "${GREEN}🚀 Dictionary processing completed! Ready for production use.${NC}"
