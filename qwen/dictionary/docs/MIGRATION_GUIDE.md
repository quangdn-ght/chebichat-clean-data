# 🎯 Migration Guide - Cấu trúc Mới và Hướng dẫn Chuyển đổi

## 📋 Tổng quan Migration

Project dictionary đã được restructure hoàn toàn để cải thiện maintainability, scalability, và developer experience. Document này hướng dẫn chi tiết cách sử dụng cấu trúc mới và migrate từ cấu trúc cũ.

## 🗂️ So sánh Cấu trúc Cũ vs Mới

### 🔺 Cấu trúc Cũ (Flat):
```
dictionary/
├── dictionaryGenerate.js           # Scattered trong root
├── mergeDictionary.js              # Khó tìm kiếm
├── analyze_batch_distribution.js   # Không có category
├── find_missing_batches.js         # Hỗn tạp chức năng
├── deduplicate_items.js           # Khó maintain
├── test_api_direct.js             # Không có organization
├── ecosystem.config.js            # Config lẫn lộn
├── pm2.sh                         # Scripts khó tìm
└── ... (30+ files hỗn độn)
```

### ✅ Cấu trúc Mới (Organized):
```
dictionary/
├── 📂 src/                         # Mã nguồn có tổ chức
│   ├── 📂 core/                    # ✨ Tạo từ điển cốt lõi
│   ├── 📂 analysis/                # 📊 Phân tích dữ liệu  
│   ├── 📂 merging/                 # 🔄 Gộp dữ liệu
│   ├── 📂 missing-items/           # 🔍 Xử lý items thiếu
│   ├── 📂 deduplication/           # 🧹 Khử trùng lặp
│   └── 📂 testing/                 # 🧪 Kiểm thử
├── 📂 config/                      # ⚙️ Cấu hình tập trung
├── 📂 scripts/                     # 📜 Automation scripts
├── 📂 docs/                        # 📚 Tài liệu chi tiết
├── 📂 input/                       # 📥 Dữ liệu đầu vào
├── 📂 output/                      # 📤 Dữ liệu đầu ra
└── README_RESTRUCTURED.md          # 📋 Hướng dẫn mới
```

## 🔄 Mapping Files Cũ sang Mới

### Core Generation:
```bash
# CŨ → MỚI
dictionaryGenerate.js           → src/core/dictionaryGenerate.js
dictionaryGenerate.old.js       → src/core/dictionaryGenerate.old.js
hanviet.js                      → src/core/hanviet.js
```

### Analysis & Reporting:
```bash
# CŨ → MỚI
analyze_batch_distribution.js   → src/analysis/analyze_batch_distribution.js
analyze_deduplication.js        → src/analysis/analyze_deduplication.js
checkCoverage.js                → src/analysis/checkCoverage.js
```

### Merging Operations:
```bash
# CŨ → MỚI
mergeDictionary.js              → src/merging/mergeDictionary.js
mergeReprocessedData.js         → src/merging/mergeReprocessedData.js
mergeResults.js                 → src/merging/mergeResults.js
merge_final_translations.js     → src/merging/merge_final_translations.js
merge_parallel_results.js       → src/merging/merge_parallel_results.js
merge_reprocessed_items.js      → src/merging/merge_reprocessed_items.js
combine_parallel_results.js     → src/merging/combine_parallel_results.js
```

### Missing Items Processing:
```bash
# CŨ → MỚI
check_missing_batches.js        → src/missing-items/check_missing_batches.js
find_gaps.js                    → src/missing-items/find_gaps.js
find_missing_batches.js         → src/missing-items/find_missing_batches.js
identify_missing_items.js       → src/missing-items/identify_missing_items.js
process_final_missing_items.js  → src/missing-items/process_final_missing_items.js
reprocess_final_missing.js      → src/missing-items/reprocess_final_missing.js
reprocess_missing_items.js      → src/missing-items/reprocess_missing_items.js
reprocess_missing_parallel.js   → src/missing-items/reprocess_missing_parallel.js
reprocessErrorBatches.js        → src/missing-items/reprocessErrorBatches.js
split_missing_items.js          → src/missing-items/split_missing_items.js
```

### Deduplication:
```bash
# CŨ → MỚI
deduplicate_items.js            → src/deduplication/deduplicate_items.js
```

