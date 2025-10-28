import fs from 'fs/promises';
import path from 'path';
import { spawn } from 'child_process';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Mock the greetingGenerate module by temporarily creating test input
async function createTestGreetings() {
    const testGreetings = [
        {
            "category": "日常",
            "content": "快乐并不不远，嘴角常挂微笑，就行；幸福其实简单，凡事懂得知足，就行。"
        },
        {
            "category": "节日",
            "content": "新年快乐！愿你在新的一年里身体健康，工作顺利，家庭幸福。"
        },
        {
            "category": "祝福",
            "content": "祝你前程似锦，事业有成，爱情甜蜜，家庭和睦。"
        }
    ];

    // Ensure test directories exist
    await fs.mkdir('./test-input', { recursive: true });
    await fs.mkdir('./test-output/greetings', { recursive: true });
    
    // Write test file
    const testPath = './test-input/greetings-test.json';
    await fs.writeFile(testPath, JSON.stringify(testGreetings, null, 2), 'utf8');
    
    console.log(`✅ Test file created at: ${testPath}`);
    console.log(`📊 Test data contains ${testGreetings.length} greetings`);
    
    return { testPath, testGreetings };
}

// Function to validate greeting output structure
function validateGreetingOutput(greeting, originalGreeting) {
    const errors = [];
    
    // Check required fields exist
    if (!greeting.category) errors.push('Missing category field');
    if (!greeting.content) errors.push('Missing content field');
    if (!greeting.content_vietnamese) errors.push('Missing content_vietnamese field');
    
    // Check fields match original
    if (greeting.category !== originalGreeting.category) {
        errors.push(`Category mismatch: expected "${originalGreeting.category}", got "${greeting.category}"`);
    }
    if (greeting.content !== originalGreeting.content) {
        errors.push(`Content mismatch: expected "${originalGreeting.content}", got "${greeting.content}"`);
    }
    
    // Check Vietnamese translation exists and is reasonable
    if (greeting.content_vietnamese && greeting.content_vietnamese.length < 10) {
        errors.push('Vietnamese translation seems too short');
    }
    
    if (greeting.content_vietnamese === greeting.content) {
        errors.push('Vietnamese translation is identical to Chinese original');
    }
    
    return errors;
}

