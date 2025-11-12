# 🚀 Quick Start Guide

Get started with the Attraction Content Generator in 5 minutes!

## Step 1: Install Dependencies

```bash
cd qwen/attractions
npm install
```

## Step 2: Verify Environment

Make sure your `../../.env` file contains:

```env
DASHSCOPE_API_KEY=sk-your-key-here
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-key-here
```

## Step 3: Test Database Connection

```bash
npm run test-db
```

Expected output:
```
✅ Found X attractions in database
✅ Sample attraction fetched successfully
```

## Step 4: Add Multilingual Columns (First Time Only)

If the test shows missing columns, run this SQL in Supabase SQL Editor:

1. Go to your Supabase project → SQL Editor
2. Open `add-multilingual-columns.sql`
3. Copy and execute the SQL

## Step 5: Test with Single Attraction

```bash
npm run test-single
# or specify a code:
node supabase-attraction-processor.js --code 10001
```

This will:
- ✅ Fetch attraction from Supabase
- ✅ Generate Vietnamese & English content
- ✅ Save to `output/attraction-10001.json`
- ❌ NOT update database (safe test)

## Step 6: Process Small Batch (Dry Run)

```bash
npm run process-dry
```

This processes 10 attractions without updating the database.

## Step 7: Process and Update Database

Once satisfied with the output:

```bash
npm run process-update
```

This will process 10 attractions and update your Supabase database.

## Step 8: Scale Up

Process in batches:

```bash
# Batch 1: First 50
node supabase-attraction-processor.js --limit 50 --update-db

# Batch 2: Next 50
node supabase-attraction-processor.js --limit 50 --offset 50 --update-db
```

Or process all (may take hours):

```bash
npm run process-all
```

---

## 📊 Available NPM Scripts

| Command | Description |
|---------|-------------|
| `npm run test-db` | Test Supabase connection |
| `npm run test-api` | Test Qwen API with sample |
| `npm run test-single` | Process one attraction (no DB update) |
| `npm run process-dry` | Process 10 attractions (no DB update) |
| `npm run process-update` | Process 10 attractions + update DB |
| `npm run process-all` | Process ALL attractions + update DB |

---

## 🔍 What Gets Generated?

For each Chinese attraction, you get:

✅ **name_vi** - Vietnamese name translation  
✅ **name_en** - English name translation  
✅ **description_vi** - 400-800 word Vietnamese description with:
   - Geographic and cultural context
   - Historical background
   - Scenic zones and features
   - Seasonal changes
   - Visitor experience
   - Legends and spiritual significance

✅ **short_description_zh** - 1-2 sentence Chinese summary  
✅ **short_description_vi** - 2-3 sentence Vietnamese summary

---

## 📁 Output Files

All results saved to `output/` directory:

- `processed-attractions.json` - Complete results
- `attraction-{code}.json` - Individual results
- `processed-attractions-errors.json` - Failed items (if any)

---

## ⚠️ Important Notes

1. **First run**: Always test with `--code` or `--limit 10` first
2. **Check output**: Review generated content before mass processing
3. **Database backup**: Backup your Supabase data before mass updates
4. **API costs**: Qwen API usage costs money - monitor your usage
5. **Rate limits**: Built-in delays prevent rate limiting
6. **Progress saving**: Progress auto-saves every 5 successes

---

## 🐛 Common Issues

### "API key not found"
→ Check `.env` file has `DASHSCOPE_API_KEY`

### "Supabase credentials not found"
→ Check `.env` file has `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`

### "No attractions found"
→ Make sure your attractions have non-null `description` field

### "Column does not exist"
→ Run `add-multilingual-columns.sql` in Supabase

---

## 📚 Documentation

- Full README: [README.md](./README.md)
- Database schema: [travel_normalized_schema.sql](./travel_normalized_schema.sql)
- Add columns: [add-multilingual-columns.sql](./add-multilingual-columns.sql)

---

## 🎯 Recommended Workflow

```bash
# 1. Test connection
npm run test-db

# 2. Test single attraction
npm run test-single

# 3. Check the output
cat output/attraction-10001.json

# 4. If good, process small batch
npm run process-dry

# 5. Review output/processed-attractions.json

# 6. If satisfied, update database
npm run process-update

# 7. Scale up in batches
node supabase-attraction-processor.js --limit 50 --update-db
node supabase-attraction-processor.js --limit 50 --offset 50 --update-db
# ... continue as needed
```

---

**Happy processing! 🎉**

For help: `node supabase-attraction-processor.js --help`
