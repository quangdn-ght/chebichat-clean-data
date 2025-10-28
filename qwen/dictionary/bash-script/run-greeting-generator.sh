#!/bin/bash

# Greeting Generator Runner Script
# This script starts the greeting translation process using PM2

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🌟 Starting Greeting Generator...${NC}"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ Error: .env file not found${NC}"
    echo "Please create a .env file with your DASHSCOPE_API_KEY"
    exit 1
fi

# Source environment variables
source .env

# Check if API key is set
if [ -z "$DASHSCOPE_API_KEY" ]; then
    echo -e "${RED}❌ Error: DASHSCOPE_API_KEY not set in .env file${NC}"
    exit 1
fi

# Check if input file exists
if [ ! -f "./input/greetings.json" ]; then
    echo -e "${RED}❌ Error: Input file ./input/greetings.json not found${NC}"
    exit 1
fi

# Create output directory
mkdir -p ./output/greetings
mkdir -p ./logs

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}❌ Error: PM2 is not installed${NC}"
    echo "Please install PM2: npm install -g pm2"
    exit 1
fi

# Count total greetings
TOTAL_GREETINGS=$(jq 'length' ./input/greetings.json)
echo -e "${GREEN}📊 Total greetings to process: ${TOTAL_GREETINGS}${NC}"

# Calculate expected processing capacity
BATCH_SIZE=8
BATCHES_PER_PROCESS=500
TOTAL_PROCESSES=8
TOTAL_CAPACITY=$((BATCH_SIZE * BATCHES_PER_PROCESS * TOTAL_PROCESSES))

echo -e "${GREEN}🔧 Configuration:${NC}"
echo -e "  Batch size: ${BATCH_SIZE}"
echo -e "  Batches per process: ${BATCHES_PER_PROCESS}"
echo -e "  Total processes: ${TOTAL_PROCESSES}"
echo -e "  Processing capacity: ${TOTAL_CAPACITY} greetings"

if [ $TOTAL_CAPACITY -ge $TOTAL_GREETINGS ]; then
    echo -e "${GREEN}✅ Capacity sufficient for all greetings${NC}"
else
    echo -e "${YELLOW}⚠️  Warning: Capacity may not cover all greetings${NC}"
fi

# Stop any existing greeting processes
echo -e "${YELLOW}🛑 Stopping any existing greeting processes...${NC}"
pm2 delete all 2>/dev/null || true

# Start the greeting generators
echo -e "${GREEN}🚀 Starting greeting generators...${NC}"
pm2 start ./config/ecosystem.greeting.config.cjs

# Show PM2 status
echo -e "${GREEN}📋 Process Status:${NC}"
pm2 list

# Show logs
echo -e "${GREEN}📋 Starting to monitor logs...${NC}"
echo -e "${YELLOW}💡 You can stop monitoring with Ctrl+C${NC}"
echo -e "${YELLOW}💡 To check progress later, use: pm2 logs greeting-generator${NC}"
echo -e "${YELLOW}💡 To stop all processes: pm2 delete all${NC}"
echo ""

# Follow logs for all greeting processes
pm2 logs greeting-generator --lines 10

echo -e "${GREEN}✅ Greeting generator started successfully!${NC}"
