# Supabase Dictionary Import Tools

Enhanced tools for importing Chinese-Vietnamese dictionary data into Supabase with proper role management and environment configuration.

## � Quick Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Setup environment:**
   ```bash
   npm run setup  # Creates .env from template
   nano .env      # Edit with your Supabase credentials
   ```

3. **Generate SQL files:**
   ```bash
   npm run import:bulk  # Process all JSON files in ./import/
   ```

4. **Deploy to Supabase:**
   ```bash
   npm run deploy  # Full deployment with role management
   ```

## 🔐 Environment Configuration

Create a `.env` file with your Supabase settings:

```bash
# Required for Node.js deployment (deploy-node.js)
SUPABASE_PROJECT_ID=your-project-id
SUPABASE_DB_PASSWORD=your-database-password

# Required for JavaScript client (insert_dict_data.js)
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
SUPABASE_ANON_KEY=your-anon-key
```

### How to get these values:

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Select your project
3. **For API keys:** Settings → API
   - Copy Project URL → `SUPABASE_URL`
   - Copy anon/public key → `SUPABASE_ANON_KEY`
   - Copy service_role key → `SUPABASE_SERVICE_ROLE_KEY` (keep secret!)
4. **For database:** Settings → Database
   - Copy Project ID from URL or Host field
   - Password is what you set during project creation 
       "type": "đại từ",
       "meaning_vi": "Chúng (dùng để chỉ động vật hoặc đồ vật)",
       "meaning_en": "They/them (used to refer to animals or objects)",
       "example_cn": "我喜欢这些小狗，它们很可爱。",
       "example_vi": "Tôi thích những chú chó con này, chúng rất đáng yêu.",
       "example_en": "I like these puppies; they are very cute.",
       "grammar": "Đại từ số nhiều, dùng để chỉ các sự vật hoặc động vật không phải là người."
     }
   ]
   ```

## 🔧 Usage

### Basic Import
```bash
node dictionayImport.js your_data.json
```

### Advanced Usage
```bash
# Test with sample data
node dictionayImport.js test_data.json

# Import from qwen output
node dictionayImport.js ../qwen/dictionary/output/dict-processed-process-1.json

# Check help
node dictionayImport.js
```

### Import to Database
```bash
# After generating SQL file
psql -d your_database -f output/dictionary_insert.sql

# Or for Supabase (using connection string)
psql "postgresql://user:pass@host:port/dbname" -f output/dictionary_insert.sql
```

## 📊 Data Validation

The script validates:
- ✅ Required fields (chinese, pinyin, meanings, examples)
- ✅ Data types and non-empty values
- ✅ Field length constraints
- ✅ Word type normalization

**Supported Word Types**:
- `danh từ` (noun)
- `động từ` (verb) 
- `tính từ` (adjective)
- `trạng từ` (adverb)
- `đại từ` (pronoun)
- `giới từ` (preposition)
- `liên từ` (conjunction)
- `thán từ` (interjection)
- `số từ` (numeral)
- `lượng từ` (classifier)
- `phó từ` (adverb)
- `other` (fallback)

## 🎯 Performance Optimization

### Database Indexes
- **GIN Indexes**: For trigram fuzzy search on text fields
- **Composite Indexes**: For common query patterns
- **tsvector**: For full-text search across all fields

### Import Performance
- **Batch Size**: 1000 records per INSERT (configurable)
- **Transaction Management**: Single transaction for consistency
- **Memory Efficiency**: Streams large files without loading entire dataset

### Search Performance
- **Fuzzy Matching**: Handles typos in Chinese characters and Vietnamese text
- **Accent Handling**: Vietnamese search works with/without accents
- **Ranked Results**: Results sorted by similarity score

## 📈 Monitoring & Statistics

### Built-in Views
```sql
-- Overall statistics
SELECT * FROM dictionary_stats;

-- Performance monitoring  
SELECT * FROM dictionary_performance_stats;
```

### Search Functions
```sql
-- Vietnamese search
SELECT * FROM search_dictionary_vietnamese('yêu thương') LIMIT 10;

-- Chinese search  
SELECT * FROM search_dictionary_chinese('爱') LIMIT 10;
```

## 🗂️ File Structure

```
dictionary/
├── dictionayImport.js          # Main import script
├── test_data.json              # Sample data for testing
├── package.json                # Node.js configuration
├── README.md                   # This file
├── output/                     # Generated SQL files
│   ├── dictionary_insert.sql   # Main import SQL
│   └── import_log.txt          # Validation errors (if any)
└── ../db/
    └── dictionary_schema.sql   # Database schema
```

## 🚨 Troubleshooting

### Common Issues

**1. "column has pseudo-type anyarray"**
- ✅ **Fixed**: Schema updated to cast `most_common_vals` properly

**2. "enum value does not exist"**  
- Check word type mapping in script
- Use 'other' for unknown types

**3. "JSON parse error"**
- Validate JSON format with `jq` or online validator
- Check for trailing commas or unescaped quotes

**4. "Out of memory"**
- Reduce batch size in script configuration  
- Process data in smaller chunks

### Performance Issues

**Slow Import (12K+ records)**:
- Increase `work_mem` and `maintenance_work_mem` in PostgreSQL
- Use SSD storage
- Disable triggers temporarily during import
- Consider using `COPY` for very large datasets

**Slow Search**:
- Ensure all indexes are created
- Run `ANALYZE dictionary;` after import
- Check query plans with `EXPLAIN ANALYZE`

## 📋 Example Output

```
🚀 Starting dictionary import...
📖 Reading input file: test_data.json
📊 Loaded 12000 entries
🔍 Validating entries...
✅ Valid entries: 11950
❌ Invalid entries: 50
🔧 Generating SQL statements...
📦 Processing 11950 entries in 12 batches...
✓ Generated batch 1/12 (1000 records)
...
✓ Generated batch 12/12 (950 records)
✅ Import SQL generated successfully!
📁 Output file: output/dictionary_insert.sql
📈 File size: 12.45 MB

📊 Import Summary:
   Total entries: 12000
   Valid entries: 11950  
   Invalid entries: 50
   Validation errors: 127
   SQL batches: 12
   Success rate: 99.6%
```

## 🔮 Future Enhancements

- [ ] Support for CSV input format
- [ ] Incremental import (update existing records)
- [ ] Audio file integration for pronunciation
- [ ] HSK level classification
- [ ] API endpoint for real-time import
- [ ] Docker containerization

## 📝 License

MIT License - see project root for details.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Test with sample data
4. Submit pull request

For questions or issues, please create an issue in the repository.
