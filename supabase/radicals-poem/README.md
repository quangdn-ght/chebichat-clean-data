# Radicals Poem Schema for Supabase

A comprehensive database schema for storing Vietnamese poetic mnemonic descriptions of Chinese characters and radicals, optimized for Supabase with relationships to the dictionary table.

## Overview

This schema provides:
- **Storage** for Chinese radicals with Vietnamese poetic descriptions
- **Search functionality** with accent-insensitive Vietnamese text search
- **Categorization** of radicals (basic_radical, pictograph, ideograph, etc.)
- **Stroke count** tracking for educational purposes
- **Dictionary integration** showing relationships between radicals and dictionary words
- **Performance optimization** with appropriate indexes and full-text search

## Data Structure

The schema handles data in this format:
```json
{
  "黄": "Bụng lớn vàng vọt, tượng hình người khuyết tật.",
  "它": "Rắn uốn lượn mềm, chữ xưa vẽ dáng rắn.",
  "直": "Mắt nhìn thẳng băng, đường ngay không ngoặt.",
  "带": "Thắt lưng quấn quanh, dệt nên nét đẹp."
}
```

## Schema Features

### Main Table: `radicals_poem`

| Column | Type | Description |
|--------|------|-------------|
| `chinese` | VARCHAR(10) PRIMARY KEY | Chinese character/radical |
| `poem_description` | TEXT | Vietnamese poetic description |
| `category` | ENUM | Radical category (basic_radical, pictograph, etc.) |
| `stroke_count` | SMALLINT | Number of strokes (optional) |
| `radical_number` | SMALLINT | Traditional radical number (optional) |
| `notes` | TEXT | Additional notes (optional) |
| `normalized_description` | TEXT | Generated accent-free text for search |
| `search_vector` | TSVECTOR | Generated full-text search vector |

### Enums

- **radical_category**: `basic_radical`, `compound_character`, `pictograph`, `ideograph`, `phonetic_compound`, `other`

### Views

1. **radicals_dictionary_relation**: Shows relationships between radicals and dictionary words
2. **radicals_poem_stats**: Statistics by category
3. **radicals_poem_performance_stats**: Database performance metrics

### Functions

1. **search_radicals_by_description(text)**: Vietnamese text search with accent handling
2. **search_radicals_by_chinese(text)**: Chinese character search
3. **get_radical_by_chinese(text)**: Exact character lookup
4. **get_radicals_by_category(category)**: Filter by category
5. **get_radicals_by_stroke_range(min, max)**: Filter by stroke count
6. **get_dictionary_words_with_radical(char)**: Find dictionary words containing radical

## Setup Instructions

### 1. Prerequisites

- Supabase project with PostgreSQL database
- Node.js 16+ installed
- Supabase environment variables configured

### 2. Environment Setup

Create a `.env` file in the project root:
```bash
cp .env.example .env
```

Edit the `.env` file with your Supabase credentials:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

You can find these values in your Supabase project dashboard under Settings > API.

### 3. Install Dependencies

```bash
cd supabase/radicals-poem
npm install
```

### 4. Create Database Schema

Run the schema creation scripts in your Supabase SQL editor:

1. First, run `db/radicals_poem_schema.sql`
2. Then, run `db/import_functions.sql`

Or use the Supabase CLI:
```bash
supabase db push
```

### 5. Import Data

```bash
npm run import
```

This will import data from `import/merged_radicals.json`.

### 6. Test the Schema

```bash
npm test
```

## Usage Examples

### Search Radicals by Vietnamese Description

```sql
SELECT * FROM search_radicals_by_description('vàng');
```

```javascript
const { data } = await supabase.rpc('search_radicals_by_description', {
  search_term: 'vàng'
});
```

### Get Radical by Chinese Character

```sql
SELECT * FROM get_radical_by_chinese('黄');
```

```javascript
const { data } = await supabase.rpc('get_radical_by_chinese', {
  char_chinese: '黄'
});
```

### Find Dictionary Words Containing a Radical

```sql
SELECT * FROM get_dictionary_words_with_radical('黄');
```

```javascript
const { data } = await supabase.rpc('get_dictionary_words_with_radical', {
  radical_char: '黄'
});
```

### Get Radicals by Category

```sql
SELECT * FROM get_radicals_by_category('pictograph');
```

```javascript
const { data } = await supabase.rpc('get_radicals_by_category', {
  cat: 'pictograph'
});
```

### Search by Stroke Count Range

```sql
SELECT * FROM get_radicals_by_stroke_range(5, 10);
```

```javascript
const { data } = await supabase.rpc('get_radicals_by_stroke_range', {
  min_strokes: 5,
  max_strokes: 10
});
```

## Performance Features

### Indexes

- **Primary key**: Automatic index on `chinese` for fast lookups
- **Trigram indexes**: For fuzzy Vietnamese text search
- **GIN indexes**: For full-text search capabilities
- **Composite indexes**: For multi-column queries
- **Conditional indexes**: Only on non-null values to save space

### Search Optimization

- **Accent normalization**: Automatic accent-free text generation
- **Full-text search**: PostgreSQL tsvector for complex queries
- **Similarity scoring**: Ranked results using pg_trgm
- **Vietnamese text handling**: Proper Unicode and accent support

## Data Management

### Import Functions

- **import_radicals_from_json(jsonb)**: Import from JSON structure
- **auto_categorize_radicals()**: Automatic categorization
- **validate_radicals_data()**: Data quality checks
- **analyze_dictionary_relationships()**: Relationship analysis

### Quality Assurance

The schema includes validation for:
- Non-empty descriptions
- Valid stroke counts (1-50)
- Valid radical numbers (1-300)
- Unique Chinese characters
- Data integrity constraints

## API Integration

### Supabase Client Examples

```javascript
// Initialize client
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(url, key);

// Search examples
const searchResults = await supabase.rpc('search_radicals_by_description', {
  search_term: 'rắn'
});

const radical = await supabase.rpc('get_radical_by_chinese', {
  char_chinese: '它'
});

// Direct table queries
const pictographs = await supabase
  .from('radicals_poem')
  .select('*')
  .eq('category', 'pictograph')
  .limit(10);
```

### REST API

```bash
# Search by description
curl -X POST 'https://your-project.supabase.co/rest/v1/rpc/search_radicals_by_description' \
  -H "apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"search_term": "vàng"}'

# Get by Chinese character
curl -X POST 'https://your-project.supabase.co/rest/v1/rpc/get_radical_by_chinese' \
  -H "apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"char_chinese": "黄"}'
```

## Monitoring and Statistics

### View Statistics

```sql
SELECT * FROM radicals_poem_stats;
```

### Performance Monitoring

```sql
SELECT * FROM radicals_poem_performance_stats;
```

### Data Validation

```sql
SELECT * FROM validate_radicals_data();
```

## File Structure

```
supabase/radicals-poem/
├── package.json              # Node.js dependencies
├── import_radicals.js         # Main import script
├── test_queries.js           # Test suite
├── README.md                 # This file
├── db/
│   ├── radicals_poem_schema.sql    # Main schema
│   └── import_functions.sql        # Import utilities
└── import/
    └── merged_radicals.json        # Source data
```

## Contributing

1. Follow the existing schema patterns
2. Add appropriate indexes for new query patterns
3. Include validation functions for data quality
4. Update tests when adding new features
5. Document any new functions or views

## License

MIT License - see project root for details.

## Related Tables

This schema is designed to work with:
- **dictionary**: Main Chinese-Vietnamese dictionary
- **letters**: Character learning modules
- **bookmark**: User bookmarking system

See the respective schemas for integration details.
