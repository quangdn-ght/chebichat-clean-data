import OpenAI from "openai";
import fs from "fs/promises";
import path from "path";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

// Parse command line arguments
function parseArguments() {
    const args = process.argv.slice(2);
    const config = {
        apiKey: process.env.DASHSCOPE_API_KEY,
        batchSize: parseInt(process.env.BATCH_SIZE) || 20,
        batchDelay: parseInt(process.env.BATCH_DELAY) || 2000,
        processId: 1,
        totalProcesses: 1,
        batchesPerProcess: 60
    };

    // Parse arguments: --process-id=1 --total-processes=10 --batches-per-process=50
    for (let i = 0; i < args.length; i++) {
        const arg = args[i];
        if (arg.startsWith('--process-id=')) {
            config.processId = parseInt(arg.split('=')[1]);
        } else if (arg.startsWith('--total-processes=')) {
            config.totalProcesses = parseInt(arg.split('=')[1]);
        } else if (arg.startsWith('--batches-per-process=')) {
            config.batchesPerProcess = parseInt(arg.split('=')[1]);
        }
    }

    return config;
}

const config = parseArguments();

// Validate environment variables and arguments
if (!config.apiKey) {
    console.error('Error: DASHSCOPE_API_KEY environment variable is not set');
    console.error('Please set your API key in .env file: DASHSCOPE_API_KEY="your-api-key"');
    console.error('Or export it: export DASHSCOPE_API_KEY="your-api-key"');
    process.exit(1);
}

if (config.processId < 1 || config.processId > config.totalProcesses) {
    console.error(`Error: process-id (${config.processId}) must be between 1 and ${config.totalProcesses}`);
    process.exit(1);
}

console.log(`Process ${config.processId}/${config.totalProcesses} - Configuration:`);
console.log(`  Batch size: ${config.batchSize}`);
console.log(`  Delay: ${config.batchDelay}ms`);
console.log(`  Batches per process: ${config.batchesPerProcess}`);

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

// Function to calculate batch range for this process - optimized to handle all items
function calculateBatchRange(totalBatches, processId, totalProcesses, batchesPerProcess) {
    // Calculate batches per process dynamically to ensure all batches are covered
    const batchesPerProcessOptimal = Math.ceil(totalBatches / totalProcesses);
    const actualBatchesPerProcess = Math.max(batchesPerProcess, batchesPerProcessOptimal);
    
    const startBatch = (processId - 1) * actualBatchesPerProcess;
    const endBatch = Math.min(startBatch + actualBatchesPerProcess - 1, totalBatches - 1);
    
    console.log(`Process ${processId}: Dynamic calculation:`);
    console.log(`  Total batches: ${totalBatches}`);
    console.log(`  Optimal batches per process: ${batchesPerProcessOptimal}`);
    console.log(`  Using batches per process: ${actualBatchesPerProcess}`);
    console.log(`  Assigned range: ${startBatch + 1} to ${endBatch + 1}`);
    
    return { 
        startBatch, 
        endBatch, 
        batchesPerProcess: actualBatchesPerProcess,
        actualBatches: endBatch >= startBatch ? endBatch - startBatch + 1 : 0
    };
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
        // Try to parse as-is first
        return JSON.parse(jsonString);
    } catch (error) {
        // Common repair strategies
        let repairedJson = jsonString.trim();
        
        // Strategy 1: If it's an incomplete array, close it
        if (repairedJson.startsWith('[') && !repairedJson.endsWith(']')) {
            // Count open objects
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
                // Truncate to last complete object and close array
                repairedJson = repairedJson.substring(0, lastCompleteObject + 1) + ']';
                try {
                    return JSON.parse(repairedJson);
                } catch (e) {
                    // Continue to next strategy
                }
            }
        }
        
        // Strategy 2: If it's an incomplete object, close it
        if (repairedJson.startsWith('{') && !repairedJson.endsWith('}')) {
            // Find last complete property
            let lastComma = repairedJson.lastIndexOf(',');
            let lastColon = repairedJson.lastIndexOf(':');
            
            if (lastComma > lastColon) {
                // Remove incomplete property and close object
                repairedJson = repairedJson.substring(0, lastComma) + '}';
            } else if (lastColon > -1) {
                // Remove incomplete value and close object
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
        
        // Strategy 3: Return empty array as fallback
        console.warn(`Could not repair JSON, returning empty array`);
        return [];
    }
}

