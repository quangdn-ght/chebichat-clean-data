# HSK Level Update Script

This Node.js script updates the Supabase dictionary table with HSK (Hanyu Shuiping Kaoshi) level information by reading from `./import/hsk-complete.json` and mapping HSK levels to Chinese words using the Chinese characters as the primary key.

## Features

- ✅ **Dual Connection Support**: Uses either Supabase JavaScript client or direct PostgreSQL connection
- 🚀 **Batch Processing**: Efficient batch updates with configurable batch sizes
- 🛡️ **Auto Schema Update**: Automatically adds HSK level column if it doesn't exist
- 📊 **Progress Tracking**: Real-time progress updates and detailed statistics
- 🔍 **Verification**: Post-update verification with HSK level distribution
- ⚡ **Performance Optimized**: PostgreSQL mode uses bulk updates for maximum efficiency

## Prerequisites

1. **Node.js** version 14 or higher
2. **Dependencies installed**:
   ```bash
   npm install
   ```
3. **Environment Configuration**: Copy `.env.example` to `.env` and configure your Supabase credentials

## Environment Configuration

### Required Environment Variables

```bash
# Supabase Project Configuration
SUPABASE_PROJECT_ID=your-project-id-here
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here

# For direct PostgreSQL connection (optional, more efficient)
SUPABASE_DB_PASSWORD=your-database-password-here

# Optional Performance Settings
BATCH_SIZE=1000              # Number of entries to process per batch
USE_DIRECT_PG=true          # Use direct PostgreSQL connection (faster)
```

### Optional Environment Variables

```bash
# Custom database connection settings (auto-detected if not provided)
SUPABASE_HOST=db.your-project-id.supabase.co
SUPABASE_PORT=5432
SUPABASE_DATABASE=postgres
SUPABASE_USER=postgres
```

## Usage

### Quick Start

```bash
# Using npm scripts (recommended)
npm run hsk:update

# Or run directly
node hsk-level-update.js
```

### Performance Options

```bash
# Fast mode (larger batches, direct PostgreSQL)
npm run hsk:update:fast

# Safe mode (smaller batches, more error handling)
npm run hsk:update:safe

# Custom batch size
BATCH_SIZE=2000 node hsk-level-update.js

# Force Supabase client mode
USE_DIRECT_PG=false node hsk-level-update.js
```

## Input Data Format

The script reads from `./import/hsk-complete.json` which should contain an array of objects with this structure:

```json
[
  {
    "chinese": "阿姨",
    "level": "hsk 4"
  },
  {
    "chinese": "爱",
    "level": "hsk 1"
  }
]
```

## What the Script Does

1. **🔌 Connection Setup**: Initializes either Supabase client or direct PostgreSQL connection
2. **📝 Schema Update**: Adds `hsk_level` column to dictionary table if it doesn't exist
3. **📖 Data Loading**: Loads and validates HSK data from JSON file
4. **🔄 Batch Updates**: Updates dictionary records in configurable batches
5. **🔍 Verification**: Provides statistics and verification of updates
6. **📊 Reporting**: Shows success rates, coverage, and HSK level distribution

## Database Schema Changes

The script automatically adds this column to your dictionary table:

```sql
ALTER TABLE dictionary 
ADD COLUMN IF NOT EXISTS hsk_level VARCHAR(20);

CREATE INDEX IF NOT EXISTS idx_dictionary_hsk_level 
ON dictionary (hsk_level);
```

## Performance Comparison

| Connection Type | Speed | Memory Usage | Best For |
|----------------|--------|--------------|----------|
| **Direct PostgreSQL** | ⚡ Very Fast | 🟢 Low | Production, large datasets |
| **Supabase Client** | 🐌 Slower | 🟡 Medium | Development, compatibility |

## Error Handling

The script provides comprehensive error handling:

- **❌ Connection Errors**: Clear guidance on missing credentials
- **⚠️ Data Validation**: Validates JSON structure and required fields
- **🔍 Missing Words**: Reports words in HSK data not found in dictionary
- **📊 Statistics**: Detailed success/failure reporting

## Output Example

```
🚀 Starting HSK Level Update Process
====================================

📡 Using connection type: postgresql
✅ HSK level column already exists
📖 Loading HSK data from: ./import/hsk-complete.json
✅ Loaded 45978 HSK entries
📦 Using batch size: 1000

📦 Processing batch 1/46 (1000 entries)
   ✅ Updated: 950/1000 in this batch

📊 Final Results:
   ✅ Successfully updated: 43,245 entries
   ⚠️  Words not found in dictionary: 2,733 entries
   ❌ Errors encountered: 0 entries
   📈 Success rate: 94.05%

📊 HSK Level Distribution:
   hsk 1: 150 entries
   hsk 2: 300 entries
   hsk 3: 600 entries
   ...

📈 Coverage: 43,245/50,000 dictionary entries have HSK levels (86.49%)

🎉 HSK Level Update Process Completed Successfully!
```

## Troubleshooting

### Common Issues

1. **Missing Service Role Key**
   ```bash
   # Get from: Supabase Dashboard → Settings → API → service_role
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1...
   ```

2. **Connection Timeout**
   ```bash
   # Reduce batch size
   BATCH_SIZE=500 node hsk-level-update.js
   ```

3. **Memory Issues**
   ```bash
   # Use direct PostgreSQL connection
   USE_DIRECT_PG=true node hsk-level-update.js
   ```

4. **Data Not Found**
   - Ensure `./import/hsk-complete.json` exists
   - Check JSON format matches expected structure
   - Verify Chinese characters are correctly encoded

### Debug Mode

```bash
# Enable debug logging
DEBUG=true node hsk-level-update.js
```

## Integration

This script can be integrated into deployment pipelines:

```bash
# In your deployment script
npm run hsk:update:safe && echo "HSK levels updated successfully"
```

## Related Scripts

- `dictionayImport.js` - Import dictionary data
- `deploy-node.js` - Deploy dictionary schema and data
- `insert_dict_data.js` - Insert dictionary data via SQL

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Verify your environment configuration
3. Check Supabase dashboard for database connectivity
4. Review the console output for specific error messages
