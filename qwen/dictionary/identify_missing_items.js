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
    } catch (e) {
        console.log(`Process ${processId}: No aggregated file found`);
    }
    
    const difference = expectedItems.length - actualItems.length;
    if (difference !== 0) {
        console.log(`Process ${processId}: expected ${expectedItems.length}, actual ${actualItems.length}, missing ${difference}`);
        
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

// Save missing items for each process that can be reprocessed
console.log('\n=== SAVING MISSING ITEMS FOR REPROCESSING ===');

const missingDir = './missing-items';
try {
    await fs.access(missingDir);
} catch {
    await fs.mkdir(missingDir, { recursive: true });
}

for (const [processId, missingItems] of Object.entries(missingItemsByProcess)) {
    if (missingItems.length > 0) {
        const filename = `${missingDir}/missing-items-process-${processId}.json`;
        await fs.writeFile(filename, JSON.stringify(missingItems, null, 2), 'utf8');
        console.log(`Saved ${missingItems.length} missing items for process ${processId} to ${filename}`);
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
}
