# Deduplication Module - Khử Trùng lặp Dữ liệu

## 📋 Tổng quan

Module Deduplication chuyên xử lý việc loại bỏ các items trùng lặp trong từ điển. Đây là module quan trọng để đảm bảo chất lượng dữ liệu và tối ưu hóa kích thước từ điển cuối cùng.

## 📁 Files trong Module

### 1. `deduplicate_items.js` - Khử Trùng lặp Items

**Chức năng:**
- 🧹 Loại bỏ các items trùng lặp trong từ điển
- 🔍 Phát hiện duplicate patterns
- 📊 Thống kê chi tiết về deduplication
- 📈 Báo cáo hiệu quả khử trùng lặp
- 🎯 Maintain data quality và integrity

**Cách sử dụng:**
```bash
node deduplicate_items.js
```

**Input:**
- Multiple process files: `../../output/dict-processed-process-*.json`
- Configuration settings trong script

**Output:**
- Deduplicated files: `../../output/dict-processed-process-{id}-deduplicated.json`
- Deduplication report: `../../deduplication-report.json`
- Statistics summary in console

**Features:**
- ✅ Smart duplicate detection
- ✅ Preserve highest quality entries
- ✅ Detailed statistics reporting
- ✅ Memory-efficient processing
- ✅ Progress tracking cho large datasets

## 🧹 Deduplication Strategies

### 1. Exact Match Deduplication

**Strategy:** Exact string matching trên field `chinese`
```javascript
const exactMatchStrategy = {
    keyField: 'chinese',
    caseSensitive: true,
    preserveFirst: true,        // Keep first occurrence
    conflictResolution: 'first_wins'
};
```

**Algorithm:**
```javascript
class ExactDeduplicator {
    constructor() {
        this.seenItems = new Map();
        this.duplicateCount = 0;
    }
    
    process(item) {
        const key = item.chinese;
        
        if (this.seenItems.has(key)) {
            this.duplicateCount++;
            return { action: 'skip', reason: 'exact_duplicate' };
        }
        
        this.seenItems.set(key, item);
        return { action: 'keep', item };
    }
}
```

### 2. Smart Quality-based Deduplication

**Strategy:** Preserve items với higher quality scores
```javascript
const qualityBasedStrategy = {
    keyField: 'chinese',
    qualityMetrics: {
        completeness: 0.4,      // 40% weight
        translation_quality: 0.3, // 30% weight
        example_presence: 0.2,  // 20% weight
        metadata_richness: 0.1  // 10% weight
    },
    conflictResolution: 'higher_quality'
};
```

**Quality Score Calculation:**
```javascript
class QualityScorer {
    calculateScore(item) {
        const scores = {
            completeness: this.calculateCompleteness(item),
            translation_quality: this.assessTranslationQuality(item),
            example_presence: this.checkExamplePresence(item),
            metadata_richness: this.assessMetadataRichness(item)
        };
        
        return Object.entries(scores).reduce((total, [metric, score]) => {
            const weight = this.config.qualityMetrics[metric];
            return total + (score * weight);
        }, 0);
    }
    
    calculateCompleteness(item) {
        const requiredFields = ['chinese', 'pinyin', 'meaning_vi'];
        const optionalFields = ['meaning_en', 'example_cn', 'example_vi'];
        
        const requiredScore = requiredFields.every(field => item[field]) ? 0.7 : 0;
        const optionalScore = optionalFields.filter(field => item[field]).length / optionalFields.length * 0.3;
        
        return requiredScore + optionalScore;
    }
}
```

### 3. Semantic Similarity Deduplication

**Strategy:** Detect semantic duplicates với different forms
```javascript
const semanticStrategy = {
    similarityThreshold: 0.85,
    useEmbeddings: false,       // Use simple similarity for performance
    preserveBest: true,
    metrics: ['character_overlap', 'meaning_similarity']
};
```

**Similarity Calculation:**
```javascript
class SemanticComparator {
    calculateSimilarity(item1, item2) {
        const charSimilarity = this.characterOverlapScore(item1.chinese, item2.chinese);
        const meaningSimilarity = this.meaningOverlapScore(item1.meaning_vi, item2.meaning_vi);
        
        return (charSimilarity * 0.6) + (meaningSimilarity * 0.4);
    }
    
    characterOverlapScore(str1, str2) {
        const set1 = new Set(str1);
        const set2 = new Set(str2);
        const intersection = new Set([...set1].filter(x => set2.has(x)));
        const union = new Set([...set1, ...set2]);
        
        return intersection.size / union.size; // Jaccard similarity
    }
}
```

