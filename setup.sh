#!/bin/bash

# Image Matcher Setup Script
# This script helps set up the image matching feature

echo "🚀 Image Matcher Setup"
echo "====================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

echo "✓ Node.js is available"

# Check if required files exist
if [ ! -f "qwen/dictionary/input/dict-images.json" ]; then
    echo "❌ dict-images.json not found at expected location"
    echo "   Expected: qwen/dictionary/input/dict-images.json"
    exit 1
fi

echo "✓ dict-images.json found"

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install dependencies"
        exit 1
    fi
else
    echo "✓ Dependencies are installed"
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "⚙️  Creating .env configuration file..."
    cp .env.example .env
    echo "✓ Created .env file"
    echo "⚠️  Please edit .env with your database credentials"
else
    echo "✓ .env file already exists"
fi

# Run tests
echo ""
echo "🧪 Running tests..."
node test-image-matcher.js

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Edit .env with your database credentials"
    echo "2. Run: node image-matcher.js preview"
    echo "3. Run: node image-matcher.js process --dry-run"
    echo "4. Run: node image-matcher.js process"
    echo ""
    echo "For help: node image-matcher.js"
else
    echo "❌ Tests failed. Please check the output above."
    exit 1
fi
