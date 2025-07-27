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

// Function to process a batch of data
async function processBatch(batch, batchIndex) {
    try {
        console.log(`Process ${config.processId}: Processing batch ${batchIndex + 1} with ${batch.length} items...`);
        
        const startTime = Date.now();
        
        const completion = await openai.chat.completions.create({
            model: "qwen-max",
            messages: [
                {"role":"system","content":"Bạn là một chuyên gia dịch thuật từ điển tiếng Trung – tiếng Việt, có kinh nghiệm dạy học sinh Việt Nam. Mục tiêu là giúp học sinh hiểu và ghi nhớ từ vựng tiếng Trung dễ dàng, thông qua:\\n\\nDịch nghĩa ví dụ sang tiếng Việt (chính) và tiếng anh (phụ).\\n\\nGiải nghĩa từ đơn giản, dễ hiểu.\\n\\nCung cấp ví dụ cụ thể bằng tiếng Trung và dịch nghĩa.\\n\\nGiải thích ngữ pháp nếu từ đó có đặc điểm ngữ pháp đặc biệt (từ loại, cách dùng, vị trí trong câu...). Xuất kết quả theo dạng JSON, \\n\\nVí dụ Output mẫu:\\n  {\\n    \"chinese\": \"爱护\",\\n    \"pinyin\": \"ài hù\",\\n    \"type\": \"động từ\",\\n    \"meaning_vi\": \"Yêu thương và bảo vệ, chăm sóc một cách cẩn thận (con người, động vật, tài sản...)\",\\n    \"meaning_en\": \"To cherish and protect carefully (people, animals, property, etc.).\",\\n    \"example_cn\": \"我们要爱护环境。\",\\n    \"example_vi\": \"Chúng ta cần phải bảo vệ môi trường.\",\\n    \"example_en\": \"We need to protect the environment.\",\\n    \"grammar\": \"Là động từ hai âm tiết, thường đi kèm với đối tượng cụ thể phía sau. Ví dụ: 爱护公物 (bảo vệ tài sản công cộng), 爱护孩子 (yêu thương trẻ em).\"\\n  }"},
                {
                    "role": "user",
                    "content": JSON.stringify(batch)
                }
            ],
            top_p: 0.8,
            temperature: 0.7
        });

        const endTime = Date.now();
        const responseTimeMs = endTime - startTime;
        const responseTimeSeconds = (responseTimeMs / 1000).toFixed(2);
        
        console.log(`Process ${config.processId}: ✓ Batch ${batchIndex + 1} completed in ${responseTimeSeconds}s`);

        const responseContent = completion.choices[0].message.content;
        
        let parsedResponse;
        try {
            const jsonResponse = extractJsonFromResponse(responseContent);
            parsedResponse = JSON.parse(jsonResponse);
            console.log(`Process ${config.processId}: ✓ Successfully parsed JSON response for batch ${batchIndex + 1}`);
        } catch (parseError) {
            console.error(`Process ${config.processId}: ✗ Failed to parse JSON response for batch ${batchIndex + 1}:`, parseError);
            parsedResponse = {
                error: "Failed to parse JSON",
                parseError: parseError.message,
                rawResponse: responseContent,
                extractedJson: extractJsonFromResponse(responseContent),
                batch: batch,
                responseTime: responseTimeSeconds,
                processId: config.processId
            };
        }

        if (parsedResponse && typeof parsedResponse === 'object' && !parsedResponse.error) {
            parsedResponse._metadata = {
                responseTime: responseTimeSeconds,
                batchIndex: batchIndex + 1,
                processId: config.processId,
                timestamp: new Date().toISOString()
            };
        }

        return parsedResponse;
    } catch (error) {
        console.error(`Process ${config.processId}: ✗ Error processing batch ${batchIndex + 1}:`, error);
        return {
            error: error.message,
            batch: batch,
            processId: config.processId,
            timestamp: new Date().toISOString()
        };
    }
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
        const inputPath = './input/dict-full.json';
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