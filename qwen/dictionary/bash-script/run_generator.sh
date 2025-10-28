#!/bin/bash

# Dictionary Generator Runner Script
# This script starts the parallel dictionary generation processes using PM2

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
LOGS_DIR="$SCRIPT_DIR/logs"
OUTPUT_DIR="$SCRIPT_DIR/output"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  [INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠️  [WARN]${NC} $1"; }
log_error() { echo -e "${RED}❌ [ERROR]${NC} $1"; }
log_success() { echo -e "${GREEN}✅ [SUCCESS]${NC} $1"; }

# Check if PM2 is installed
check_pm2() {
    if ! command -v pm2 &> /dev/null; then
        log_error "PM2 is not installed. Please install it with: npm install -g pm2"
        exit 1
    fi
}

# Check if required files exist
check_requirements() {
    local required_files=(
        "$CONFIG_DIR/ecosystem.config.js"
        "$SCRIPT_DIR/src/core/dictionaryGenerate.js"
        "$SCRIPT_DIR/input/DICTIONARY.json"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "Required file not found: $file"
            exit 1
        fi
    done
    
    log_success "All required files found"
}

# Create necessary directories
create_directories() {
    mkdir -p "$LOGS_DIR" "$OUTPUT_DIR"
    log_info "Created output and logs directories"
}

# Check environment variables
check_environment() {
    if [[ -f "$SCRIPT_DIR/.env" ]]; then
        source "$SCRIPT_DIR/.env"
        log_info "Loaded environment from .env file"
    fi
    
    if [[ -z "${DASHSCOPE_API_KEY:-}" ]]; then
        log_error "DASHSCOPE_API_KEY environment variable is not set"
        log_info "Please set it in .env file or export DASHSCOPE_API_KEY=your_api_key"
        exit 1
    fi
    
    log_success "Environment configuration verified"
}

# Start PM2 processes
start_processes() {
    log_info "Starting dictionary generation processes..."
    
    cd "$SCRIPT_DIR"
    
    # Start all processes using the ecosystem config
    if pm2 start "$CONFIG_DIR/ecosystem.config.js"; then
        log_success "All dictionary processes started successfully"
    else
        log_error "Failed to start PM2 processes"
        exit 1
    fi
}

# Show process status
show_status() {
    log_info "Current process status:"
    pm2 list | grep -E "(dict-process|Process)"
}

# Monitor progress
monitor_progress() {
    log_info "Monitoring progress... (Press Ctrl+C to stop monitoring)"
    echo ""
    echo "Real-time logs:"
    echo "=================="
    
    # Show logs for all dictionary processes
    pm2 logs --lines 20 dict-process-1 dict-process-2 dict-process-3 dict-process-4 dict-process-5 \
             dict-process-6 dict-process-7 dict-process-8 dict-process-9 dict-process-10 2>/dev/null || {
        log_info "To view logs manually, run: pm2 logs"
        log_info "To stop monitoring, run: pm2 stop all"
    }
}

# Show help
show_help() {
    echo "Dictionary Generator Runner"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start all dictionary generation processes (default)"
    echo "  stop      Stop all dictionary processes"
    echo "  restart   Restart all dictionary processes"
    echo "  status    Show process status"
    echo "  logs      Show real-time logs"
    echo "  monitor   Start processes and monitor progress"
    echo "  help      Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  DASHSCOPE_API_KEY    Required: Your Qwen API key"
    echo "  BATCH_SIZE          Optional: Items per batch (default: 20)"
    echo "  BATCH_DELAY         Optional: Delay between requests in ms (default: 2000)"
    echo ""
    echo "Examples:"
    echo "  $0                  # Start processes"
    echo "  $0 monitor          # Start and monitor progress"
    echo "  $0 status           # Check process status"
    echo "  $0 stop             # Stop all processes"
}

# Main function
main() {
    local command="${1:-start}"
    
    case "$command" in
        "start")
            log_info "🚀 Starting Dictionary Generator..."
            check_pm2
            check_requirements
            create_directories
            check_environment
            start_processes
            show_status
            log_success "Dictionary generation started! Use '$0 monitor' to view progress"
            ;;
        "stop")
            log_info "Stopping all dictionary processes..."
            pm2 delete all 2>/dev/null || log_warn "No processes to stop"
            log_success "All processes stopped"
            ;;
        "restart")
            log_info "Restarting dictionary processes..."
            pm2 restart all || log_error "Failed to restart processes"
            show_status
            ;;
        "status")
            show_status
            ;;
        "logs")
            monitor_progress
            ;;
        "monitor")
            main "start"
            monitor_progress
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
