#!/bin/bash

echo "🚀 Starting PM2 Multi-Worker Quotation Generation"
echo "=================================================="
echo ""

cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary

# Stop any existing quotation processes
echo "🛑 Stopping existing quotation processes..."
pm2 delete quotation-process-* 2>/dev/null || true

# Clean up previous output files
echo "🧹 Cleaning up previous output files..."
rm -f output/quotation_*.json
rm -f output/quotations-processed-*.json

# Show configuration
echo "📊 Configuration:"
echo "  - Total quotations: 7,103"
echo "  - Workers: 8 parallel processes"
echo "  - Batch size: 10 quotations per batch"
echo "  - Batches per worker: ~89 (711 total batches / 8 workers)"
echo "  - Batch delay: 1.5 seconds (to avoid rate limiting)"
echo "  - Expected completion time: ~15-20 minutes"
echo ""

# Start all quotation processes with PM2
echo "🔄 Starting 8 worker processes..."
pm2 start config/ecosystem.quotation.config.cjs

# Show status
echo ""
echo "✅ All processes started! Use the following commands to monitor:"
echo ""
echo "  pm2 status                    # Show all processes status"
echo "  pm2 logs quotation-process    # Show logs from all quotation processes"
echo "  pm2 monit                     # Real-time monitoring"
echo ""
echo "  ./monitor-quotation-progress.sh   # Custom progress monitor"
echo ""
echo "📂 Output files will be saved to:"
echo "  - Individual batches: output/quotation_batch_*.json"
echo "  - Per-worker results: output/quotations-processed-process-*.json"
echo ""

# Wait a moment for processes to start
sleep 3

# Show initial status
echo "📈 Initial Status:"
pm2 status
