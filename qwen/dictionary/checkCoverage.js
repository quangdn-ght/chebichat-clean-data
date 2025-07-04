import fs from "fs/promises";

async function checkCoverage() {
    try {
        // Read input data
        const inputPath = './input/dict-full.json';
        const inputData = JSON.parse(await fs.readFile(inputPath, 'utf8'));
        
        console.log('📊 Dictionary Processing Coverage Analysis');
        console.log('==========================================');
        console.log(`Total items to process: ${inputData.length}`);
        console.log('');
        
        // Current configuration
        const batchSize = 20;
        const totalProcesses = 10;
        const currentBatchesPerProcess = 50;
        
        const currentCapacity = totalProcesses * currentBatchesPerProcess * batchSize;
        const currentCoverage = ((currentCapacity / inputData.length) * 100).toFixed(1);
        
        console.log('Current Configuration:');
        console.log(`  Processes: ${totalProcesses}`);
        console.log(`  Batch size: ${batchSize}`);
        console.log(`  Batches per process: ${currentBatchesPerProcess}`);
        console.log(`  Total capacity: ${currentCapacity} items`);
        console.log(`  Coverage: ${currentCoverage}%`);
        
        if (currentCapacity < inputData.length) {
            console.log(`  ❌ Missing: ${inputData.length - currentCapacity} items`);
        } else {
            console.log(`  ✅ Full coverage with ${currentCapacity - inputData.length} extra capacity`);
        }
        
        console.log('');
        
        // Calculate optimal configuration
        const totalBatches = Math.ceil(inputData.length / batchSize);
        const optimalBatchesPerProcess = Math.ceil(totalBatches / totalProcesses);
        const optimalCapacity = totalProcesses * optimalBatchesPerProcess * batchSize;
        
        console.log('Optimal Configuration:');
        console.log(`  Total batches needed: ${totalBatches}`);
        console.log(`  Optimal batches per process: ${optimalBatchesPerProcess}`);
        console.log(`  Optimal capacity: ${optimalCapacity} items`);
        console.log(`  Coverage: 100% (${optimalCapacity - inputData.length} extra capacity)`);
        
        console.log('');
        console.log('📝 Recommended ecosystem.config.js arguments:');
        console.log(`--process-id=X --total-processes=${totalProcesses} --batches-per-process=${optimalBatchesPerProcess}`);
        
        // Check existing results
        try {
            const outputDir = './output';
            const files = await fs.readdir(outputDir);
            const processFiles = files.filter(file => 
                file.startsWith('dict-processed-process-') && file.endsWith('.json')
            );
            
            let totalProcessed = 0;
            console.log('');
            console.log('📈 Current Progress:');
            
            for (const file of processFiles.sort()) {
                try {
                    const content = await fs.readFile(`${outputDir}/${file}`, 'utf8');
                    const data = JSON.parse(content);
                    if (Array.isArray(data)) {
                        totalProcessed += data.length;
                        const processId = file.match(/process-(\d+)\.json/)?.[1] || 'unknown';
                        console.log(`  Process ${processId}: ${data.length} items`);
                    }
                } catch (error) {
                    console.log(`  ${file}: Error reading file`);
                }
            }
            
            const progressPercent = ((totalProcessed / inputData.length) * 100).toFixed(1);
            console.log(`  Total processed: ${totalProcessed} / ${inputData.length} (${progressPercent}%)`);
            
            if (totalProcessed < inputData.length) {
                console.log(`  ⚠️  Still missing: ${inputData.length - totalProcessed} items`);
            } else {
                console.log(`  ✅ Processing complete!`);
            }
            
        } catch (error) {
            console.log('');
            console.log('📁 No output directory found - no processing started yet');
        }
        
    } catch (error) {
        console.error('Error checking coverage:', error);
    }
}

checkCoverage();
