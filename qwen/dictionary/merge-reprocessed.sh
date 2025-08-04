#!/bin/bash

# Script to merge reprocessed dictionary data
# Usage: ./merge-reprocessed.sh [process_id]

echo "🔄 Dictionary Data Merge Script"
echo "==============================="

if [ $# -eq 1 ]; then
    PROCESS_ID=$1
    echo "📋 Merging data for process ${PROCESS_ID} only..."
    node mergeReprocessedData.js --process-id=${PROCESS_ID} --skip-final-merge
else
    echo "📋 Merging data for all processes..."
    node mergeReprocessedData.js
fi

echo ""
echo "📊 Summary of generated files:"
echo "------------------------------"

if [ $# -eq 1 ]; then
    # Show specific process file
    PROCESS_FILE="output/dict-processed-process-${PROCESS_ID}.json"
    if [ -f "$PROCESS_FILE" ]; then
        WORD_COUNT=$(grep -o '"chinese"' "$PROCESS_FILE" | wc -l)
        echo "✅ $PROCESS_FILE - ${WORD_COUNT} words"
    else
        echo "❌ $PROCESS_FILE - not found"
    fi
else
    # Show all process files
    for file in output/dict-processed-process-*.json; do
        if [ -f "$file" ]; then
            WORD_COUNT=$(grep -o '"chinese"' "$file" | wc -l)
            echo "✅ $(basename "$file") - ${WORD_COUNT} words"
        fi
    done
    
    echo ""
    echo "📂 Final merged files:"
    for file in output/dictionary-final-merged-*.json; do
        if [ -f "$file" ]; then
            WORD_COUNT=$(grep -o '"chinese"' "$file" | wc -l)
            echo "🎯 $(basename "$file") - ${WORD_COUNT} words"
        fi
    done
fi

echo ""
echo "🔍 Data quality check:"
echo "----------------------"

# Count remaining error files
ERROR_COUNT=$(find output -name "dict_batch_*.json" -exec grep -l "400 Access denied" {} \; 2>/dev/null | wc -l)
echo "❌ Batch files with errors: ${ERROR_COUNT}"

# Count backup files
BACKUP_COUNT=$(find output -name "*.error-backup.json" 2>/dev/null | wc -l)
echo "💾 Error backup files: ${BACKUP_COUNT}"

# Count total batch files
BATCH_COUNT=$(find output -name "dict_batch_*.json" 2>/dev/null | wc -l)
echo "📁 Total batch files: ${BATCH_COUNT}"

echo ""
echo "✅ Merge completed!"
