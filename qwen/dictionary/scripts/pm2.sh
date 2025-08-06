#!/bin/bash

# Dictionary Processing PM2 Management Script

case "$1" in
    "start")
        echo "🚀 Starting all dictionary processing workers..."
        pm2 start ecosystem.config.cjs
        echo "✅ All processes started!"
        echo "📊 Use 'pm2 status' to check process status"
        echo "📝 Use 'pm2 logs' to view logs"
        ;;
    "stop")
        echo "⏹️  Stopping all dictionary processing workers..."
        pm2 delete all
        echo "✅ All processes stopped!"
        ;;
    "restart")
        echo "🔄 Restarting all dictionary processing workers..."
        pm2 delete all
        sleep 2
        pm2 start ecosystem.config.cjs
        echo "✅ All processes restarted!"
        ;;
    "status")
        echo "📊 Process status:"
        pm2 status
        ;;
    "logs")
        echo "📝 Showing logs for all processes:"
        pm2 logs
        ;;
    "merge")
        echo "🔄 Merging results from all processes..."
        node mergeResults.js
        echo "✅ Merge completed!"
        ;;
    "monitor")
        echo "📊 Opening PM2 monitor..."
        pm2 monit
        ;;
    "info")
        echo "📊 Dictionary Processing System Info:"
        echo "   Total Processes: 30"
        echo "   Batches per Process: 164 (optimized for 98,053 items)"
        echo "   Total Capacity: 4,920 batches (98,400 items)"
        echo "   Coverage: 100% (all 98,053 items will be processed)"
        echo ""
        echo "💡 Commands:"
        echo "   ./pm2.sh start    - Start all processes"
        echo "   ./pm2.sh stop     - Stop all processes"
        echo "   ./pm2.sh restart  - Restart all processes"
        echo "   ./pm2.sh status   - Show process status"
        echo "   ./pm2.sh logs     - Show process logs"
        echo "   ./pm2.sh coverage - Check processing coverage"
        echo "   ./pm2.sh merge    - Merge results from all processes"
        echo "   ./pm2.sh monitor  - Open PM2 monitor dashboard"
        echo "   ./pm2.sh info     - Show this information"
        ;;
    "coverage")
        echo "📊 Checking processing coverage..."
        node checkCoverage.js
        ;;
    *)
        echo "❌ Invalid command. Available commands:"
        echo "   start, stop, restart, status, logs, coverage, merge, monitor, info"
        echo ""
        echo "💡 Run './pm2.sh info' for detailed information"
        exit 1
        ;;
esac
