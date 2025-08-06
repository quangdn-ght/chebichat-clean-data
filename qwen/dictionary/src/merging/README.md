# Merging Module - Gộp và Kết hợp Dữ liệu

## 📋 Tổng quan

Module Merging chịu trách nhiệm gộp các kết quả từ multiple processes, parallel processing, và reprocessed data thành một từ điển hoàn chỉnh. Đây là bước quan trọng để tạo ra final output từ các batch results.

## 📁 Files trong Module

### 1. `mergeDictionary.js` - Script Gộp Chính

**Chức năng:**
- 🔄 Gộp tất cả files pattern `dict-processed-process-*.json`
- 🧹 Loại bỏ trùng lặp dựa trên field `chinese`
- 📚 Tích hợp dữ liệu Hán Việt
- 📊 Thống kê chi tiết và báo cáo
- 🗂️ Sắp xếp theo thứ tự chữ Hán

**Cách sử dụng:**
```bash
node mergeDictionary.js
```

**Input Requirements:**
- Files trong `../../output/` với pattern `dict-processed-process-*.json`
- File Hán Việt: `../../input/tudienhanviet.json` (optional)

**Output:**
- `../../output/dictionary-final-merged-{timestamp}.json`
- `../../output/merge-summary-final-{timestamp}.json`

**Features:**
- ✅ Automatic duplicate detection và removal
- ✅ Progress tracking cho large datasets
- ✅ Hanviet integration với fallback
- ✅ Detailed statistics và reporting
- ✅ Error handling và recovery

### 2. `merge_parallel_results.js` - Gộp Kết quả Song song

**Chức năng:**
- 🚀 Merge results từ parallel processing
- ⚡ Optimized cho high-performance merging
- 🔄 Handle concurrent processing results
- 📊 Parallel merge statistics

**Cách sử dụng:**
```bash
node merge_parallel_results.js
```

**Special Features:**
- Concurrent file reading
- Memory-efficient streaming
- Parallel deduplication
- Load balancing optimization

### 3. `merge_final_translations.js` - Gộp Bản dịch Cuối

**Chức năng:**
- 📝 Merge final translation results
- 🎯 Focus on translation quality
- 🔍 Validation of translation completeness
- 📋 Quality metrics reporting

**Workflow:**
```
Translation Batches → Validation → Quality Check → Final Merge
```

### 4. `mergeResults.js` - Gộp Kết quả Tổng quát

**Chức năng:**
- 🔧 General-purpose result merger
- 🛠️ Flexible input format support
- ⚙️ Configurable merge strategies
- 📊 Comprehensive reporting

### 5. `mergeReprocessedData.js` - Gộp Dữ liệu Xử lý lại

**Chức năng:**
- 🔄 Merge reprocessed items back into main dataset
- 🎯 Handle error correction data
- 🧹 Update existing entries với corrected data
- 📈 Track improvement metrics

**Use Cases:**
- Merge fixed missing items
- Update corrected translations
- Integrate quality improvements
- Consolidate error fixes

### 6. `merge_reprocessed_items.js` - Gộp Items Xử lý lại

**Chức năng:**
- 📦 Specialized merger cho reprocessed items
- 🔍 Smart conflict resolution
- 🎯 Priority-based merging
- 📊 Reprocessing success metrics

### 7. `combine_parallel_results.js` - Kết hợp Kết quả Song song

**Chức năng:**
- 🚀 High-performance parallel result combination
- ⚡ Optimized memory usage
- 🔧 Advanced merge algorithms
- 📈 Performance monitoring

## 🔧 Merge Strategies

### 1. Standard Merge (mergeDictionary.js)

**Strategy:** First-come, first-serve với deduplication
```javascript
const mergeStrategy = {
    duplicateHandling: 'keep_first',
    sorting: 'chinese_alphabetical',
    hanvietIntegration: true,
    validateOutput: true
};
```

**Process Flow:**
```
Input Files → Load → Deduplicate → Sort → Hanviet → Output → Validate
```

### 2. Priority Merge (merge_reprocessed_items.js)

**Strategy:** Priority-based conflict resolution
```javascript
const priorityOrder = [
    'manual_corrections',    // Highest priority
    'reprocessed_items',
    'original_translations'  // Lowest priority
];
```

### 3. Quality-based Merge (merge_final_translations.js)

**Strategy:** Merge dựa trên translation quality scores
```javascript
const qualityMetrics = {
    completeness: 0.4,      // 40% weight
    accuracy: 0.4,          // 40% weight
    naturalness: 0.2        // 20% weight
};
```

## 📊 Data Structures

### Input Data Format:
```json
[
  {
    "chinese": "你好",
    "pinyin": "nǐ hǎo", 
    "meaning_vi": "xin chào",
    "meaning_en": "hello",
    "example_cn": "你好，很高兴见到你。",
    "example_vi": "Xin chào, rất vui được gặp bạn.",
    "type": "phrase",
    "hsk_level": 1
  }
]
```

### Output Data Format:
```json
[
  {
    "chinese": "你好",
    "hanviet": "nể hảo",
    "pinyin": "nǐ hǎo",
    "meaning_vi": "xin chào", 
    "meaning_en": "hello",
    "example_cn": "你好，很高兴见到你。",
    "example_vi": "Xin chào, rất vui được gặp bạn.",
    "type": "phrase",
    "hsk_level": 1,
    "source_process": 1,
    "merge_timestamp": "2025-08-05T10:30:45.123Z"
  }
]
```