// Function to process a batch with retry logic
async function processBatchWithRetry(batch, batchIndex, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`Process ${config.processId}: Processing batch ${batchIndex + 1} with ${batch.length} items (attempt ${attempt}/${maxRetries})...`);
            
            // Extract only the "word" values for API processing
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
                max_tokens: 4000, // Increase token limit to prevent truncation
                timeout: 60000 // 60 second timeout
            });

            const endTime = Date.now();
            const responseTimeMs = endTime - startTime;
            const responseTimeSeconds = (responseTimeMs / 1000).toFixed(2);
            
            const responseContent = completion.choices[0].message.content;
            
            // Check if response was truncated by looking at finish_reason
            if (completion.choices[0].finish_reason === 'length') {
                console.warn(`Process ${config.processId}: Response was truncated for batch ${batchIndex + 1}, attempting to repair...`);
            }
            
            let parsedResponse;
            try {
                const jsonResponse = extractJsonFromResponse(responseContent);
                parsedResponse = attemptJsonRepair(jsonResponse);
                
                // Validate that we got reasonable results
                if (!Array.isArray(parsedResponse)) {
                    throw new Error("Response is not an array");
                }
                
                if (parsedResponse.length === 0 && wordsToProcess.length > 0) {
                    throw new Error("Got empty array for non-empty input");
                }
                
                console.log(`Process ${config.processId}: ✓ Successfully parsed JSON response for batch ${batchIndex + 1} (${parsedResponse.length} items)`);
                
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
                    processId: config.processId,
                    timestamp: new Date().toISOString(),
                    attempt: attempt,
                    finishReason: completion.choices[0].finish_reason
                };
                
                return parsedResponse;
                
            } catch (parseError) {
                console.error(`Process ${config.processId}: ✗ Failed to parse JSON response for batch ${batchIndex + 1} (attempt ${attempt}):`, parseError.message);
                
                // If this is the last attempt, try processing individual items
                if (attempt === maxRetries) {
                    console.log(`Process ${config.processId}: Attempting individual word processing for batch ${batchIndex + 1}...`);
                    return await processIndividualWords(batch, batchIndex);
                }
                
                // Otherwise, wait before retry
                const retryDelay = attempt * 2000; // Exponential backoff
                console.log(`Process ${config.processId}: Retrying batch ${batchIndex + 1} in ${retryDelay}ms...`);
                await new Promise(resolve => setTimeout(resolve, retryDelay));
                continue;
            }
            
        } catch (error) {
            console.error(`Process ${config.processId}: ✗ Error processing batch ${batchIndex + 1} (attempt ${attempt}):`, error.message);
            
            if (attempt === maxRetries) {
                // Last attempt failed, return error object
                return {
                    error: error.message,
                    batch: batch,
                    processId: config.processId,
                    timestamp: new Date().toISOString(),
                    attempts: maxRetries
                };
            }
            
            // Wait before retry
            const retryDelay = attempt * 2000;
            console.log(`Process ${config.processId}: Retrying batch ${batchIndex + 1} in ${retryDelay}ms...`);
            await new Promise(resolve => setTimeout(resolve, retryDelay));
        }
    }
}

