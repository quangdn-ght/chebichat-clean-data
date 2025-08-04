#!/bin/bash

# Script to verify merged dictionary data quality
# Usage: ./verify-merged-data.sh

echo "🔍 Dictionary Data Quality Verification"
echo "======================================="

echo ""
echo "📊 Process Files Analysis:"
echo "---------------------------"

TOTAL_WORDS=0
TOTAL_PROCESSES=0

for file in output/dict-processed-process-*.json; do
    if [ -f "$file" ]; then
        PROCESS_ID=$(basename "$file" | sed 's/dict-processed-process-\([0-9]*\)\.json/\1/')
        WORD_COUNT=$(grep -o '"chinese"' "$file" | wc -l)
        
        # Check for any remaining errors in the file
        ERROR_COUNT=$(grep -c '"error"' "$file" 2>/dev/null || echo "0")
        
        TOTAL_WORDS=$((TOTAL_WORDS + WORD_COUNT))
        TOTAL_PROCESSES=$((TOTAL_PROCESSES + 1))
        
        if [ $ERROR_COUNT -gt 0 ]; then
            echo "⚠️  Process $PROCESS_ID: $WORD_COUNT words (❌ $ERROR_COUNT errors)"
        else
            echo "✅ Process $PROCESS_ID: $WORD_COUNT words"
        fi
    fi
done

echo ""
echo "📈 Summary Statistics:"
echo "----------------------"
echo "Total processes: $TOTAL_PROCESSES"
echo "Total words across all processes: $TOTAL_WORDS"

if [ $TOTAL_PROCESSES -gt 0 ]; then
    AVG_WORDS=$((TOTAL_WORDS / TOTAL_PROCESSES))
    echo "Average words per process: $AVG_WORDS"
fi

echo ""
echo "🎯 Final Merged Files:"
echo "----------------------"

for file in output/dictionary-final-merged-*.json; do
    if [ -f "$file" ]; then
        WORD_COUNT=$(grep -o '"chinese"' "$file" | wc -l)
        FILE_SIZE=$(du -h "$file" | cut -f1)
        echo "📚 $(basename "$file")"
        echo "   Words: $WORD_COUNT"
        echo "   Size: $FILE_SIZE"
        
        # Check for duplicate words in final file
        DUPLICATES=$(grep '"chinese":' "$file" | sort | uniq -d | wc -l)
        if [ $DUPLICATES -gt 0 ]; then
            echo "   ⚠️  Duplicates found: $DUPLICATES"
        else
            echo "   ✅ No duplicates detected"
        fi
        
        # Sample some entries
        echo "   📝 Sample entries:"
        grep '"chinese":' "$file" | head -3 | sed 's/.*"chinese": *"\([^"]*\)".*/      - \1/'
    fi
done

echo ""
echo "🔍 Error Analysis:"
echo "------------------"

# Count remaining batch errors
BATCH_ERRORS=$(find output -name "dict_batch_*.json" -exec grep -l "400 Access denied" {} \; 2>/dev/null | wc -l)
echo "Batch files with API errors: $BATCH_ERRORS"

# Count backup files
BACKUP_FILES=$(find output -name "*.error-backup.json" 2>/dev/null | wc -l)
echo "Error backup files available: $BACKUP_FILES"

# Count total batch files
TOTAL_BATCHES=$(find output -name "dict_batch_*.json" 2>/dev/null | wc -l)
echo "Total batch files: $TOTAL_BATCHES"

if [ $TOTAL_BATCHES -gt 0 ]; then
    SUCCESS_RATE=$(echo "scale=1; ($TOTAL_BATCHES - $BATCH_ERRORS) * 100 / $TOTAL_BATCHES" | bc -l)
    echo "Success rate: ${SUCCESS_RATE}%"
fi

echo ""
echo "💡 Recommendations:"
echo "-------------------"

if [ $BATCH_ERRORS -gt 0 ]; then
    echo "- Run reprocessing script to fix remaining $BATCH_ERRORS error files"
    echo "  ./reprocess-errors.sh 4 50"
fi

if [ $TOTAL_PROCESSES -lt 10 ]; then
    echo "- Consider running merge for missing processes"
    echo "  ./merge-reprocessed.sh"
fi

if [ ! -f output/dictionary-final-merged-*.json ]; then
    echo "- Create final merged dictionary file"
    echo "  node mergeReprocessedData.js"
fi

echo ""
echo "✅ Verification completed!"