// Function to test the greeting generator with small sample
async function runGreetingGeneratorTest() {
    try {
        console.log('🧪 Starting Greeting Generator Unit Test');
        console.log('=====================================\n');
        
        // Create test data
        const { testPath, testGreetings } = await createTestGreetings();
        
        // Backup original input file if it exists
        const originalInputPath = './input/greetings.json';
        const backupPath = './input/greetings-backup.json';
        let needsRestore = false;
        
        try {
            await fs.access(originalInputPath);
            await fs.copyFile(originalInputPath, backupPath);
            needsRestore = true;
            console.log('📦 Backed up original greetings.json');
        } catch (e) {
            console.log('📝 No existing greetings.json found');
        }
        
        // Copy test file to input location
        await fs.copyFile(testPath, originalInputPath);
        console.log('📁 Copied test data to input location');
        
        // We need to spawn a child process since the original is designed to run as a script
        console.log('🚀 Running greeting generator...\n');
        
        // Import spawn from child_process
        
        const child = spawn('node', [
            'src/core/greetingGenerate.js',
            '--process-id=1',
            '--total-processes=1', 
            '--batches-per-process=10'
        ], {
            cwd: process.cwd(),
            stdio: ['pipe', 'pipe', 'pipe']
        });
        
        let stdout = '';
        let stderr = '';
        
        child.stdout.on('data', (data) => {
            stdout += data.toString();
            process.stdout.write(data);
        });
        
        child.stderr.on('data', (data) => {
            stderr += data.toString();
            process.stderr.write(data);
        });
        
        // Wait for completion
        await new Promise((resolve, reject) => {
            child.on('close', (code) => {
                if (code === 0) {
                    resolve();
                } else {
                    reject(new Error(`Process exited with code ${code}`));
                }
            });
            
            child.on('error', reject);
            
            // Set timeout to prevent hanging
            setTimeout(() => {
                child.kill();
                reject(new Error('Process timeout'));
            }, 60000); // 60 second timeout
        });
        
        console.log('\n✅ Greeting generator completed');
        
        // Validate output
        console.log('🔍 Validating output...\n');
        
        const outputPath = './output/greetings/greetings-processed-process-1.json';
        
        try {
            const outputContent = await fs.readFile(outputPath, 'utf8');
            const outputGreetings = JSON.parse(outputContent);
            
            console.log(`📊 Output contains ${outputGreetings.length} greetings`);
            
            if (outputGreetings.length !== testGreetings.length) {
                console.log(`⚠️  Warning: Expected ${testGreetings.length} greetings, got ${outputGreetings.length}`);
            }
            
            let validationErrors = 0;
            
            // Validate each greeting
            for (let i = 0; i < Math.min(outputGreetings.length, testGreetings.length); i++) {
                const errors = validateGreetingOutput(outputGreetings[i], testGreetings[i]);
                
                if (errors.length === 0) {
                    console.log(`✅ Greeting ${i + 1}: Valid`);
                    console.log(`   Original: ${testGreetings[i].content.substring(0, 50)}...`);
                    console.log(`   Vietnamese: ${outputGreetings[i].content_vietnamese.substring(0, 50)}...`);
                } else {
                    console.log(`❌ Greeting ${i + 1}: Validation failed`);
                    errors.forEach(error => console.log(`   - ${error}`));
                    validationErrors++;
                }
                console.log();
            }
            
            // Summary
            console.log('📈 Test Summary:');
            console.log(`   Total greetings: ${outputGreetings.length}`);
            console.log(`   Valid greetings: ${outputGreetings.length - validationErrors}`);
            console.log(`   Failed validations: ${validationErrors}`);
            
            if (validationErrors === 0) {
                console.log('🎉 All tests passed! The greeting generator is working correctly.');
            } else {
                console.log('⚠️  Some validations failed. Please check the output.');
            }
            
            // Show sample output
            if (outputGreetings.length > 0) {
                console.log('\n📄 Sample output:');
                console.log(JSON.stringify(outputGreetings[0], null, 2));
            }
            
        } catch (readError) {
            console.error('❌ Failed to read output file:', readError.message);
            console.log('💡 Expected output file:', outputPath);
            
            // List what files were actually created
            try {
                const files = await fs.readdir('./output/greetings');
                console.log('📁 Files in output/greetings:', files);
            } catch (e) {
                console.log('📁 No output/greetings directory found');
            }
        }
        
        // Restore original input file
        if (needsRestore) {
            await fs.copyFile(backupPath, originalInputPath);
            await fs.unlink(backupPath);
            console.log('\n📦 Restored original greetings.json');
        } else {
            await fs.unlink(originalInputPath);
            console.log('\n🗑️  Removed test greetings.json');
        }
        
    } catch (error) {
        console.error('\n❌ Test failed:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

// Check if we have the required environment setup
async function checkEnvironment() {
    const errors = [];
    
    // Check if .env file exists
    try {
        await fs.access('.env');
    } catch (e) {
        errors.push('Missing .env file');
    }
    
    // Check if required directories exist
    try {
        await fs.access('./src/core/greetingGenerate.js');
    } catch (e) {
        errors.push('Missing greetingGenerate.js');
    }
    
    // Check for API key in environment
    if (!process.env.DASHSCOPE_API_KEY) {
        errors.push('DASHSCOPE_API_KEY not set in environment');
    }
    
    return errors;
}

// Main test execution
async function main() {
    console.log('🔧 Checking environment...');
    
    const envErrors = await checkEnvironment();
    if (envErrors.length > 0) {
        console.log('❌ Environment check failed:');
        envErrors.forEach(error => console.log(`   - ${error}`));
        console.log('\n💡 Please ensure:');
        console.log('   1. You are in the dictionary directory');
        console.log('   2. .env file exists with DASHSCOPE_API_KEY');
        console.log('   3. greetingGenerate.js exists');
        return;
    }
    
    console.log('✅ Environment check passed\n');
    
    await runGreetingGeneratorTest();
}

// Run the test
main().catch(console.error);

export {
    createTestGreetings,
    validateGreetingOutput,
    runGreetingGeneratorTest
};
