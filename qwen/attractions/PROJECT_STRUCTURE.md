# Attractions Project Structure

## 📁 Directory Organization

```
attractions/
├── database/                      # Database schemas and SQL scripts
│   ├── add-multilingual-columns.sql
│   └── travel_normalized_schema.sql
│
├── scripts/                       # Main processing scripts
│   ├── processors/               # Core data processing scripts
│   │   ├── attraction-generator.js
│   │   ├── supabase-attraction-processor.js
│   │   ├── worker.js
│   │   ├── fetch-html-entity-items.js
│   │   └── merge-results.js
│   │
│   ├── analysis/                 # Data analysis scripts
│   │   └── analyze-failed-items.js
│   │
│   └── retry/                    # Retry mechanisms for failed items
│       ├── retry-failed-items.js
│       ├── final-retry.js
│       └── smart-retry.js
│
├── pm2/                          # PM2 configuration and monitoring
│   ├── ecosystem.config.cjs      # PM2 ecosystem configuration
│   ├── PM2_QUICK_REFERENCE.txt   # PM2 commands reference
│   ├── monitor-db.js             # Database monitoring script
│   └── monitor-pm2.sh            # PM2 monitoring shell script
│
├── shell-scripts/                # Shell scripts for automation
│   ├── setup.sh                  # Project setup script
│   ├── start-pm2.sh              # PM2 startup script
│   └── merge-results.sh          # Results merging script
│
├── tests/                        # Test scripts
│   ├── test-generator.js
│   └── test-supabase.js
│
├── reports/                      # Generated reports and logs
│   ├── results/                  # Processing results and reports
│   │   ├── failed-attractions-report.csv
│   │   ├── failed-attractions-report.json
│   │   ├── final-retry-results.json
│   │   └── html-entity-cleaned-items.json
│   │
│   └── logs/                     # Log files
│       └── smart-retry-log.txt
│
├── input/                        # Input data files
│   └── sample.txt
│
├── output/                       # Generated output files
│   ├── attractions.json
│   ├── output.md
│   └── worker-*.json             # Worker results (0-9)
│
├── logs/                         # Runtime logs (gitignored)
│
├── docs/                         # Project documentation
│   ├── README.md
│   ├── QUICKSTART.md
│   ├── ARCHITECTURE.md
│   ├── PROJECT_SUMMARY.md
│   ├── PM2_GUIDE.md
│   ├── FILE_INDEX.md
│   └── ... (other documentation)
│
├── package.json                  # Node.js dependencies
└── PROJECT_STRUCTURE.md          # This file

```

## 📋 Quick Reference

### Main Entry Points
- **Start Processing**: `./shell-scripts/start-pm2.sh`
- **Setup Environment**: `./shell-scripts/setup.sh`
- **PM2 Config**: `./pm2/ecosystem.config.cjs`

### Core Processors
- **Main Generator**: `scripts/processors/attraction-generator.js`
- **Supabase Processor**: `scripts/processors/supabase-attraction-processor.js`
- **Worker**: `scripts/processors/worker.js`

### Monitoring & Analysis
- **Monitor Database**: `pm2/monitor-db.js`
- **Analyze Failures**: `scripts/analysis/analyze-failed-items.js`
- **Smart Retry**: `scripts/retry/smart-retry.js`

### Documentation
- **Getting Started**: `docs/QUICKSTART.md`
- **Architecture**: `docs/ARCHITECTURE.md`
- **PM2 Guide**: `docs/PM2_GUIDE.md`

## 🔧 Common Commands

```bash
# Setup
npm install
./shell-scripts/setup.sh

# Start processing with PM2
./shell-scripts/start-pm2.sh

# Monitor processes
pm2 monit
pm2 logs

# Run tests
node tests/test-generator.js
node tests/test-supabase.js

# Analyze and retry failed items
node scripts/analysis/analyze-failed-items.js
node scripts/retry/smart-retry.js
```

## 📝 Notes

- All SQL schemas are in `database/`
- Processing scripts are organized by function in `scripts/`
- PM2 configuration and monitoring tools are in `pm2/`
- Reports and results are kept in `reports/`
- Documentation is centralized in `docs/`
- Test files are in `tests/`

For detailed information, see the documentation in the `docs/` folder.