### Testing:
```bash
# CŨ → MỚI
test_api_direct.js              → src/testing/test_api_direct.js
test-refactored.js              → src/testing/test-refactored.js
```

### Configuration:
```bash
# CŨ → MỚI
ecosystem.config.js             → config/ecosystem.config.js
ecosystem.config.cjs            → config/ecosystem.config.cjs
ecosystem.missing.config.cjs    → config/ecosystem.missing.config.cjs
```

### Scripts:
```bash
# CŨ → MỚI
pm2.sh                          → scripts/pm2.sh
dictionary_summary.sh           → scripts/dictionary_summary.sh
fix_missing_items.sh           → scripts/fix_missing_items.sh
merge-reprocessed.sh           → scripts/merge-reprocessed.sh
merge_complete_dictionary.sh   → scripts/merge_complete_dictionary.sh
merge_complete_dictionary_enhanced.sh → scripts/merge_complete_dictionary_enhanced.sh
process_final_missing.sh       → scripts/process_final_missing.sh
process_final_simplified.sh    → scripts/process_final_simplified.sh
reprocess-errors.sh            → scripts/reprocess-errors.sh
verify-merged-data.sh          → scripts/verify-merged-data.sh
```

### Documentation:
```bash
# CŨ → MỚI
ERROR_REPROCESSING_GUIDE.md     → docs/ERROR_REPROCESSING_GUIDE.md
ISSUE_ANALYSIS_AND_SOLUTION.md → docs/ISSUE_ANALYSIS_AND_SOLUTION.md
PARALLEL_PROCESSING_README.md  → docs/PARALLEL_PROCESSING_README.md
README_MERGE_DICTIONARY.md     → docs/README_MERGE_DICTIONARY.md
SOLUTION_SUMMARY.md            → docs/SOLUTION_SUMMARY.md
```

## 🚀 Hướng dẫn Migrate Commands

### 1. Core Generation Commands

**Cũ:**
```bash
# Cách cũ (từ root directory)
node dictionaryGenerate.js --process-id=1 --total-processes=10
node hanviet.js input/dictionary.json
```

**Mới:**
```bash
# Cách mới (organized structure)
cd src/core
node dictionaryGenerate.js --process-id=1 --total-processes=10
node hanviet.js ../../input/dictionary.json

# Hoặc từ root với path adjustment
node src/core/dictionaryGenerate.js --process-id=1 --total-processes=10
node src/core/hanviet.js input/dictionary.json
```

### 2. Analysis Commands

**Cũ:**
```bash
node analyze_batch_distribution.js
node checkCoverage.js
```

**Mới:**
```bash
cd src/analysis
node analyze_batch_distribution.js
node checkCoverage.js

# Hoặc từ root
node src/analysis/analyze_batch_distribution.js
node src/analysis/checkCoverage.js
```

### 3. Merging Commands

**Cũ:**
```bash
node mergeDictionary.js
node mergeResults.js
```

**Mới:**
```bash
cd src/merging
node mergeDictionary.js
node mergeResults.js

# Hoặc từ root
node src/merging/mergeDictionary.js
node src/merging/mergeResults.js
```

### 4. PM2 Commands

**Cũ:**
```bash
pm2 start ecosystem.config.js
./pm2.sh start
```

**Mới:**
```bash
pm2 start config/ecosystem.config.js
./scripts/pm2.sh start

# Từ root directory
pm2 start config/ecosystem.config.js
bash scripts/pm2.sh start
```

### 5. Testing Commands

**Cũ:**
```bash
node test_api_direct.js
node test-refactored.js
```

**Mới:**
```bash
cd src/testing
node test_api_direct.js
node test-refactored.js

# Hoặc từ root
node src/testing/test_api_direct.js
node src/testing/test-refactored.js
```

## 🔧 Path Updates trong Scripts

### Update Import Paths:

**JavaScript Files:**
```javascript
// CŨ (relative paths có thể bị lỗi)
import fs from 'fs';
import path from 'path';
import { someFunction } from './helper.js';

// MỚI (explicit relative paths)
import fs from 'fs';
import path from 'path';
import { someFunction } from '../utils/helper.js';

// Update file paths
const inputDir = './input';           // CŨ
const inputDir = '../../input';       // MỚI (từ trong src modules)

const outputDir = './output';         // CŨ  
const outputDir = '../../output';     // MỚI (từ trong src modules)
```

