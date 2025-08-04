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
        maxBatches: 50 // Maximum batches to process per run
    };

    console.log(`API key:`, config.apiKey);

    // Parse arguments: --process-id=1 --total-processes=10 --max-batches=50
    for (let i = 0; i < args.length; i++) {
        const arg = args[i];
        if (arg.startsWith('--process-id=')) {
            config.processId = parseInt(arg.split('=')[1]);
        } else if (arg.startsWith('--total-processes=')) {
            config.totalProcesses = parseInt(arg.split('=')[1]);
        } else if (arg.startsWith('--max-batches=')) {
            config.maxBatches = parseInt(arg.split('=')[1]);
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

console.log(`Error Reprocessing - Process ${config.processId}/${config.totalProcesses} - Configuration:`);
console.log(`  Batch size: ${config.batchSize}`);
console.log(`  Delay: ${config.batchDelay}ms`);
console.log(`  Max batches per run: ${config.maxBatches}`);

const openai = new OpenAI({
    apiKey: config.apiKey,
    baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// Function to check if a file contains the access denied error
async function hasAccessDeniedError(filePath) {
    try {
        const content = await fs.readFile(filePath, 'utf8');
        return content.includes('400 Access denied, please make sure your account is in good standing');
    } catch (error) {
        console.error(`Error reading file ${filePath}:`, error.message);
        return false;
    }
}

// Function to extract batch information from filename
function extractBatchInfo(filename) {
    // Handle both regular and backup files
    const cleanFilename = filename.replace('.error-backup', '').replace('.backup', '');
    const match = cleanFilename.match(/dict_batch_(\d+)_of_(\d+)_process_(\d+)\.json/);
    if (match) {
        return {
            batchNumber: parseInt(match[1]),
            totalBatches: parseInt(match[2]),
            processId: parseInt(match[3])
        };
    }
    console.warn(`⚠ Filename pattern not recognized: ${filename} (cleaned: ${cleanFilename})`);
    return null;
}

// Function to get original batch data from input file
async function getOriginalBatchData(batchNumber, batchSize) {
    try {
        const inputPath = './input/DICTIONARY.json';
        const inputData = JSON.parse(await fs.readFile(inputPath, 'utf8'));
        
        const startIndex = (batchNumber - 1) * batchSize;
        const endIndex = Math.min(startIndex + batchSize, inputData.length);
        
        return inputData.slice(startIndex, endIndex);
    } catch (error) {
        console.error(`Error reading original batch data for batch ${batchNumber}:`, error.message);
        return null;
    }
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
async function processBatchWithRetry(batch, batchInfo, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`Reprocessing batch ${batchInfo.batchNumber} with ${batch.length} items (attempt ${attempt}/${maxRetries})...`);
            
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
                max_tokens: 4000,
                timeout: 60000
            });

            const endTime = Date.now();
            const responseTimeMs = endTime - startTime;
            const responseTimeSeconds = (responseTimeMs / 1000).toFixed(2);
            
            const responseContent = completion.choices[0].message.content;
            
            // Check if response was truncated
            if (completion.choices[0].finish_reason === 'length') {
                console.warn(`Response was truncated for batch ${batchInfo.batchNumber}, attempting to repair...`);
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
                
                console.log(`✓ Successfully reprocessed batch ${batchInfo.batchNumber} (${parsedResponse.length} items)`);
                
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
                    batchIndex: batchInfo.batchNumber,
                    processId: config.processId,
                    timestamp: new Date().toISOString(),
                    attempt: attempt,
                    finishReason: completion.choices[0].finish_reason,
                    reprocessed: true
                };
                
                return parsedResponse;
                
            } catch (parseError) {
                console.error(`✗ Failed to parse JSON response for batch ${batchInfo.batchNumber} (attempt ${attempt}):`, parseError.message);
                
                if (attempt === maxRetries) {
                    console.log(`Attempting individual word processing for batch ${batchInfo.batchNumber}...`);
                    return await processIndividualWords(batch, batchInfo);
                }
                
                // Wait before retry
                const retryDelay = attempt * 2000;
                console.log(`Retrying batch ${batchInfo.batchNumber} in ${retryDelay}ms...`);
                await new Promise(resolve => setTimeout(resolve, retryDelay));
                continue;
            }
            
        } catch (error) {
            console.error(`✗ Error processing batch ${batchInfo.batchNumber} (attempt ${attempt}):`, error.message);
            
            if (attempt === maxRetries) {
                return {
                    error: error.message,
                    batch: batch,
                    batchInfo: batchInfo,
                    timestamp: new Date().toISOString(),
                    attempts: maxRetries,
                    reprocessed: true
                };
            }
            
            const retryDelay = attempt * 2000;
            console.log(`Retrying batch ${batchInfo.batchNumber} in ${retryDelay}ms...`);
            await new Promise(resolve => setTimeout(resolve, retryDelay));
        }
    }
}

