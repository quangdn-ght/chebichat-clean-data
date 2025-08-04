#!/bin/bash

# Script to reprocess error batches with parallel processes
# Usage: ./reprocess-errors.sh [total_processes] [max_batches_per_run]

TOTAL_PROCESSES=${1:-4}  # Default to 4 processes
MAX_BATCHES=${2:-50}     # Default to 50 batches per process per run

echo "🚀 Starting error reprocessing with ${TOTAL_PROCESSES} processes"
echo "📊 Max batches per process per run: ${MAX_BATCHES}"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create a .env file with your DASHSCOPE_API_KEY"
    exit 1
fi

# Create array to store process PIDs
declare -a pids=()

# Start parallel processes
for ((i=1; i<=TOTAL_PROCESSES; i++)); do
    echo "🔄 Starting process $i/$TOTAL_PROCESSES..."
    node reprocessErrorBatches.js --process-id=$i --total-processes=$TOTAL_PROCESSES --max-batches=$MAX_BATCHES &
    pids+=($!)
done

echo ""
echo "⏳ All processes started. Waiting for completion..."
echo "Process PIDs: ${pids[@]}"

# Wait for all processes to complete
for pid in "${pids[@]}"; do
    wait $pid
    exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "✅ Process $pid completed successfully"
    else
        echo "❌ Process $pid failed with exit code $exit_code"
    fi
done

echo ""
echo "🎉 All reprocessing tasks completed!"
echo ""
echo "📊 Summary of remaining errors:"
cd output
remaining_errors=$(find . -name "dict_batch_*.json" ! -name "*backup*" ! -name "*error-backup*" -exec grep -l "400 Access denied, please make sure your account is in good standing" {} \; 2>/dev/null | wc -l)
echo "   Files with access denied errors: $remaining_errors"

if [ $remaining_errors -gt 0 ]; then
    echo ""
    echo "💡 To process remaining errors, run this script again:"
    echo "   ./reprocess-errors.sh $TOTAL_PROCESSES $MAX_BATCHES"
fi
