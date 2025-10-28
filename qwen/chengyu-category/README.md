# Chinese Idiom Classifier (成语分类器)

Automatically classify Chinese idioms (成语) into 10 semantic categories using Qwen API (通义千问).

## Features

✨ **Intelligent Classification**: Uses Qwen AI to categorize idioms based on meaning and usage  
🔄 **Batch Processing**: Processes 10 idioms per request for efficiency  
⚡ **Rate Limit Handling**: Automatic retry with exponential backoff  
📊 **Progress Tracking**: Real-time progress logs and detailed statistics  
🛡️ **Error Recovery**: Robust error handling with fallback mechanisms  

## Categories (10 类别)

1. **比喻形象** - Metaphorical/Imagery
2. **人情世故** - Human Relations/Social Wisdom
3. **智慧谋略** - Wisdom/Strategy
4. **学习勤奋** - Learning/Diligence
5. **自然时光** - Nature/Time
6. **战争政治** - War/Politics
7. **情绪状态** - Emotions/States
8. **人生哲学** - Life Philosophy
9. **数字成语** - Number Idioms
10. **品德修养** - Moral Cultivation

## Prerequisites

- Node.js 18+ (ESM support)
- Qwen API key from DashScope (阿里云百炼)

## Setup

1. **Install dependencies**:
```bash
cd qwen/chengyu-category
npm install
```

2. **Configure environment variables**:
Ensure `.env` file in project root contains:
```env
DASHSCOPE_API_KEY=sk-your-api-key-here
QWEN_MODEL=qwen-turbo  # Optional, defaults to qwen-turbo
```

3. **Prepare input file**:
Ensure `chengyu-chinese.json` exists with format:
```json
[
  { "chinese": "楚河汉界" },
  { "chinese": "一五一十" },
  ...
]
```

## Usage

### Run the classifier:
```bash
npm run classify
# or
node classify-idioms.js
```

### Expected output:
```
🚀 Starting Chinese idiom classification...

📚 Loaded 546 idioms from chengyu-chinese.json
🔧 Using model: qwen-turbo
📦 Batch size: 10 idioms per request

📊 Processing batch 1/55 (idioms 1-10)...
✅ Batch 1/55 completed (10/546)

📊 Processing batch 2/55 (idioms 11-20)...
✅ Batch 2/55 completed (20/546)
...
```

## Output Files

### 1. `classified_idioms.json`
Idioms grouped by category:
```json
{
  "比喻形象": ["虎头蛇尾", "画蛇添足", ...],
  "人情世故": ["口是心非", "笑里藏刀", ...],
  "智慧谋略": ["运筹帷幄", "深谋远虑", ...],
  ...
}
```

### 2. `stats.json`
Detailed statistics:
```json
{
  "total": 546,
  "classified": 546,
  "failed": [],
  "distribution": {
    "比喻形象": 89,
    "人情世故": 67,
    ...
  }
}
```

## Configuration

Edit `classify-idioms.js` to adjust:

```javascript
const CONFIG = {
  batchSize: 10,        // Idioms per API call
  retryDelay: 1200,     // Delay between retries (ms)
  maxRetries: 3         // Max retry attempts
};
```

## API Usage

The script uses Qwen's text generation API:
- **Endpoint**: `https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation`
- **Model**: `qwen-turbo` (configurable)
- **Temperature**: 0.1 (low for consistent classification)
- **Rate Limit**: ~60 requests/minute (handled automatically)

## Error Handling

- **Rate Limiting**: Automatic retry with 1.2s delay
- **Invalid Classifications**: Logged in `stats.json`, assigned to fallback category
- **API Errors**: Retry up to 3 times before failing
- **Batch Failures**: Failed idioms assigned to default category

## Performance

- **Processing Time**: ~11 minutes for 546 idioms (55 batches × 1.2s delay)
- **API Calls**: 55 requests (546 idioms ÷ 10 batch size)
- **Cost**: Minimal (Qwen-turbo is very affordable)

## Troubleshooting

### Issue: "DASHSCOPE_API_KEY not found"
**Solution**: Ensure `.env` file exists in project root with valid API key

### Issue: Rate limit errors
**Solution**: Increase `CONFIG.retryDelay` to 2000ms or reduce `batchSize` to 5

### Issue: Invalid classifications
**Solution**: Check `stats.json` for failed items, may need to adjust system prompt

## Example System Prompt

The script uses this Chinese prompt for Qwen:

```text
你是一个中文成语分类专家。请根据成语的深层含义和常见用法，将每个成语归入以下10个类别之一（只能选一个）：
- 比喻形象
- 人情世故
- 智慧谋略
- 学习勤奋
- 自然时光
- 战争政治
- 情绪状态
- 人生哲学
- 数字成语
- 品德修养

输出格式：仅返回类别名称，每行一个，不要解释。
```

## License

MIT

## Author

Created for CheBiChat project
