# 🚀 PM2 Multi-Worker Processing Guide

Speed up attraction content generation by processing in parallel using PM2 workers.

## 📊 Performance Comparison

| Method | Workers | Speed | Best For |
|--------|---------|-------|----------|
| **Sequential** | 1 | 100 attractions/hour | Testing, small batches |
| **PM2 (2 workers)** | 2 | ~180 attractions/hour | Medium datasets |
| **PM2 (4 workers)** | 4 | ~320 attractions/hour | Large datasets ⭐ |
| **PM2 (8 workers)** | 8 | ~500 attractions/hour | Very large datasets |

**Note**: Actual speed depends on API rate limits and system resources.

---

## 🎯 Quick Start

### 1. Install PM2 (if needed)

```bash
npm install
# PM2 will be installed automatically
```

Or install globally:

```bash
npm install -g pm2
```

### 2. Start Processing with 4 Workers (Recommended)

```bash
cd qwen/attractions
npm run pm2:start
```

This will:
- ✅ Start 4 parallel workers
- ✅ Divide work evenly among workers
- ✅ Process unprocessed attractions only
- ✅ Update Supabase database
- ✅ Save individual worker results

### 3. Monitor Progress

```bash
npm run pm2:monitor
```

Or use PM2's built-in tools:

```bash
pm2 status           # Quick status
pm2 logs             # View logs
pm2 monit            # Real-time dashboard
```

### 4. Merge Results (After Completion)

```bash
npm run pm2:merge
```

---

## 🔧 Configuration Options

### Start with Custom Worker Count

```bash
# 2 workers (slower, safer for API limits)
npm run pm2:start-2
./start-pm2.sh --workers 2

# 8 workers (faster, requires good API quota)
npm run pm2:start-8
./start-pm2.sh --workers 8

# Custom number
./start-pm2.sh --workers 6
```

### Dry Run (No Database Update)

```bash
npm run pm2:start-dry
./start-pm2.sh --dry-run
```

### Stop Workers

```bash
npm run pm2:stop      # Stop workers
npm run pm2:delete    # Stop and remove from PM2
```

---

## 📊 How It Works

### Work Distribution

```
Total attractions: 1000
Workers: 4

Worker 0: Processes items 0-249    (250 items)
Worker 1: Processes items 250-499  (250 items)
Worker 2: Processes items 500-749  (250 items)
Worker 3: Processes items 750-999  (250 items)
```

### Smart Processing

- ✅ Only processes attractions without `description_vi` (skips already processed)
- ✅ Each worker saves progress independently
- ✅ Workers don't overlap (no duplicate processing)
- ✅ Graceful shutdown preserves progress

### Output Files

Each worker creates its own result file:

```
output/
  ├── worker-0-results.json    # Worker 0 results
  ├── worker-1-results.json    # Worker 1 results
  ├── worker-2-results.json    # Worker 2 results
  ├── worker-3-results.json    # Worker 3 results
  └── (merged after completion)
      ├── merged-results.json       # All results combined
      ├── merged-errors.json        # Failed items only
      └── processing-summary.json   # Summary stats
```

---

## 📋 Complete Workflow

### Step 1: Start Workers

```bash
npm run pm2:start
```

**Output:**
```
🚀 Starting PM2 Multi-Worker Attraction Processing

⚙️  Configuration:
   Workers: 4
   Update DB: true

🚀 Starting 4 workers...
✅ Workers started successfully!
```

### Step 2: Monitor Progress

**Terminal 1** - Monitor overview:
```bash
npm run pm2:monitor
```

**Terminal 2** - Follow logs:
```bash
npm run pm2:logs
```

**Web UI** - Real-time dashboard:
```bash
pm2 monit
```

### Step 3: Wait for Completion

Workers will automatically stop when done. Monitor shows:

```
Worker 0: 250/250 (100.0%) - ✅ 248 | ❌ 2
Worker 1: 250/250 (100.0%) - ✅ 250 | ❌ 0
Worker 2: 250/250 (100.0%) - ✅ 247 | ❌ 3
Worker 3: 250/250 (100.0%) - ✅ 249 | ❌ 1
```

### Step 4: Merge Results

```bash
npm run pm2:merge
```

**Output:**
```
📊 Worker 0:
   Total: 250
   Successful: 248
   Failed: 2
   Success rate: 99.2%

📊 FINAL SUMMARY
Workers: 4
Total processed: 1000
Successful: 994 ✅
Failed: 6 ❌
Success rate: 99.4%
```

### Step 5: Check Results

```bash
cat output/merged-results.json
cat output/processing-summary.json
```

---

## 🎛️ NPM Scripts Reference

| Command | Description |
|---------|-------------|
| `npm run pm2:start` | Start 4 workers (default) |
| `npm run pm2:start-dry` | Start 4 workers (no DB update) |
| `npm run pm2:start-2` | Start 2 workers |
| `npm run pm2:start-8` | Start 8 workers |
| `npm run pm2:monitor` | Check progress |
| `npm run pm2:logs` | View logs |
| `npm run pm2:merge` | Merge results after completion |
| `npm run pm2:stop` | Stop workers |
| `npm run pm2:delete` | Stop and remove workers |

---

## 🐛 Troubleshooting

### Workers Not Starting

**Problem:** `pm2 start` fails
```bash
# Check Node.js version
node --version  # Should be v16+

# Reinstall PM2
npm install pm2

# Check permissions
chmod +x start-pm2.sh
```

### API Rate Limiting

**Problem:** Too many 429 errors

**Solution:** Reduce workers or increase delay

