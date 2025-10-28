#!/bin/bash

# Greeting Generator Progress Monitor
# This script monitors the progress of greeting translation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}📊 Greeting Generator Progress Monitor${NC}"
echo "=========================================="

# Function to count processed greetings
count_processed_greetings() {
    local total=0
    local output_dir="./output/greetings"
    
    if [ -d "$output_dir" ]; then
        for file in "$output_dir"/greetings-processed-process-*.json; do
            if [ -f "$file" ]; then
                local count=$(jq 'length' "$file" 2>/dev/null || echo 0)
                total=$((total + count))
                local process_id=$(basename "$file" | sed 's/greetings-processed-process-\([0-9]*\)\.json/\1/')
                echo -e "  Process ${process_id}: ${count} greetings"
            fi
        done
    fi
    
    echo "$total"
}

# Function to get PM2 status
get_pm2_status() {
    echo -e "\n${BLUE}📋 PM2 Process Status:${NC}"
    pm2 list | grep -E "(greeting-generator|Process Name)" || echo "No greeting generator processes found"
}

# Function to show recent logs
show_recent_logs() {
    echo -e "\n${BLUE}📝 Recent Log Activity:${NC}"
    echo "------------------------"
    
    local log_dir="./logs"
    if [ -d "$log_dir" ]; then
        # Show the most recent log entries from all greeting processes
        for i in {1..8}; do
            local log_file="$log_dir/greeting-$i-out.log"
            if [ -f "$log_file" ]; then
                echo -e "${YELLOW}Process $i:${NC}"
                tail -2 "$log_file" 2>/dev/null | head -1 || echo "  No recent activity"
            fi
        done
    else
        echo "No log directory found"
    fi
}

# Function to calculate estimated completion time
calculate_eta() {
    local processed=$1
    local total=$2
    local start_time_file="./logs/greeting_start_time.txt"
    
    if [ -f "$start_time_file" ]; then
        local start_time=$(cat "$start_time_file")
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if [ $processed -gt 0 ] && [ $elapsed -gt 0 ]; then
            local rate=$(echo "scale=2; $processed / $elapsed" | bc)
            local remaining=$((total - processed))
            local eta_seconds=$(echo "scale=0; $remaining / $rate" | bc)
            local eta_hours=$((eta_seconds / 3600))
            local eta_minutes=$(((eta_seconds % 3600) / 60))
            
            echo -e "${BLUE}⏱️  Estimated completion: ${eta_hours}h ${eta_minutes}m${NC}"
            echo -e "${BLUE}📈 Processing rate: $(echo "scale=1; $rate * 60" | bc) greetings/minute${NC}"
        fi
    fi
}

# Main monitoring loop
while true; do
    clear
    echo -e "${GREEN}📊 Greeting Generator Progress Monitor${NC}"
    echo "=========================================="
    
    # Get total greetings count
    total_greetings=0
    if [ -f "./input/greetings.json" ]; then
        total_greetings=$(jq 'length' ./input/greetings.json)
    fi
    
    echo -e "${GREEN}📚 Total greetings to process: ${total_greetings}${NC}"
    echo ""
    
    # Count processed greetings
    echo -e "${GREEN}✅ Processed greetings by process:${NC}"
    processed_count=$(count_processed_greetings)
    echo -e "\n${GREEN}📊 Total processed: ${processed_count}/${total_greetings}${NC}"
    
    # Calculate progress percentage
    if [ $total_greetings -gt 0 ]; then
        progress=$(echo "scale=1; ($processed_count * 100) / $total_greetings" | bc)
        echo -e "${GREEN}🎯 Progress: ${progress}%${NC}"
        
        # Show progress bar
        filled=$((processed_count * 50 / total_greetings))
        empty=$((50 - filled))
        printf "${GREEN}["
        printf "%${filled}s" | tr ' ' '█'
        printf "%${empty}s" | tr ' ' '░'
        printf "]${NC}\n"
        
        # Calculate ETA
        calculate_eta $processed_count $total_greetings
    fi
    
    # Show PM2 status
    get_pm2_status
    
    # Show recent logs
    show_recent_logs
    
    echo ""
    echo -e "${YELLOW}💡 Press Ctrl+C to stop monitoring${NC}"
    echo -e "${YELLOW}💡 Refreshing every 30 seconds...${NC}"
    
    # Wait for 30 seconds or until Ctrl+C
    sleep 30
done
