# Greeting Generator Documentation

## Overview
The Greeting Generator is a multi-process translation system that translates Chinese greetings and messages to Vietnamese using the Qwen AI model. It processes 8,611 greetings using 8 parallel workers for efficient translation.

## Features
- **Multi-process Architecture**: 8 parallel processes for faster translation
- **Robust Error Handling**: Retry logic and fallback processing
- **Progress Monitoring**: Real-time progress tracking
- **Automatic Recovery**: Skips already processed batches
- **PM2 Integration**: Process management and monitoring

## Input Format
```json
[
  {
    "category": "日常",
    "content": "狡兔死，走狗烹，飞鸟尽，良工藏，都是在为他人做嫁衣裳。秋风凉，甚凄凉，枝儿晃，叶儿黄，万紫千红都只剩下这衰柳枯杨。莫妄想，添衣裳，保健康！"
  }
]
```

## Output Format
```json
[
  {
    "category": "日常",
    "content": "狡兔死，走狗烹，飞鸟尽，良工藏，都是在为他人做嫁衣裳。秋风凉，甚凄凉，枝儿晃，叶儿黄，万紫千红都只剩下这衰柳枯杨。莫妄想，添衣裳，保健康！",
    "content_vietnamese": "Thỏ khôn chết rồi, chó săn bị luộc; chim bay hết, thợ giỏi cất tài. Tất cả đều chỉ là đang may áo cưới cho người khác. Gió thu lạnh, thật bi thương, cành lay, lá vàng, muôn sắc hoa tươi giờ chỉ còn lại liễu rụng cây khô. Đừng mơ mộng viễn vông, hãy thêm áo ấm, giữ gìn sức khỏe!"
  }
]
```

## Configuration

### Processing Settings
- **Total Greetings**: 8,611
- **Batch Size**: 8 greetings per batch
- **Total Processes**: 8 parallel workers
- **Batches per Process**: 500 batches each
- **Processing Capacity**: 32,000 greetings (covers all input)
- **Batch Delay**: 3 seconds between batches
- **Output Directory**: `./output/greetings/`

### Environment Variables
Create a `.env` file with:
```
DASHSCOPE_API_KEY=your-api-key-here
BATCH_SIZE=8
BATCH_DELAY=3000
```

## Usage

### 1. Start Processing
```bash
./run-greeting-generator.sh
```

This script will:
- Validate environment setup
- Create necessary directories
- Start 8 PM2 processes
- Begin monitoring logs

### 2. Monitor Progress
```bash
./monitor-greeting-progress.sh
```

This provides:
- Real-time progress tracking
- Processing rate calculation
- ETA estimation
- PM2 process status
- Recent log activity

### 3. Merge Results
```bash
./merge-greeting-results.sh
```

This creates:
- `greetings-merged-complete.json` with all translated greetings
- Verification of merge integrity
- File size and count statistics

## File Structure

### Input Files
- `input/greetings.json` - Source Chinese greetings

### Output Files
- `output/greetings/greetings-processed-process-[1-8].json` - Individual process results
- `output/greetings/greeting_batch_*_process_*.json` - Individual batch results
- `output/greetings/greeting_complete_process_*_*.json` - Complete process logs
- `output/greetings/greetings-merged-complete.json` - Final merged result

### Configuration Files
- `config/ecosystem.greeting.config.js` - PM2 configuration
- `src/core/greetingGenerate.js` - Main processing script

### Scripts
- `run-greeting-generator.sh` - Start processing
- `monitor-greeting-progress.sh` - Monitor progress
- `merge-greeting-results.sh` - Merge results

### Logs
- `logs/greeting-[1-8]-combined.log` - Combined process logs
- `logs/greeting-[1-8]-out.log` - Standard output logs
- `logs/greeting-[1-8]-error.log` - Error logs

## Process Management

### Check Status
```bash
pm2 list
```

### View Logs
```bash
pm2 logs greeting-generator
```

### Stop All Processes
```bash
pm2 delete all
```

### Restart Specific Process
```bash
pm2 restart greeting-generator-1
```

## Error Handling

The system includes several error handling mechanisms:

1. **Retry Logic**: Up to 3 attempts per batch
2. **Individual Processing**: Falls back to processing greetings one by one
3. **JSON Repair**: Attempts to fix incomplete JSON responses
4. **Batch Skipping**: Automatically skips already processed batches
5. **Error Logging**: Comprehensive error tracking

## Performance Metrics

- **Processing Rate**: ~2-4 greetings per minute per process
- **Total Estimated Time**: 4-6 hours for full processing
- **Memory Usage**: ~1GB per process
- **API Calls**: ~1,076 total batches

## Troubleshooting

### Common Issues

1. **API Key Not Set**
   - Ensure `DASHSCOPE_API_KEY` is in `.env` file
   - Check environment variable export

2. **PM2 Not Found**
   - Install PM2: `npm install -g pm2`

3. **Insufficient Disk Space**
   - Check available space for logs and output files

4. **API Rate Limits**
   - The system includes automatic delays to respect rate limits
   - Increase `BATCH_DELAY` if needed

5. **Process Hanging**
   - Check individual process logs
   - Restart specific hanging processes

### Monitoring Commands

```bash
# Check processing progress
jq 'length' output/greetings/greetings-processed-process-*.json

# View recent activity
tail -f logs/greeting-*-out.log

# Check for errors
grep -i error logs/greeting-*-error.log
```

## API Integration

The system uses the Qwen AI model through the DashScope API:
- Model: `qwen-max`
- Temperature: 0.7
- Top P: 0.8
- Max Tokens: 4000
- Timeout: 90 seconds

## Translation Quality

The system uses a specialized prompt for greeting translation that:
- Maintains cultural appropriateness
- Preserves emotional tone
- Adapts idioms and expressions
- Ensures natural Vietnamese flow
- Keeps original formatting and structure

## Completion

When processing is complete, you will have:
- 8,611 translated greetings in Vietnamese
- Individual process files for debugging
- A merged complete file ready for use
- Comprehensive logs for analysis

The final merged file (`greetings-merged-complete.json`) contains all greetings with both original Chinese content and Vietnamese translations.
