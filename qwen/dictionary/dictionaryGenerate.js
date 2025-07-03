import OpenAI from "openai";
import fs from "fs/promises";
import path from "path";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

// Configuration from environment variables with defaults
const config = {
    apiKey: process.env.DASHSCOPE_API_KEY,
    batchSize: parseInt(process.env.BATCH_SIZE) || 20,
    batchDelay: parseInt(process.env.BATCH_DELAY) || 2000
};

// Validate environment variables
if (!config.apiKey) {
    console.error('Error: DASHSCOPE_API_KEY environment variable is not set');
    console.error('Please set your API key in .env file: DASHSCOPE_API_KEY="your-api-key"');
    console.error('Or export it: export DASHSCOPE_API_KEY="your-api-key"');
    process.exit(1);
}

console.log(`Configuration: Batch size=${config.batchSize}, Delay=${config.batchDelay}ms`);

const openai = new OpenAI(
    {
        // If env config not provided, please use Bailian API KEY: api_key="sk-xxx",
        apiKey: config.apiKey,
        baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
    }
);

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
    // Check if response is wrapped in markdown code blocks
    const jsonBlockMatch = responseContent.match(/```json\s*([\s\S]*?)\s*```/);
    if (jsonBlockMatch) {
        return jsonBlockMatch[1].trim();
    }
    
    // Check for generic code blocks
    const codeBlockMatch = responseContent.match(/```\s*([\s\S]*?)\s*```/);
    if (codeBlockMatch) {
        return codeBlockMatch[1].trim();
    }
    
    // Try to extract just the JSON object from the response
    // Look for content between the first { and the last } that forms valid JSON
    const content = responseContent.trim();
    if (content.startsWith('{')) {
        try {
            // Find the main JSON object by counting braces
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
    
    // Return as-is if no processing worked
    return content;
}

// Function to process a batch of data
async function processBatch(batch, batchIndex) {
    try {
        console.log(`Processing batch ${batchIndex + 1} with ${batch.length} items...`);
        
        // Record start time
        const startTime = Date.now();
        
        const completion = await openai.chat.completions.create({
            model: "qwen-max",
            messages: [
                // SYSTEM
                {"role":"system","content":"Bạn là một chuyên gia dịch thuật từ điển tiếng Trung – tiếng Việt, có kinh nghiệm dạy học sinh Việt Nam. Mục tiêu là giúp học sinh hiểu và ghi nhớ từ vựng tiếng Trung dễ dàng, thông qua:\\n\\nDịch nghĩa ví dụ sang tiếng Việt (chính) và tiếng anh (phụ).\\n\\nGiải nghĩa từ đơn giản, dễ hiểu.\\n\\nCung cấp ví dụ cụ thể bằng tiếng Trung và dịch nghĩa.\\n\\nGiải thích ngữ pháp nếu từ đó có đặc điểm ngữ pháp đặc biệt (từ loại, cách dùng, vị trí trong câu...). Xuất kết quả theo dạng JSON, \\n\\nVí dụ Output mẫu:\\n  {\\n    \"chinese\": \"爱护\",\\n    \"pinyin\": \"ài hù\",\\n    \"type\": \"động từ\",\\n    \"meaning_vi\": \"Yêu thương và bảo vệ, chăm sóc một cách cẩn thận (con người, động vật, tài sản...)\",\\n    \"meaning_en\": \"To cherish and protect carefully (people, animals, property, etc.).\",\\n    \"example_cn\": \"我们要爱护环境。\",\\n    \"example_vi\": \"Chúng ta cần phải bảo vệ môi trường.\",\\n    \"example_en\": \"We need to protect the environment.\",\\n    \"grammar\": \"Là động từ hai âm tiết, thường đi kèm với đối tượng cụ thể phía sau. Ví dụ: 爱护公物 (bảo vệ tài sản công cộng), 爱护孩子 (yêu thương trẻ em).\"\\n  }"},

                // USER
                {
                    "role": "user",
                    "content": JSON.stringify(batch)
                }
            ],
            top_p: 0.8,
            temperature: 0.7
        });

        // Calculate response time
        const endTime = Date.now();
        const responseTimeMs = endTime - startTime;
        const responseTimeSeconds = (responseTimeMs / 1000).toFixed(2);
        
        console.log(`✓ Batch ${batchIndex + 1} completed in ${responseTimeSeconds}s (${responseTimeMs}ms)`);

        // Extract the JSON response from the completion
        const responseContent = completion.choices[0].message.content;
        
        // Try to parse the JSON response
        let parsedResponse;
        try {
            const jsonResponse = extractJsonFromResponse(responseContent);
            parsedResponse = JSON.parse(jsonResponse);
            console.log(`✓ Successfully parsed JSON response for batch ${batchIndex + 1}`);
        } catch (parseError) {
            console.error(`✗ Failed to parse JSON response for batch ${batchIndex + 1}:`, parseError);
            console.error(`Raw response length: ${responseContent.length}`);
            console.error(`Raw response (first 500 chars): ${responseContent.substring(0, 500)}`);
            // If parsing fails, save the raw response for inspection
            parsedResponse = {
                error: "Failed to parse JSON",
                parseError: parseError.message,
                rawResponse: responseContent,
                extractedJson: extractJsonFromResponse(responseContent),
                batch: batch,
                responseTime: responseTimeSeconds
            };
        }

        // Add response time to the result for tracking
        if (parsedResponse && typeof parsedResponse === 'object' && !parsedResponse.error) {
            parsedResponse._metadata = {
                responseTime: responseTimeSeconds,
                batchIndex: batchIndex + 1,
                timestamp: new Date().toISOString()
            };
        }

        return parsedResponse;
    } catch (error) {
        console.error(`✗ Error processing batch ${batchIndex + 1}:`, error);
        return {
            error: error.message,
            batch: batch,
            timestamp: new Date().toISOString()
        };
    }
}

// Function to save results to output file
async function saveResults(results, filename) {
    const outputPath = path.join('./output', filename);
    try {
        await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf8');
        console.log(`Results saved to ${outputPath}`);
    } catch (error) {
        console.error(`Error saving results to ${outputPath}:`, error);
    }
}

// Function to append results to a single JSON file
async function appendToJsonFile(newData, filename) {
    const outputPath = path.join('./output', filename);
    try {
        let existingData = [];
        
        // Read existing file if it exists
        try {
            const existingContent = await fs.readFile(outputPath, 'utf8');
            if (existingContent.trim()) {
                existingData = JSON.parse(existingContent);
                // Ensure it's an array
                if (!Array.isArray(existingData)) {
                    existingData = [];
                }
            }
        } catch (readError) {
            // File doesn't exist yet, start with empty array
            console.log(`Creating new file: ${outputPath}`);
        }
        
        // Append new data
        if (Array.isArray(newData)) {
            existingData.push(...newData);
        } else {
            existingData.push(newData);
        }
        
        // Write back to file
        await fs.writeFile(outputPath, JSON.stringify(existingData, null, 2), 'utf8');
        console.log(`Appended ${Array.isArray(newData) ? newData.length : 1} items to ${outputPath}. Total: ${existingData.length} items.`);
        
        return existingData.length;
    } catch (error) {
        console.error(`Error appending to ${outputPath}:`, error);
        throw error;
    }
}

// Function to check if batch result already exists
async function batchExists(batchIndex, totalBatches) {
    const filename = `dict_batch_${batchIndex + 1}_of_${totalBatches}.json`;
    const outputPath = path.join('./output', filename);
    try {
        await fs.access(outputPath);
        return true;
    } catch {
        return false;
    }
}

async function main() {
    try {
        // Ensure output directory exists
        await fs.mkdir('./output', { recursive: true });
        
        // Read input data
        console.log('Reading input data...');
        const inputPath = './input/dict-full.json';
        const inputData = JSON.parse(await fs.readFile(inputPath, 'utf8'));
        
        console.log(`Loaded ${inputData.length} items from ${inputPath}`);
        
        // Split data into batches of 20 items
        const batches = chunkArray(inputData, 20);
        console.log(`Split into ${batches.length} batches of 20 items`);
        
        const allResults = [];
        let processedCount = 0;
        
        // Process each batch
        for (let i = 0; i < batches.length; i++) {
            // Check if batch already processed
            const exists = await batchExists(i, batches.length);
            if (exists) {
                console.log(`Batch ${i + 1} already exists, skipping...`);
                processedCount += batches[i].length;
                continue;
            }
            
            console.log(`Progress: ${processedCount}/${inputData.length} items processed (${Math.round(processedCount/inputData.length*100)}%)`);
            
            const batchResult = await processBatch(batches[i], i);
            allResults.push({
                batchIndex: i,
                batchSize: batches[i].length,
                result: batchResult,
                timestamp: new Date().toISOString()
            });
            
            // Save intermediate results after each batch
            const intermediateFilename = `dict_batch_${i + 1}_of_${batches.length}.json`;
            await saveResults(batchResult, intermediateFilename);
            
            // Append results to main output file
            if (Array.isArray(batchResult)) {
                await appendToJsonFile(batchResult, 'dict-processed.json');
            } else if (batchResult && !batchResult.error) {
                await appendToJsonFile(batchResult, 'dict-processed.json');
            } else {
                console.log(`Skipping append for batch ${i + 1} due to error or invalid result`);
            }
            
            processedCount += batches[i].length;
            
            // Add configurable delay between requests to avoid rate limiting
            if (i < batches.length - 1) {
                console.log(`Waiting ${config.batchDelay}ms before next batch...`);
                await new Promise(resolve => setTimeout(resolve, config.batchDelay));
            }
        }
        
        // Save complete results
        const completeFilename = `dict_complete_${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
        await saveResults(allResults, completeFilename);
        
        console.log(`Processing completed successfully! Processed ${processedCount}/${inputData.length} items.`);
        
    } catch (error) {
        console.error('Error in main function:', error);
        process.exit(1);
    }
}

main();