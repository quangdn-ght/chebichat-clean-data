# Region Data Generator

Automatically generate multilingual region data (Vietnamese translations and descriptions) using Qwen-Max API and sync to Supabase.

## Overview

This tool processes Chinese region names from the `regions` table and generates:
- `name_vi`: Vietnamese translation of region name
- `short_description`: Concise 1-2 sentence description in Chinese
- `short_description_vi`: Concise 2-3 sentence description in Vietnamese

## Features

- ✅ **Qwen-Max API Integration**: High-quality translations and descriptions
- ✅ **Multi-worker Processing**: Parallel processing with PM2 for faster execution
- ✅ **Database Sync**: Automatic updates to Supabase regions table
- ✅ **Progress Tracking**: Monitor processing status in real-time
- ✅ **Error Handling**: Retry logic and detailed error reporting

## Prerequisites

1. Node.js 18+ installed
2. Supabase credentials configured in `.env`
3. Qwen API key (DASHSCOPE_API_KEY) in `.env`
4. PM2 installed globally: `npm install -g pm2`

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Add Short Description Columns (First Time Only)

Run this SQL in Supabase SQL Editor:

```sql
-- Add short_description columns to regions table
ALTER TABLE public.regions 
ADD COLUMN IF NOT EXISTS short_description TEXT;

ALTER TABLE public.regions 
ADD COLUMN IF NOT EXISTS short_description_vi TEXT;
```

Or run the schema script:
```bash
# Note: This requires Supabase RPC function or manual SQL execution
node apply-schema.js
```

### 3. Test with a Few Records

Test without updating database (dry run):
```bash
node region-generator.js --limit 3
```

Test with database update:
```bash
node region-generator.js --limit 3 --update-db
```

### 4. Process All Regions with PM2 (Recommended)

**Dry run (no database updates):**
```bash
./start-pm2.sh --workers 4 --dry-run
```

**Production mode (with database updates):**
```bash
./start-pm2.sh --workers 4 --update-db
```

## Commands

### Single-threaded Processing

```bash
# Process 10 regions (dry run)
node region-generator.js --limit 10

# Process 10 regions and update database
node region-generator.js --limit 10 --update-db

# Process all regions
node region-generator.js --update-db

# Process with offset
node region-generator.js --limit 50 --offset 100 --update-db
```

### Multi-worker Processing with PM2

```bash
# Start with 4 workers (dry run)
./start-pm2.sh --workers 4 --dry-run

# Start with 4 workers and update database
./start-pm2.sh --workers 4 --update-db

# Start with 8 workers for faster processing
./start-pm2.sh --workers 8 --update-db

# View logs
pm2 logs region-worker

# Monitor status
pm2 monit

# Stop workers
pm2 stop region-worker

# Delete workers
pm2 delete region-worker
```

### Monitoring

```bash
# Check database status once
node monitor-db.js

# Watch mode (auto-refresh every 5 seconds)
node monitor-db.js --watch

# Custom refresh interval (10 seconds)
node monitor-db.js --watch --interval=10

# Query regions without name_vi
node test-query-regions.js
```

## Project Structure

```
regions/
├── region-generator.js          # Main generator script (single-threaded)
├── worker.js                    # Worker script for PM2 parallel processing
├── ecosystem.config.cjs         # PM2 configuration
├── start-pm2.sh                # PM2 startup script
├── monitor-db.js               # Database monitoring tool
├── test-query-regions.js       # Query and test script
├── apply-schema.js             # Schema migration script
├── add-short-description-columns.sql  # SQL schema changes
├── package.json                # Dependencies
├── logs/                       # PM2 logs
└── output/                     # Processing results
    └── workers/                # Worker-specific results
```

## Configuration

Edit `ecosystem.config.cjs` to customize:

```javascript
{
  instances: 4,              // Number of parallel workers
  env: {
    TOTAL_WORKERS: '4',      // Total workers (should match instances)
    BATCH_SIZE: '50',        // Items per worker batch
    UPDATE_DB: 'true'        // 'true' to update DB, 'false' for dry run
  }
}
```

## Processing Statistics

- **Total Regions**: 294 regions without `name_vi`
- **Processing Time**: ~2-3 seconds per region
- **Estimated Total Time**:
  - 1 worker: ~15-20 minutes
  - 4 workers: ~4-5 minutes
  - 8 workers: ~2-3 minutes

## Output Files

Results are saved in `output/` directory:

- `regions-all-[timestamp].json`: All processing results
- `regions-success-[timestamp].json`: Successfully processed regions
- `regions-failed-[timestamp].json`: Failed regions (if any)
- `workers/worker-[id]-results-[timestamp].json`: Individual worker results

## Workflow

1. **Query**: Fetch regions where `name_vi IS NULL`
2. **Generate**: Call Qwen-Max API to generate translations and descriptions
3. **Validate**: Check response for required fields
4. **Update**: Sync data to Supabase (if `--update-db` flag is set)
5. **Save**: Store results in JSON files for tracking

## Error Handling

- **API Errors**: Automatic retry (up to 3 attempts)
- **Rate Limiting**: 1 second delay between requests
- **Failed Items**: Saved to separate JSON file for review
- **Worker Crashes**: PM2 auto-restart disabled (set `autorestart: true` if needed)

## Monitoring Progress

While processing is running:

```bash
# Terminal 1: Watch PM2 logs
pm2 logs region-worker

# Terminal 2: Monitor database
node monitor-db.js --watch

# Terminal 3: PM2 dashboard
pm2 monit
```

## Troubleshooting

**Issue**: "Cannot find package '@supabase/supabase-js'"
```bash
npm install
```

**Issue**: PM2 not found
```bash
npm install -g pm2
```

**Issue**: Workers not updating database
- Ensure `--update-db` flag is set in `start-pm2.sh`
- Check `UPDATE_DB: 'true'` in `ecosystem.config.cjs`

**Issue**: API rate limit errors
- Increase sleep time in `region-generator.js`
- Reduce number of workers

## Example Output

```
🚀 Worker 0 started
   Total workers: 4
   Batch size: 50
   Update DB: true

📊 Worker 0: Found 294 unprocessed regions
📋 Worker 0: Assigned range 0 to 73 (74 items)
✅ Worker 0: Fetched 74 regions

[Worker 0] [1/74] Processing "伊春"...
📡 Calling Qwen-Max API for "伊春" (attempt 1)...
✅ Generated content for "伊春"

📝 Generated Content:
   Name (ZH): 伊春
   Name (VI): Nghi Xuân
   Short Desc (ZH): 伊春位于黑龙江省东北部，是中国著名的林业城市，被誉为"中国林都"。
   Short Desc (VI): Nghi Xuân nằm ở phía đông bắc tỉnh Hắc Long Giang, là thành phố lâm nghiệp nổi tiếng của Trung Quốc, được mệnh danh là "Kinh đô rừng xanh của Trung Quốc". Thành phố này nổi bật với diện tích rừng rộng lớn và cảnh quan thiên nhiên tươi đẹp.

✅ Updated region ID 146 in database

✅ Completed in 2847ms
```

## Next Steps

After processing completes:

1. Verify results: `node monitor-db.js`
2. Check output files in `output/` directory
3. Review any failed items in `regions-failed-*.json`
4. Manually process failures if needed

## License

Part of the CheBiChat project.
