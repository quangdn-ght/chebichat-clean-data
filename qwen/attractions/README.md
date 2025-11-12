# Attraction Content Generator for Supabase

A comprehensive Node.js tool to generate multilingual content (Vietnamese & English translations + descriptions) for Chinese tourist attractions using Qwen-Max API, integrated with Supabase database.

## 🌟 Features

- **Supabase Integration**: Fetch attractions directly from your Supabase database
- **AI-Powered Translation**: Uses Qwen-Max API for high-quality Vietnamese and English translations
- **Rich Content Generation**: Creates detailed 400-800 word Vietnamese descriptions with cultural context
- **Batch Processing**: Process multiple attractions with automatic progress saving
- **PM2 Multi-Worker**: Parallel processing with 3-6x speed improvement 🚀 **NEW!**
- **Database Updates**: Optionally update Supabase with generated content
- **Error Handling**: Robust retry logic and error tracking
- **Flexible CLI**: Command-line interface with multiple options

## 📋 Prerequisites

- Node.js v16 or higher
- Supabase account with attractions table
- Dashscope (Qwen) API key

## 🚀 Installation

```bash
cd qwen/attractions
npm install
```

## ⚙️ Configuration

Ensure your `.env` file has the following variables:

```env
# Qwen API
DASHSCOPE_API_KEY=sk-your-api-key-here

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## 📊 Database Schema

The script expects the following fields in your `attractions` table:

**Required fields (input):**
- `id` (uuid)
- `attraction_code` (bigint)
- `name` (text) - Chinese name
- `description` (text) - Chinese description

**Generated fields (output):**
- `name_vi` (text) - Vietnamese name
- `name_en` (text) - English name
- `description_vi` (text) - Vietnamese description (400-800 words)
- `short_description_zh` (text) - Short Chinese summary
- `short_description_vi` (text) - Short Vietnamese summary

### Add Missing Columns

If your table doesn't have the output fields, run this SQL:

```sql
ALTER TABLE attractions
  ADD COLUMN IF NOT EXISTS name_vi TEXT,
  ADD COLUMN IF NOT EXISTS name_en TEXT,
  ADD COLUMN IF NOT EXISTS description_vi TEXT,
  ADD COLUMN IF NOT EXISTS short_description_zh TEXT,
  ADD COLUMN IF NOT EXISTS short_description_vi TEXT;
```

## 🎯 Usage

### Sequential Processing (Default)

#### 1. Process Single Attraction (Test Mode)

Test with one attraction first:

```bash
node supabase-attraction-processor.js --code 10001
```

### 2. Dry Run (First 10 Attractions)

Generate content without updating database:

```bash
node supabase-attraction-processor.js --limit 10
```

### 3. Process and Update Database

Process first 10 attractions and save to Supabase:

```bash
node supabase-attraction-processor.js --limit 10 --update-db
```

### 4. Process with Offset

Skip first 20 attractions, process next 10:

```bash
node supabase-attraction-processor.js --limit 10 --offset 20 --update-db
```

### 5. Process All Attractions

**⚠️ Warning: This may take hours for large datasets**

```bash
npm run process-all
```

---

### 🚀 PM2 Multi-Worker Processing (Recommended for Large Batches)

**3-6x faster** than sequential processing! Perfect for processing hundreds or thousands of attractions.

#### Quick Start with PM2

```bash
# Start 4 parallel workers
npm run pm2:start

# Monitor progress
npm run pm2:monitor

# After completion, merge results
npm run pm2:merge
```

#### PM2 Options

```bash
# Different worker counts
npm run pm2:start-2     # 2 workers (safer)
npm run pm2:start       # 4 workers (recommended)
npm run pm2:start-8     # 8 workers (fastest)

# Dry run (no database update)
npm run pm2:start-dry

