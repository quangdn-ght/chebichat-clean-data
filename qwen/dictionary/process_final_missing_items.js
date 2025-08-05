import OpenAI from "openai";
import fs from "fs/promises";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

// Configuration
const config = {
    apiKey: process.env.DASHSCOPE_API_KEY,
    batchSize: 8, // Smaller batch size for better API reliability with rare characters
    batchDelay: 3000 // Longer delay for stability
};

// Validate API key
if (!config.apiKey) {
    console.error('Error: DASHSCOPE_API_KEY environment variable is not set');
    process.exit(1);
}

const openai = new OpenAI({
    apiKey: config.apiKey,
    baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// Function to chunk array into smaller batches
function chunkArray(array, chunkSize) {
    const chunks = [];
    for (let i = 0; i < array.length; i += chunkSize) {
        chunks.push(array.slice(i, i + chunkSize));
    }
    return chunks;
}

// Function to extract JSON from markdown code blocks
function extractJsonFromResponse(responseContent) {
    const jsonBlockMatch = responseContent.match(/```json\s*([\s\S]*?)\s*```/);
    if (jsonBlockMatch) {
        return jsonBlockMatch[1].trim();
    }
    
    const codeBlockMatch = responseContent.match(/```\s*([\s\S]*?)\s*```/);
    if (codeBlockMatch) {
        return codeBlockMatch[1].trim();
    }
    
    const content = responseContent.trim();
    if (content.startsWith('{')) {
        try {
            let braceCount = 0;
            let jsonEnd = 0;
            
            for (let i = 0; i < content.length; i++) {
                if (content[i] === '{') {
                    braceCount++;
                } else if (content[i] === '}') {
                    braceCount--;
                    if (braceCount === 0) {
                        jsonEnd = i + 1;
                        break;
                    }
                }
            }
            
            if (jsonEnd > 0) {
                return content.substring(0, jsonEnd);
            }
        } catch (e) {
            // Fall through to return original content
        }
    }
    
    return content;
}

// Function to attempt JSON repair for incomplete responses
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
                } catch (e) {
                    // Continue to next strategy
                }
            }
        }
        
        if (repairedJson.startsWith('{') && !repairedJson.endsWith('}')) {
            let lastComma = repairedJson.lastIndexOf(',');
            let lastColon = repairedJson.lastIndexOf(':');
            
            if (lastComma > lastColon) {
                repairedJson = repairedJson.substring(0, lastComma) + '}';
            } else if (lastColon > -1) {
                let beforeColon = repairedJson.substring(0, lastColon - 1);
                let lastQuote = beforeColon.lastIndexOf('"');
                if (lastQuote > -1) {
                    repairedJson = beforeColon.substring(0, lastQuote) + '}';
                }
            }
            
            try {
                return JSON.parse(repairedJson);
            } catch (e) {
                // Continue to next strategy
            }
        }
        
        console.warn(`Could not repair JSON, returning empty array`);
        return [];
    }
}

// Fallback function to process words individually with simpler prompt
async function processIndividualWords(batch, batchIndex) {
    console.log(`Processing ${batch.length} words individually for batch ${batchIndex + 1}...`);
    const results = [];
    
    for (let i = 0; i < batch.length; i++) {
        try {
            const word = batch[i];
            console.log(`  Processing individual word: ${word.word || word}`);
            
            const completion = await openai.chat.completions.create({
                model: "qwen-max",
                messages: [
                    {"role":"system","content":"You are a Chinese-Vietnamese translator. For the given Chinese word, provide a simple Vietnamese translation. Respond with JSON format: {\"chinese\": \"word\", \"meaning_vi\": \"Vietnamese meaning\", \"pinyin\": \"pinyin if known\", \"type\": \"word type if known\"}. If the word is very rare or unknown, provide your best guess or mark as unknown."},
                    {
                        "role": "user",
                        "content": `Translate this Chinese word to Vietnamese: ${word.word || word}`
                    }
                ],
                temperature: 0.3,
                max_tokens: 500,
                timeout: 30000
            });
            
            const responseContent = completion.choices[0].message.content;
            const jsonResponse = extractJsonFromResponse(responseContent);
            
            try {
                const parsedResponse = JSON.parse(jsonResponse);
                results.push({
                    ...parsedResponse,
                    chinese: word.word || word,
                    meaning_cn: word.meaning || "Original meaning not available",
                    source: "individual_processing"
                });
                console.log(`  ✓ Successfully processed: ${word.word || word}`);
            } catch (parseError) {
                // Create fallback entry
                results.push({
                    chinese: word.word || word,
                    meaning_vi: "Cần dịch thủ công", // Need manual translation
                    meaning_cn: word.meaning || "Original meaning not available",
                    pinyin: "unknown",
                    type: "unknown",
                    note: "API parsing failed",
                    source: "fallback"
                });
                console.log(`  ⚠ Created fallback for: ${word.word || word}`);
            }
            
            // Small delay between individual requests
            await new Promise(resolve => setTimeout(resolve, 800));
            
        } catch (error) {
            console.error(`  ✗ Error processing individual word ${batch[i].word || batch[i]}:`, error.message);
            results.push({
                chinese: batch[i].word || batch[i],
                meaning_vi: "Lỗi xử lý API", // API processing error
                meaning_cn: batch[i].meaning || "Original meaning not available",
                pinyin: "unknown",
                type: "unknown",
                error: error.message,
                source: "error_fallback"
            });
        }
    }
    
    return results;
}

