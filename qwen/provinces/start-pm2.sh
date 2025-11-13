#!/bin/bash

# Province Worker PM2 Startup Script
# This script starts multiple worker processes in parallel using PM2

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default configuration
WORKERS=4
UPDATE_DB=false
DRY_RUN=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --workers)
      WORKERS="$2"
      shift 2
      ;;
    --update-db)
      UPDATE_DB=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Province Worker PM2 Startup${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Workers: ${GREEN}${WORKERS}${NC}"
echo -e "Update DB: ${GREEN}${UPDATE_DB}${NC}"
echo -e "Dry Run: ${GREEN}${DRY_RUN}${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Create logs directory
mkdir -p logs
mkdir -p output/workers

# Stop any existing instances
echo -e "${YELLOW}Stopping any existing province-worker instances...${NC}"
pm2 delete province-worker 2>/dev/null || true

# Update ecosystem config
echo -e "${BLUE}Configuring PM2...${NC}"
cat > ecosystem.config.cjs << EOF
module.exports = {
  apps: [{
    name: 'province-worker',
    script: './worker.js',
    instances: ${WORKERS},
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      TOTAL_WORKERS: '${WORKERS}',
      BATCH_SIZE: '50',
      UPDATE_DB: '${UPDATE_DB}'
    },
    error_file: './logs/province-worker-error.log',
    out_file: './logs/province-worker-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss',
    autorestart: false,
    max_memory_restart: '500M',
    time: true
  }]
};
EOF

if [ "$DRY_RUN" = true ]; then
  echo -e "${YELLOW}DRY RUN MODE - Database will NOT be updated${NC}\n"
fi

# Start PM2
echo -e "${GREEN}Starting ${WORKERS} worker(s)...${NC}\n"
pm2 start ecosystem.config.cjs

echo -e "\n${GREEN}✅ Workers started successfully!${NC}\n"

# Show status
pm2 list

echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}   Useful Commands${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Monitor logs:     ${GREEN}pm2 logs province-worker${NC}"
echo -e "Monitor status:   ${GREEN}pm2 monit${NC}"
echo -e "Stop workers:     ${GREEN}pm2 stop province-worker${NC}"
echo -e "Delete workers:   ${GREEN}pm2 delete province-worker${NC}"
echo -e "Check DB status:  ${GREEN}node monitor-db.js${NC}"
echo -e "${BLUE}========================================${NC}\n"
