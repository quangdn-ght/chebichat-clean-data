#!/bin/bash

# Monitor quotation generation progress

echo "Quotation Generation Progress Monitor"
echo "======================================"

while true; do
    clear
    echo "Quotation Generation Progress Monitor"
    echo "======================================"
    echo "Time: $(date)"
    echo ""
    
    # Check if process is still running
    if pgrep -f "quotationGenerate.js" > /dev/null; then
        echo "Status: ✅ RUNNING"
    else
        echo "Status: ❌ NOT RUNNING"
    fi
    echo ""
    
    # Count processed files
    batch_files=$(ls output/quotation_batch_*.json 2>/dev/null | wc -l)
    echo "Processed batches: $batch_files / ~711"
    
    # Calculate progress
    if [ $batch_files -gt 0 ]; then
        progress=$(echo "scale=1; $batch_files * 100 / 711" | bc -l)
        echo "Progress: ${progress}%"
        
        # Estimate remaining time
        if [ $batch_files -gt 5 ]; then
            # Calculate average time per batch (assuming 3 seconds + processing time = ~5 seconds)
            remaining_batches=$((711 - $batch_files))
            remaining_minutes=$(echo "scale=0; $remaining_batches * 5 / 60" | bc -l)
            echo "Estimated remaining time: ~$remaining_minutes minutes"
        fi
    fi
    echo ""
    
    # Show recent activity
    echo "Recent files:"
    ls -lt output/quotation_batch_*.json 2>/dev/null | head -3
    echo ""
    
    # Check for final output
    if [ -f "output/quotations-processed-process-1.json" ]; then
        processed_count=$(cat output/quotations-processed-process-1.json | jq '. | length' 2>/dev/null || echo "checking...")
        echo "Total processed quotations: $processed_count"
    fi
    
    echo ""
    echo "Press Ctrl+C to exit monitor"
    sleep 10
done
