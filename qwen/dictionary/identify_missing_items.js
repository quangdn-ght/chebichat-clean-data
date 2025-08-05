import fs from 'fs/promises';
import { readFileSync } from 'fs';

// Fix the batch range calculation and identify missing items
console.log('=== FIXING BATCH DISTRIBUTION ===');

const inputData = JSON.parse(readFileSync('./input/DICTIONARY.json', 'utf8'));
const batchSize = 20;
const totalBatches = Math.ceil(inputData.length / batchSize);
const totalProcesses = 30;

console.log(`Input items: ${inputData.length}`);
console.log(`Total batches: ${totalBatches}`);
console.log(`Total processes: ${totalProcesses}`);

// Correct batch distribution - ensure no overlaps
const batchesPerProcess = Math.ceil(totalBatches / totalProcesses);
console.log(`Batches per process (corrected): ${batchesPerProcess}`);

// Function to chunk array into smaller batches
function chunkArray(array, chunkSize) {
    const chunks = [];
    for (let i = 0; i < array.length; i += chunkSize) {
        chunks.push(array.slice(i, i + chunkSize));
    }
    return chunks;
}

const batches = chunkArray(inputData, batchSize);

// Calculate what each process SHOULD process (correct ranges)
const correctAssignments = {};
for (let processId = 1; processId <= totalProcesses; processId++) {
    const startBatch = (processId - 1) * batchesPerProcess;
    const endBatch = Math.min(startBatch + batchesPerProcess - 1, totalBatches - 1);
    
    if (startBatch < totalBatches) {
        correctAssignments[processId] = {
            startBatch: startBatch,
            endBatch: endBatch,
            batchCount: endBatch - startBatch + 1,
            items: []
        };
        
        // Calculate actual items for this process
        for (let i = startBatch; i <= endBatch && i < totalBatches; i++) {
            correctAssignments[processId].items.push(...batches[i]);
        }
        
        console.log(`Process ${processId}: batches ${startBatch + 1}-${endBatch + 1} (${correctAssignments[processId].items.length} items)`);
    }
}

// Check what's actually in each aggregated file vs what should be there
console.log('\n=== COMPARING ACTUAL VS EXPECTED CONTENT ===');

let totalExpectedItems = 0;
let totalActualItems = 0;
const missingItemsByProcess = {};
const allActualWords = new Map(); // Track all words and which processes have them
const duplicateWords = new Map(); // Track duplicated words

for (let processId = 1; processId <= totalProcesses; processId++) {
    if (!correctAssignments[processId]) continue;
    
    const expectedItems = correctAssignments[processId].items;
    totalExpectedItems += expectedItems.length;
    
    // Read actual aggregated file
    const processFile = `./output/dict-processed-process-${processId}.json`;
    let actualItems = [];
    
    try {
        actualItems = JSON.parse(readFileSync(processFile, 'utf8'));
        totalActualItems += actualItems.length;
        
        // Track all words and detect duplicates across processes
        for (const item of actualItems) {
            const word = item.chinese || item.word;
            if (word) {
                if (allActualWords.has(word)) {
                    // This word exists in another process - it's a duplicate
                    const existingProcesses = allActualWords.get(word);
                    existingProcesses.push(processId);
                    duplicateWords.set(word, existingProcesses);
                } else {
                    allActualWords.set(word, [processId]);
                }
            }
        }
        
    } catch (e) {
        console.log(`Process ${processId}: No aggregated file found`);
    }
    
    const difference = expectedItems.length - actualItems.length;
    if (difference !== 0) {
        console.log(`Process ${processId}: expected ${expectedItems.length}, actual ${actualItems.length}, difference ${difference}`);
        
        if (difference > 0) {
            // Find which specific items are missing by comparing word values
            const expectedWords = new Set(expectedItems.map(item => item.word));
            const actualWords = new Set(actualItems.map(item => item.chinese || item.word));
            
            const missingWords = [];
            for (const word of expectedWords) {
                if (!actualWords.has(word)) {
                    missingWords.push(expectedItems.find(item => item.word === word));
                }
            }
            
            missingItemsByProcess[processId] = missingWords;
            console.log(`  First few missing words: ${missingWords.slice(0, 5).map(item => item.word).join(', ')}`);
        }
    }
}

