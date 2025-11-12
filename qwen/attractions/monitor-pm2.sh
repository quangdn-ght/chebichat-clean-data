#!/bin/bash

echo "📊 Monitoring PM2 Workers"
echo ""

# Check if PM2 processes are running
if ! pm2 list | grep -q "attraction-worker"; then
    echo "⚠️  No attraction-worker processes found"
    echo ""
    echo "Start workers with: ./start-pm2.sh"
    exit 1
fi

echo "🔍 Current Status:"
pm2 list | grep -E "attraction-worker|App name"
echo ""

echo "📈 Worker Statistics:"
echo ""

# Count processed items from each worker
for i in {0..7}; do
    RESULT_FILE="output/worker-${i}-results.json"
    
    if [ -f "$RESULT_FILE" ]; then
        TOTAL=$(jq -r '.total' "$RESULT_FILE" 2>/dev/null || echo "0")
        PROCESSED=$(jq -r '.processed' "$RESULT_FILE" 2>/dev/null || echo "0")
        SUCCESSFUL=$(jq -r '.successful' "$RESULT_FILE" 2>/dev/null || echo "0")
        FAILED=$(jq -r '.failed' "$RESULT_FILE" 2>/dev/null || echo "0")
        
        if [ "$TOTAL" != "0" ]; then
            PERCENT=$(echo "scale=1; $PROCESSED * 100 / $TOTAL" | bc 2>/dev/null || echo "0")
            echo "Worker $i: $PROCESSED/$TOTAL ($PERCENT%) - ✅ $SUCCESSFUL | ❌ $FAILED"
        fi
    fi
done

echo ""
echo "📁 Output files in: output/"
ls -lh output/worker-*.json 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'

echo ""
echo "💡 Commands:"
echo "   pm2 logs attraction-worker      # View logs"
echo "   pm2 monit                       # Real-time monitoring"
echo "   pm2 stop attraction-worker      # Stop all workers"
echo "   ./merge-results.sh              # Merge results after completion"
echo ""
