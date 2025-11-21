# 🏗️ System Architecture Diagram

Visual overview of the Attraction Content Generator system.

---

## 📊 System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ATTRACTION CONTENT GENERATOR                      │
│                     (Multilingual AI System)                         │
└─────────────────────────────────────────────────────────────────────┘

                              ┌─────────┐
                              │ USER    │
                              └────┬────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
               ┌────▼────┐    ┌────▼────┐   ┌────▼────┐
               │ Test DB │    │ Test API│   │ Process │
               │         │    │         │   │ Batch   │
               └────┬────┘    └────┬────┘   └────┬────┘
                    │              │              │
                    └──────────────┼──────────────┘
                                   │
                         ┌─────────▼──────────┐
                         │  Main Processor    │
                         │  (supabase-        │
                         │   attraction-      │
                         │   processor.js)    │
                         └─────────┬──────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
             ┌──────▼──────┐  ┌───▼────┐   ┌─────▼──────┐
             │  SUPABASE   │  │ QWEN   │   │   OUTPUT   │
             │  Database   │  │ API    │   │   Files    │
             │             │  │        │   │            │
             │ - Fetch     │  │ - Gen  │   │ - JSON     │
             │ - Update    │  │   VI   │   │ - Errors   │
             │             │  │ - Gen  │   │ - Progress │
             │             │  │   EN   │   │            │
             └─────────────┘  └────────┘   └────────────┘
```

---

## 🔄 Data Flow

```
INPUT DATA (from Supabase)
┌──────────────────────────┐
│ id: uuid                 │
│ attraction_code: 10001   │
│ name: 玉龙雪山            │
│ description: 玉龙雪山... │
└────────────┬─────────────┘
             │
             ▼
┌────────────────────────────────────┐
│     QWEN-MAX API PROCESSING        │
│                                    │
│  System Prompt:                   │
│  - Professional translator        │
│  - Tourism content specialist     │
│  - Cultural context expert        │
│                                    │
│  User Prompt:                     │
│  - Name: 玉龙雪山                 │
│  - Description: [full text]       │
│                                    │
│  Model: qwen-max                  │
│  Temperature: 0.7                 │
│  Response format: JSON            │
└────────────┬───────────────────────┘
             │
             ▼
OUTPUT DATA (generated)
┌──────────────────────────────────────┐
│ name: "玉龙雪山"                      │
│ name_vi: "Núi Tuyết Ngọc Long"      │
│ name_en: "Jade Dragon Snow Mountain"│
│ description_vi: "Núi Tuyết..."      │
│   (400-800 words in Vietnamese)     │
│ short_description_zh: "玉龙雪山..." │
│ short_description_vi: "Núi Tuyết..."│
└────────────┬─────────────────────────┘
             │
             ▼
┌────────────────────────────────────┐
│     SAVE TO SUPABASE & FILES       │
│                                    │
│ Supabase: UPDATE attractions       │
│ Files: processed-attractions.json  │
└────────────────────────────────────┘
```

---

## 🔧 Component Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         MAIN PROCESSOR                          │
│                (supabase-attraction-processor.js)               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │   CONFIG     │  │  SUPABASE    │  │    QWEN      │        │
│  │              │  │   CLIENT     │  │   CLIENT     │        │
│  │ - API Keys   │  │              │  │              │        │
│  │ - Settings   │  │ - Connect    │  │ - Connect    │        │
│  │ - Timeouts   │  │ - Fetch      │  │ - Generate   │        │
│  └──────────────┘  │ - Update     │  │ - Validate   │        │
│                    └──────────────┘  └──────────────┘        │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              CORE FUNCTIONS                              │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │ fetchAttractionsFromSupabase(limit, offset)            │ │
│  │ generateAttractionContent(name, description)            │ │
│  │ updateAttractionInSupabase(id, content)                │ │
│  │ processAttraction(attraction, updateDb)                 │ │
│  │ processAttractionBatch(options)                         │ │
│  │ processSingleByCode(code, updateDb)                     │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              ERROR HANDLING                              │ │
│  ├──────────────────────────────────────────────────────────┤ │
│  │ - Rate limiting retry (exponential backoff)            │ │
│  │ - JSON parsing fallback                                 │ │
│  │ - Database error recovery                               │ │
│  │ - Progress auto-save                                    │ │
│  │ - Error logging to file                                 │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Database Schema

```
ATTRACTIONS TABLE (Supabase)
┌──────────────────────────────────────────┐
│ CORE FIELDS (existing)                   │
├──────────────────────────────────────────┤
│ id                    UUID PRIMARY KEY   │
│ attraction_code       BIGINT UNIQUE      │
│ name                  TEXT               │◄─── INPUT
│ description           TEXT               │◄─── INPUT
│ province_id           INTEGER            │
│ region_id             INTEGER            │
│ category_id           INTEGER            │
│ opening_hours         TEXT               │
│ ticket_price          TEXT               │
│ best_time             TEXT               │
│ contact_info          TEXT               │
│ complaint_phone       TEXT               │
│ transport_guide       TEXT               │
│ image                 TEXT               │
│ created_at            TIMESTAMP          │
│ updated_at            TIMESTAMP          │
├──────────────────────────────────────────┤
│ MULTILINGUAL FIELDS (generated)          │
├──────────────────────────────────────────┤
│ name_vi               TEXT               │◄─── OUTPUT
│ name_en               TEXT               │◄─── OUTPUT
│ description_vi        TEXT (400-800w)    │◄─── OUTPUT
│ short_description_zh  TEXT (1-2 sent)    │◄─── OUTPUT
│ short_description_vi  TEXT (2-3 sent)    │◄─── OUTPUT
└──────────────────────────────────────────┘