// Enhanced processBatchWithRetry function for final missing items
async function processBatchWithRetry(batch, batchIndex, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`Processing final missing batch ${batchIndex + 1} with ${batch.length} items (attempt ${attempt}/${maxRetries})...`);
            
            const wordsToProcess = batch.map(item => item.word || item);
            const startTime = Date.now();
            
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

            const endTime = Date.now();
            const responseTimeMs = endTime - startTime;
            const responseTimeSeconds = (responseTimeMs / 1000).toFixed(2);
            
            const responseContent = completion.choices[0].message.content;
            
            if (completion.choices[0].finish_reason === 'length') {
                console.warn(`Response was truncated for batch ${batchIndex + 1}, attempting to repair...`);
            }
            
            let parsedResponse;
            try {
                const jsonResponse = extractJsonFromResponse(responseContent);
                parsedResponse = attemptJsonRepair(jsonResponse);
                
                if (!Array.isArray(parsedResponse)) {
                    throw new Error("Response is not an array");
                }
                
                if (parsedResponse.length === 0 && wordsToProcess.length > 0) {
                    throw new Error("Got empty array for non-empty input");
                }
                
                console.log(`✓ Successfully parsed JSON response for batch ${batchIndex + 1} (${parsedResponse.length} items)`);
                
                // Merge original meaning as meaning_cn
                parsedResponse = parsedResponse.map((item, index) => {
                    const originalItem = batch[index];
                    return {
                        ...item,
                        meaning_cn: (originalItem && originalItem.meaning) || "Original meaning not available",
                        source: "batch_processing"
                    };
                });
                
                // Add metadata
                parsedResponse._metadata = {
                    responseTime: responseTimeSeconds,
                    batchIndex: batchIndex + 1,
                    timestamp: new Date().toISOString(),
                    attempt: attempt,
                    finishReason: completion.choices[0].finish_reason,
                    source: 'final_missing_items_processing'
                };
                
                return parsedResponse;
                
            } catch (parseError) {
                console.error(`✗ Failed to parse JSON response for batch ${batchIndex + 1} (attempt ${attempt}):`, parseError.message);
                
                if (attempt === maxRetries) {
                    console.log(`Attempting individual word processing for batch ${batchIndex + 1}...`);
                    return await processIndividualWords(batch, batchIndex);
                }
                
                const retryDelay = attempt * 2000;
                console.log(`Retrying batch ${batchIndex + 1} in ${retryDelay}ms...`);
                await new Promise(resolve => setTimeout(resolve, retryDelay));
                continue;
            }
            
        } catch (error) {
            console.error(`✗ Error processing batch ${batchIndex + 1} (attempt ${attempt}):`, error.message);
            
            if (attempt === maxRetries) {
                console.log(`Creating fallback entries for batch ${batchIndex + 1}...`);
                return batch.map(item => ({
                    chinese: item.word || item,
                    meaning_vi: "Lỗi xử lý API",
                    meaning_cn: (item && item.meaning) || "Original meaning not available",
                    pinyin: "unknown",
                    type: "unknown",
                    error: error.message,
                    timestamp: new Date().toISOString(),
                    attempts: maxRetries,
                    source: 'error_fallback'
                }));
            }
            
            const retryDelay = attempt * 2000;
            console.log(`Retrying batch ${batchIndex + 1} in ${retryDelay}ms...`);
            await new Promise(resolve => setTimeout(resolve, retryDelay));
        }
    }
}