// Fallback function to process words individually
async function processIndividualWords(batch, batchIndex) {
    console.log(`Process ${config.processId}: Processing ${batch.length} words individually for batch ${batchIndex + 1}...`);
    const results = [];
    
    for (let i = 0; i < batch.length; i++) {
        try {
            const word = batch[i];
            const completion = await openai.chat.completions.create({
                model: "qwen-max",
                messages: [
                    {"role":"system","content":"Bạn là một chuyên gia dịch thuật từ điển tiếng Trung – tiếng Việt. Trả về JSON object cho từ vựng tiếng Trung được yêu cầu. Format: {\"chinese\": \"từ\", \"pinyin\": \"phiên âm\", \"type\": \"từ loại\", \"meaning_vi\": \"nghĩa tiếng Việt\", \"meaning_en\": \"nghĩa tiếng Anh\", \"example_cn\": \"ví dụ tiếng Trung\", \"example_vi\": \"ví dụ tiếng Việt\", \"example_en\": \"ví dụ tiếng Anh\", \"grammar\": \"giải thích ngữ pháp\", \"hsk_level\": số_cấp_độ}"},
                    {
                        "role": "user",
                        "content": word.word
                    }
                ],
                top_p: 0.8,
                temperature: 0.7,
                max_tokens: 1000
            });
            
            const responseContent = completion.choices[0].message.content;
            const jsonResponse = extractJsonFromResponse(responseContent);
            const parsedResponse = attemptJsonRepair(jsonResponse);
            
            if (parsedResponse && typeof parsedResponse === 'object') {
                results.push({
                    ...parsedResponse,
                    meaning_cn: word.meaning
                });
            } else {
                // Fallback: create basic entry
                results.push({
                    chinese: word.word,
                    meaning_cn: word.meaning,
                    error: "Individual processing failed",
                    timestamp: new Date().toISOString()
                });
            }
            
            // Small delay between individual requests
            await new Promise(resolve => setTimeout(resolve, 500));
            
        } catch (error) {
            console.error(`Process ${config.processId}: Error processing individual word ${batch[i].word}:`, error.message);
            results.push({
                chinese: batch[i].word,
                meaning_cn: batch[i].meaning,
                error: "Individual processing failed",
                errorMessage: error.message,
                timestamp: new Date().toISOString()
            });
        }
    }
    
    return results;
}

// Function to process a batch of data (wrapper for retry logic)
async function processBatch(batch, batchIndex) {
    return await processBatchWithRetry(batch, batchIndex);
}

// Function to save results to output file
async function saveResults(results, filename) {
    const outputPath = path.join('./output', filename);
    try {
        await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf8');
        console.log(`Process ${config.processId}: Results saved to ${outputPath}`);
    } catch (error) {
        console.error(`Process ${config.processId}: Error saving results to ${outputPath}:`, error);
    }
}

// Function to check if batch result already exists
async function batchExists(batchIndex, totalBatches, processId) {
    const filename = `dict_batch_${batchIndex + 1}_of_${totalBatches}_process_${processId}.json`;
    const outputPath = path.join('./output', filename);
    try {
        await fs.access(outputPath);
        return true;
    } catch {
        return false;
    }
}

// Function to append to process-specific output file
async function appendToProcessFile(newData, processId) {
    const filename = `dict-processed-process-${processId}.json`;
    const outputPath = path.join('./output', filename);
    try {
        let existingData = [];
        
        try {
            const existingContent = await fs.readFile(outputPath, 'utf8');
            if (existingContent.trim()) {
                existingData = JSON.parse(existingContent);
                if (!Array.isArray(existingData)) {
                    existingData = [];
                }
            }
        } catch (readError) {
            console.log(`Process ${processId}: Creating new file: ${outputPath}`);
        }
        
        if (Array.isArray(newData)) {
            existingData.push(...newData);
        } else {
            existingData.push(newData);
        }
        
        await fs.writeFile(outputPath, JSON.stringify(existingData, null, 2), 'utf8');
        console.log(`Process ${processId}: Appended ${Array.isArray(newData) ? newData.length : 1} items to ${outputPath}. Total: ${existingData.length} items.`);
        
        return existingData.length;
    } catch (error) {
        console.error(`Process ${processId}: Error appending to ${outputPath}:`, error);
        throw error;
    }
}