```javascript
// Edit worker.js - line with sleep()
await sleep(2000);  // Increase from 1000 to 2000ms
```

Or start fewer workers:
```bash
./start-pm2.sh --workers 2
```

### Worker Stuck

**Problem:** Worker stops responding

```bash
# Check worker status
pm2 list

# View worker logs
pm2 logs attraction-worker --lines 100

# Restart specific worker
pm2 restart attraction-worker:0  # Restart worker 0

# Restart all
pm2 restart attraction-worker
```

### Out of Memory

**Problem:** `FATAL ERROR: ... - JavaScript heap out of memory`

**Solution:** Increase memory limit in `ecosystem.config.cjs`:

```javascript
max_memory_restart: '2G',  // Increase from 1G to 2G
```

### Results Missing

**Problem:** No worker result files

```bash
# Check if workers are still running
pm2 list

# Check logs for errors
pm2 logs --err

# Check output directory
ls -lh output/worker-*.json
```

---

## 📊 Monitoring Commands

### Quick Status Check

```bash
pm2 status
```

Shows:
- Worker names
- Status (online/stopped/errored)
- CPU usage
- Memory usage
- Uptime

### Real-time Logs

```bash
pm2 logs attraction-worker
```

Press `Ctrl+C` to exit logs (workers keep running).

### Real-time Monitoring Dashboard

```bash
pm2 monit
```

Interactive TUI showing:
- Live logs
- Resource usage
- Process list

Press `q` to quit.

### Process Details

```bash
pm2 describe attraction-worker
```

Shows full process information.

---

## 🎯 Best Practices

### 1. Choose Right Worker Count

```bash
# Small dataset (< 100 items)
./start-pm2.sh --workers 2

# Medium dataset (100-500 items)
./start-pm2.sh --workers 4  # Recommended

# Large dataset (500-2000 items)
./start-pm2.sh --workers 6

# Very large dataset (2000+ items)
./start-pm2.sh --workers 8
```

### 2. Test Before Full Run

```bash
# Dry run first (no DB updates)
./start-pm2.sh --dry-run --workers 2

# Check results
cat output/worker-0-results.json

# If good, run for real
pm2 delete attraction-worker
./start-pm2.sh --workers 4
```

### 3. Monitor Actively

Keep monitoring in another terminal:
```bash
watch -n 5 './monitor-pm2.sh'
```

### 4. Handle Interruptions

If you need to stop:
```bash
pm2 stop attraction-worker   # Graceful stop
# Workers save progress before exiting

# Later, restart from where you left off
pm2 restart attraction-worker
# Skips already processed items
```

### 5. Check Failed Items

```bash
# After merging results
cat output/merged-errors.json | jq '.[] | .original.name'

# Process failed items separately
node supabase-attraction-processor.js --code 10001
```

---

## 🚦 Performance Tuning

### Optimize for Speed

```bash
# More workers
./start-pm2.sh --workers 8

# Reduce delay in worker.js
await sleep(500);  # Down from 1000ms
```

**Risk:** May hit API rate limits

### Optimize for Stability

```bash
# Fewer workers
./start-pm2.sh --workers 2

# Increase delay in worker.js
await sleep(2000);  # Up from 1000ms
```

**Benefit:** More reliable, fewer errors

### Balance (Recommended)

```bash
# 4 workers with 1000ms delay
./start-pm2.sh --workers 4
```

**Best for:** Most use cases

---

## 📈 Expected Performance

### Example: 1000 Attractions

**Sequential Processing:**
- Time: ~8-10 hours
- Workers: 1
- Rate: ~100-125 attractions/hour

**PM2 (4 workers):**
- Time: ~3-4 hours
- Workers: 4
- Rate: ~250-330 attractions/hour
- **Speedup: 3-4x faster** 🚀

**PM2 (8 workers):**
- Time: ~2-2.5 hours
- Workers: 8
- Rate: ~400-500 attractions/hour
- **Speedup: 5-6x faster** 🚀🚀

---

## 🔒 Safety Features

✅ **No Duplicate Processing** - Workers don't overlap  
✅ **Progress Preservation** - Each worker saves independently  
✅ **Graceful Shutdown** - SIGINT/SIGTERM handled properly  
✅ **Error Isolation** - One worker's error doesn't affect others  
✅ **Automatic Restart** - Failed workers restart (configurable)  
✅ **Memory Limits** - Auto-restart if memory exceeds limit  

---

## 📞 Getting Help

**Check logs:**
```bash
pm2 logs --err                    # Error logs only
pm2 logs --lines 500              # More history
pm2 logs --json                   # JSON format
```

**Debug specific worker:**
```bash
pm2 logs attraction-worker:0      # Worker 0 only
```

**System status:**
```bash
pm2 status
pm2 info attraction-worker
pm2 describe attraction-worker:0
```

---

## 🎉 Success Example

```bash
$ npm run pm2:start
🚀 Starting 4 workers...
✅ Workers started successfully!

$ npm run pm2:monitor
Worker 0: 250/250 (100.0%) - ✅ 248 | ❌ 2
Worker 1: 250/250 (100.0%) - ✅ 250 | ❌ 0
Worker 2: 250/250 (100.0%) - ✅ 247 | ❌ 3
Worker 3: 250/250 (100.0%) - ✅ 249 | ❌ 1

$ npm run pm2:merge
📊 FINAL SUMMARY
Total processed: 1000
Successful: 994 ✅
Failed: 6 ❌
Success rate: 99.4%

✅ Results merged successfully!
```

---

**Ready to speed up your processing? Start with:**

```bash
npm run pm2:start
```

🚀 Happy parallel processing!
