const ImageMatcher = require('./image-matcher');
const path = require('path');

/**
 * Test script for Image Matcher functionality
 */
async function runTests() {
    console.log('🧪 Running Image Matcher Tests\n');
    
    const matcher = new ImageMatcher();
    
    // Test 1: Parse Chinese words
    console.log('Test 1: Parsing Chinese words');
    const testCases = [
        "棺材,眉毛,眼睛,鼻子,嘴巴,腿,手",
        "符号,字母,小写字母",
        "工具",
        "",
        "  植物  ,  水果  ,  食物  "
    ];
    
    testCases.forEach((testCase, index) => {
        const words = matcher.parseChineseWords(testCase);
        console.log(`  ${index + 1}. "${testCase}" -> [${words.join(', ')}] (${words.length} words)`);
    });
    
    console.log('\n✅ Word parsing tests completed\n');
    
    // Test 2: Load images data
    console.log('Test 2: Loading images data');
    try {
        const imagesPath = path.join(__dirname, 'qwen', 'dictionary', 'input', 'dict-images.json');
        const imagesData = matcher.loadImagesData(imagesPath);
        console.log(`  ✅ Successfully loaded ${imagesData.length} image entries`);
        
        // Show first few entries
        console.log('  📄 Sample entries:');
        imagesData.slice(0, 3).forEach((entry, index) => {
            const words = matcher.parseChineseWords(entry.chinese);
            console.log(`    ${index + 1}. ${entry.images}: "${entry.chinese}" (${words.length} words)`);
        });
        
    } catch (error) {
        console.log(`  ❌ Failed to load images data: ${error.message}`);
    }
    
    console.log('\n✅ Images data loading test completed\n');
    
    // Test 3: Database connection (optional)
    console.log('Test 3: Database connection');
    try {
        await matcher.testConnection();
        console.log('  ✅ Database connection successful');
        
        // Test word existence
        const testWords = ['人', '水', '不存在的词'];
        console.log('  🔍 Testing word existence:');
        
        for (const word of testWords) {
            const exists = await matcher.checkWordExists(word);
            console.log(`    "${word}": ${exists.length > 0 ? `Found (${exists.length} entries)` : 'Not found'}`);
        }
        
    } catch (error) {
        console.log(`  ⚠️  Database connection failed: ${error.message}`);
        console.log('    This is normal if database is not configured yet');
    } finally {
        await matcher.pool.end();
    }
    
    console.log('\n✅ All tests completed!');
}

// Run tests
if (require.main === module) {
    runTests().catch(error => {
        console.error('❌ Test error:', error.message);
        process.exit(1);
    });
}

module.exports = runTests;
