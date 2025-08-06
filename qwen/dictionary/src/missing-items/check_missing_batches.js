import fs from 'fs';

// Find what batches should have been processed by each process vs what was actually processed
console.log('=== EXPECTED VS ACTUAL BATCH ASSIGNMENTS ===');

const totalBatches = 4903;
const totalProcesses = 30;
const batchesPerProcess = 164; // From analysis
const batchSize = 20;

// Expected assignments
const expectedAssignments = {};
for (let processId = 1; processId <= totalProcesses; processId++) {
    const startBatch = (processId - 1) * batchesPerProcess;
    const endBatch = Math.min(startBatch + batchesPerProcess - 1, totalBatches - 1);
    expectedAssignments[processId] = {
        start: startBatch + 1,
        end: endBatch + 1,
        count: endBatch >= startBatch ? endBatch - startBatch + 1 : 0
    };
}

// Actual assignments
const actualAssignments = {};
for (let processId = 1; processId <= totalProcesses; processId++) {
    const files = fs.readdirSync('./output').filter(f => 
        f.startsWith(`dict_batch_`) && f.endsWith(`_process_${processId}.json`)
    );
    
    const batches = files.map(f => {
        const match = f.match(/dict_batch_(\d+)_of_\d+_process_\d+\.json/);
        return match ? parseInt(match[1]) : null;
    }).filter(b => b !== null).sort((a, b) => a - b);
    
    actualAssignments[processId] = {
        batches: batches,
        count: batches.length,
        min: batches.length > 0 ? Math.min(...batches) : 0,
        max: batches.length > 0 ? Math.max(...batches) : 0
    };
}

// Find completely missing batches
const processedBatches = new Set();
for (let processId = 1; processId <= totalProcesses; processId++) {
    actualAssignments[processId].batches.forEach(b => processedBatches.add(b));
}

const missingBatches = [];
for (let i = 1; i <= totalBatches; i++) {
    if (!processedBatches.has(i)) {
        missingBatches.push(i);
    }
}

console.log(`Total missing batches: ${missingBatches.length}`);
if (missingBatches.length > 0) {
    console.log('First 20 missing batches:', missingBatches.slice(0, 20));
    
    // Calculate missing items
    let missingItems = missingBatches.length * batchSize;
    // Adjust for the last batch which might have fewer items
    const inputData = JSON.parse(fs.readFileSync('./input/DICTIONARY.json', 'utf8'));
    const lastBatch = Math.ceil(inputData.length / batchSize);
    if (missingBatches.includes(lastBatch)) {
        const lastBatchItems = inputData.length - (lastBatch - 1) * batchSize;
        missingItems = missingItems - batchSize + lastBatchItems;
    }
    
    console.log(`Estimated missing items: ${missingItems}`);
}

// Show first few processes comparison
console.log('\n=== PROCESS COMPARISON (first 10) ===');
for (let processId = 1; processId <= 10; processId++) {
    const expected = expectedAssignments[processId];
    const actual = actualAssignments[processId];
    
    console.log(`Process ${processId}:`);
    console.log(`  Expected: batches ${expected.start}-${expected.end} (${expected.count} batches)`);
    console.log(`  Actual: batches ${actual.min}-${actual.max} (${actual.count} batches)`);
    
    if (actual.count !== expected.count) {
        console.log(`  ⚠️  Mismatch: expected ${expected.count}, got ${actual.count}`);
    }
}
