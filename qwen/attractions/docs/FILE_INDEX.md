# 📁 Attraction Content Generator - File Index

Complete directory structure and file descriptions for the Supabase Attraction Content Generator.

---

## 📂 Directory Structure

```
qwen/attractions/
├── 📄 Core Scripts
│   ├── supabase-attraction-processor.js   # Main script (Supabase integration)
│   ├── attraction-generator.js            # Standalone version (file-based)
│   ├── test-supabase.js                   # Test database connection
│   └── test-generator.js                  # Test API with sample data
│
├── 📊 Database
│   ├── travel_normalized_schema.sql       # Full database schema reference
│   └── add-multilingual-columns.sql       # SQL to add required columns
│
├── 📚 Documentation
│   ├── README.md                          # Full documentation (reference)
│   ├── QUICKSTART.md                      # 5-minute tutorial (beginners)
│   ├── PROJECT_SUMMARY.md                 # Project overview (developers)
│   └── FILE_INDEX.md                      # This file
│
├── ⚙️ Configuration
│   ├── package.json                       # Dependencies & NPM scripts
│   ├── setup.sh                           # Automated setup script
│   └── ../../.env                         # Environment variables (gitignored)
│
├── 📥 Input (examples)
│   ├── sample.txt                         # Real attraction example
│   └── sample-attractions.json            # Sample JSON input
│
└── 📤 Output (generated)
    ├── processed-attractions.json         # Batch processing results
    ├── attraction-{code}.json             # Individual attraction results
    └── processed-attractions-errors.json  # Failed items (if any)
```

---

## 📄 File Descriptions

### Core Scripts

#### `supabase-attraction-processor.js` ⭐ **Main Script**
**Purpose**: Process attractions from Supabase database  
**Features**:
- Fetches data directly from Supabase
- Generates multilingual content via Qwen-Max API
- Updates database with results
- CLI with multiple options (--limit, --offset, --code, --update-db)
- Batch processing with progress tracking
- Automatic error recovery and retry logic

**Usage**:
```bash
node supabase-attraction-processor.js --code 10001
node supabase-attraction-processor.js --limit 10 --update-db
```

---

#### `attraction-generator.js`
**Purpose**: Standalone file-based processor (no database required)  
**Features**:
- Processes JSON input files
- Generates same multilingual content
- Saves results to JSON files
- Good for offline testing

**Usage**:
```bash
node attraction-generator.js
node attraction-generator.js input.json output.json
```

---

#### `test-supabase.js`
**Purpose**: Verify Supabase database connection and setup  
**Features**:
- Tests database connection
- Counts available attractions
- Checks for multilingual columns
- Validates table structure
- Provides setup recommendations

**Usage**:
```bash
node test-supabase.js
npm run test-db
```

---

#### `test-generator.js`
**Purpose**: Test Qwen-Max API with sample data  
**Features**:
- Tests API connectivity
- Validates API key
- Processes sample attraction (Yulong Snow Mountain)
- Displays generated content
- No database interaction

**Usage**:
```bash
node test-generator.js
npm run test-api
```

---

### Database Files

#### `travel_normalized_schema.sql`
**Purpose**: Complete database schema reference  
**Contains**:
- Attractions table definition
- All columns and constraints
- Indexes for performance
- Foreign key relationships
- Triggers

**Usage**: Reference only (already in Supabase)

---

#### `add-multilingual-columns.sql`
**Purpose**: Add required columns for multilingual content  
**Contains**:
- ALTER TABLE statements for new columns
- Index creation for search performance
- Column comments/documentation

**Usage**:
1. Open Supabase SQL Editor
2. Copy and paste this SQL
3. Execute once (first-time setup)

---

### Documentation

#### `README.md`
**Purpose**: Comprehensive documentation  
**Covers**:
- Features overview
- Installation instructions
- Database schema details
- All CLI options
- Configuration options
- Troubleshooting guide
- Examples and use cases

**Target audience**: All users (reference)

---

#### `QUICKSTART.md` ⭐ **Start Here**
**Purpose**: Get started in 5 minutes  
**Covers**:
- Step-by-step setup
- Quick test commands
- Common workflows
- NPM scripts reference
- Troubleshooting tips

**Target audience**: New users (tutorial)

---

#### `PROJECT_SUMMARY.md`
**Purpose**: High-level project overview  
**Covers**:
- Architecture overview
- Key features
- Performance metrics
- Use cases
- Future enhancements

**Target audience**: Developers, stakeholders

---

