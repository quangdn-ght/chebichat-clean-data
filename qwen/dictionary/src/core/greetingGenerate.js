import OpenAI from 'openai';
import fs from 'fs/promises';
import path from 'path';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

// Parse command line arguments
function parseArguments() {
    const args = process.argv.slice(2);
    const config = {
        apiKey: process.env.DASHSCOPE_API_KEY,
        batchSize: parseInt(process.env.BATCH_SIZE) || 8, // Smaller batch size for greetings
        batchDelay: parseInt(process.env.BATCH_DELAY) || 3000, // Delay between batches
        processId: 1,
        totalProcesses: 1,
        batchesPerProcess: 100
    };

    console.log(`API key:`, config.apiKey);

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

// Function to calculate batch range for this process
function calculateBatchRange(totalBatches, processId, totalProcesses, batchesPerProcess) {
    const batchesPerProcessOptimal = Math.ceil(totalBatches / totalProcesses);
    
    const startBatch = (processId - 1) * batchesPerProcessOptimal;
    const endBatch = Math.min(startBatch + batchesPerProcessOptimal - 1, totalBatches - 1);
    
    console.log(`Process ${processId}: Fixed calculation:`);
    console.log(`  Total batches: ${totalBatches}`);
    console.log(`  Batches per process (optimal): ${batchesPerProcessOptimal}`);
    console.log(`  Assigned range: ${startBatch + 1} to ${endBatch + 1}`);
    
    return { 
        startBatch, 
        endBatch, 
        batchesPerProcess: batchesPerProcessOptimal,
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
    if (content.startsWith('[') || content.startsWith('{')) {
        try {
            let braceCount = 0;
            let jsonEnd = 0;
            const startChar = content[0];
            const endChar = startChar === '[' ? ']' : '}';
            
            for (let i = 0; i < content.length; i++) {
                if (content[i] === startChar) {
                    braceCount++;
                } else if (content[i] === endChar) {
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
        console.log(`JSON parse failed, attempting repair. Error: ${error.message}`);
        console.log(`JSON content length: ${jsonString.length}`);
        
        // Common repair strategies
        let repairedJson = jsonString.trim();
        
        // Strategy 1: If it's an incomplete array, close it
        if (repairedJson.startsWith('[') && !repairedJson.endsWith(']')) {
            console.log(`Attempting to repair incomplete array...`);
            
            // Count open objects and find complete objects
            let openBraces = 0;
            let lastCompleteObject = -1;
            let completeObjects = [];
            let objectStart = -1;
            
            for (let i = 0; i < repairedJson.length; i++) {
                if (repairedJson[i] === '{') {
                    if (openBraces === 0) {
                        objectStart = i;
                    }
                    openBraces++;
                } else if (repairedJson[i] === '}') {
                    openBraces--;
                    if (openBraces === 0 && objectStart !== -1) {
                        lastCompleteObject = i;
                        completeObjects.push({
                            start: objectStart,
                            end: i,
                            content: repairedJson.substring(objectStart, i + 1)
                        });
                        objectStart = -1;
                    }
                }
            }
            
            console.log(`Found ${completeObjects.length} complete objects`);
            
            if (completeObjects.length > 0) {
                // Try to reconstruct array with complete objects
                try {
                    const objectsJson = completeObjects.map(obj => obj.content).join(',');
                    const reconstructedArray = '[' + objectsJson + ']';
                    const parsed = JSON.parse(reconstructedArray);
                    console.log(`Successfully reconstructed array with ${parsed.length} objects`);
                    return parsed;
                } catch (e) {
                    console.log(`Failed to reconstruct array: ${e.message}`);
                }
                
                // Fallback: use the truncated approach
                repairedJson = repairedJson.substring(0, lastCompleteObject + 1) + ']';
                try {
                    const parsed = JSON.parse(repairedJson);
                    console.log(`Successfully repaired with truncation, got ${parsed.length} objects`);
                    return parsed;
                } catch (e) {
                    console.log(`Truncation repair failed: ${e.message}`);
                }
            }
        }
        
        // Strategy 2: If it's an incomplete object, close it
        if (repairedJson.startsWith('{') && !repairedJson.endsWith('}')) {
            console.log(`Attempting to repair incomplete object...`);
            
            // Find last complete property
            let lastComma = repairedJson.lastIndexOf(',');
            let lastColon = repairedJson.lastIndexOf(':');
            
            if (lastComma > lastColon) {
                // Remove incomplete property and close object
                repairedJson = repairedJson.substring(0, lastComma) + '}';
            } else if (lastColon > -1) {
                // Remove incomplete property and close object
                repairedJson = repairedJson.substring(0, lastColon) + '}';
            } else {
                // Just close the object
                repairedJson = repairedJson + '}';
            }
            
            try {
                const parsed = JSON.parse(repairedJson);
                console.log(`Successfully repaired incomplete object`);
                return parsed;
            } catch (e) {
                console.log(`Object repair failed: ${e.message}`);
            }
        }
        
        // Strategy 3: Try to extract valid objects even from malformed JSON
        if (repairedJson.includes('"category"') && repairedJson.includes('"content"')) {
            console.log(`Attempting to extract valid objects from malformed JSON...`);
            
            // Find all complete greeting objects using regex
            const objectRegex = /\{\s*"category"\s*:\s*"[^"]*"\s*,\s*"content"\s*:\s*"[^"]*"\s*(?:,\s*"content_vietnamese"\s*:\s*"[^"]*"\s*)?\}/g;
            const matches = repairedJson.match(objectRegex);
            
            if (matches && matches.length > 0) {
                try {
                    const extractedObjects = matches.map(match => JSON.parse(match));
                    console.log(`Successfully extracted ${extractedObjects.length} objects using regex`);
                    return extractedObjects;
                } catch (e) {
                    console.log(`Regex extraction failed: ${e.message}`);
                }
            }
        }
        
        // Strategy 4: Return empty array as fallback only if all strategies fail
        console.warn(`All repair strategies failed, returning empty array`);
        console.warn(`Original JSON preview: ${jsonString.substring(0, 300)}...`);
        return [];
    }
}

// Function to process a batch with retry logic
async function processBatchWithRetry(batch, batchIndex, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`Process ${config.processId}: Processing batch ${batchIndex + 1} with ${batch.length} greetings (attempt ${attempt}/${maxRetries})...`);
            
            const startTime = Date.now();
            
            const completion = await openai.chat.completions.create({
                model: "qwen-max",
                messages: [
                    {
                        "role": "system",
                        "content": "Bạn là một chuyên gia dịch thuật văn học tiếng Trung - tiếng Việt, có kinh nghiệm dịch các lời chào hỏi, lời chúc và thông điệp ý nghĩa. Nhiệm vụ của bạn là dịch các lời chào tiếng Trung sang tiếng Việt một cách tự nhiên, giữ nguyên ý nghĩa và tinh thần của văn bản gốc.\n\nYêu cầu:\n1. Giữ nguyên tất cả các trường gốc (category, content)\n2. Thêm trường 'content_vietnamese' - dịch content sang tiếng Việt\n3. Dịch phải tự nhiên, dễ hiểu và phù hợp với văn hóa Việt Nam\n4. Giữ nguyên tính chất ấm áp, tích cực của lời chào hỏi\n5. Dịch các thành ngữ và tục ngữ Trung Quốc một cách phù hợp\n\nTrả về JSON array hoàn chỉnh và hợp lệ.\n\nVí dụ format output:\n[\n  {\n    \"category\": \"日常\",\n    \"content\": \"快乐并不不远，嘴角常挂微笑，就行；幸福其实简单，凡事懂得知足，就行；健康也很容易，养生锻炼习惯，就行；好运就在身边，能够疼爱自己，就行！\",\n    \"content_vietnamese\": \"Hạnh phúc không xa, chỉ cần nụ cười thường trên môi là được; hạnh phúc thực ra đơn giản, biết biết đủ trong mọi việc là được; sức khỏe cũng dễ dàng, tập thói quen dưỡng sinh tập luyện là được; may mắn ngay bên cạnh, biết yêu thương bản thân là được!\"\n  }\n]"
                    },
                    {
                        "role": "user",
                        "content": JSON.stringify(batch)
                    }
                ],
                top_p: 0.8,
                temperature: 0.7,
                max_tokens: 4000, // Token limit for greetings
                timeout: 90000 // 90 second timeout
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
                    throw new Error(`Expected array, got ${typeof parsedResponse}`);
                }
                
                // Accept partial results if we got at least some valid data
                if (parsedResponse.length === 0 && batch.length > 0) {
                    throw new Error(`Got empty array for non-empty batch (${batch.length} items)`);
                }
                
                // If we got fewer items than expected, log a warning but continue
                if (parsedResponse.length < batch.length) {
                    console.warn(`Process ${config.processId}: Got ${parsedResponse.length} items but expected ${batch.length} for batch ${batchIndex + 1}`);
                    console.warn(`Process ${config.processId}: This may be due to response truncation, continuing with partial results...`);
                }
                
                console.log(`Process ${config.processId}: ✓ Successfully parsed JSON response for batch ${batchIndex + 1} (${parsedResponse.length}/${batch.length} greetings)`);
                
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
                console.error(`Process ${config.processId}: JSON parsing error for batch ${batchIndex + 1}:`, parseError.message);
                console.error(`Response content preview:`, responseContent.substring(0, 500));
                throw parseError;
            }
            
        } catch (error) {
            console.error(`Process ${config.processId}: ✗ Error processing batch ${batchIndex + 1} (attempt ${attempt}):`, error.message);
            
            // Check if this is a content filtering error
            const isContentFilterError = error.message.includes('inappropriate content') || 
                                        error.message.includes('data_inspection_failed') ||
                                        error.code === 'data_inspection_failed';
            
            if (attempt === maxRetries) {
                console.error(`Process ${config.processId}: Failed to process batch ${batchIndex + 1} after ${maxRetries} attempts`);
                
                // If this is a content filtering error or parsing error, try individual processing
                if (isContentFilterError || error.message.includes('Got empty array') || error.message.includes('parsing error')) {
                    console.log(`Process ${config.processId}: ${isContentFilterError ? 'Content filtering detected' : 'Parsing error detected'}, attempting individual processing for batch ${batchIndex + 1}...`);
                    try {
                        const individualResults = await processIndividualGreetings(batch, batchIndex);
                        console.log(`Process ${config.processId}: ✓ Individual processing succeeded for batch ${batchIndex + 1} (${individualResults.length} greetings)`);
                        return individualResults;
                    } catch (individualError) {
                        console.error(`Process ${config.processId}: Individual processing also failed:`, individualError.message);
                        
                        // If individual processing also fails due to content filtering, create placeholder entries
                        if (individualError.message.includes('inappropriate content') || individualError.message.includes('data_inspection_failed')) {
                            console.log(`Process ${config.processId}: Creating placeholder entries for filtered content in batch ${batchIndex + 1}`);
                            const placeholderResults = batch.map(greeting => ({
                                ...greeting,
                                content_vietnamese: "[Nội dung đã bị lọc] - Không thể dịch do chính sách an toàn nội dung",
                                error: "content_filtered",
                                errorMessage: "Content filtered by API safety policies",
                                timestamp: new Date().toISOString(),
                                processId: config.processId
                            }));
                            return placeholderResults;
                        }
                        
                        throw error; // Throw original error
                    }
                }
                
                throw error;
            }
            
            // For content filtering errors, don't retry - go straight to individual processing
            if (isContentFilterError && attempt === 1) {
                console.log(`Process ${config.processId}: Content filtering detected on first attempt, skipping retries and trying individual processing...`);
                attempt = maxRetries; // Skip remaining retries
                continue;
            }
            
            // Wait before retry
            const retryDelay = attempt * 3000;
            console.log(`Process ${config.processId}: Retrying batch ${batchIndex + 1} in ${retryDelay}ms...`);
            await new Promise(resolve => setTimeout(resolve, retryDelay));
        }
    }
}

// Fallback function to process greetings individually
async function processIndividualGreetings(batch, batchIndex) {
    console.log(`Process ${config.processId}: Processing ${batch.length} greetings individually for batch ${batchIndex + 1}...`);
    const results = [];
    
    for (let i = 0; i < batch.length; i++) {
        try {
            const greeting = batch[i];
            const completion = await openai.chat.completions.create({
                model: "qwen-max",
                messages: [
                    {
                        "role": "system", 
                        "content": "Bạn là một chuyên gia dịch thuật văn học tiếng Trung - tiếng Việt. Dịch lời chào tiếng Trung sang tiếng Việt, giữ nguyên các trường gốc và thêm content_vietnamese. Trả về JSON object hoàn chỉnh."
                    },
                    {
                        "role": "user",
                        "content": JSON.stringify(greeting)
                    }
                ],
                top_p: 0.8,
                temperature: 0.7,
                max_tokens: 1500
            });
            
            const responseContent = completion.choices[0].message.content;
            const jsonResponse = extractJsonFromResponse(responseContent);
            const parsedResponse = attemptJsonRepair(jsonResponse);
            
            if (parsedResponse && typeof parsedResponse === 'object') {
                results.push(parsedResponse);
            } else {
                results.push({
                    ...greeting,
                    content_vietnamese: "Dịch lỗi - " + greeting.content,
                    error: "Individual processing failed",
                    timestamp: new Date().toISOString()
                });
            }
            
            // Small delay between individual requests
            await new Promise(resolve => setTimeout(resolve, 1000));
            
        } catch (error) {
            console.error(`Process ${config.processId}: Error processing individual greeting ${batch[i].content.substring(0, 50)}...:`, error.message);
            
            // Check if this is a content filtering error
            const isContentFilterError = error.message.includes('inappropriate content') || 
                                        error.message.includes('data_inspection_failed') ||
                                        error.code === 'data_inspection_failed';
            
            if (isContentFilterError) {
                console.log(`Process ${config.processId}: Content filtered for greeting: ${batch[i].content.substring(0, 50)}...`);
                results.push({
                    ...batch[i],
                    content_vietnamese: "[Nội dung đã bị lọc] - Không thể dịch do chính sách an toàn nội dung",
                    error: "content_filtered", 
                    errorMessage: "Content filtered by API safety policies",
                    timestamp: new Date().toISOString(),
                    processId: config.processId
                });
            } else {
                results.push({
                    ...batch[i],
                    content_vietnamese: "Dịch lỗi - " + batch[i].content,
                    error: "Individual processing failed",
                    errorMessage: error.message,
                    timestamp: new Date().toISOString(),
                    processId: config.processId
                });
            }
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
    const outputPath = path.join('./output/greetings', filename);
    try {
        await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf8');
        console.log(`Process ${config.processId}: Results saved to ${outputPath}`);
    } catch (error) {
        console.error(`Process ${config.processId}: Error saving results to ${outputPath}:`, error);
    }
}

// Function to check if batch result already exists and is not an error
async function batchExists(batchIndex, totalBatches, processId) {
    const filename = `greeting_batch_${batchIndex + 1}_of_${totalBatches}_process_${processId}.json`;
    const outputPath = path.join('./output/greetings', filename);
    try {
        await fs.access(outputPath);
        
        // Check if the file contains an access denied error
        const content = await fs.readFile(outputPath, 'utf8');
        if (content.includes('400 Access denied, please make sure your account is in good standing')) {
            console.log(`Batch ${batchIndex + 1} exists but contains access denied error - will reprocess`);
            return false;
        }
        
        return true;
    } catch {
        return false;
    }
}

// Function to append to process-specific output file
async function appendToProcessFile(newData, processId) {
    const filename = `greetings-processed-process-${processId}.json`;
    const outputPath = path.join('./output/greetings', filename);
    try {
        let existingData = [];
        
        try {
            const existingContent = await fs.readFile(outputPath, 'utf8');
            if (existingContent.trim()) {
                existingData = JSON.parse(existingContent);
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
        await fs.mkdir('./output/greetings', { recursive: true });
        
        // Read input data
        console.log(`Process ${config.processId}: Reading input data...`);
        const inputPath = './input/greetings.json';
        const inputData = JSON.parse(await fs.readFile(inputPath, 'utf8'));
        
        console.log(`Process ${config.processId}: Loaded ${inputData.length} greetings from ${inputPath}`);
        
        // Split data into batches
        const batches = chunkArray(inputData, config.batchSize);
        console.log(`Process ${config.processId}: Split ${inputData.length} greetings into ${batches.length} total batches`);
        
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
                continue;
            }
            
            const batchProgress = processedCount + (i - startBatch) * config.batchSize;
            const totalAssigned = (endBatch - startBatch + 1) * config.batchSize;
            console.log(`Process ${config.processId}: Progress: ${batchProgress}/${totalAssigned} greetings processed (${Math.round(batchProgress/totalAssigned*100)}%)`);
            
            const batchResult = await processBatch(batches[i], i);
            allResults.push({
                batchIndex: i,
                batchSize: batches[i].length,
                result: batchResult,
                processId: config.processId,
                timestamp: new Date().toISOString()
            });
            
            // Save intermediate results after each batch
            const intermediateFilename = `greeting_batch_${i + 1}_of_${batches.length}_process_${config.processId}.json`;
            await saveResults(batchResult, intermediateFilename);
            
            // Append results to process-specific output file
            if (Array.isArray(batchResult)) {
                await appendToProcessFile(batchResult, config.processId);
            } else {
                await appendToProcessFile([batchResult], config.processId);
            }
            
            processedCount += batches[i].length;
            
            // Add delay between requests
            if (i < endBatch && i < batches.length - 1) {
                console.log(`Process ${config.processId}: Waiting ${config.batchDelay}ms before next batch...`);
                await new Promise(resolve => setTimeout(resolve, config.batchDelay));
            }
        }
        
        // Save complete results for this process
        const completeFilename = `greeting_complete_process_${config.processId}_${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
        await saveResults(allResults, completeFilename);
        
        console.log(`Process ${config.processId}: Processing completed successfully! Processed ${processedCount} greetings.`);
        
    } catch (error) {
        console.error(`Process ${config.processId}: Error in main function:`, error);
        process.exit(1);
    }
}

main();
