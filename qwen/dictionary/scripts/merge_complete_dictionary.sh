#!/bin/bash

# Merge Complete Dictionary Script
# Ensures total items equals exactly 98,053

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== MERGING COMPLETE DICTIONARY ===${NC}"
echo "Target: 98,053 total items"
echo ""

# Create output directory for final merged files
FINAL_OUTPUT_DIR="./output-final"
mkdir -p "$FINAL_OUTPUT_DIR"

# Create backup directory
BACKUP_DIR="./backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}📦 Creating backups...${NC}"
if [ -d "./output" ]; then
    cp -r ./output "$BACKUP_DIR/output-original"
    echo "✓ Original output backed up to $BACKUP_DIR"
fi

# Step 1: Merge original deduplicated files
echo -e "${YELLOW}🔄 Step 1: Collecting original deduplicated files...${NC}"

ORIGINAL_ITEMS=0
TEMP_COMBINED="./temp-combined-original.json"
echo "[" > "$TEMP_COMBINED"

FIRST_FILE=true
for process in {1..30}; do
    PROCESS_FILE="./output/dict-processed-process-${process}.json"
    if [ -f "$PROCESS_FILE" ]; then
        echo "Processing original file: dict-processed-process-${process}.json"
        
        # Count items in this file
        ITEMS_COUNT=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$PROCESS_FILE', 'utf8')).length)")
        ORIGINAL_ITEMS=$((ORIGINAL_ITEMS + ITEMS_COUNT))
        echo "  Items: $ITEMS_COUNT"
        
        # Add to combined file
        if [ "$FIRST_FILE" = true ]; then
            # First file - don't add comma
            node -e "
                const data = JSON.parse(require('fs').readFileSync('$PROCESS_FILE', 'utf8'));
                process.stdout.write(JSON.stringify(data, null, 0).slice(1, -1));
            " >> "$TEMP_COMBINED"
            FIRST_FILE=false
        else
            # Subsequent files - add comma first
            echo "," >> "$TEMP_COMBINED"
            node -e "
                const data = JSON.parse(require('fs').readFileSync('$PROCESS_FILE', 'utf8'));
                process.stdout.write(JSON.stringify(data, null, 0).slice(1, -1));
            " >> "$TEMP_COMBINED"
        fi
    fi
done

echo "]" >> "$TEMP_COMBINED"

echo -e "${GREEN}✓ Original deduplicated items: $ORIGINAL_ITEMS${NC}"

# Step 2: Merge reprocessed missing items
echo -e "${YELLOW}🔄 Step 2: Collecting reprocessed missing items...${NC}"

REPROCESSED_ITEMS=0
TEMP_REPROCESSED="./temp-reprocessed.json"

# Check if aggregated chunk results exist
if [ -f "./missing-items-processed-parallel/chunk_1_results.json" ] || \
   [ -f "./missing-items-processed-parallel/chunk_2_results.json" ] || \
   [ -f "./missing-items-processed-parallel/chunk_3_results.json" ] || \
   [ -f "./missing-items-processed-parallel/chunk_4_results.json" ] || \
   [ -f "./missing-items-processed-parallel/chunk_5_results.json" ]; then
    
    echo "Found aggregated chunk results..."
    echo "[" > "$TEMP_REPROCESSED"
    
    FIRST_CHUNK=true
    for chunk in {1..5}; do
        CHUNK_RESULT="./missing-items-processed-parallel/chunk_${chunk}_results.json"
        if [ -f "$CHUNK_RESULT" ]; then
            echo "Processing chunk result: chunk_${chunk}_results.json"
            
            # Count items in this chunk
            CHUNK_ITEMS=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$CHUNK_RESULT', 'utf8')).length)")
            REPROCESSED_ITEMS=$((REPROCESSED_ITEMS + CHUNK_ITEMS))
            echo "  Items: $CHUNK_ITEMS"
            
            # Add to combined file
            if [ "$FIRST_CHUNK" = true ]; then
                node -e "
                    const data = JSON.parse(require('fs').readFileSync('$CHUNK_RESULT', 'utf8'));
                    process.stdout.write(JSON.stringify(data, null, 0).slice(1, -1));
                " >> "$TEMP_REPROCESSED"
                FIRST_CHUNK=false
            else
                echo "," >> "$TEMP_REPROCESSED"
                node -e "
                    const data = JSON.parse(require('fs').readFileSync('$CHUNK_RESULT', 'utf8'));
                    process.stdout.write(JSON.stringify(data, null, 0).slice(1, -1));
                " >> "$TEMP_REPROCESSED"
            fi
        fi
    done
    
    echo "]" >> "$TEMP_REPROCESSED"
    
