# Parallel Processing Solution for Missing Dictionary Items

This optimized solution uses **PM2 for parallel processing** to dramatically reduce the time needed to reprocess missing dictionary items from **20-30 minutes to 5-8 minutes**.

## Quick Start

### Option 1: Parallel Processing (Recommended - 5x faster)
```bash
# Run parallel processing
./fix_missing_items.sh --parallel

# Monitor progress
pm2 monit

# When all processes complete, combine results
./fix_missing_items.sh --combine

# Clean up
pm2 delete ecosystem.missing.config.js
```

### Option 2: Serial Processing (Original method)
```bash
# Run serial processing (slower but simpler)
./fix_missing_items.sh
```

## Performance Comparison

| Method | Time | Processes | Batch Size | Estimated Completion |
|--------|------|-----------|------------|---------------------|
| Serial | 20-30 min | 1 | 10 items | ~25 minutes |
| Parallel | 5-8 min | 5 | 8 items | ~6 minutes |

## How Parallel Processing Works

1. **Split Phase**: Divides 14,901 missing items into 5 chunks (~2,980 items each)
2. **Process Phase**: Runs 5 PM2 processes simultaneously, each handling one chunk
3. **Combine Phase**: Merges all results from parallel processes
4. **Merge Phase**: Integrates processed items back into main dictionary files

## Files Created for Parallel Processing

### Core Scripts
- `split_missing_items.js` - Splits items into chunks for parallel processing
- `reprocess_missing_parallel.js` - Parallel processing worker script
- `combine_parallel_results.js` - Combines results from all processes
- `merge_parallel_results.js` - Merges results into main files

### Configuration
- `ecosystem.missing.config.cjs` - PM2 configuration for 5 parallel processes

### NPM Scripts (from project root)
```bash
npm run fix:missing:parallel    # Start parallel processing
npm run fix:missing:combine     # Combine parallel results
npm run dictionary:status       # Check PM2 process status
npm run dictionary:logs         # View process logs
npm run dictionary:stop         # Stop all processes
npm run dictionary:delete       # Clean up PM2 processes
```

## Monitoring and Debugging

### Real-time Monitoring
```bash
pm2 monit                    # GUI monitoring
pm2 status                   # Process status table
pm2 logs                     # All process logs
pm2 logs missing-items-chunk-1  # Specific process logs
```

### Log Files
Logs are saved to `./logs/` directory:
- `chunk-1-out.log` - Process 1 output
- `chunk-1-error.log` - Process 1 errors
- `chunk-1-combined.log` - Process 1 combined logs
- etc.

## Process Management

### Start Parallel Processing
```bash
pm2 start ecosystem.missing.config.cjs
```

### Check Status
```bash
pm2 status
# Should show 5 processes: missing-items-chunk-1 through missing-items-chunk-5
```

### Stop All Processes
```bash
pm2 stop ecosystem.missing.config.cjs
```

### Delete All Processes
```bash
pm2 delete ecosystem.missing.config.cjs
```

## Error Handling

### If Processes Fail
1. Check logs: `pm2 logs`
2. Restart failed process: `pm2 restart missing-items-chunk-X`
3. Or restart all: `pm2 restart ecosystem.missing.config.js`

### If API Rate Limits Hit
- Processes include automatic retry logic with exponential backoff
- Each process has 2-second delays between batches
- Failed batches are retried up to 3 times

### Recovery from Interruption
If processing is interrupted:
```bash
# Check which chunks completed
ls missing-items-processed-parallel/

# Restart only incomplete processes
pm2 restart missing-items-chunk-X

# Or restart all
pm2 restart ecosystem.missing.config.cjs
```

## Directory Structure After Parallel Processing

```
dictionary/
├── missing-items/                    # Original missing items
│   ├── all-missing-items.json        # All 14,901 missing items
│   └── missing-items-process-X.json  # Items by original process
├── missing-items-split/              # Split for parallel processing
│   ├── missing-items-chunk-1.json    # ~2,980 items for process 1
│   ├── missing-items-chunk-2.json    # ~2,980 items for process 2
│   └── ...
├── missing-items-processed-parallel/ # Parallel processing results
│   ├── chunk_1_results.json          # Results from chunk 1
│   ├── chunk_2_results.json          # Results from chunk 2
│   ├── ...
│   ├── all_parallel_results.json     # Combined all results
│   ├── successful_items_for_merge.json # Only successful items
│   └── processing_summary.json       # Processing statistics
├── output-backup-parallel/           # Backups before merging
└── logs/                            # PM2 process logs
    ├── chunk-1-out.log
    ├── chunk-1-error.log
    └── ...
```

## Optimization Details

### Batch Size Optimization
- **Serial**: 10 items per batch (conservative)
- **Parallel**: 8 items per batch (optimized for parallel throughput)

### Rate Limiting
- Each process waits 2 seconds between batches
- With 5 processes, effective rate is 2.5 requests/second (within API limits)

### Memory Usage
- Each process handles ~2,980 items independently
- Results are saved incrementally to prevent memory issues

### Error Recovery
- Individual batch failures don't stop the entire process
- Failed items are marked and can be reprocessed separately
- Automatic JSON repair for truncated responses

## Expected Results

After successful parallel processing:
- **Total time**: 5-8 minutes (vs 20-30 minutes serial)
- **Items processed**: 14,901 missing items
- **Final coverage**: 98,053 items (100% of input)
- **Success rate**: Typically >98% (retry logic handles most failures)

## Troubleshooting

### Common Issues

1. **PM2 not installed**
   ```bash
   npm install -g pm2
   ```

2. **Processes stuck**
   ```bash
   pm2 delete ecosystem.missing.config.cjs
   pm2 start ecosystem.missing.config.js
   ```

3. **API key issues**
   - Ensure `.env` file exists with `DASHSCOPE_API_KEY`
   - Check API quota/rate limits

4. **Incomplete processing**
   - Check `pm2 status` for failed processes
   - Review logs in `./logs/` directory
   - Restart failed processes individually

### Manual Recovery
If automatic scripts fail, you can manually:
1. Split items: `node split_missing_items.js`
2. Process chunks: `node reprocess_missing_parallel.js --chunk=1`
3. Combine results: `node combine_parallel_results.js`
4. Merge back: `node merge_parallel_results.js`

This parallel processing solution provides a robust, fast, and monitorable way to handle the missing dictionary items while maintaining all the error handling and quality checks of the original solution.
