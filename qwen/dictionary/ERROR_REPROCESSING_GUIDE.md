# Error Reprocessing Guide for Dictionary Generation

## Overview
This guide explains how to identify and reprocess batch files that contain "400 Access denied" errors from the Alibaba Qwen API.

## Current Status
- **Total batch files**: 4,974
- **Files with access denied errors**: 1,434 (initially)
- **Test processed**: 2 files (successfully)
- **Remaining errors**: ~1,432 files

## Files Created

### 1. `reprocessErrorBatches.js`
A specialized script that:
- Scans all batch files for "400 Access denied" errors
- Extracts original input data for failed batches
- Reprocesses them with the Qwen API
- Backs up original error files before overwriting
- Supports parallel processing across multiple processes
- Includes comprehensive error handling and retry logic

### 2. `reprocess-errors.sh`
A shell script wrapper that:
- Runs multiple parallel processes for faster processing
- Provides progress monitoring
- Shows summary statistics
- Easy to configure for different batch sizes

### 3. `mergeReprocessedData.js`
A data consolidation script that:
- Merges all batch files for each process into `dict-processed-process-{id}.json`
- Handles duplicate Chinese words intelligently
- Uses error fallback data when reprocessed data is invalid
- Creates a final merged dictionary from all processes
- Provides detailed statistics and data quality reports

### 4. `merge-reprocessed.sh`
A shell script wrapper for data merging that:
- Merges data for specific process or all processes
- Shows word counts and file statistics
- Provides data quality summaries

### 5. Updated `dictionaryGenerate.js`
Modified the `batchExists()` function to:
- Check not only if a file exists
- But also verify it doesn't contain access denied errors
- Automatically reprocess error files in future runs

## Usage Instructions

### Option 1: Automated Parallel Processing (Recommended)
```bash
# Run with 4 parallel processes, 50 batches per process per run
cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary
./reprocess-errors.sh 4 50

# Or customize the parameters
./reprocess-errors.sh 8 30  # 8 processes, 30 batches each
```

### Option 2: Manual Single Process
```bash
# Process specific number of batches
node reprocessErrorBatches.js --process-id=1 --total-processes=1 --max-batches=100

# Run specific process in parallel setup
node reprocessErrorBatches.js --process-id=2 --total-processes=4 --max-batches=50
```

### Option 3: Continue with Modified Original Script
The original `dictionaryGenerate.js` now automatically detects and reprocesses error files:
```bash
node dictionaryGenerate.js --process-id=1 --total-processes=10 --batches-per-process=60
```

### Option 4: Merge Reprocessed Data
After reprocessing, merge all batch data into consolidated files:
```bash
# Merge all processes
./merge-reprocessed.sh

# Merge specific process only
./merge-reprocessed.sh 1

# Manual merge with more control
node mergeReprocessedData.js --process-id=1 --skip-final-merge
```

## Configuration Parameters

### Environment Variables (.env file)
```
DASHSCOPE_API_KEY=your-api-key-here
BATCH_SIZE=20
BATCH_DELAY=2000
```

### Command Line Arguments
- `--process-id=N`: Which process number (1-based)
- `--total-processes=N`: Total number of parallel processes
- `--max-batches=N`: Maximum batches to process per run (for reprocessing script)
- `--batches-per-process=N`: Batches per process (for original script)

## Processing Strategy

### For Quick Resolution (Recommended)
```bash
# Run multiple rounds with reasonable batch sizes
./reprocess-errors.sh 8 25   # 8 processes × 25 batches = 200 batches per round
```

### For Resource-Limited Environments
```bash
# Smaller batches, fewer processes
./reprocess-errors.sh 2 10   # 2 processes × 10 batches = 20 batches per round
```

### For Maximum Speed (if API limits allow)
```bash
# More processes, larger batches
./reprocess-errors.sh 16 50  # 16 processes × 50 batches = 800 batches per round
```

## Monitoring Progress

### Check Remaining Errors
```bash
cd /home/ght/chebichat-project/chebichat-clean-data/qwen/dictionary/output
find . -name "dict_batch_*.json" -exec grep -l "400 Access denied" {} \; | wc -l
```

### View Recent Processing Logs
The scripts provide real-time progress updates including:
- Number of files being processed
- Success/failure rates
- Estimated remaining time
- Backup file locations

## Backup and Recovery

