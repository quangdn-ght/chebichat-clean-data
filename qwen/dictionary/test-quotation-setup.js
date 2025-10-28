import fs from "fs/promises";
import path from "path";

// Create a small test file with sample quotations
async function createTestFile() {
    const testQuotations = [
        {
            "title": "人逢绝境再重生，守得云开见月明",
            "category": "经典语录",
            "content": "人逢绝境再重生，守得云开见月明。就是因为无知，才不怕；就是因为简单，才直接；就是因为绝望，才敢拼，所以不知不觉才成功。成功不是因为你有多聪明多能耐，而是你比别人更懂得去多做少说和谦虚低调加勤快。",
            "images": "test1.jpg"
        },
        {
            "title": "把苦涩尝遍，就会自然回甘",
            "category": "经典的话",
            "content": "人只有将寂寞坐断，才可以重拾喧闹；把悲伤过尽，才可以重见欢颜；把苦涩尝遍，就会自然回甘。",
            "images": "test2.jpg"
        }
    ];

    // Ensure test directory exists
    await fs.mkdir('./test-input', { recursive: true });
    
    // Write test file
    const testPath = './test-input/quotations-test.json';
    await fs.writeFile(testPath, JSON.stringify(testQuotations, null, 2), 'utf8');
    
    console.log(`Test file created at: ${testPath}`);
    console.log(`Test data contains ${testQuotations.length} quotations`);
    
    return testPath;
}

// Test the quotation generator with a small sample
async function testQuotationGenerator() {
    try {
        const testFilePath = await createTestFile();
        console.log(`Created test file: ${testFilePath}`);
        console.log('\nTo run the test, execute:');
        console.log('cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary');
        console.log('cp test-input/quotations-test.json input/quotations.json');
        console.log('node src/core/quotationGenerate.js --process-id=1 --total-processes=1 --batches-per-process=10');
        
    } catch (error) {
        console.error('Error creating test setup:', error);
    }
}

testQuotationGenerator();
