import fs from 'fs';

const inputData = JSON.parse(fs.readFileSync('./input/DICTIONARY.json', 'utf8'));
const batchSize = 20;
const totalBatches = Math.ceil(inputData.length / batchSize);
const totalProcesses = 30;
const batchesPerProcess = 60;

console.log('=== ANALYSIS OF BATCH DISTRIBUTION ===');
console.log('Input items:', inputData.length);
console.log('Batch size:', batchSize);
console.log('Total batches needed:', totalBatches);
console.log('Total processes:', totalProcesses);
console.log('Batches per process (config):', batchesPerProcess);

const batchesPerProcessOptimal = Math.ceil(totalBatches / totalProcesses);
console.log('Optimal batches per process:', batchesPerProcessOptimal);

const actualBatchesPerProcess = Math.max(batchesPerProcess, batchesPerProcessOptimal);
console.log('Actual batches per process used:', actualBatchesPerProcess);

console.log('\n=== CAPACITY ANALYSIS ===');
console.log('Total capacity:', totalProcesses * actualBatchesPerProcess * batchSize);
console.log('Coverage:', ((totalProcesses * actualBatchesPerProcess * batchSize / inputData.length) * 100).toFixed(1) + '%');

console.log('\n=== BATCH DISTRIBUTION ===');
let totalItemsAssigned = 0;
let lastBatchProcessed = -1;

for (let processId = 1; processId <= totalProcesses; processId++) {
    const startBatch = (processId - 1) * actualBatchesPerProcess;
    const endBatch = Math.min(startBatch + actualBatchesPerProcess - 1, totalBatches - 1);
    const actualBatches = endBatch >= startBatch ? endBatch - startBatch + 1 : 0;
    
    if (actualBatches > 0) {
        // Calculate actual items in these batches
        let itemsInBatches = 0;
        for (let i = startBatch; i <= endBatch && i < totalBatches; i++) {
            const batchStart = i * batchSize;
            const batchEnd = Math.min(batchStart + batchSize, inputData.length);
            itemsInBatches += (batchEnd - batchStart);
            lastBatchProcessed = i;
        }
        
        totalItemsAssigned += itemsInBatches;
        console.log(`Process ${processId}: batches ${startBatch + 1} to ${endBatch + 1} (${actualBatches} batches, ${itemsInBatches} items)`);
    } else {
        console.log(`Process ${processId}: no batches assigned`);
    }
}

console.log('\n=== SUMMARY ===');
console.log('Total items assigned:', totalItemsAssigned);
console.log('Items not processed:', inputData.length - totalItemsAssigned);
console.log('Last batch processed:', lastBatchProcessed + 1, '/', totalBatches);

if (lastBatchProcessed < totalBatches - 1) {
    console.log('\n=== MISSING BATCHES ===');
    const firstMissingBatch = lastBatchProcessed + 1;
    const lastMissingBatch = totalBatches - 1;
    let missingItems = 0;
    
    for (let i = firstMissingBatch; i <= lastMissingBatch; i++) {
        const batchStart = i * batchSize;
        const batchEnd = Math.min(batchStart + batchSize, inputData.length);
        const itemsInBatch = batchEnd - batchStart;
        missingItems += itemsInBatch;
        console.log(`Missing batch ${i + 1}: items ${batchStart + 1} to ${batchEnd} (${itemsInBatch} items)`);
    }
    
    console.log(`Total missing items: ${missingItems}`);
}