**Config Files:**
```javascript
// ecosystem.config.js CŨ
{
    script: 'dictionaryGenerate.js',
    // ...
}

// ecosystem.config.js MỚI
{
    script: 'src/core/dictionaryGenerate.js',
    // ...
}
```

**Shell Scripts:**
```bash
# CŨ
node dictionaryGenerate.js

# MỚI  
node src/core/dictionaryGenerate.js
# Hoặc
cd src/core && node dictionaryGenerate.js
```

## 📋 Workflow Migration

### 1. Standard Dictionary Generation Workflow

**Workflow Cũ:**
```bash
# Workflow không có tổ chức
node dictionaryGenerate.js --process-id=1 --total-processes=10 &
node dictionaryGenerate.js --process-id=2 --total-processes=10 &
# ... wait for completion
node find_missing_batches.js
node reprocess_missing_parallel.js
node mergeDictionary.js
node deduplicate_items.js
```

**Workflow Mới:**
```bash
# Organized workflow với automation
# Option 1: Automated script
./scripts/complete_workflow.sh

# Option 2: Manual với organized structure
cd src/core
pm2 start ../../config/ecosystem.config.js

# Monitor progress
cd ../analysis  
node analyze_batch_distribution.js

# Handle missing items
cd ../missing-items
node find_missing_batches.js
node reprocess_missing_parallel.js

# Merge results
cd ../merging
node mergeDictionary.js

# Final cleanup
cd ../deduplication
node deduplicate_items.js

# Verification
cd ../testing
node test-refactored.js
```

### 2. PM2 Management Migration

**PM2 Cũ:**
```bash
# Scattered PM2 usage
pm2 start ecosystem.config.js
pm2 logs
pm2 stop all
./pm2.sh start
```

**PM2 Mới:**
```bash
# Centralized PM2 management
pm2 start config/ecosystem.config.js
pm2 start config/ecosystem.missing.config.cjs
./scripts/pm2.sh start
./scripts/pm2.sh status
./scripts/pm2.sh logs
```

## 🛠️ Development Environment Setup

### 1. Environment Variables Update

**Cũ (.env):**
```bash
# Basic settings
DASHSCOPE_API_KEY=your_key_here
BATCH_SIZE=20
```

**Mới (.env) - Enhanced:**
```bash
# API Configuration  
DASHSCOPE_API_KEY=your_key_here
API_BASE_URL=https://dashscope-intl.aliyuncs.com/compatible-mode/v1

# Processing Configuration
BATCH_SIZE=20
BATCH_DELAY=2000
MAX_RETRIES=3

# Paths (updated for new structure)
INPUT_DIR=./input
OUTPUT_DIR=./output
LOG_DIR=./logs
CONFIG_DIR=./config

# Module-specific settings
CORE_MODULE_ENABLED=true
ANALYSIS_MODULE_ENABLED=true
TESTING_MODULE_ENABLED=true
```

### 2. Package.json Scripts Update

**Thêm scripts mới:**
```json
{
  "scripts": {
    "start": "pm2 start config/ecosystem.config.js",
    "stop": "pm2 stop config/ecosystem.config.js",
    "restart": "pm2 restart config/ecosystem.config.js",
    "logs": "pm2 logs",
    "test": "cd src/testing && node test-refactored.js",
    "test:api": "cd src/testing && node test_api_direct.js",
    "analyze": "cd src/analysis && node analyze_batch_distribution.js",
    "merge": "cd src/merging && node mergeDictionary.js",
    "dedup": "cd src/deduplication && node deduplicate_items.js",
    "workflow": "./scripts/complete_workflow.sh",
    "summary": "./scripts/dictionary_summary.sh"
  }
}
```

## 🧪 Testing Migration

### Pre-Migration Testing:
```bash
# 1. Backup current setup
cp -r /current/dictionary /backup/dictionary-old

# 2. Test individual modules
cd src/testing
node test_api_direct.js          # Test API connectivity
node test-refactored.js          # Test new structure

# 3. Test sample workflow
cd ../core
node dictionaryGenerate.js --process-id=1 --total-processes=1 --batches-per-process=5

# 4. Test merging
cd ../merging  
node mergeDictionary.js

# 5. Validate results
cd ../analysis
node checkCoverage.js
```

