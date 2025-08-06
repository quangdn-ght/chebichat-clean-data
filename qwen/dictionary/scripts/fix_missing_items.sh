#!/bin/bash

echo "=== REPROCESSING MISSING ITEMS ==="
echo "This will process the 14,901 missing items that were not properly processed due to batch range overlaps."
echo ""

# Parse command line arguments
PARALLEL_MODE=false
if [ "$1" = "--parallel" ]; then
    PARALLEL_MODE=true
    echo "🚀 Parallel processing mode enabled"
fi

# Check if missing items exist
if [ ! -f "./missing-items/all-missing-items.json" ]; then
    echo "Error: Missing items file not found. Running identification script first..."
    node identify_missing_items.js
    if [ $? -ne 0 ]; then
        echo "Error: Failed to identify missing items"
        exit 1
    fi
fi

# Check if .env file exists and load API key
if [ -f ".env" ]; then
    # Source the .env file to load environment variables
    export $(grep -v '^#' .env | xargs)
    echo "Loaded environment variables from .env file"
else
    echo "Warning: .env file not found"
fi

# Check if API key is set (either from .env or environment)
if [ -z "$DASHSCOPE_API_KEY" ]; then
    echo "Error: DASHSCOPE_API_KEY not found"
    echo "Please ensure it's set in .env file: DASHSCOPE_API_KEY=\"your-api-key\""
    echo "Or export it: export DASHSCOPE_API_KEY=\"your-api-key\""
    exit 1
fi

if [ "$PARALLEL_MODE" = true ]; then
    echo "=== PARALLEL PROCESSING MODE ==="
    echo "This will split the work into 5 parallel processes for faster completion"
    echo "Estimated time: 5-8 minutes (vs 20-30 minutes for serial)"
    echo ""
    
    # Check if PM2 is available
    if ! command -v pm2 &> /dev/null; then
        echo "Error: PM2 is not installed. Please install it with:"
        echo "npm install -g pm2"
        exit 1
    fi
    
    # Create logs directory
    mkdir -p logs
    
    # Split missing items into chunks
    echo "Splitting missing items into chunks..."
    node split_missing_items.js
    if [ $? -ne 0 ]; then
        echo "Error: Failed to split missing items"
        exit 1
    fi
    
    # Start parallel processing with PM2
    echo "Starting parallel processing with PM2..."
    pm2 start ecosystem.missing.config.cjs
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to start PM2 processes"
        exit 1
    fi
    
    echo ""
    echo "✓ Parallel processing started successfully!"
    echo ""
    echo "Monitor progress with:"
    echo "  pm2 monit                    # Real-time monitoring"
    echo "  pm2 logs                     # View logs"
    echo "  pm2 status                   # Check status"
    echo ""
    echo "When all processes complete, run:"
    echo "  ./fix_missing_items.sh --combine"
    echo ""
    echo "Or to stop all processes:"
    echo "  pm2 stop ecosystem.missing.config.cjs"
    echo "  pm2 delete ecosystem.missing.config.cjs"

elif [ "$1" = "--combine" ]; then
    echo "=== COMBINING PARALLEL RESULTS ==="
    
    # Check if all PM2 processes are completed
    RUNNING_PROCESSES=$(pm2 status | grep "missing-items-chunk" | grep -c "online")
    if [ "$RUNNING_PROCESSES" -gt 0 ]; then
        echo "Warning: $RUNNING_PROCESSES PM2 processes are still running"
        echo "Wait for all processes to complete before combining results"
        echo "Check status with: pm2 status"
        exit 1
    fi
    
    # Combine results
    echo "Combining parallel processing results..."
    node combine_parallel_results.js
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "Results combined successfully!"
        echo "Now merging back into main files..."
        echo ""
        
        # Merge results
        node merge_parallel_results.js
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "🎉 SUCCESS! Parallel processing completed and merged."
            echo ""
            echo "Summary:"
            echo "- Processing method: Parallel (5 processes)"
            echo "- Original processed items: 83,152"  
            echo "- Missing items identified: 14,901"
            echo "- Items should now total: 98,053 (100% coverage)"
            echo ""
            echo "Check the parallel-merge-report.json file for detailed statistics."
            echo ""
            echo "Clean up PM2 processes with:"
            echo "  pm2 delete ecosystem.missing.config.cjs"
        else
            echo "Error: Failed to merge parallel results"
            exit 1
        fi
    else
        echo "Error: Failed to combine parallel results"
        exit 1
    fi

else
    echo "=== SERIAL PROCESSING MODE ==="
    echo "This will process items sequentially (slower but more reliable)"
    echo "Estimated time: 20-30 minutes"
    echo ""
    echo "For faster processing, use: ./fix_missing_items.sh --parallel"
    echo ""
    
    echo "Starting reprocessing of missing items..."
    
    # Run the reprocessing
    node reprocess_missing_items.js

    if [ $? -eq 0 ]; then
        echo ""
        echo "Reprocessing completed successfully!"
        echo "Now merging the results back into the main files..."
        echo ""
        
        # Run the merge
        node merge_reprocessed_items.js
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "🎉 SUCCESS! All missing items have been processed and merged."
            echo ""
            echo "Summary:"
            echo "- Processing method: Serial"
            echo "- Original processed items: 83,152"
            echo "- Missing items identified: 14,901"
            echo "- Items should now total: 98,053 (100% coverage)"
            echo ""
            echo "Check the merge-report.json file for detailed statistics."
        else
            echo "Error: Failed to merge reprocessed items"
            exit 1
        fi
    else
        echo "Error: Failed to reprocess missing items"
        exit 1
    fi
fi
