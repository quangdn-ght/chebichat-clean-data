import fs from 'fs';

// Find missing batches by checking which batch files exist
console.log('=== FINDING MISSING BATCHES ===');

const totalBatches = 4903;
const missingBatches = [];

for (let batchNum = 1; batchNum <= totalBatches; batchNum++) {
    let found = false;
    
    for (let processId = 1; processId <= 30; processId++) {
        const filename = `./output/dict_batch_${batchNum}_of_${totalBatches}_process_${processId}.json`;
        try {
            fs.accessSync(filename);
            found = true;
            break;
        } catch (e) {
            // File doesn't exist
        }
    }
    
    if (!found) {
        missingBatches.push(batchNum);
    }
}

console.log(`Total missing batches: ${missingBatches.length}`);
if (missingBatches.length > 0) {
    console.log('Missing batch numbers:', missingBatches.slice(0, 50), missingBatches.length > 50 ? '...' : '');
    
    // Calculate missing items
    const batchSize = 20;
    const inputData = JSON.parse(fs.readFileSync('./input/DICTIONARY.json', 'utf8'));
    let missingItems = 0;
    
    for (const batchNum of missingBatches) {
        const batchIndex = batchNum - 1;
        const startItem = batchIndex * batchSize;
        const endItem = Math.min(startItem + batchSize, inputData.length);
        missingItems += (endItem - startItem);
    }
    
    console.log(`Total missing items: ${missingItems}`);
    console.log(`Expected total items: ${inputData.length}`);
    console.log(`Should be processed: ${inputData.length - missingItems}`);
}

// Check for duplicate batch processing
console.log('\n=== CHECKING FOR DUPLICATE PROCESSING ===');
const batchToProcessMap = {};

for (let processId = 1; processId <= 30; processId++) {
    const files = fs.readdirSync('./output').filter(f => 
        f.startsWith(`dict_batch_`) && f.endsWith(`_process_${processId}.json`)
    );
    
    for (const file of files) {
        const match = file.match(/dict_batch_(\d+)_of_\d+_process_\d+\.json/);
        if (match) {
            const batchNum = parseInt(match[1]);
            if (!batchToProcessMap[batchNum]) {
                batchToProcessMap[batchNum] = [];
            }
            batchToProcessMap[batchNum].push(processId);
        }
    }
}

const duplicates = {};
for (const [batchNum, processes] of Object.entries(batchToProcessMap)) {
    if (processes.length > 1) {
        duplicates[batchNum] = processes;
    }
}

if (Object.keys(duplicates).length > 0) {
    console.log('Duplicate processing found:');
    for (const [batchNum, processes] of Object.entries(duplicates)) {
        console.log(`Batch ${batchNum}: processed by processes ${processes.join(', ')}`);
    }
} else {
    console.log('No duplicate processing found.');
}
