import fs from 'fs/promises';
import { readFileSync } from 'fs';

// Split missing items into chunks for parallel processing
async function main() {
    try {
        console.log('=== PREPARING MISSING ITEMS FOR PARALLEL PROCESSING ===');
        
        // Read all missing items
        const allMissingItems = JSON.parse(await fs.readFile('./missing-items/all-missing-items.json', 'utf8'));
        console.log(`Total missing items: ${allMissingItems.length}`);
        
        // Configuration for parallel processing
        const processCount = 5; // Number of parallel processes
        const itemsPerProcess = Math.ceil(allMissingItems.length / processCount);
        
        console.log(`Splitting into ${processCount} processes with ~${itemsPerProcess} items each`);
        
        // Create output directory for split files
        await fs.mkdir('./missing-items-split', { recursive: true });
        
        // Split items into chunks
        for (let i = 0; i < processCount; i++) {
            const startIndex = i * itemsPerProcess;
            const endIndex = Math.min(startIndex + itemsPerProcess, allMissingItems.length);
            const chunk = allMissingItems.slice(startIndex, endIndex);
            
            if (chunk.length > 0) {
                const filename = `./missing-items-split/missing-items-chunk-${i + 1}.json`;
                await fs.writeFile(filename, JSON.stringify(chunk, null, 2), 'utf8');
                console.log(`Chunk ${i + 1}: ${chunk.length} items saved to ${filename}`);
            }
        }
        
        console.log('\n✓ Missing items split completed');
        console.log('Now run: npm run reprocess:parallel');
        
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

main();