console.log(`\nTotal expected items: ${totalExpectedItems}`);
console.log(`Total actual items: ${totalActualItems}`);
console.log(`Total missing items: ${totalExpectedItems - totalActualItems}`);

// Analyze duplicates
console.log('\n=== DUPLICATE ANALYSIS ===');
console.log(`Total unique words in all processes: ${allActualWords.size}`);
console.log(`Total duplicated words: ${duplicateWords.size}`);

if (duplicateWords.size > 0) {
    let totalDuplicateInstances = 0;
    for (const [word, processes] of duplicateWords) {
        totalDuplicateInstances += processes.length - 1; // -1 because original is not a duplicate
    }
    
    console.log(`Total duplicate instances: ${totalDuplicateInstances}`);
    console.log(`Expected total without duplicates: ${totalActualItems - totalDuplicateInstances}`);
    
    console.log('\nFirst 10 duplicated words:');
    let count = 0;
    for (const [word, processes] of duplicateWords) {
        if (count >= 10) break;
        console.log(`  "${word}": found in processes ${processes.join(', ')}`);
        count++;
    }
    
    // Save duplicate analysis
    const duplicateAnalysis = {
        totalUniqueWords: allActualWords.size,
        totalDuplicatedWords: duplicateWords.size,
        totalDuplicateInstances: totalDuplicateInstances,
        duplicateWords: Object.fromEntries(duplicateWords)
    };
    
    const missingDir = './missing-items';
    try {
        await fs.access(missingDir);
    } catch {
        await fs.mkdir(missingDir, { recursive: true });
    }
    
    await fs.writeFile(`${missingDir}/duplicate-analysis.json`, JSON.stringify(duplicateAnalysis, null, 2), 'utf8');
    console.log(`\nDuplicate analysis saved to ${missingDir}/duplicate-analysis.json`);
}

// Save missing items for each process that can be reprocessed
console.log('\n=== SAVING MISSING ITEMS FOR REPROCESSING ===');

const missingDir = './missing-items';
try {
    await fs.access(missingDir);
} catch {
    await fs.mkdir(missingDir, { recursive: true });
}

// Only save missing items if there are actually missing items (not just duplicates)
let actualMissingCount = 0;
for (const [processId, missingItems] of Object.entries(missingItemsByProcess)) {
    if (missingItems.length > 0) {
        const filename = `${missingDir}/missing-items-process-${processId}.json`;
        await fs.writeFile(filename, JSON.stringify(missingItems, null, 2), 'utf8');
        console.log(`Saved ${missingItems.length} missing items for process ${processId} to ${filename}`);
        actualMissingCount += missingItems.length;
    }
}

// Create a summary of all missing items
const allMissingItems = [];
for (const missingItems of Object.values(missingItemsByProcess)) {
    allMissingItems.push(...missingItems);
}

if (allMissingItems.length > 0) {
    const allMissingFile = `${missingDir}/all-missing-items.json`;
    await fs.writeFile(allMissingFile, JSON.stringify(allMissingItems, null, 2), 'utf8');
    console.log(`\nSaved all ${allMissingItems.length} missing items to ${allMissingFile}`);
    
    console.log('\n=== NEXT STEPS ===');
    console.log('1. Review the missing items files');
    console.log('2. Run a targeted processing job for these missing items');
    console.log('3. Merge the results back into the main aggregated files');
} else {
    console.log('\n=== NO MISSING ITEMS FOUND ===');
    if (duplicateWords.size > 0) {
        console.log('The discrepancy is due to duplicate items across processes.');
        console.log('Consider running a deduplication process instead of reprocessing.');
        console.log('');
        console.log('Next steps:');
        console.log('1. Create deduplicated files by removing duplicates');
        console.log('2. Verify final count matches expected total');
    } else {
        console.log('All items are properly processed. No action needed.');
    }
}
