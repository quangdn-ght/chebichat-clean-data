#!/bin/bash

# Test script to validate the setup before running the full generation

echo "🧪 Testing Dictionary Generator Setup"
echo "===================================="

# Test 1: Check input file
echo "1. Checking input file..."
if [ -f "input/DICTIONARY.json" ]; then
    items=$(jq length input/DICTIONARY.json 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "   ✅ DICTIONARY.json found with $items items"
    else
        echo "   ❌ DICTIONARY.json is not valid JSON"
        exit 1
    fi
else
    echo "   ❌ input/DICTIONARY.json not found"
    exit 1
fi

# Test 2: Check .env file
echo "2. Checking environment configuration..."
if [ -f ".env" ]; then
    if grep -q "DASHSCOPE_API_KEY" .env; then
        echo "   ✅ .env file found with API key"
    else
        echo "   ❌ DASHSCOPE_API_KEY not found in .env"
        exit 1
    fi
else
    echo "   ❌ .env file not found"
    exit 1
fi

# Test 3: Check Node.js and dependencies
echo "3. Checking Node.js setup..."
if command -v node >/dev/null 2>&1; then
    node_version=$(node --version)
    echo "   ✅ Node.js found: $node_version"
else
    echo "   ❌ Node.js not found"
    exit 1
fi

if [ -d "../node_modules" ] || [ -d "node_modules" ]; then
    echo "   ✅ Dependencies installed"
else
    echo "   ⚠️  Dependencies not found, will install automatically"
fi

# Test 4: Check output directory permissions
echo "4. Checking output directory..."
mkdir -p output
if [ -w "output" ]; then
    echo "   ✅ Output directory is writable"
else
    echo "   ❌ Output directory is not writable"
    exit 1
fi

# Test 5: Sample API call (optional)
echo "5. Testing API connection (optional)..."
echo "   This will use 1 API call to test connectivity..."
read -p "   Run API test? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "   🔄 Testing API connection..."
    node -e "
    import OpenAI from 'openai';
    import dotenv from 'dotenv';
    dotenv.config();
    
    const client = new OpenAI({
        apiKey: process.env.DASHSCOPE_API_KEY,
        baseURL: 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1'
    });
    
    client.chat.completions.create({
        model: 'qwen-max',
        messages: [
            {role: 'user', content: 'Respond with exactly: API_TEST_SUCCESS'}
        ],
        max_tokens: 10
    }).then(response => {
        if (response.choices[0].message.content.includes('API_TEST_SUCCESS')) {
            console.log('   ✅ API connection successful');
        } else {
            console.log('   ⚠️  API responded but with unexpected content');
        }
    }).catch(error => {
        console.log('   ❌ API connection failed:', error.message);
        process.exit(1);
    });
    " 2>/dev/null
else
    echo "   ⏭️  Skipped API test"
fi

echo ""
echo "🎉 Setup validation completed!"
echo "Ready to run: ./run_generator.sh"
