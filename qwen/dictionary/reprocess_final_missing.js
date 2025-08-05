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
