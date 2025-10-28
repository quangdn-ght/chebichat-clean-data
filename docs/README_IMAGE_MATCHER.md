# Dictionary Image Matcher

This feature implements automatic matching of Chinese words in the dictionary with their corresponding images, based on the `dict-images.json` file.

## Overview

The image matcher processes the `dict-images.json` file which contains mappings between Chinese words and image filenames. It implements an **n:1 relationship** where multiple Chinese words can map to the same image.

### Data Structure

Each entry in `dict-images.json` follows this format:
```json
{
  "chinese": "棺材,眉毛,眼睛,鼻子,嘴巴,腿,手",
  "images": "836.jpg"
}
```

This means:
- `棺材` → `836.jpg`
- `眉毛` → `836.jpg`  
- `眼睛` → `836.jpg`
- `鼻子` → `836.jpg`
- `嘴巴` → `836.jpg`
- `腿` → `836.jpg`
- `手` → `836.jpg`

## Database Schema

First, add the image field to the dictionary table:

```sql
-- Run this SQL to add the image_url field
ALTER TABLE public.dictionary 
ADD COLUMN image_url text;

-- Add index for better performance
CREATE INDEX idx_dictionary_image_url ON public.dictionary (image_url);
```

Or run the provided SQL file:
```bash
psql -d your_database -f database/add-image-field.sql
```

## Installation & Setup

1. **Install dependencies** (already included in package.json):
   ```bash
   npm install
   ```

2. **Configure database connection**:
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

3. **Test the setup**:
   ```bash
   node image-matcher.js preview 5
   ```

## Usage

### Preview Mode
Preview what would be processed without making any changes:
```bash
node image-matcher.js preview [maxEntries]
```

Examples:
```bash
node image-matcher.js preview           # Show first 10 entries
node image-matcher.js preview 20        # Show first 20 entries
```

### Dry Run Mode
See what would be processed without updating the database:
```bash
node image-matcher.js process --dry-run
node image-matcher.js process --dry-run --max 50   # Process only first 50 entries
```

### Full Processing
Process all entries and update the database:
```bash
node image-matcher.js process [batchSize]
```

Examples:
```bash
node image-matcher.js process           # Process with default batch size (10)
node image-matcher.js process 20        # Process with batch size of 20
node image-matcher.js process --max 100 # Process only first 100 entries
```

### Statistics
View current image statistics in the database:
```bash
node image-matcher.js stats
```

## Features

### 🔄 Batch Processing
- Processes entries in configurable batches to avoid overwhelming the database
- Default batch size: 10 entries
- Includes small delays between batches

### 📊 Detailed Logging
- Real-time progress updates
- Word-by-word matching results
- Comprehensive error reporting
- Final processing summary

### 🔍 Smart Word Parsing
- Splits comma-separated Chinese words
- Trims whitespace and filters empty entries
- Handles various input formats gracefully

### 🛡️ Error Handling
- Continues processing even if individual words fail
- Collects and reports all errors at the end
- Database transaction safety

### 📈 Statistics & Monitoring
- Tracks total entries processed
- Counts successful matches and updates
- Reports database records affected
- Provides image usage statistics

## Example Output

```
🚀 Starting Image Matcher for Dictionary

Configuration:
  📄 Images file: /path/to/dict-images.json
  🗄️  Database: localhost:5432/chebichat
  📦 Batch size: 10
  🔍 Dry run: No

✓ Loaded 4002 image entries from dict-images.json
🔗 Testing database connection...
✓ Connected successfully! Dictionary has 15000 entries

📊 Processing 4002 image entries...

[1] Processing: "符号,字母,小写字母" -> 53.jpg
  📝 Found 3 words: 符号, 字母, 小写字母
  ✓ Found "符号" in dictionary (2 entries)
  ✅ Updated 2 record(s) for "符号"
  ✓ Found "字母" in dictionary (1 entries)
  ✅ Updated 1 record(s) for "字母"
  ❌ Word "小写字母" not found in dictionary

[2] Processing: "棺材,眉毛,眼睛,鼻子,嘴巴,腿,手" -> 836.jpg
  📝 Found 7 words: 棺材, 眉毛, 眼睛, 鼻子, 嘴巴, 腿, 手
  ✓ Found "棺材" in dictionary (1 entries)
  ✅ Updated 1 record(s) for "棺材"
  ✓ Found "眉毛" in dictionary (1 entries)
  ✅ Updated 1 record(s) for "眉毛"
  ...

============================================================
📊 PROCESSING SUMMARY
============================================================
📄 Total image entries: 4002
📝 Total words extracted: 12546
✅ Words matched in dictionary: 8934
🔄 Database records updated: 8934
❌ Errors encountered: 0
============================================================
```

## Configuration Options

### Environment Variables
```bash
DB_HOST=localhost           # Database host
DB_PORT=5432               # Database port
DB_NAME=chebichat          # Database name
DB_USER=postgres           # Database user
DB_PASSWORD=your_password  # Database password
```

### Command Line Options
- `--dry-run`: Preview without making changes
- `--max [number]`: Limit number of entries to process
- `[batchSize]`: Number of entries to process in each batch

## Database Updates

The script updates the following fields in the `public.dictionary` table:
- `image_url`: Set to the image filename (e.g., "836.jpg")
- `updated_at`: Set to current timestamp

## Performance Considerations

- **Batch Processing**: Reduces database load by processing entries in batches
- **Connection Pooling**: Uses PostgreSQL connection pooling for efficiency
- **Indexing**: Adds index on `image_url` field for faster queries
- **Error Recovery**: Continues processing even if individual entries fail

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check your database credentials in `.env`
   - Ensure database is running and accessible
   - Verify database name and table existence

2. **Many "Word not found" Messages**
   - This is normal - not all words in images file exist in dictionary
   - Check if dictionary table has expected data
   - Verify Chinese character encoding

3. **Memory Issues with Large Files**
   - Reduce batch size: `node image-matcher.js process 5`
   - Process in chunks: `--max 1000`

### Debug Mode
For detailed debugging, modify the script to enable verbose logging:
```javascript
// Add this to enable debug mode
const DEBUG = true;
```

## File Structure

```
├── database/
│   └── add-image-field.sql      # SQL to add image field
├── qwen/dictionary/input/
│   └── dict-images.json         # Input images data
├── image-matcher.js             # Main processing script
├── .env.example                 # Configuration template
└── README_IMAGE_MATCHER.md      # This documentation
```

## API Reference

The `ImageMatcher` class can also be used programmatically:

```javascript
const ImageMatcher = require('./image-matcher');

const matcher = new ImageMatcher({
    database: {
        host: 'localhost',
        port: 5432,
        database: 'chebichat',
        user: 'postgres',
        password: 'password'
    }
});

// Process images
await matcher.processImages('./dict-images.json', {
    batchSize: 10,
    dryRun: false,
    maxEntries: 100
});

// Get statistics
const stats = await matcher.getImageStatistics();
```
