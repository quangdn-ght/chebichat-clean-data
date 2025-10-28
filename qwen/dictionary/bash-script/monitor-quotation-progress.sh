#!/bin/bash

# Enhanced monitor for multi-worker quotation generation

echo "🔍 Multi-Worker Quotation Generation Monitor"
echo "============================================="

cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary

while true; do
    clear
    echo "🔍 Multi-Worker Quotation Generation Monitor"
    echo "============================================="
    echo "Time: $(date)"
    echo ""
    
    # Check PM2 processes status
    echo "🔄 Worker Status:"
    pm2 jlist | jq -r '.[] | select(.name | startswith("quotation-process")) | "  \(.name): \(.pm2_env.status) (PID: \(.pid // "N/A"), CPU: \(.monit.cpu)%, Memory: \(.monit.memory // 0 | . / 1024 / 1024 | floor)MB)"' 2>/dev/null || {
        echo "  PM2 processes:"
        pm2 status | grep quotation-process || echo "  No quotation processes running"
    }
    echo ""
    
    # Count processed files per worker
    echo "📊 Progress per Worker:"
    total_processed=0
    total_quotations=0
    
    for i in {1..8}; do
        batch_files=$(ls output/quotation_batch_*_process_${i}.json 2>/dev/null | wc -l)
        processed_file="output/quotations-processed-process-${i}.json"
        
        if [ -f "$processed_file" ]; then
            worker_quotations=$(cat "$processed_file" | jq '. | length' 2>/dev/null || echo "0")
            total_quotations=$((total_quotations + worker_quotations))
        else
            worker_quotations=0
        fi
        
        total_processed=$((total_processed + batch_files))
        
        echo "  Worker $i: $batch_files batches, $worker_quotations quotations"
    done
    
    echo ""
    echo "📈 Overall Progress:"
    echo "  Total batches processed: $total_processed / 711"
    echo "  Total quotations processed: $total_quotations / 7,103"
    
    # Calculate progress percentage
    if [ $total_processed -gt 0 ]; then
        progress=$(echo "scale=1; $total_processed * 100 / 711" | bc -l 2>/dev/null || echo "0")
        echo "  Progress: ${progress}%"
        
        # Estimate remaining time (each batch takes ~2-3 seconds on average with parallel processing)
        if [ $total_processed -gt 10 ]; then
            remaining_batches=$((711 - total_processed))
            # With 8 workers, effective time per batch is reduced
            remaining_minutes=$(echo "scale=0; $remaining_batches * 2 / 8 / 60" | bc -l 2>/dev/null || echo "unknown")
            echo "  Estimated remaining time: ~$remaining_minutes minutes"
        fi
    fi
    echo ""
    
    # Show recent activity
    echo "📋 Recent Activity:"
    ls -lt output/quotation_batch_*.json 2>/dev/null | head -5 | while read line; do
        echo "  $line"
    done
    echo ""
    
    # Check for errors in logs
    echo "⚠️  Recent Errors (if any):"
    pm2 logs quotation-process --lines 5 --nostream 2>/dev/null | grep -i "error\|failed\|✗" | tail -3 | while read line; do
        echo "  $line"
    done
    
    echo ""
    echo "🎯 Quick Commands:"
    echo "  pm2 logs quotation-process      # View all logs"
    echo "  pm2 restart quotation-process   # Restart all workers"
    echo "  pm2 stop quotation-process      # Stop all workers"
    echo "  pm2 delete quotation-process    # Delete all workers"
    echo ""
    echo "Press Ctrl+C to exit monitor"
    
    # Check if all processes are complete
    if [ $total_processed -ge 711 ]; then
        echo "🎉 PROCESSING COMPLETE! All 711 batches have been processed."
        echo ""
        echo "📁 Final Results:"
        for i in {1..8}; do
            if [ -f "output/quotations-processed-process-${i}.json" ]; then
                count=$(cat "output/quotations-processed-process-${i}.json" | jq '. | length' 2>/dev/null || echo "0")
                echo "  Worker $i: $count quotations"
            fi
        done
        echo ""
        echo "Next steps:"
        echo "  1. Merge all worker results into final file"
        echo "  2. Validate translation quality"
        echo "  3. Deploy to production"
        break
    fi
    
    sleep 10
done