# Monitor and control
npm run pm2:logs        # View logs
npm run pm2:stop        # Stop workers
npm run pm2:delete      # Remove workers
```

#### Performance Comparison

| Method | Workers | Speed | Time for 1000 items |
|--------|---------|-------|---------------------|
| Sequential | 1 | 100/hour | ~10 hours |
| PM2 (4 workers) | 4 | 320/hour | ~3 hours 🚀 |
| PM2 (8 workers) | 8 | 500/hour | ~2 hours 🚀🚀 |

**See [PM2_GUIDE.md](./PM2_GUIDE.md) for detailed documentation.**

---

## 📖 Command-Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `--limit <n>` | Process only N attractions | `--limit 10` |
| `--offset <n>` | Skip first N attractions | `--offset 20` |
| `--code <code>` | Process single attraction by code | `--code 10001` |
| `--update-db` | Update Supabase with generated content | `--update-db` |
| `--no-save` | Don't save results to file | `--no-save` |
| `--help` | Show help message | `--help` |

## 📁 Output Files

Results are saved to `output/` directory:

- `processed-attractions.json` - Full results with statistics
- `processed-attractions-errors.json` - Failed items (if any)
- `attraction-{code}.json` - Individual attraction results

### Output Format

```json
{
  "total": 10,
  "processed": 10,
  "successful": 9,
  "failed": 1,
  "items": [
    {
      "success": true,
      "attraction_code": 10001,
      "original": {
        "id": "uuid",
        "name": "玉龙雪山",
        "description": "玉龙雪山是..."
      },
      "generated": {
        "name": "玉龙雪山",
        "name_vi": "Núi Tuyết Ngọc Long",
        "name_en": "Jade Dragon Snow Mountain",
        "description_vi": "Núi Tuyết Ngọc Long là...",
        "short_description_zh": "玉龙雪山是纳西族...",
        "short_description_vi": "Núi Tuyết Ngọc Long là..."
      }
    }
  ]
}
```

## 🎨 Example Output

**Input (Chinese):**
```
Name: 玉龙雪山
Description: 玉龙雪山位于云南省丽江市...
```

**Output:**
```json
{
  "name": "玉龙雪山",
  "name_vi": "Núi Tuyết Ngọc Long",
  "name_en": "Jade Dragon Snow Mountain",
  "description_vi": "Núi Tuyết Ngọc Long là ngọn núi thiêng trong tâm thức của dân tộc Nạp Tây...",
  "short_description_zh": "玉龙雪山是纳西族及丽江各民族心目中一座神圣的山...",
  "short_description_vi": "Núi Tuyết Ngọc Long là ngọn núi thiêng trong tâm linh người Nạp Tây..."
}
```

## ⚡ Performance

- **Processing speed**: ~2-3 seconds per attraction (with API delay)
- **Rate limiting**: Built-in retry logic with exponential backoff
- **Progress saving**: Auto-saves every 5 successful processings
- **Batch size**: Configurable in code (default: 10 per batch)

## 🔧 Customization

Edit `supabase-attraction-processor.js` to customize:

```javascript
const CONFIG = {
  model: 'qwen-max',              // AI model
  temperature: 0.7,                // Creativity level (0-1)
  retryDelay: 2000,                // Delay between requests (ms)
  maxRetries: 3,                   // Max retry attempts
  saveProgressInterval: 5          // Save every N successes
};
```

## 🐛 Troubleshooting

### API Key Error
```
❌ DASHSCOPE_API_KEY not found in environment variables
```
→ Check your `.env` file has valid `DASHSCOPE_API_KEY`

### Supabase Connection Error
```
❌ Supabase credentials not found
```
→ Verify `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` in `.env`

### Rate Limiting
```
⚠️ Rate limit hit, retrying...
```
→ Automatic retry with exponential backoff. Increase `retryDelay` if persistent.

### Empty Results
```
⚠️ No attractions found to process
```
→ Check your attractions table has records with non-null `description` field

## 📚 Related Files

- `attraction-generator.js` - Standalone generator (file-based)
- `test-generator.js` - Test script with sample data
- `travel_normalized_schema.sql` - Database schema
- `input/sample-attractions.json` - Sample input format
- `output/attractions.json` - Sample output format

## 🤝 Integration Workflow

### Recommended Process:

1. **Test with one attraction:**
   ```bash
   node supabase-attraction-processor.js --code 10001
   ```

2. **Review the output** in `output/attraction-10001.json`

3. **Process small batch (dry run):**
   ```bash
   node supabase-attraction-processor.js --limit 5
   ```

4. **If satisfied, update database:**
   ```bash
   node supabase-attraction-processor.js --limit 5 --update-db
   ```

5. **Process in chunks** (safer for large datasets):
   ```bash
   # Batch 1: 0-50
   node supabase-attraction-processor.js --limit 50 --update-db
   
   # Batch 2: 50-100
   node supabase-attraction-processor.js --limit 50 --offset 50 --update-db
   ```

6. **Monitor progress** via console logs and output files

## 📞 Support

For issues or questions:
- Check the console output for detailed error messages
- Review `processed-attractions-errors.json` for failed items
- Verify your Supabase table structure matches the schema
- Ensure your API key has sufficient credits

## 📄 License

MIT

---

**Note**: This tool uses AI-generated content. Always review generated descriptions for accuracy and cultural sensitivity before publishing.