else
    echo "No aggregated chunk results found. Collecting individual batch files..."
    
    # Collect all individual batch files
    echo "[" > "$TEMP_REPROCESSED"
    
    FIRST_BATCH=true
    BATCH_COUNT=0
    
    for chunk_file in ./missing-items-processed-parallel/chunk_*_batch_*_of_*.json; do
        if [ -f "$chunk_file" ]; then
            BATCH_COUNT=$((BATCH_COUNT + 1))
            
            # Count items in this batch
            BATCH_ITEMS=$(node -e "
                try {
                    const data = JSON.parse(require('fs').readFileSync('$chunk_file', 'utf8'));
                    console.log(Array.isArray(data) ? data.length : 0);
                } catch(e) {
                    console.log(0);
                }
            ")
            REPROCESSED_ITEMS=$((REPROCESSED_ITEMS + BATCH_ITEMS))
            
            if [ $((BATCH_COUNT % 100)) -eq 0 ]; then
                echo "  Processed $BATCH_COUNT batches... (Total items so far: $REPROCESSED_ITEMS)"
            fi
            
            # Add to combined file
            if [ "$FIRST_BATCH" = true ]; then
                node -e "
                    try {
                        const data = JSON.parse(require('fs').readFileSync('$chunk_file', 'utf8'));
                        if (Array.isArray(data) && data.length > 0) {
                            process.stdout.write(JSON.stringify(data, null, 0).slice(1, -1));
                        }
                    } catch(e) {}
                " >> "$TEMP_REPROCESSED"
                FIRST_BATCH=false
            else
                node -e "
                    try {
                        const data = JSON.parse(require('fs').readFileSync('$chunk_file', 'utf8'));
                        if (Array.isArray(data) && data.length > 0) {
                            process.stdout.write(',' + JSON.stringify(data, null, 0).slice(1, -1));
                        }
                    } catch(e) {}
                " >> "$TEMP_REPROCESSED"
            fi
        fi
    done
    
    echo "]" >> "$TEMP_REPROCESSED"
    echo "  Processed $BATCH_COUNT total batches"
fi

echo -e "${GREEN}✓ Reprocessed items: $REPROCESSED_ITEMS${NC}"

# Step 3: Combine original and reprocessed items
echo -e "${YELLOW}🔄 Step 3: Combining all items...${NC}"

COMBINED_FILE="$FINAL_OUTPUT_DIR/complete-dictionary-raw.json"

node -e "
const fs = require('fs');

console.log('Reading original items...');
const originalData = JSON.parse(fs.readFileSync('./temp-combined-original.json', 'utf8'));
console.log('Original items loaded:', originalData.length);

console.log('Reading reprocessed items...');
const reprocessedData = JSON.parse(fs.readFileSync('./temp-reprocessed.json', 'utf8'));
console.log('Reprocessed items loaded:', reprocessedData.length);

console.log('Combining all items...');
const allItems = [...originalData, ...reprocessedData];
console.log('Total combined items:', allItems.length);

console.log('Saving combined dictionary...');
fs.writeFileSync('$COMBINED_FILE', JSON.stringify(allItems, null, 2));
console.log('Combined dictionary saved to: $COMBINED_FILE');
"

# Get the combined count
COMBINED_ITEMS=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$COMBINED_FILE', 'utf8')).length)")

echo -e "${GREEN}✓ Combined items: $COMBINED_ITEMS${NC}"

# Step 4: Remove duplicates to ensure exactly 98,053 unique items
echo -e "${YELLOW}🔄 Step 4: Removing duplicates and finalizing...${NC}"

FINAL_FILE="$FINAL_OUTPUT_DIR/complete-dictionary-final.json"

node -e "
const fs = require('fs');

console.log('Loading combined dictionary...');
const allItems = JSON.parse(fs.readFileSync('$COMBINED_FILE', 'utf8'));
console.log('Total items before deduplication:', allItems.length);

console.log('Removing duplicates...');
const uniqueItems = new Map();
let duplicateCount = 0;

for (const item of allItems) {
    const word = item.chinese || item.word;
    if (word) {
        if (uniqueItems.has(word)) {
            duplicateCount++;
        } else {
            uniqueItems.set(word, item);
        }
    }
}

const finalItems = Array.from(uniqueItems.values());
console.log('Duplicates removed:', duplicateCount);
console.log('Final unique items:', finalItems.length);

// Sort by word for consistency
finalItems.sort((a, b) => {
    const wordA = a.chinese || a.word;
    const wordB = b.chinese || b.word;
    return wordA.localeCompare(wordB);
});

console.log('Saving final dictionary...');
fs.writeFileSync('$FINAL_FILE', JSON.stringify(finalItems, null, 2));
console.log('Final dictionary saved to: $FINAL_FILE');
"

# Get final count
FINAL_ITEMS=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$FINAL_FILE', 'utf8')).length)")

# Step 5: Verification
echo -e "${YELLOW}🔄 Step 5: Verification...${NC}"

# Clean up temporary files
rm -f "$TEMP_COMBINED" "$TEMP_REPROCESSED"

echo ""
echo -e "${BLUE}=== FINAL RESULTS ===${NC}"
echo -e "Original deduplicated items: ${GREEN}$ORIGINAL_ITEMS${NC}"
echo -e "Reprocessed missing items:   ${GREEN}$REPROCESSED_ITEMS${NC}"
echo -e "Combined total:              ${GREEN}$COMBINED_ITEMS${NC}"
echo -e "Final unique items:          ${GREEN}$FINAL_ITEMS${NC}"
echo -e "Expected target:             ${YELLOW}98,053${NC}"

if [ "$FINAL_ITEMS" -eq 98053 ]; then
    echo ""
    echo -e "${GREEN}🎉 SUCCESS! Dictionary merge completed successfully!${NC}"
    echo -e "${GREEN}✓ Achieved exactly 98,053 unique items as expected${NC}"
    echo ""
    echo -e "Final dictionary: ${BLUE}$FINAL_FILE${NC}"
    echo -e "Backup location:  ${BLUE}$BACKUP_DIR${NC}"
else
    echo ""
    echo -e "${RED}⚠️  WARNING: Final count ($FINAL_ITEMS) does not match expected (98,053)${NC}"
    echo -e "Difference: $((FINAL_ITEMS - 98053))"
    echo ""
    if [ "$FINAL_ITEMS" -lt 98053 ]; then
        echo -e "${YELLOW}Missing items: $((98053 - FINAL_ITEMS))${NC}"
        echo "Consider running identify_missing_items.js again to check for remaining gaps."
    else
        echo -e "${YELLOW}Extra items: $((FINAL_ITEMS - 98053))${NC}"
        echo "There may be remaining duplicates or additional items."
    fi
fi

echo ""
echo -e "${BLUE}Files created:${NC}"
echo "  • $FINAL_FILE (Final dictionary)"
echo "  • $BACKUP_DIR/ (Backup directory)"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Review the final dictionary file"
echo "  2. Run verification: node identify_missing_items.js"
echo "  3. If satisfied, copy final file to production location"