#### `FILE_INDEX.md`
**Purpose**: Navigate the codebase  
**Covers**:
- Directory structure
- File descriptions
- Usage examples
- Quick reference

**Target audience**: Developers

---

### Configuration

#### `package.json`
**Purpose**: Node.js project configuration  
**Contains**:
- Dependencies (openai, supabase-js, dotenv)
- NPM scripts (shortcuts)
- Project metadata

**Key scripts**:
```bash
npm run test-db          # Test database
npm run test-single      # Test one attraction
npm run process-dry      # Process 10 (no DB update)
npm run process-update   # Process 10 + update DB
npm run process-all      # Process all + update DB
```

---

#### `setup.sh`
**Purpose**: Automated setup script  
**Features**:
- Checks Node.js installation
- Installs dependencies
- Verifies .env file
- Tests database connection
- Creates output directory

**Usage**:
```bash
chmod +x setup.sh
./setup.sh
```

---

#### `../../.env`
**Purpose**: Environment variables (sensitive data)  
**Required variables**:
```env
DASHSCOPE_API_KEY=sk-your-api-key
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-key
```

**⚠️ Never commit this file to git!**

---

### Input Files

#### `input/sample.txt`
**Purpose**: Real-world example (Yulong Snow Mountain)  
**Contains**: Full Chinese description with cultural context  
**Usage**: Reference for input quality expectations

---

#### `input/sample-attractions.json`
**Purpose**: Sample JSON input format  
**Contains**: 3 sample attractions with all required fields  
**Usage**: Template for file-based processing

---

### Output Files

#### `output/processed-attractions.json`
**Purpose**: Batch processing results  
**Contains**:
- Processing statistics
- All processed items (success + failed)
- Original and generated content
- Timestamps

**Structure**:
```json
{
  "total": 10,
  "processed": 10,
  "successful": 9,
  "failed": 1,
  "items": [...]
}
```

---

#### `output/attraction-{code}.json`
**Purpose**: Individual attraction result  
**Contains**: Single attraction with generated content  
**Created by**: Single attraction processing (--code option)

---

#### `output/processed-attractions-errors.json`
**Purpose**: Failed items for debugging  
**Contains**: Only failed items with error details  
**Created by**: Batch processing (if errors occur)

---

## 🚀 Quick Reference

### Most Important Files

1. **Start here**: `QUICKSTART.md`
2. **Main script**: `supabase-attraction-processor.js`
3. **Setup**: `setup.sh`
4. **Database setup**: `add-multilingual-columns.sql`

### Common Commands

```bash
# Setup
./setup.sh

# Test
npm run test-db
npm run test-single

# Process
npm run process-update

# Help
node supabase-attraction-processor.js --help
```

---

## 📦 Dependencies

From `package.json`:
- `openai` ^4.20.0 - Qwen API client
- `@supabase/supabase-js` ^2.39.0 - Supabase client
- `dotenv` ^16.0.3 - Environment variables

---

## 🔄 Data Flow

```
┌─────────────┐
│  Supabase   │
│ attractions │
└──────┬──────┘
       │ fetch (name, description)
       ▼
┌──────────────────┐
│  Qwen-Max API    │
│  (OpenAI SDK)    │
└──────┬───────────┘
       │ generate (name_vi, name_en, description_vi, etc.)
       ▼
┌──────────────────┐
│  Output Files    │
│  + Supabase DB   │
└──────────────────┘
```

---

## 🎯 Which File to Use?

**I want to...**

- **Get started quickly** → `QUICKSTART.md`
- **Understand the system** → `README.md`
- **Setup from scratch** → `./setup.sh`
- **Test my database** → `npm run test-db`
- **Process one attraction** → `npm run test-single`
- **Process many attractions** → `npm run process-update`
- **Add database columns** → `add-multilingual-columns.sql`
- **See example output** → `output/attractions.json`
- **Troubleshoot errors** → `README.md` (Troubleshooting section)
- **Modify configuration** → Edit `supabase-attraction-processor.js` CONFIG
- **Use without database** → `attraction-generator.js`

---

## 📞 Getting Help

1. **Quick questions**: Check `QUICKSTART.md`
2. **Detailed info**: Check `README.md`
3. **Database issues**: Run `test-supabase.js`
4. **API issues**: Run `test-generator.js`
5. **Error details**: Check `processed-attractions-errors.json`
6. **CLI help**: `node supabase-attraction-processor.js --help`

---

**Last updated**: November 2025  
**Version**: 1.0.0
