#!/bin/bash

# Auto-restart script for greeting generator processes
# This script checks for stopped processes and restarts them automatically

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔄 Checking greeting generator processes...${NC}"

# Get stopped processes
STOPPED_PROCESSES=$(pm2 jlist | jq -r '.[] | select(.pm2_env.status == "stopped" and (.name | startswith("greeting-generator"))) | .name')

if [ -z "$STOPPED_PROCESSES" ]; then
    echo -e "${GREEN}✅ All greeting generator processes are running${NC}"
else
    echo -e "${YELLOW}⚠️  Found stopped processes:${NC}"
    echo "$STOPPED_PROCESSES"
    
    # Restart each stopped process
    for process in $STOPPED_PROCESSES; do
        echo -e "${YELLOW}🔄 Restarting $process...${NC}"
        pm2 restart "$process"
        sleep 2
    done
    
    echo -e "${GREEN}✅ All stopped processes have been restarted${NC}"
fi

# Show current status
echo -e "\n${GREEN}📊 Current Process Status:${NC}"
pm2 list | grep -E "(greeting-generator|Process Name)" || echo "No greeting generator processes found"

# Show current progress
echo -e "\n${GREEN}📈 Current Progress:${NC}"
cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary
total=0
for i in {1..8}; do 
    count=$(jq 'length' output/greetings/greetings-processed-process-$i.json 2>/dev/null || echo 0)
    echo "  Process $i: $count greetings"
    total=$((total + count))
done

progress=$(echo "scale=1; ($total * 100) / 8611" | bc)
echo -e "${GREEN}📊 Total: $total/8611 greetings (${progress}%)${NC}"

# Check for content filtering issues
echo -e "\n${GREEN}🛡️  Content Filter Status:${NC}"
filtered_count=0
for i in {1..8}; do
    if [ -f "output/greetings/greetings-processed-process-$i.json" ]; then
        count=$(jq '[.[] | select(.error == "content_filtered")] | length' output/greetings/greetings-processed-process-$i.json 2>/dev/null || echo 0)
        if [ $count -gt 0 ]; then
            echo "  Process $i: $count filtered items"
            filtered_count=$((filtered_count + count))
        fi
    fi
done

if [ $filtered_count -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Total filtered content: $filtered_count items${NC}"
else
    echo -e "${GREEN}✅ No content filtering detected${NC}"
fi