async function main() {
    try {
        console.log('=== PROCESSING FINAL MISSING TRANSLATIONS ===');
        console.log('Target: Complete the final 336 missing translations for 100% coverage');
        
        // Ensure output directory exists
        await fs.mkdir('./final-missing-processed', { recursive: true });
        
        // Read the still missing translations
        const stillMissingWords = JSON.parse(await fs.readFile('./output-final/still-missing-translations.json', 'utf8'));
        console.log(`Total final missing words: ${stillMissingWords.length}`);
        
        // Load original dictionary to get meanings for these words
        const originalDict = JSON.parse(await fs.readFile('./input/DICTIONARY.json', 'utf8'));
        const originalMap = new Map(originalDict.map(item => [item.word, item]));
        
        // Create batch items with original meanings
        const batchItems = stillMissingWords.map(word => {
            const original = originalMap.get(word);
            return {
                word: word,
                meaning: original ? original.meaning : 'No original meaning available'
            };
        });
        
        console.log(`Prepared ${batchItems.length} items with original meanings`);
        
        // Split into batches
        const batches = chunkArray(batchItems, config.batchSize);
        console.log(`Split into ${batches.length} batches of ${config.batchSize} items each`);
        
        const allResults = [];
        
        // Process all batches
        for (let i = 0; i < batches.length; i++) {
            console.log(`\\nProgress: ${i + 1}/${batches.length} batches (${Math.round((i + 1)/batches.length*100)}%)`);
            
            const batchResult = await processBatchWithRetry(batches[i], i);
            
            // Handle both array and non-array results
            if (Array.isArray(batchResult)) {
                allResults.push(...batchResult);
            } else if (batchResult && batchResult._metadata) {
                // Remove metadata before adding to results
                const { _metadata, ...dataWithoutMetadata } = batchResult;
                allResults.push(...(Array.isArray(dataWithoutMetadata) ? dataWithoutMetadata : [batchResult]));
            } else {
                allResults.push(batchResult);
            }
            
            // Save intermediate results
            const intermediateFilename = `./final-missing-processed/final_batch_${i + 1}_of_${batches.length}.json`;
            await fs.writeFile(intermediateFilename, JSON.stringify(batchResult, null, 2), 'utf8');
            console.log(`Saved batch ${i + 1} results to ${intermediateFilename}`);
            
            // Add delay between requests
            if (i < batches.length - 1) {
                console.log(`Waiting ${config.batchDelay}ms before next batch...`);
                await new Promise(resolve => setTimeout(resolve, config.batchDelay));
            }
        }
        
        // Save all results
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const completeFilename = `./final-missing-processed/final_missing_complete_${timestamp}.json`;
        await fs.writeFile(completeFilename, JSON.stringify(allResults, null, 2), 'utf8');
        
        console.log(`\\n=== FINAL MISSING TRANSLATIONS COMPLETED ===`);
        console.log(`Total items processed: ${allResults.length}`);
        console.log(`Results saved to: ${completeFilename}`);
        
        // Analysis of results
        const successfulTranslations = allResults.filter(item => 
            item.meaning_vi && 
            item.meaning_vi.trim() && 
            item.meaning_vi !== 'Cần dịch thủ công' && 
            item.meaning_vi !== 'Lỗi xử lý API'
        ).length;
        
        const needManualReview = allResults.length - successfulTranslations;
        
        console.log(`\\n📊 PROCESSING SUMMARY:`);
        console.log(`✓ Successful translations: ${successfulTranslations}`);
        console.log(`⚠ Need manual review: ${needManualReview}`);
        console.log(`📈 Success rate: ${(successfulTranslations/allResults.length*100).toFixed(1)}%`);
        
        console.log(`\\n🔄 Next step: Merge these translations into the complete dictionary`);
        console.log(`   Use: node merge_final_translations.js`);
        
    } catch (error) {
        console.error('Error in main function:', error);
        process.exit(1);
    }
}

main();
