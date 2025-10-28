# Quotation Generator

This script processes Chinese quotations and adds Vietnamese translations using the Qwen API.

## Features

- Processes Chinese quotations from `input/quotations.json`
- Adds Vietnamese translations for both title and content
- Preserves all original fields (title, category, content, images)
- Batch processing with retry logic
- Error handling and recovery
- Progress tracking and logging

## Input Format

The input file should contain an array of quotation objects:

```json
[
  {
    "title": "人逢绝境再重生，守得云开见月明",
    "category": "经典语录", 
    "content": "人逢绝境再重生，守得云开见月明。就是因为无知，才不怕...",
    "images": "1.jpg"
  }
]
```

## Output Format

The output includes Vietnamese translations:

```json
[
  {
    "title": "人逢绝境再重生，守得云开见月明",
    "category": "经典语录",
    "content": "人逢绝境再重生，守得云开见月明。就是因为无知，才不怕...",
    "images": "1.jpg",
    "title_vietnamese": "Người gặp tuyệt cảnh lại tái sinh, kiên trì đến cùng sẽ thấy trăng sáng sau mây tan",
    "content_vietnamese": "Khi con người rơi vào hoàn cảnh tuyệt vọng nhưng vẫn có cơ hội tái sinh..."
  }
]
```

## Usage

### Prerequisites

1. Ensure you have the API key set in `.env` file:
   ```
   DASHSCOPE_API_KEY=your-api-key
   BATCH_SIZE=10
   BATCH_DELAY=3000
   ```

2. Make sure the input file exists:
   ```
   input/quotations.json
   ```

### Running the Generator

#### Option 1: Use the convenience script
```bash
./run-quotation-generator.sh
```

#### Option 2: Run directly with Node.js
```bash
node src/core/quotationGenerate.js --process-id=1 --total-processes=1 --batches-per-process=800
```

#### Option 3: Parallel processing (for large datasets)
```bash
# Process 1
node src/core/quotationGenerate.js --process-id=1 --total-processes=4 --batches-per-process=200 &

# Process 2  
node src/core/quotationGenerate.js --process-id=2 --total-processes=4 --batches-per-process=200 &

# Process 3
node src/core/quotationGenerate.js --process-id=3 --total-processes=4 --batches-per-process=200 &

# Process 4
node src/core/quotationGenerate.js --process-id=4 --total-processes=4 --batches-per-process=200 &

wait
```

### Testing

To test with a small sample:

1. Create test data:
   ```bash
   node test-quotation-setup.js
   ```

2. Run test:
   ```bash
   cp test-input/quotations-test.json input/quotations.json
   node src/core/quotationGenerate.js --process-id=1 --total-processes=1 --batches-per-process=10
   ```

## Output Files

- `quotations-processed-process-{id}.json` - Final merged results for each process
- `quotation_batch_{n}_of_{total}_process_{id}.json` - Individual batch results
- `quotation_complete_process_{id}_{timestamp}.json` - Complete processing log

## Configuration

- `BATCH_SIZE`: Number of quotations per API request (default: 10)
- `BATCH_DELAY`: Delay between batches in milliseconds (default: 3000)
- `--process-id`: ID of current process (for parallel processing)
- `--total-processes`: Total number of parallel processes
- `--batches-per-process`: Maximum batches each process should handle

## Error Handling

- Automatic retry with exponential backoff
- Individual quotation processing fallback
- Incomplete JSON response repair
- Resume capability (skips already processed batches)

## Performance

For 7,103 quotations with batch size 10:
- Total batches: ~710
- Estimated time: 35-40 minutes (with 3-second delays)
- API calls: ~710 requests

## Troubleshooting

1. **API Errors**: Check your API key and account status
2. **Large Content**: Quotations are processed with max 6000 tokens
3. **Memory Issues**: Use parallel processing with smaller batch counts
4. **Network Issues**: The script will automatically retry failed requests