## 📊 Statistics và Reporting

### Deduplication Statistics:
```javascript
const deduplicationStats = {
    totalItemsBefore: 150000,
    totalItemsAfter: 145200,
    duplicatesRemoved: 4800,
    deduplicationRate: 3.2,     // Percentage
    
    // By process breakdown
    duplicatesByProcess: {
        process_1: { before: 18750, after: 18234, removed: 516 },
        process_2: { before: 18650, after: 18123, removed: 527 },
        // ...
    },
    
    // Duplicate patterns
    duplicatePatterns: {
        exact_matches: 3200,
        similar_characters: 980,
        meaning_duplicates: 620
    },
    
    // Processing metrics
    processingTime: '00:08:45',
    memoryUsage: '1.8GB',
    throughput: 287.5           // Items per second
};
```

### Report Generation:
```javascript
class DeduplicationReporter {
    generateReport(stats) {
        return {
            summary: this.generateSummary(stats),
            details: this.generateDetails(stats),
            recommendations: this.generateRecommendations(stats),
            visualizations: this.generateCharts(stats)
        };
    }
    
    generateSummary(stats) {
        return {
            efficiency: `Removed ${stats.duplicatesRemoved} duplicates (${stats.deduplicationRate}%)`,
            quality: `Final dataset: ${stats.totalItemsAfter} unique items`,
            performance: `Processed in ${stats.processingTime} at ${stats.throughput} items/sec`
        };
    }
}
```

### Console Output Example:
```
=== DEDUPLICATING DICTIONARY ITEMS ===
📊 Processing 30 files...

Process 1: [████████████] 18,750 → 18,234 (-516 duplicates)
Process 2: [████████████] 18,650 → 18,123 (-527 duplicates)
Process 3: [████████████] 18,800 → 18,267 (-533 duplicates)
...

=== DEDUPLICATION SUMMARY ===
✅ Total items processed: 150,000
🧹 Duplicates removed: 4,800 (3.2%)
📊 Final unique items: 145,200
⏱️ Processing time: 8m 45s
💾 Memory used: 1.8GB

=== DUPLICATE PATTERNS ===
🔍 Exact matches: 3,200 (66.7%)
📝 Similar characters: 980 (20.4%)
💭 Meaning duplicates: 620 (12.9%)

=== QUALITY METRICS ===
📈 Data quality improved by 12.3%
🎯 Duplicate detection accuracy: 97.8%
✨ No false positives detected
```

## 🔧 Advanced Features

### 1. Incremental Deduplication

**Feature:** Process only new items against existing deduplicated set
```javascript
class IncrementalDeduplicator {
    constructor(existingDedupSet) {
        this.existingItems = new Map(existingDedupSet.map(item => [item.chinese, item]));
    }
    
    processNewItems(newItems) {
        return newItems.filter(item => {
            return !this.existingItems.has(item.chinese);
        });
    }
}
```

### 2. Cross-Process Deduplication

**Feature:** Detect duplicates across different process outputs
```javascript
const crossProcessDedup = {
    async findCrossProcessDuplicates() {
        const allItems = new Map();
        const duplicates = [];
        
        for (let processId = 1; processId <= 30; processId++) {
            const processItems = await this.loadProcessFile(processId);
            
            for (const item of processItems) {
                const key = item.chinese;
                if (allItems.has(key)) {
                    duplicates.push({
                        item,
                        originalProcess: allItems.get(key).process,
                        duplicateProcess: processId
                    });
                } else {
                    allItems.set(key, { ...item, process: processId });
                }
            }
        }
        
        return duplicates;
    }
};
```

### 3. Fuzzy Deduplication

**Feature:** Handle slight variations và typos
```javascript
class FuzzyDeduplicator {
    constructor() {
        this.fuzzyThreshold = 0.9;
        this.editDistanceLimit = 2;
    }
    
    calculateEditDistance(str1, str2) {
        const matrix = Array(str2.length + 1).fill().map(() => Array(str1.length + 1).fill(0));
        
        for (let i = 0; i <= str1.length; i++) matrix[0][i] = i;
        for (let j = 0; j <= str2.length; j++) matrix[j][0] = j;
        
        for (let j = 1; j <= str2.length; j++) {
            for (let i = 1; i <= str1.length; i++) {
                const cost = str1[i - 1] === str2[j - 1] ? 0 : 1;
                matrix[j][i] = Math.min(
                    matrix[j - 1][i] + 1,     // deletion
                    matrix[j][i - 1] + 1,     // insertion
                    matrix[j - 1][i - 1] + cost // substitution
                );
            }
        }
        
        return matrix[str2.length][str1.length];
    }
    
    isFuzzyDuplicate(item1, item2) {
        const editDistance = this.calculateEditDistance(item1.chinese, item2.chinese);
        const maxLength = Math.max(item1.chinese.length, item2.chinese.length);
        const similarity = 1 - (editDistance / maxLength);
        
        return similarity >= this.fuzzyThreshold && editDistance <= this.editDistanceLimit;
    }
}
```