INDEXES
- idx_attractions_code (attraction_code)
- idx_attractions_name (name)
- idx_attractions_name_vi (name_vi)
- idx_attractions_name_en (name_en)
- idx_attractions_search (name + description, GIN)
- idx_attractions_search_vi (name_vi + description_vi, GIN)
```

---

## 🚦 Processing Flow

```
START
  │
  ├─► Load Config
  │    - API keys from .env
  │    - Processing settings
  │
  ├─► Initialize Clients
  │    - Supabase client
  │    - OpenAI client (Qwen endpoint)
  │
  ├─► Fetch Attractions
  │    - Query: SELECT * FROM attractions WHERE description IS NOT NULL
  │    - Apply limit/offset
  │    - Order by attraction_code
  │
  ├─► For Each Attraction:
  │    │
  │    ├─► Prepare Request
  │    │    - System prompt
  │    │    - User prompt with name + description
  │    │
  │    ├─► Call Qwen API
  │    │    - POST to dashscope-intl.aliyuncs.com
  │    │    - Model: qwen-max
  │    │    - Response format: JSON
  │    │
  │    ├─► Handle Response
  │    │    - Parse JSON
  │    │    - Validate fields
  │    │    - Check word count
  │    │
  │    ├─► Update Database (if --update-db)
  │    │    - UPDATE attractions SET ...
  │    │    - WHERE id = ...
  │    │
  │    ├─► Save to File
  │    │    - Append to results array
  │    │    - Save progress every 5 items
  │    │
  │    ├─► Handle Errors
  │    │    - Retry on rate limit (3x)
  │    │    - Log errors separately
  │    │    - Continue to next item
  │    │
  │    └─► Delay (2 seconds)
  │         - Prevent rate limiting
  │
  ├─► Save Final Results
  │    - processed-attractions.json
  │    - processed-attractions-errors.json
  │
  └─► Print Summary
       - Total processed
       - Success count
       - Failed count
       - Success rate

END
```

---

## 🔐 Security Architecture

```
┌─────────────────────────────────────────┐
│         SECURITY LAYERS                 │
├─────────────────────────────────────────┤
│                                         │
│  1. ENVIRONMENT VARIABLES               │
│     ┌─────────────────────────────┐   │
│     │ .env (gitignored)            │   │
│     │ - DASHSCOPE_API_KEY          │   │
│     │ - SUPABASE_URL               │   │
│     │ - SUPABASE_SERVICE_ROLE_KEY  │   │
│     └─────────────────────────────┘   │
│                                         │
│  2. API KEY VALIDATION                  │
│     - Check on startup                  │
│     - Fail fast if missing              │
│                                         │
│  3. SUPABASE RLS (Optional)             │
│     - Row Level Security                │
│     - Service role bypasses             │
│                                         │
│  4. HTTPS ONLY                          │
│     - All API calls encrypted           │
│     - TLS 1.2+                          │
│                                         │
│  5. NO SENSITIVE DATA IN LOGS           │
│     - API keys truncated in output      │
│     - No user data logged               │
│                                         │
└─────────────────────────────────────────┘
```

---

## 📊 Performance Metrics

```
┌────────────────────────────────────────┐
│         PROCESSING METRICS             │
├────────────────────────────────────────┤
│                                        │
│  Speed per Attraction:                 │
│  ├─ API Call: 1-2 seconds             │
│  ├─ Database Update: 0.1-0.3 seconds  │
│  ├─ File Save: 0.01-0.05 seconds      │
│  └─ Total: ~2-3 seconds                │
│                                        │
│  Rate Limiting:                        │
│  ├─ Delay: 2 seconds between requests │
│  ├─ Max retries: 3 attempts           │
│  └─ Backoff: Exponential              │
│                                        │
│  Batch Processing:                     │
│  ├─ 10 attractions: ~30-40 seconds    │
│  ├─ 50 attractions: ~2.5-4 minutes    │
│  ├─ 100 attractions: ~5-8 minutes     │
│  └─ 1000 attractions: ~50-80 minutes  │
│                                        │
│  Memory Usage:                         │
│  ├─ Base: ~50-100 MB                  │
│  ├─ Per attraction: ~1-2 MB           │
│  └─ Max recommended: < 1 GB           │
│                                        │
└────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

