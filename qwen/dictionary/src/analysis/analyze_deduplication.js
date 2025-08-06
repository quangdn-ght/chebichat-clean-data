import fs from 'fs';

console.log('=== ANALYZING THE DEDUPLICATION ISSUE ===');

const totalBatches = 4903;
const batchSize = 20;
const inputData = JSON.parse(fs.readFileSync('./input/DICTIONARY.json', 'utf8'));

// Find batches that were processed by multiple processes
const batchProcessors = {};
for (let processId = 1; processId <= 30; processId++) {
    const files = fs.readdirSync('./output').filter(f => 
        f.startsWith(`dict_batch_`) && f.endsWith(`_process_${processId}.json`)
    );
    
    files.forEach(f => {
        const match = f.match(/dict_batch_(\d+)_of_\d+_process_\d+\.json/);
        if (match) {
            const batchNum = parseInt(match[1]);
            if (!batchProcessors[batchNum]) {
                batchProcessors[batchNum] = [];
            }
            batchProcessors[batchNum].push(processId);
        }
    });
}

// Find duplicated batches
const duplicatedBatches = {};
let totalDuplicatedItems = 0;

for (const [batchNum, processors] of Object.entries(batchProcessors)) {
    if (processors.length > 1) {
        const batchIndex = parseInt(batchNum) - 1;
        const startItem = batchIndex * batchSize;
        const endItem = Math.min(startItem + batchSize, inputData.length);
        const itemsInBatch = endItem - startItem;
        
        duplicatedBatches[batchNum] = {
            processors: processors,
            items: itemsInBatch,
            duplicates: processors.length - 1
        };
        totalDuplicatedItems += itemsInBatch * (processors.length - 1);
    }
}

console.log(`Duplicated batches: ${Object.keys(duplicatedBatches).length}`);
console.log(`Total items processed multiple times: ${totalDuplicatedItems}`);

// Calculate expected items per process
const expectedItemsPerProcess = {};
const batchesPerProcess = 164;

for (let processId = 1; processId <= 30; processId++) {
    const startBatch = (processId - 1) * batchesPerProcess;
    const endBatch = Math.min(startBatch + batchesPerProcess - 1, totalBatches - 1);
    
    let expectedItems = 0;
    for (let i = startBatch; i <= endBatch && i < totalBatches; i++) {
        const batchStart = i * batchSize;
        const batchEnd = Math.min(batchStart + batchSize, inputData.length);
        expectedItems += (batchEnd - batchStart);
    }
    expectedItemsPerProcess[processId] = expectedItems;
}

// Compare with actual items in aggregated files
console.log('\n=== EXPECTED VS ACTUAL ITEMS PER PROCESS ===');
let totalExpected = 0;
let totalActual = 0;

for (let processId = 1; processId <= 30; processId++) {
    const expected = expectedItemsPerProcess[processId];
    totalExpected += expected;
    
    const processFile = `./output/dict-processed-process-${processId}.json`;
    let actual = 0;
    try {
        const processData = JSON.parse(fs.readFileSync(processFile, 'utf8'));
        actual = processData.length;
    } catch (e) {
        // File doesn't exist
    }
    totalActual += actual;
    
    const difference = actual - expected;
    if (difference !== 0) {
        console.log(`Process ${processId}: expected ${expected}, actual ${actual}, difference ${difference}`);
    }
}

console.log(`\nTotal expected across all processes: ${totalExpected}`);
console.log(`Total actual across all processes: ${totalActual}`);
console.log(`Overall difference: ${totalActual - totalExpected}`);

// Check for batches with errors that might not have been properly aggregated
console.log('\n=== CHECKING FOR ERROR BATCHES ===');
let errorBatches = 0;
let errorItems = 0;

for (let batchNum = 1; batchNum <= totalBatches; batchNum++) {
    const processors = batchProcessors[batchNum];
    if (!processors || processors.length === 0) continue;
    
    // Check if any version of this batch has errors
    for (const processId of processors) {
        const filename = `./output/dict_batch_${batchNum}_of_${totalBatches}_process_${processId}.json`;
        try {
            const content = fs.readFileSync(filename, 'utf8');
            const data = JSON.parse(content);
            
            if (data.error || (Array.isArray(data) && data.some(item => item.error))) {
                console.log(`Batch ${batchNum} (process ${processId}): contains errors`);
                errorBatches++;
                
                const batchIndex = batchNum - 1;
                const startItem = batchIndex * batchSize;
                const endItem = Math.min(startItem + batchSize, inputData.length);
                errorItems += (endItem - startItem);
                break; // Only count once per batch
            }
        } catch (e) {
            console.log(`Batch ${batchNum} (process ${processId}): could not read file`);
        }
    }
}

console.log(`Batches with errors: ${errorBatches}`);
console.log(`Items in error batches: ${errorItems}`);

console.log('\n=== SUMMARY ===');
console.log(`Input items: ${inputData.length}`);
console.log(`Items processed multiple times: ${totalDuplicatedItems}`);
console.log(`Items in error batches: ${errorItems}`);
console.log(`Net items that should be available: ${inputData.length}`);
console.log(`Actual items aggregated: ${totalActual}`);
console.log(`Missing items: ${inputData.length - totalActual}`);
