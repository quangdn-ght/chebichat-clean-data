import fs from "fs/promises";
import path from "path";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

async function testSetup() {
    try {
        console.log('Testing setup...');
        
        // Check if input file exists
        const inputPath = './input/radical-suggest.json';
        const inputData = JSON.parse(await fs.readFile(inputPath, 'utf8'));
        console.log(`✓ Input file loaded: ${inputData.length} items`);
        
        // Check first few items structure
        console.log('First 3 items:');
        inputData.slice(0, 3).forEach((item, index) => {
            console.log(`  ${index + 1}:`, item);
        });
        
        // Check output directory
        const outputDir = './output';
        try {
            await fs.access(outputDir);
            console.log('✓ Output directory exists');
        } catch {
            console.log('✗ Output directory does not exist');
        }
        
        // Test chunking function
        function chunkArray(array, chunkSize) {
            const chunks = [];
            for (let i = 0; i < array.length; i += chunkSize) {
                chunks.push(array.slice(i, i + chunkSize));
            }
            return chunks;
        }
        
        const testBatches = chunkArray(inputData, 100);
        console.log(`✓ Data can be split into ${testBatches.length} batches of 100 items`);
        console.log(`  First batch size: ${testBatches[0].length}`);
        console.log(`  Last batch size: ${testBatches[testBatches.length - 1].length}`);
        
        // Check environment variable (without showing the value)
        const hasApiKey = !!process.env.DASHSCOPE_API_KEY;
        console.log(`${hasApiKey ? '✓' : '✗'} DASHSCOPE_API_KEY environment variable ${hasApiKey ? 'is set' : 'is NOT set'}`);
        
        console.log('\nSetup test completed successfully!');
        
    } catch (error) {
        console.error('Setup test failed:', error);
    }
}

testSetup();