async function main() {
    try {
        // Ensure output directory exists
        await fs.mkdir('./output', { recursive: true });
        
        // Read input data
        console.log(`Process ${config.processId}: Reading input data...`);
        const inputPath = './input/DICTIONARY.json';
        const inputData = JSON.parse(await fs.readFile(inputPath, 'utf8'));
        
        console.log(`Process ${config.processId}: Loaded ${inputData.length} items from ${inputPath}`);
        
        // Split data into batches
        const batches = chunkArray(inputData, config.batchSize);
        console.log(`Process ${config.processId}: Split ${inputData.length} items into ${batches.length} total batches`);
        
        // Calculate total capacity and coverage
        const totalCapacity = config.totalProcesses * config.batchesPerProcess * config.batchSize;
        const coverage = ((totalCapacity / inputData.length) * 100).toFixed(1);
        console.log(`Process ${config.processId}: System capacity: ${totalCapacity} items (${coverage}% of ${inputData.length} total items)`);
        
        if (totalCapacity < inputData.length) {
            console.log(`Process ${config.processId}: ⚠️  WARNING: Current configuration may not process all items!`);
            console.log(`Process ${config.processId}: Consider increasing batch size or batches per process.`);
        }
        
        // Calculate which batches this process should handle
        const { startBatch, endBatch, actualBatches } = calculateBatchRange(
            batches.length, 
            config.processId, 
            config.totalProcesses, 
            config.batchesPerProcess
        );
        
        console.log(`Process ${config.processId}: Handling batches ${startBatch + 1} to ${endBatch + 1} (${actualBatches} batches)`);
        
        if (startBatch >= batches.length || actualBatches === 0) {
            console.log(`Process ${config.processId}: No batches to process`);
            return;
        }
        
        const allResults = [];
        let processedCount = 0;
        
        // Process assigned batches
        for (let i = startBatch; i <= endBatch && i < batches.length; i++) {
            // Check if batch already processed
            const exists = await batchExists(i, batches.length, config.processId);
            if (exists) {
                console.log(`Process ${config.processId}: Batch ${i + 1} already exists, skipping...`);
                processedCount += batches[i].length;
                continue;
            }
            
            const batchProgress = processedCount + (i - startBatch) * config.batchSize;
            const totalAssigned = (endBatch - startBatch + 1) * config.batchSize;
            console.log(`Process ${config.processId}: Progress: ${batchProgress}/${totalAssigned} items processed (${Math.round(batchProgress/totalAssigned*100)}%)`);
            
            const batchResult = await processBatch(batches[i], i);
            allResults.push({
                batchIndex: i,
                batchSize: batches[i].length,
                result: batchResult,
                processId: config.processId,
                timestamp: new Date().toISOString()
            });
            
            // Save intermediate results after each batch
            const intermediateFilename = `dict_batch_${i + 1}_of_${batches.length}_process_${config.processId}.json`;
            await saveResults(batchResult, intermediateFilename);
            
            // Append results to process-specific output file
            if (Array.isArray(batchResult)) {
                await appendToProcessFile(batchResult, config.processId);
            } else if (batchResult && !batchResult.error) {
                await appendToProcessFile(batchResult, config.processId);
            } else {
                console.log(`Process ${config.processId}: Skipping append for batch ${i + 1} due to error or invalid result`);
            }
            
            processedCount += batches[i].length;
            
            // Add delay between requests
            if (i < endBatch && i < batches.length - 1) {
                console.log(`Process ${config.processId}: Waiting ${config.batchDelay}ms before next batch...`);
                await new Promise(resolve => setTimeout(resolve, config.batchDelay));
            }
        }
        
        // Save complete results for this process
        const completeFilename = `dict_complete_process_${config.processId}_${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
        await saveResults(allResults, completeFilename);
        
        console.log(`Process ${config.processId}: Processing completed successfully! Processed ${processedCount} items.`);
        
    } catch (error) {
        console.error(`Process ${config.processId}: Error in main function:`, error);
        process.exit(1);
    }
}

main();