### Post-Migration Validation:
```bash
# 1. Full workflow test
./scripts/complete_workflow.sh --test-mode

# 2. Compare results với old system
diff -r /backup/dictionary-old/output /current/dictionary/output

# 3. Performance comparison
./scripts/performance_comparison.sh

# 4. Validate all modules
npm run test
```

## 📚 Documentation Updates

### 1. README Updates
- ✅ **README_RESTRUCTURED.md**: Main documentation cho new structure
- ✅ **src/core/README.md**: Core module documentation
- ✅ **src/analysis/README.md**: Analysis module documentation
- ✅ **src/merging/README.md**: Merging module documentation
- ✅ **src/missing-items/README.md**: Missing items documentation
- ✅ **src/deduplication/README.md**: Deduplication documentation
- ✅ **src/testing/README.md**: Testing documentation
- ✅ **config/README.md**: Configuration documentation
- ✅ **scripts/README.md**: Scripts documentation

### 2. Migration Checklist

**Pre-Migration:**
- [ ] Backup current working directory
- [ ] Document current workflow
- [ ] Test API connectivity
- [ ] Verify environment variables
- [ ] Check disk space

**Migration:**
- [ ] Move files to new structure (Done ✅)
- [ ] Update import paths in scripts
- [ ] Update PM2 configurations
- [ ] Update shell script paths
- [ ] Test individual modules

**Post-Migration:**
- [ ] Run complete workflow test
- [ ] Validate output quality
- [ ] Update team documentation
- [ ] Train team on new structure
- [ ] Monitor performance

## 🎯 Benefits của New Structure

### 1. **Maintainability** 📈
- **Trước:** Files scattered, khó tìm kiếm
- **Sau:** Organized by functionality, easy navigation

### 2. **Scalability** 🚀  
- **Trước:** Adding new features means more clutter
- **Sau:** Clear module boundaries, easy to extend

### 3. **Team Collaboration** 👥
- **Trước:** Developers confused about file purposes  
- **Sau:** Clear responsibility separation

### 4. **Testing & QA** 🧪
- **Trước:** Ad-hoc testing approaches
- **Sau:** Dedicated testing module với comprehensive coverage

### 5. **Deployment** 🚀
- **Trước:** Manual deployment steps
- **Sau:** Automated scripts và clear configuration management

### 6. **Documentation** 📚
- **Trước:** Single README, hard to find specific info
- **Sau:** Module-specific documentation, easy reference

## 🚨 Troubleshooting Migration Issues

### Common Issues:

1. **Import Path Errors:**
```javascript
// Error: Cannot find module './someFile.js'
// Solution: Update relative paths
// From: './someFile.js' 
// To: '../utils/someFile.js' or absolute path
```

2. **PM2 Script Paths:**
```javascript
// Error: Script not found
// Solution: Update ecosystem.config.js
// From: script: 'dictionaryGenerate.js'
// To: script: 'src/core/dictionaryGenerate.js'
```

3. **Shell Script Paths:**
```bash
# Error: command not found
# Solution: Update script paths
# From: node dictionaryGenerate.js
# To: node src/core/dictionaryGenerate.js
```

4. **Working Directory Issues:**
```bash
# Error: Input/output directory not found
# Solution: Use absolute paths hoặc proper relative paths
# From: ./input
# To: ../../input (từ src/module directories)
```

## 📞 Support và Migration Help

### Contact Information:
- **Technical Lead**: Dictionary Team
- **Migration Support**: DevOps Team  
- **Documentation**: QA Team

### Resources:
- **Migration Guide**: This document
- **Module Documentation**: Each src/*/README.md
- **Video Tutorial**: [Coming soon]
- **Team Training**: Schedule với Technical Lead

---

**Migration Guide Version:** 1.0  
**Last Updated:** 05/08/2025  
**Migration Status:** ✅ COMPLETED

*Cấu trúc mới đã được implement và tested. Team có thể bắt đầu sử dụng new structure ngay lập tức.*