### Merge Statistics Format:
```json
{
  "totalItemsProcessed": 150000,
  "uniqueItems": 145000,
  "duplicatesRemoved": 5000,
  "sourceFiles": 8,
  "hanvietMatches": 120000,
  "hanvietMatchPercentage": 82.8,
  "mergedAt": "2025-08-05T10:30:45.123Z",
  "processingTime": "00:15:30",
  "memoryUsage": "2.4GB",
  "fileBreakdown": {
    "dict-processed-process-1.json": 18750,
    "dict-processed-process-2.json": 18650,
    "dict-processed-process-3.json": 18800
  }
}
```

## ⚡ Performance Optimization

### 1. Memory Management
```javascript
// Streaming cho large files
const streamProcessor = {
    chunkSize: 10000,
    memoryLimit: '4GB',
    gcInterval: 5000
};
```

### 2. Parallel Processing
```javascript
// Worker threads cho CPU-intensive tasks
const workers = {
    deduplication: 4,
    sorting: 2, 
    validation: 2
};
```

### 3. Disk I/O Optimization
```javascript
// Batch file operations
const ioConfig = {
    batchSize: 100,
    writeBuffer: '64MB',
    readAhead: true
};
```

## 🔍 Deduplication Algorithm

### Smart Deduplication:
```javascript
class SmartDeduplicator {
    constructor() {
        this.seenItems = new Map();
        this.duplicateStrategies = {
            exact: this.handleExactDuplicate,
            similar: this.handleSimilarDuplicate,
            conflict: this.handleConflictingDuplicate
        };
    }
    
    deduplicate(item) {
        const key = this.generateKey(item);
        const existingItem = this.seenItems.get(key);
        
        if (!existingItem) {
            this.seenItems.set(key, item);
            return { action: 'keep', item };
        }
        
        return this.resolveConflict(existingItem, item);
    }
}
```

### Conflict Resolution:
```javascript
const conflictResolution = {
    // Prioritize items với more complete data
    completeness: (item1, item2) => {
        const score1 = this.calculateCompleteness(item1);
        const score2 = this.calculateCompleteness(item2);
        return score1 > score2 ? item1 : item2;
    },
    
    // Prioritize items từ reliable sources
    sourceReliability: (item1, item2) => {
        const reliability1 = this.getSourceReliability(item1.source);
        const reliability2 = this.getSourceReliability(item2.source);
        return reliability1 > reliability2 ? item1 : item2;
    }
};
```

## 📊 Quality Assurance

### Validation Rules:
```javascript
const validationRules = {
    required: ['chinese', 'meaning_vi'],
    format: {
        chinese: /^[\u4e00-\u9fff]+$/,
        pinyin: /^[a-zA-ZāáǎàēéěèīíǐìōóǒòūúǔùüǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙÜǗǙǛ\s]+$/
    },
    constraints: {
        maxLength: {
            chinese: 50,
            meaning_vi: 500
        }
    }
};
```

### Quality Metrics:
```javascript
const qualityMetrics = {
    dataCompleteness: calculateCompleteness(mergedData),
    translationQuality: assessTranslationQuality(mergedData),
    consistencyScore: checkConsistency(mergedData),
    duplicateRate: calculateDuplicateRate(mergedData)
};
```

## 🚨 Error Handling

### Common Merge Errors:

1. **Memory Overflow:**
```javascript
// Solution: Streaming processing
if (estimatedMemoryUsage > memoryLimit) {
    return processInChunks(data, chunkSize);
}
```

2. **File Corruption:**
```javascript
// Solution: Skip và log corrupted files
try {
    data = JSON.parse(fileContent);
} catch (error) {
    logger.warn(`Skipping corrupted file: ${fileName}`);
    return;
}
```

3. **Inconsistent Data Format:**
```javascript
// Solution: Format normalization
const normalizedItem = normalizeDataFormat(item, expectedSchema);
```

## 🔧 Configuration

### Merge Configuration:
```javascript
const mergeConfig = {
    // Input settings
    inputPattern: 'dict-processed-process-*.json',
    inputDirectory: '../../output/',
    
    // Processing settings
    chunkSize: 10000,
    enableParallelProcessing: true,
    workerThreads: 4,
    
    // Output settings
    outputDirectory: '../../output/',
    timestampFormat: 'YYYY-MM-DDTHH-mm-ss-sssZ',
    compressionEnabled: false,
    
    // Quality settings
    enableValidation: true,
    strictMode: false,
    maxErrorRate: 0.01,
    
    // Hanviet integration
    hanvietDictionary: '../../input/tudienhanviet.json',
    enableHanviet: true,
    hanvietFallback: null
};
```

## 📈 Monitoring và Reporting

### Real-time Progress:
```javascript
const progressReporter = {
    reportInterval: 5000,  // Report every 5 seconds
    metrics: [
        'itemsProcessed',
        'duplicatesFound', 
        'memoryUsage',
        'processingSpeed'
    ]
};
```

### Final Report Generation:
```bash
# Tạo báo cáo chi tiết
node generateMergeReport.js --input=merge-summary-*.json

# Output: detailed-merge-report.html
```

## 🧪 Testing

### Unit Tests:
```bash
# Test individual merge functions
npm test src/merging/

# Test với sample data
node test_merge_with_sample.js
```

### Integration Tests:
```bash
# Test complete merge workflow
npm run test:integration:merge

# Performance testing
npm run test:performance:merge
```

### Load Testing:
```bash
# Test với large datasets
node loadtest_merge.js --size=1000000
```

---

**Module:** Merging  
**Maintainer:** Data Integration Team  
**Last Updated:** 05/08/2025

*Module Merging là trung tâm của data consolidation pipeline. Đảm bảo chạy tests trước khi merge production data.*
