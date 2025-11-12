#!/bin/bash

echo "🚀 Setting up Attraction Content Generator..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js v16 or higher."
    exit 1
fi

echo "✅ Node.js version: $(node --version)"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm."
    exit 1
fi

echo "✅ npm version: $(npm --version)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"
echo ""

# Check for .env file
if [ ! -f "../../.env" ]; then
    echo "⚠️  Warning: .env file not found at ../../.env"
    echo ""
    echo "Please create a .env file with the following variables:"
    echo ""
    echo "DASHSCOPE_API_KEY=your-api-key-here"
    echo "SUPABASE_URL=https://your-project.supabase.co"
    echo "SUPABASE_SERVICE_ROLE_KEY=your-service-role-key"
    echo ""
    exit 1
fi

echo "✅ .env file found"
echo ""

# Create output directory if it doesn't exist
mkdir -p output
echo "✅ Output directory ready"
echo ""

# Test database connection
echo "🔍 Testing Supabase connection..."
npm run test-db

if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  Database connection test failed. Please check:"
    echo "   1. Your .env file has correct credentials"
    echo "   2. Your Supabase project is accessible"
    echo "   3. The attractions table exists"
    echo ""
    echo "You can still continue, but database operations won't work."
    echo ""
else
    echo ""
    echo "✅ Database connection successful!"
fi

echo ""
echo "================================"
echo "✅ Setup Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "  1. Run: npm run test-single"
echo "  2. Check output/attraction-*.json"
echo "  3. If good, run: npm run process-update"
echo ""
echo "For more info, see QUICKSTART.md"
echo ""