### Error File Backups
- Original error files are automatically backed up with `.error-backup.json` extension
- Example: `dict_batch_113_of_4903_process_1.error-backup.json`

### Recovery Process
If something goes wrong, you can restore original files:
```bash
cd output
# Restore a specific file
cp dict_batch_113_of_4903_process_1.error-backup.json dict_batch_113_of_4903_process_1.json

# Restore all error backups (if needed)
for file in *.error-backup.json; do
    original=${file/.error-backup.json/.json}
    cp "$file" "$original"
done
```

## Expected Processing Time

With the current setup (~1,432 error files):
- **Single process, 50 batches**: ~29 rounds needed
- **4 processes, 25 batches each**: ~15 rounds needed  
- **8 processes, 25 batches each**: ~8 rounds needed

Estimated time per batch: 3-5 seconds (including API call + delay)

## Next Steps

1. **Run the reprocessing script**:
   ```bash
   ./reprocess-errors.sh 4 50
   ```

2. **Monitor progress** and run additional rounds as needed

3. **Merge reprocessed data**:
   ```bash
   ./merge-reprocessed.sh
   ```

4. **Verify completion**:
   ```bash
   # Should return 0 when all errors are fixed
   find output -name "dict_batch_*.json" -exec grep -l "400 Access denied" {} \; | wc -l
   ```

5. **Check final output**:
   ```bash
   # View merged files
   ls -la output/dict-processed-process-*.json
   ls -la output/dictionary-final-merged-*.json
   ```

6. **Continue with normal dictionary generation** for any remaining unprocessed batches

## Troubleshooting

### API Rate Limits
- Increase `BATCH_DELAY` in .env file
- Reduce number of parallel processes
- Reduce `max-batches` parameter

### Memory Issues
- Reduce number of parallel processes
- Reduce batch sizes

### Network Issues
- The script includes automatic retry logic
- Failed batches will be retried up to 3 times
- Individual word processing as fallback

This solution ensures all "400 Access denied" errors are systematically identified and reprocessed while maintaining data integrity and providing comprehensive monitoring.

## Data Merging and Consolidation

### Overview
After reprocessing error batches, you need to consolidate all the batch files into unified process files and create a final merged dictionary.

### Merge Process Features
- **Duplicate Detection**: Identifies duplicate Chinese words across batches
- **Error Fallback**: Uses original error backup data when reprocessed data is invalid
- **Quality Control**: Validates dictionary entries and provides statistics
- **Process Isolation**: Creates separate files for each process ID
- **Final Consolidation**: Merges all processes into a single dictionary file

### Merge Commands

#### Quick Merge (Recommended)
```bash
# Merge all processes and create final dictionary
./merge-reprocessed.sh
```

#### Process-Specific Merge
```bash
# Merge only process 1
./merge-reprocessed.sh 1

# Merge only process 5
./merge-reprocessed.sh 5
```

#### Advanced Manual Control
```bash
# Merge specific process without final merge
node mergeReprocessedData.js --process-id=1 --skip-final-merge

# Merge all processes without final merge
node mergeReprocessedData.js --skip-final-merge

# Only create final merge (assumes process files exist)
node mergeReprocessedData.js
```

### Output Files

#### Process Files
- `dict-processed-process-1.json` - All valid words from process 1
- `dict-processed-process-2.json` - All valid words from process 2
- etc.

#### Final Merged File
- `dictionary-final-merged-YYYY-MM-DDTHH-MM-SS.json` - Complete dictionary

#### File Structure
```json
[
  {
    "chinese": "爱护",
    "pinyin": "ài hù",
    "type": "động từ",
    "meaning_vi": "Yêu thương và bảo vệ...",
    "meaning_en": "To cherish and protect...",
    "example_cn": "我们要爱护环境。",
    "example_vi": "Chúng ta cần phải bảo vệ môi trường.",
    "example_en": "We need to protect the environment.",
    "grammar": "Là động từ hai âm tiết...",
    "hsk_level": 6,
    "meaning_cn": "原始中文释义..."
  }
]
```

### Merge Statistics
The merge process provides detailed statistics:
- Total batch files processed
- Valid dictionary entries
- Duplicates found and resolved  
- Error fallback data used
- Final unique word count

### Data Quality Checks
- Validates dictionary entry completeness
- Identifies and handles invalid entries
- Uses error backup data when needed
- Removes metadata and system entries
- Sorts output alphabetically
