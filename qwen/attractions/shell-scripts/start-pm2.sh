#!/bin/bash

echo "🚀 Starting PM2 Multi-Worker Attraction Processing"
echo ""

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo "📦 PM2 not found. Installing..."
    npm install -g pm2
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install PM2. Please run: npm install -g pm2"
        exit 1
    fi
fi

echo "✅ PM2 version: $(pm2 --version)"
echo ""

# Create logs directory
mkdir -p logs

# Stop any existing processes
echo "🛑 Stopping any existing workers..."
pm2 delete attraction-worker 2>/dev/null || true

# Parse arguments
WORKERS=4
UPDATE_DB="true"
DRY_RUN="false"

while [[ $# -gt 0 ]]; do
    case $1 in
        --workers)
            WORKERS="$2"
            shift 2
            ;;
        --dry-run)
            UPDATE_DB="false"
            DRY_RUN="true"
            shift
            ;;
        --no-update)
            UPDATE_DB="false"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--workers N] [--dry-run] [--no-update]"
            exit 1
            ;;
    esac
done

echo "⚙️  Configuration:"
echo "   Workers: $WORKERS"
echo "   Update DB: $UPDATE_DB"
echo "   Dry run: $DRY_RUN"
echo ""

# Update ecosystem config with worker count
cat > ecosystem.config.cjs << EOF
module.exports = {
  apps: [
    {
      name: 'attraction-worker',
      script: './worker.js',
      instances: $WORKERS,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        TOTAL_WORKERS: $WORKERS,
        BATCH_SIZE: 50,
        UPDATE_DB: '$UPDATE_DB'
      },
      max_memory_restart: '1G',
      error_file: './logs/pm2-error.log',
      out_file: './logs/pm2-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss',
      merge_logs: true,
      autorestart: false,
      max_restarts: 3,
      min_uptime: '10s'
    }
  ]
};
EOF

echo "🚀 Starting $WORKERS workers..."
pm2 start ecosystem.config.cjs

if [ $? -ne 0 ]; then
    echo "❌ Failed to start workers"
    exit 1
fi

echo ""
echo "✅ Workers started successfully!"
echo ""
echo "📊 Monitor progress:"
echo "   pm2 status"
echo "   pm2 logs attraction-worker"
echo "   pm2 monit"
echo ""
echo "📁 Output files:"
echo "   output/worker-0-results.json"
echo "   output/worker-1-results.json"
echo "   output/worker-2-results.json"
echo "   output/worker-3-results.json"
echo ""
echo "🛑 Stop workers:"
echo "   pm2 stop attraction-worker"
echo "   pm2 delete attraction-worker"
echo ""

# Follow logs
echo "Following logs (Ctrl+C to exit)..."
echo ""
pm2 logs attraction-worker --lines 100
