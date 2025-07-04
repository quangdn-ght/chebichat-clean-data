import fs from "fs/promises";
import path from "path";

async function mergeProcessResults() {
    try {
        const outputDir = './output';
        
        // Ensure output directory exists
        await fs.mkdir(outputDir, { recursive: true });
        
        const files = await fs.readdir(outputDir);
        
        // Find all process-specific result files
        const processFiles = files.filter(file => 
            file.startsWith('dict-processed-process-') && file.endsWith('.json')
        );
        
        console.log(`Found ${processFiles.length} process result files`);
        
        if (processFiles.length === 0) {
            console.log('No process files found to merge');
            return;
        }
        
        let allResults = [];
        let totalItems = 0;
        
        // Read and merge all process files
        for (const file of processFiles.sort()) {
            const filePath = path.join(outputDir, file);
            try {
                const content = await fs.readFile(filePath, 'utf8');
                const data = JSON.parse(content);
                
                if (Array.isArray(data)) {
                    allResults.push(...data);
                    totalItems += data.length;
                    console.log(`✓ Merged ${data.length} items from ${file}`);
                } else {
                    console.log(`⚠ Skipped ${file} - not an array`);
                }
            } catch (error) {
                console.error(`✗ Error reading ${file}:`, error.message);
            }
        }
        
        console.log(`\nTotal items to merge: ${totalItems}`);
        
        // Sort by process ID and batch index if metadata exists
        allResults.sort((a, b) => {
            const aProcessId = a._metadata?.processId || 0;
            const bProcessId = b._metadata?.processId || 0;
            const aBatchIndex = a._metadata?.batchIndex || 0;
            const bBatchIndex = b._metadata?.batchIndex || 0;
            
            if (aProcessId !== bProcessId) {
                return aProcessId - bProcessId;
            }
            return aBatchIndex - bBatchIndex;
        });
        
        // Save merged results
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const mergedPath = path.join(outputDir, `dict-processed-merged-${timestamp}.json`);
        
        await fs.writeFile(mergedPath, JSON.stringify(allResults, null, 2), 'utf8');
        
        console.log(`\n✓ Successfully merged ${allResults.length} total items to ${mergedPath}`);
        
        // Create summary statistics
        const summary = {
            totalItems: allResults.length,
            processedFiles: processFiles.length,
            mergedAt: new Date().toISOString(),
            fileBreakdown: {}
        };
        
        // Count items per process
        allResults.forEach(item => {
            const processId = item._metadata?.processId || 'unknown';
            if (!summary.fileBreakdown[processId]) {
                summary.fileBreakdown[processId] = 0;
            }
            summary.fileBreakdown[processId]++;
        });
        
        const summaryPath = path.join(outputDir, `merge-summary-${timestamp}.json`);
        await fs.writeFile(summaryPath, JSON.stringify(summary, null, 2), 'utf8');
        
        console.log(`✓ Summary saved to ${summaryPath}`);
        console.log('\nBreakdown by process:');
        Object.entries(summary.fileBreakdown).forEach(([processId, count]) => {
            console.log(`  Process ${processId}: ${count} items`);
        });
        
    } catch (error) {
        console.error('Error merging results:', error);
        process.exit(1);
    }
}

// Check if script is run directly
if (import.meta.url === `file://${process.argv[1]}`) {
    mergeProcessResults();
}

export default mergeProcessResults;