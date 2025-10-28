#!/bin/bash

# Greeting Results Merger Script
# This script merges all greeting translation results into a single file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔗 Greeting Results Merger${NC}"
echo "=============================="

OUTPUT_DIR="./output/greetings"
FINAL_OUTPUT="$OUTPUT_DIR/greetings-merged-complete.json"

# Check if output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
    echo -e "${RED}❌ Error: Output directory $OUTPUT_DIR not found${NC}"
    exit 1
fi

# Check if processed files exist
PROCESSED_FILES=("$OUTPUT_DIR"/greetings-processed-process-*.json)
if [ ! -f "${PROCESSED_FILES[0]}" ]; then
    echo -e "${RED}❌ Error: No processed greeting files found${NC}"
    echo "Expected files: greetings-processed-process-[1..8].json"
    exit 1
fi

echo -e "${BLUE}📊 Analyzing processed files...${NC}"

# Count greetings in each file
total_count=0
for file in "$OUTPUT_DIR"/greetings-processed-process-*.json; do
    if [ -f "$file" ]; then
        count=$(jq 'length' "$file")
        process_id=$(basename "$file" | sed 's/greetings-processed-process-\([0-9]*\)\.json/\1/')
        echo -e "  Process ${process_id}: ${count} greetings"
        total_count=$((total_count + count))
    fi
done

echo -e "\n${GREEN}📊 Total greetings found: ${total_count}${NC}"

# Merge all files
echo -e "${BLUE}🔗 Merging greeting files...${NC}"
jq -s 'add' "$OUTPUT_DIR"/greetings-processed-process-*.json > "$FINAL_OUTPUT"

# Verify the merge
merged_count=$(jq 'length' "$FINAL_OUTPUT")
file_size=$(ls -lh "$FINAL_OUTPUT" | awk '{print $5}')

echo -e "${GREEN}✅ Merge completed successfully!${NC}"
echo -e "${GREEN}📄 Output file: ${FINAL_OUTPUT}${NC}"
echo -e "${GREEN}📊 Total merged greetings: ${merged_count}${NC}"
echo -e "${GREEN}📦 File size: ${file_size}${NC}"

# Verification
if [ "$merged_count" -eq "$total_count" ]; then
    echo -e "${GREEN}✅ Verification passed: All greetings merged correctly${NC}"
else
    echo -e "${RED}⚠️  Warning: Merged count (${merged_count}) != expected count (${total_count})${NC}"
fi

# Show sample of merged data
echo -e "\n${BLUE}📝 Sample of merged data:${NC}"
jq '.[0:2]' "$FINAL_OUTPUT"

echo -e "\n${GREEN}🎉 Greeting merge completed!${NC}"
