import OpenAI from "openai";
import fs from "fs/promises";
import path from "path";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

// Parse command line arguments for chunk processing
function parseArguments() {
    const args = process.argv.slice(2);
    let chunkId = 1;
    
    for (let i = 0; i < args.length; i++) {
        if (args[i].startsWith('--chunk=')) {
            chunkId = parseInt(args[i].split('=')[1]);
        }
    }
    
    return { chunkId };
}

const { chunkId } = parseArguments();

// Configuration
const config = {
    apiKey: process.env.DASHSCOPE_API_KEY,
    batchSize: 8, // Smaller batch size for parallel processing
    batchDelay: 2000, // 2 second delay
    chunkId: chunkId
};

// Validate API key
if (!config.apiKey) {
    console.error(`Chunk ${chunkId}: Error - DASHSCOPE_API_KEY environment variable is not set`);
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
    const jsonBlockMatch = responseContent.match(/```json\\s*([\\s\\S]*?)\\s*```/);
    if (jsonBlockMatch) {
        return jsonBlockMatch[1].trim();
    }
    
    const codeBlockMatch = responseContent.match(/```\\s*([\\s\\S]*?)\\s*```/);
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
        
        console.warn(`Chunk ${chunkId}: Could not repair JSON, returning empty array`);
        return [];
    }
}

// Function to process a batch with retry logic
async function processBatchWithRetry(batch, batchIndex, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`Chunk ${chunkId}: Processing batch ${batchIndex + 1}/${batch.length} items (attempt ${attempt}/${maxRetries})...`);
            
            const wordsToProcess = batch.map(item => item.word);
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
                console.warn(`Chunk ${chunkId}: Response was truncated for batch ${batchIndex + 1}, attempting to repair...`);
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
                
                console.log(`Chunk ${chunkId}: ✓ Successfully parsed JSON response for batch ${batchIndex + 1} (${parsedResponse.length} items)`);
                
                // Merge original meaning as meaning_cn
                parsedResponse = parsedResponse.map((item, index) => {
                    if (batch[index] && batch[index].meaning) {
                        return {
                            ...item,
                            meaning_cn: batch[index].meaning
                        };
                    }
                    return item;
                });
                
                // Add metadata
                parsedResponse._metadata = {
                    responseTime: responseTimeSeconds,
                    batchIndex: batchIndex + 1,
                    chunkId: chunkId,
                    timestamp: new Date().toISOString(),
                    attempt: attempt,
                    finishReason: completion.choices[0].finish_reason,
                    source: 'parallel_missing_items_reprocessing'
                };
                
                return parsedResponse;
                
            } catch (parseError) {
                console.error(`Chunk ${chunkId}: ✗ Failed to parse JSON response for batch ${batchIndex + 1} (attempt ${attempt}):`, parseError.message);
                
                if (attempt === maxRetries) {
                    console.log(`Chunk ${chunkId}: Skipping batch ${batchIndex + 1} after ${maxRetries} attempts`);
                    return {
                        error: parseError.message,
                        batch: batch,
                        chunkId: chunkId,
                        timestamp: new Date().toISOString(),
                        attempts: maxRetries
                    };
                }
                
                const retryDelay = attempt * 2000;
                console.log(`Chunk ${chunkId}: Retrying batch ${batchIndex + 1} in ${retryDelay}ms...`);
                await new Promise(resolve => setTimeout(resolve, retryDelay));
                continue;
            }
            
        } catch (error) {
            console.error(`Chunk ${chunkId}: ✗ Error processing batch ${batchIndex + 1} (attempt ${attempt}):`, error.message);
            
            if (attempt === maxRetries) {
                return {
                    error: error.message,
                    batch: batch,
                    chunkId: chunkId,
                    timestamp: new Date().toISOString(),
                    attempts: maxRetries
                };
            }
            
            const retryDelay = attempt * 2000;
            console.log(`Chunk ${chunkId}: Retrying batch ${batchIndex + 1} in ${retryDelay}ms...`);
            await new Promise(resolve => setTimeout(resolve, retryDelay));
        }
    }
}

async function main() {
    try {
        console.log(`Chunk ${chunkId}: Starting parallel reprocessing...`);
        
        // Ensure output directory exists
        await fs.mkdir('./missing-items-processed-parallel', { recursive: true });
        
        // Read chunk-specific missing items
        const chunkFile = `./missing-items-split/missing-items-chunk-${chunkId}.json`;
        
        let chunkItems;
        try {
            chunkItems = JSON.parse(await fs.readFile(chunkFile, 'utf8'));
        } catch (error) {
            console.error(`Chunk ${chunkId}: Could not read chunk file ${chunkFile}:`, error.message);
            process.exit(1);
        }
        
        console.log(`Chunk ${chunkId}: Processing ${chunkItems.length} items`);
        
        // Split into batches
        const batches = chunkArray(chunkItems, config.batchSize);
        console.log(`Chunk ${chunkId}: Split into ${batches.length} batches of ${config.batchSize} items each`);
        
        const allResults = [];
        
        // Process all batches
        for (let i = 0; i < batches.length; i++) {
            console.log(`Chunk ${chunkId}: Progress: ${i + 1}/${batches.length} batches (${Math.round((i + 1)/batches.length*100)}%)`);
            
            const batchResult = await processBatchWithRetry(batches[i], i);
            
            if (Array.isArray(batchResult)) {
                allResults.push(...batchResult);
            } else {
                allResults.push(batchResult);
            }
            
            // Save intermediate results
            const intermediateFilename = `./missing-items-processed-parallel/chunk_${chunkId}_batch_${i + 1}_of_${batches.length}.json`;
            await fs.writeFile(intermediateFilename, JSON.stringify(batchResult, null, 2), 'utf8');
            
            // Add delay between requests
            if (i < batches.length - 1) {
                await new Promise(resolve => setTimeout(resolve, config.batchDelay));
            }
        }
        
        // Save all results for this chunk
        const chunkResultsFilename = `./missing-items-processed-parallel/chunk_${chunkId}_results.json`;
        await fs.writeFile(chunkResultsFilename, JSON.stringify(allResults, null, 2), 'utf8');
        
        // Count successful vs error items
        const successfulItems = allResults.filter(item => !item.error);
        const errorItems = allResults.filter(item => item.error);
        
        console.log(`Chunk ${chunkId}: Processing completed!`);
        console.log(`Chunk ${chunkId}: Successful items: ${successfulItems.length}`);
        console.log(`Chunk ${chunkId}: Error items: ${errorItems.length}`);
        console.log(`Chunk ${chunkId}: Results saved to: ${chunkResultsFilename}`);
        
    } catch (error) {
        console.error(`Chunk ${chunkId}: Error in main function:`, error);
        process.exit(1);
    }
}

main();