```
┌───────────────────────────────────────────────────────┐
│                  TECHNOLOGY STACK                     │
├───────────────────────────────────────────────────────┤
│                                                       │
│  Runtime Environment:                                 │
│  └─ Node.js v16+ (JavaScript/ESM)                   │
│                                                       │
│  Package Manager:                                     │
│  └─ npm                                              │
│                                                       │
│  Core Dependencies:                                   │
│  ├─ openai ^4.20.0                                   │
│  │  └─ Client for Qwen API (OpenAI compatible)     │
│  ├─ @supabase/supabase-js ^2.39.0                  │
│  │  └─ PostgreSQL client for Supabase              │
│  └─ dotenv ^16.0.3                                   │
│     └─ Environment variable management               │
│                                                       │
│  External Services:                                   │
│  ├─ Dashscope (Alibaba Cloud)                       │
│  │  └─ Qwen-Max LLM API                            │
│  └─ Supabase                                         │
│     └─ PostgreSQL database + REST API                │
│                                                       │
│  File System:                                         │
│  ├─ fs/promises (native Node.js)                    │
│  └─ path (native Node.js)                           │
│                                                       │
└───────────────────────────────────────────────────────┘
```

---

## 🔄 CLI Flow Diagram

```
$ node supabase-attraction-processor.js [options]
│
├─► Parse Arguments
│   ├─ --limit <n>
│   ├─ --offset <n>
│   ├─ --code <code>
│   ├─ --update-db
│   ├─ --no-save
│   └─ --help
│
├─► Validate Configuration
│   ├─ Check API key
│   ├─ Check Supabase credentials
│   └─ Display settings
│
├─► Execute Action
│   │
│   ├─ Single Attraction (--code)
│   │   └─ processSingleByCode()
│   │
│   └─ Batch Processing (default)
│       └─ processAttractionBatch()
│
└─► Display Results
    ├─ Success count
    ├─ Error count
    ├─ Success rate
    └─ Output file paths
```

---

## 📈 Scalability Considerations

```
┌─────────────────────────────────────────┐
│         SCALABILITY FACTORS             │
├─────────────────────────────────────────┤
│                                         │
│  Current Implementation:                │
│  ✓ Sequential processing                │
│  ✓ Single instance                      │
│  ✓ File-based progress tracking         │
│  ✓ Suitable for: < 10,000 items        │
│                                         │
│  Future Enhancements (if needed):       │
│  ○ Parallel processing (workers)        │
│  ○ Queue-based architecture (Bull/BQ)   │
│  ○ Database progress tracking           │
│  ○ Distributed processing               │
│  ○ Suitable for: > 100,000 items       │
│                                         │
└─────────────────────────────────────────┘
```

---

## 🎯 Integration Points

```
┌─────────────────────────────────────────┐
│      EXTERNAL INTEGRATIONS              │
├─────────────────────────────────────────┤
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ SUPABASE                          │ │
│  ├───────────────────────────────────┤ │
│  │ Protocol: HTTPS REST API          │ │
│  │ Auth: Service Role Key            │ │
│  │ Operations: SELECT, UPDATE        │ │
│  │ Tables: attractions               │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ QWEN-MAX API (Dashscope)          │ │
│  ├───────────────────────────────────┤ │
│  │ Protocol: HTTPS (OpenAI compat)   │ │
│  │ Auth: API Key (Bearer token)      │ │
│  │ Endpoint: chat.completions.create │ │
│  │ Model: qwen-max                   │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ FILE SYSTEM                       │ │
│  ├───────────────────────────────────┤ │
│  │ Read: .env, input/*.json          │ │
│  │ Write: output/*.json              │ │
│  │ Format: JSON, UTF-8               │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

---

**For more details, see:**
- Architecture: `PROJECT_SUMMARY.md`
- File structure: `FILE_INDEX.md`
- Getting started: `QUICKSTART.md`
- Full docs: `README.md`