## ⚡ Performance Optimization

### Memory Management:
```javascript
const performanceConfig = {
    // Process in chunks để avoid memory overflow
    chunkSize: 10000,
    
    // Use streaming cho very large datasets
    useStreaming: true,
    streamBufferSize: 1000,
    
    // Garbage collection optimization
    gcInterval: 5000,
    maxMemoryUsage: '4GB',
    
    // Parallel processing
    workerThreads: 4,
    concurrentFiles: 3
};
```

### Efficient Data Structures:
```javascript
class EfficientDeduplicator {
    constructor() {
        // Use Map cho O(1) lookup
        this.seenHashes = new Map();
        
        // Use Set cho faster existence checks
        this.processedKeys = new Set();
        
        // Use WeakMap cho memory management
        this.itemMetadata = new WeakMap();
    }
    
    // Fast hash generation cho duplicate detection
    generateHash(item) {
        return `${item.chinese}|${item.pinyin}|${item.meaning_vi}`;
    }
}
```

## 🚨 Error Handling

### Common Deduplication Issues:

1. **Memory Overflow:**
```javascript
// Solution: Chunk processing
if (itemCount > this.memoryThreshold) {
    return this.processInChunks(items);
}
```

2. **Corrupted Data:**
```javascript
// Solution: Validation và skip
try {
    const parsedItem = this.validateItem(item);
    return this.processItem(parsedItem);
} catch (error) {
    this.logCorruptedItem(item, error);
    return { action: 'skip', reason: 'corrupted_data' };
}
```

3. **Inconsistent Data Format:**
```javascript
// Solution: Normalization
const normalizedItem = this.normalizeItemFormat(item);
return this.processItem(normalizedItem);
```

## 🧪 Testing và Validation

### Unit Tests:
```bash
# Test deduplication logic
npm test src/deduplication/

# Test với sample data
node test_deduplication_sample.js

# Performance testing
node test_deduplication_performance.js
```

### Validation Tests:
```javascript
const validationTests = {
    // Test duplicate detection accuracy
    testDuplicateDetection() {
        const testCases = [
            { item1: {chinese: '你好'}, item2: {chinese: '你好'}, expected: true },
            { item1: {chinese: '你好'}, item2: {chinese: '再见'}, expected: false }
        ];
        
        testCases.forEach(test => {
            const result = this.deduplicator.isDuplicate(test.item1, test.item2);
            assert.equal(result, test.expected);
        });
    },
    
    // Test quality preservation
    testQualityPreservation() {
        const duplicates = [
            { chinese: '你好', completeness: 0.8 },
            { chinese: '你好', completeness: 0.6 }
        ];
        
        const result = this.deduplicator.resolveDuplicates(duplicates);
        assert.equal(result.completeness, 0.8);
    }
};
```

## 📊 Configuration

### Deduplication Configuration:
```javascript
const deduplicationConfig = {
    // Strategy settings
    strategy: 'quality_based',          // 'exact', 'quality_based', 'semantic'
    preserveFirst: false,               // false = preserve highest quality
    
    // Quality metrics weights
    qualityWeights: {
        completeness: 0.4,
        translation_quality: 0.3,
        example_presence: 0.2,
        metadata_richness: 0.1
    },
    
    // Similarity thresholds
    exactMatchThreshold: 1.0,
    semanticSimilarityThreshold: 0.85,
    fuzzyMatchThreshold: 0.9,
    
    // Performance settings
    chunkSize: 10000,
    enableParallelProcessing: true,
    maxWorkers: 4,
    memoryLimit: '4GB',
    
    // Output settings
    generateReport: true,
    reportFormat: 'json',               // 'json', 'html', 'csv'
    logLevel: 'info',
    
    // Safety settings
    backupOriginal: true,
    validateResults: true,
    maxErrorRate: 0.01
};
```

---

**Module:** Deduplication  
**Maintainer:** Data Quality Team  
**Last Updated:** 05/08/2025

*Module Deduplication đảm bảo chất lượng dữ liệu cao. Luôn backup dữ liệu trước khi chạy deduplication.*