// Fallback function to process words individually
async function processIndividualWords(batch, batchInfo) {
    console.log(`Processing ${batch.length} words individually for batch ${batchInfo.batchNumber}...`);
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
                results.push({
                    chinese: word.word,
                    meaning_cn: word.meaning,
                    error: "Individual processing failed",
                    timestamp: new Date().toISOString()
                });
            }
            
            await new Promise(resolve => setTimeout(resolve, 500));
            
        } catch (error) {
            console.error(`Error processing individual word ${batch[i].word}:`, error.message);
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

// Function to save results to output file
async function saveResults(results, filename) {
    const outputPath = path.join('./output', filename);
    try {
        await fs.writeFile(outputPath, JSON.stringify(results, null, 2), 'utf8');
        console.log(`✓ Results saved to ${outputPath}`);
    } catch (error) {
        console.error(`✗ Error saving results to ${outputPath}:`, error);
    }
}

// Function to backup the original error file
async function backupErrorFile(filename) {
    const originalPath = path.join('./output', filename);
    const backupPath = path.join('./output', filename.replace('.json', '.error-backup.json'));
    
    try {
        await fs.copyFile(originalPath, backupPath);
        console.log(`✓ Backed up original error file to ${backupPath}`);
    } catch (error) {
        console.warn(`⚠ Could not backup error file ${filename}:`, error.message);
    }
}

async function main() {
    try {
        console.log('🔍 Scanning for files with "400 Access denied" errors...');
        
        // Get list of all output files (exclude backup files)
        const outputFiles = await fs.readdir('./output');
        const jsonFiles = outputFiles.filter(file => 
            file.endsWith('.json') && 
            file.startsWith('dict_batch_') && 
            !file.includes('.error-backup.') &&
            !file.includes('.backup.')
        );
        
        console.log(`📁 Found ${jsonFiles.length} batch files to check`);
        
        // Find files with access denied errors
        const errorFiles = [];
        for (const file of jsonFiles) {
            if (await hasAccessDeniedError(path.join('./output', file))) {
                errorFiles.push(file);
            }
        }
        
        console.log(`❌ Found ${errorFiles.length} files with access denied errors`);
        
        if (errorFiles.length === 0) {
            console.log('✅ No files with access denied errors found!');
            return;
        }
        
        // Sort error files by batch number for logical processing
        errorFiles.sort((a, b) => {
            const aInfo = extractBatchInfo(a);
            const bInfo = extractBatchInfo(b);
            return aInfo?.batchNumber - bInfo?.batchNumber;
        });
        
        // Calculate which files this process should handle
        const filesPerProcess = Math.ceil(errorFiles.length / config.totalProcesses);
        const startIndex = (config.processId - 1) * filesPerProcess;
        const endIndex = Math.min(startIndex + filesPerProcess, errorFiles.length);
        const assignedFiles = errorFiles.slice(startIndex, endIndex);
        
        // Limit the number of batches to process in this run
        const filesToProcess = assignedFiles.slice(0, config.maxBatches);
        
        console.log(`🔧 Process ${config.processId}/${config.totalProcesses} assigned ${assignedFiles.length} files`);
        console.log(`⚡ Processing ${filesToProcess.length} files in this run (max: ${config.maxBatches})`);
        
        if (filesToProcess.length === 0) {
            console.log('✅ No files assigned to this process');
            return;
        }
        
        let processedCount = 0;
        let successCount = 0;
        let errorCount = 0;
        
        for (const filename of filesToProcess) {
            const batchInfo = extractBatchInfo(filename);
            if (!batchInfo) {
                console.warn(`⚠ Could not extract batch info from ${filename} - skipping`);
                errorCount++;
                processedCount++;
                continue;
            }
            
            console.log(`\n🔄 [${processedCount + 1}/${filesToProcess.length}] Processing batch ${batchInfo.batchNumber}...`);
            
            // Get original batch data
            const originalBatch = await getOriginalBatchData(batchInfo.batchNumber, config.batchSize);
            if (!originalBatch) {
                console.error(`❌ Could not get original data for batch ${batchInfo.batchNumber}`);
                errorCount++;
                processedCount++;
                continue;
            }
            
            // Backup the error file
            await backupErrorFile(filename);
            
            // Process the batch
            const result = await processBatchWithRetry(originalBatch, batchInfo);
            
            // Save the new result
            await saveResults(result, filename);
            
            if (result.error) {
                errorCount++;
                console.error(`❌ Failed to reprocess batch ${batchInfo.batchNumber}`);
            } else {
                successCount++;
                console.log(`✅ Successfully reprocessed batch ${batchInfo.batchNumber}`);
            }
            
            processedCount++;
            
            // Add delay between batches
            if (processedCount < filesToProcess.length) {
                console.log(`⏳ Waiting ${config.batchDelay}ms before next batch...`);
                await new Promise(resolve => setTimeout(resolve, config.batchDelay));
            }
        }
        
        console.log(`\n📊 Reprocessing Summary:`);
        console.log(`   Total files processed: ${processedCount}`);
        console.log(`   Successful: ${successCount}`);
        console.log(`   Failed: ${errorCount}`);
        console.log(`   Remaining error files: ${assignedFiles.length - filesToProcess.length}`);
        console.log(`\n✅ Reprocessing completed!`);
        
        if (assignedFiles.length > filesToProcess.length) {
            console.log(`\n💡 To process remaining files, run the script again or increase --max-batches parameter.`);
        }
        
    } catch (error) {
        console.error('❌ Error in main function:', error);
        process.exit(1);
    }
}

main();
