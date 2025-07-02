# Radical Suggest Batch Processor

This script processes Chinese character descriptions in batches using Qwen API to generate poetic mnemonics.

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Set up environment variables:**
   
   Copy the example file and edit it:
   ```bash
   cp .env.example .env
   ```
   
   Then edit `.env` file and add your API key:
   ```
   DASHSCOPE_API_KEY=your-api-key-here
   ```
   
   Alternatively, you can still use environment variables:
   ```bash
   export DASHSCOPE_API_KEY="your-api-key-here"
   ```

3. **Verify setup:**
   ```bash
   node test-setup.js
   ```

## Usage

```bash
node radicalSuggest.js
```

## Features

- **Batch Processing**: Processes 100 items per batch to manage API rate limits
- **Resume Capability**: Automatically skips already processed batches if interrupted
- **Error Handling**: Robust error handling with detailed logging
- **Progress Tracking**: Shows processing progress and percentage completion
- **Rate Limiting**: Built-in 2-second delay between batches
- **Dual Output**: Saves both individual batch results and complete combined results

## Input Format

The script reads from `./input/radical-suggest.json` which should contain an array of objects:

```json
[
    { "一": "Hình ảnh một ngón tay để ngang." },
    { "二": "Hình ảnh hai ngón tay để ngang, ngón dưới dài hơn." }
]
```

## Output

Results are saved to `./output/` folder:

- **Individual batches**: `radical_suggest_batch_X_of_Y.json`
- **Complete results**: `radical_suggest_complete_TIMESTAMP.json`

## Data Statistics

- Total items: 2,792 Chinese characters
- Batch size: 100 items
- Total batches: 28 (last batch has 92 items)
- Estimated processing time: ~2 minutes (with 2-second delays)

## Error Recovery

If the process is interrupted, simply run the script again. It will automatically:
- Check for existing batch files
- Skip already processed batches
- Continue from where it left off

## API Configuration

The script uses:
- **Model**: qwen-max
- **Base URL**: https://dashscope-intl.aliyuncs.com/compatible-mode/v1
- **Parameters**: top_p=0.8, temperature=0.7
