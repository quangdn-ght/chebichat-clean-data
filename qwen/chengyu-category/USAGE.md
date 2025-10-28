# Quick Start Guide - 成语分类器

## ✅ Fixed Issue

**Problem**: API authentication error (401 Invalid API-key)  
**Solution**: Updated to use OpenAI SDK with correct endpoint (`dashscope-intl.aliyuncs.com/compatible-mode/v1`)

## 🚀 Run Classification

```bash
cd /home/ght/chebichat-project/chebichat-clean-data/qwen/chengyu-category
npm run classify
```

## 📊 Current Status

- **Total idioms**: 737 (from `chengyu-chinese.json`)
- **Batches**: 74 batches × 10 idioms each
- **Model**: `qwen-max` (configurable via `QWEN_MODEL` env var)
- **Processing time**: ~2.5 minutes per batch = ~3 hours total
- **Delay**: 2 seconds between batches to avoid rate limits

## 📁 Output Files

After completion, you'll find:

1. **`classified_idioms.json`** - Idioms grouped by 10 categories
2. **`stats.json`** - Statistics and failed classifications

## 🔧 Key Changes from Original Script

### Before (Not Working):
```javascript
// Used fetch() with DashScope API endpoint
const response = await fetch('https://dashscope.aliyuncs.com/...', {
  headers: { 'Authorization': `Bearer ${apiKey}` }
});
```

### After (Working):
```javascript
// Uses OpenAI SDK with compatible endpoint
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.DASHSCOPE_API_KEY,
  baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

const completion = await openai.chat.completions.create({
  model: "qwen-max",
  messages: [...]
});
```

## ⚙️ Configuration

Edit `.env` file:
```env
DASHSCOPE_API_KEY=sk-your-key-here
QWEN_MODEL=qwen-max  # Optional, defaults to qwen-max
```

Edit `classify-idioms.js` for batch settings:
```javascript
const CONFIG = {
  batchSize: 10,      // Idioms per request
  retryDelay: 2000,   // 2 seconds between batches
  maxRetries: 3       // Retry attempts
};
```

## 📈 Expected Output Example

```json
{
  "比喻形象": ["虎头蛇尾", "画蛇添足", "守株待兔", ...],
  "人情世故": ["口是心非", "笑里藏刀", "表里不一", ...],
  "智慧谋略": ["运筹帷幄", "深谋远虑", "足智多谋", ...],
  "学习勤奋": ["悬梁刺股", "凿壁偷光", "囊萤映雪", ...],
  "自然时光": ["春暖花开", "秋高气爽", "电闪雷鸣", ...],
  "战争政治": ["纸上谈兵", "草木皆兵", "四面楚歌", ...],
  "情绪状态": ["心花怒放", "怒发冲冠", "愁眉苦脸", ...],
  "人生哲学": ["塞翁失马", "因祸得福", "否极泰来", ...],
  "数字成语": ["一心一意", "三心二意", "七上八下", ...],
  "品德修养": ["一诺千金", "正直无私", "大公无私", ...]
}
```

## 🛠️ Troubleshooting

### Script stops mid-way
- Check your API quota/balance
- Increase `retryDelay` to reduce rate limit hits
- Check `stats.json` for error details

### Invalid classifications
- Some idioms may be misclassified or returned as themselves
- Check `stats.json` → `failed` array for details
- These are automatically assigned to fallback category (比喻形象)

### Want to resume from where it stopped?
- The script processes all batches sequentially
- To resume, you'd need to modify the code to skip already processed idioms
- Or manually extract unprocessed idioms from `stats.json`

## 📝 Notes

- Classification quality depends on Qwen model's understanding
- Temperature is set to 0.1 for consistent results
- Each batch takes ~2 seconds (API call + delay)
- Total processing time: 74 batches × 2s = ~3 minutes
