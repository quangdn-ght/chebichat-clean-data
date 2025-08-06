import fs from 'fs';

// Find the gaps in processed batches
console.log('=== FINDING GAPS IN PROCESSED BATCHES ===');

const totalBatches = 4903;
const processedBatches = new Set();

// Collect all processed batches
for (let processId = 1; processId <= 30; processId++) {
    const files = fs.readdirSync('./output').filter(f => 
        f.startsWith(`dict_batch_`) && f.endsWith(`_process_${processId}.json`)
    );
    
    files.forEach(f => {
        const match = f.match(/dict_batch_(\d+)_of_\d+_process_\d+\.json/);
        if (match) {
            processedBatches.add(parseInt(match[1]));
        }
    });
}

console.log(`Total processed batches: ${processedBatches.size}`);
console.log(`Total expected batches: ${totalBatches}`);

// Find gaps
const gaps = [];
let currentGapStart = null;

for (let i = 1; i <= totalBatches; i++) {
    if (!processedBatches.has(i)) {
        if (currentGapStart === null) {
            currentGapStart = i;
        }
    } else {
        if (currentGapStart !== null) {
            gaps.push({
                start: currentGapStart,
                end: i - 1,
                size: i - currentGapStart
            });
            currentGapStart = null;
        }
    }
}

// Handle case where gap extends to the end
if (currentGapStart !== null) {
    gaps.push({
        start: currentGapStart,
        end: totalBatches,
        size: totalBatches - currentGapStart + 1
    });
}

if (gaps.length > 0) {
    console.log(`\nFound ${gaps.length} gaps:`);
    gaps.forEach((gap, index) => {
        console.log(`Gap ${index + 1}: batches ${gap.start}-${gap.end} (${gap.size} batches missing)`);
    });
    
    const totalMissingBatches = gaps.reduce((sum, gap) => sum + gap.size, 0);
    const totalMissingItems = totalMissingBatches * 20; // Assuming 20 items per batch
    
    console.log(`\nTotal missing batches: ${totalMissingBatches}`);
    console.log(`Estimated missing items: ${totalMissingItems}`);
    
    // Calculate which processes should handle these gaps based on the expected assignment
    console.log('\n=== PROCESSES THAT SHOULD HANDLE MISSING BATCHES ===');
    const batchesPerProcess = 164;
    
    gaps.forEach((gap, index) => {
        console.log(`\nGap ${index + 1} (batches ${gap.start}-${gap.end}):`);
        for (let batchNum = gap.start; batchNum <= gap.end; batchNum++) {
            const expectedProcessId = Math.ceil(batchNum / batchesPerProcess);
            console.log(`  Batch ${batchNum} should be handled by process ${expectedProcessId}`);
        }
    });
} else {
    console.log('\nNo gaps found - all batches have been processed!');
    console.log('The issue might be in deduplication or merging of results.');
}

// Check if the issue is in the aggregated files
console.log('\n=== CHECKING AGGREGATED RESULTS ===');
const inputData = JSON.parse(fs.readFileSync('./input/DICTIONARY.json', 'utf8'));

for (let processId = 1; processId <= 30; processId++) {
    const processFile = `./output/dict-processed-process-${processId}.json`;
    try {
        const processData = JSON.parse(fs.readFileSync(processFile, 'utf8'));
        console.log(`Process ${processId}: ${processData.length} items in aggregated file`);
    } catch (e) {
        console.log(`Process ${processId}: No aggregated file found`);
    }
}
