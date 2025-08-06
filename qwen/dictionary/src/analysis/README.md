# Analysis Module - Phân tích và Thống kê

## 📋 Tổng quan

Module Analysis cung cấp các công cụ để phân tích dữ liệu từ điển, kiểm tra tình trạng processing, và tạo báo cáo thống kê chi tiết. Đây là công cụ quan trọng để monitoring và quality assurance.

## 📁 Files trong Module

### 1. `analyze_batch_distribution.js` - Phân tích Phân bố Batch

**Chức năng:**
- 📊 Phân tích cách phân bố batches giữa các processes
- 🎯 Tính toán optimal batch distribution
- 📈 Đánh giá coverage và capacity utilization
- ⚖️ Kiểm tra load balancing giữa processes

**Cách sử dụng:**
```bash
node analyze_batch_distribution.js
```

**Output Sample:**
```
=== ANALYSIS OF BATCH DISTRIBUTION ===
Input items: 98,160
Batch size: 20
Total batches needed: 4,908
Total processes: 30
Batches per process (config): 60
Optimal batches per process: 164
Actual batches per process used: 164

=== CAPACITY ANALYSIS ===
Total capacity: 98,400
Coverage: 100.2%

=== BATCH DISTRIBUTION ===
Process 1: Batches 1-164 (Items 1-3,280)
Process 2: Batches 165-328 (Items 3,281-6,560)
...
```

**Thông tin được phân tích:**
- Total input items vs batch capacity
- Batch distribution fairness
- Process load balancing
- Coverage percentage
- Potential gaps hoặc overlaps

### 2. `analyze_deduplication.js` - Phân tích Trùng lặp

**Chức năng:**
- 🔍 Phân tích tình trạng duplicate items
- 📋 Thống kê duplicate patterns
- 🎯 Identify nguồn gốc duplicates
- 📊 Báo cáo deduplication effectiveness

**Cách sử dụng:**
```bash
node analyze_deduplication.js
```

**Phân tích nội dung:**
- Duplicate rate by process
- Most common duplicate patterns
- Character-based duplicate analysis
- Deduplication impact assessment

**Output Format:**
```
=== DEDUPLICATION ANALYSIS ===
Total items analyzed: 150,000
Unique items: 145,200
Duplicate items: 4,800
Duplication rate: 3.2%

=== DUPLICATE PATTERNS ===
Most duplicated words:
- 的: 45 occurrences
- 是: 38 occurrences
- 在: 32 occurrences

=== BY PROCESS ANALYSIS ===
Process 1: 2.1% duplicates
Process 2: 3.8% duplicates
Process 3: 2.9% duplicates
```

### 3. `checkCoverage.js` - Kiểm tra Độ bao phủ

**Chức năng:**
- ✅ Kiểm tra coverage của input data
- 🔍 Identify missing items hoặc gaps
- 📊 Thống kê completion rate
- 🎯 Validate processing completeness

**Cách sử dụng:**
```bash
node checkCoverage.js
```

**Kiểm tra nội dung:**
- Input vs output item count
- Missing item identification
- Batch completion status
- Data integrity verification

**Coverage Report:**
```
=== COVERAGE ANALYSIS ===
Input items: 98,160
Processed items: 97,845
Missing items: 315
Coverage rate: 99.68%

=== MISSING ITEMS BREAKDOWN ===
Missing by batch:
- Batch 45: 12 items
- Batch 67: 8 items
- Batch 89: 15 items

=== QUALITY METRICS ===
Items with complete data: 97,234 (99.37%)
Items missing fields: 611 (0.63%)
Items with validation errors: 0 (0.00%)
```

## 🔧 Configuration

### Analysis Settings
Có thể customize trong từng script:

```javascript
// analyze_batch_distribution.js
const BATCH_SIZE = 20;
const TOTAL_PROCESSES = 30;
const BATCHES_PER_PROCESS = 60;

// analyze_deduplication.js
const DUPLICATE_THRESHOLD = 0.95; // Similarity threshold
const MIN_OCCURRENCE_REPORT = 5;  // Min occurrences để report

// checkCoverage.js
const EXPECTED_FIELDS = ['chinese', 'pinyin', 'meaning_vi'];
const CRITICAL_FIELDS = ['chinese', 'meaning_vi'];
```

## 📊 Advanced Analysis Features

### 1. Batch Distribution Analysis

**Key Metrics:**
- **Load Balance Score**: Đánh giá sự cân bằng giữa processes
- **Capacity Utilization**: % sử dụng theoretical capacity
- **Overlap Detection**: Phát hiện items được process nhiều lần
- **Gap Detection**: Phát hiện items bị skip

**Optimization Recommendations:**
```javascript
// Script tự động suggest optimal settings
if (coverageRate < 100) {
    console.log('💡 Recommendation: Increase batches-per-process to', optimizedBatchesPerProcess);
}

if (loadBalanceScore < 0.8) {
    console.log('⚖️ Recommendation: Redistribute batches for better load balancing');
}
```

### 2. Deduplication Deep Analysis

**Pattern Recognition:**
- Character frequency analysis
- Semantic similarity detection
- Source process correlation
- Temporal duplicate patterns

**Quality Metrics:**
```javascript
const qualityMetrics = {
    exactDuplicates: 1250,        // Identical chinese + pinyin
    semanticDuplicates: 340,      // Same meaning, different form
    partialDuplicates: 120,       // Similar but different
    crossProcessDuplicates: 890   // Duplicates across processes
};
```

### 3. Coverage Comprehensive Check

**Multi-dimensional Coverage:**
- **Quantitative**: Item count coverage
- **Qualitative**: Field completeness coverage
- **Semantic**: Meaning coverage analysis
- **Character**: Character set coverage

**Validation Rules:**
```javascript
const validationRules = {
    required: ['chinese', 'meaning_vi'],
    optional: ['pinyin', 'hanviet', 'example_cn'],
    format: {
        chinese: /^[\u4e00-\u9fff]+$/,
        pinyin: /^[a-zA-ZāáǎàēéěèīíǐìōóǒòūúǔùüǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙÜǗǙǛ\s]+$/
    }
};
```

## 📈 Reporting Features

### 1. Executive Summary Reports

```bash
# Tạo báo cáo tổng quan
node generate_executive_summary.js

# Output: analysis-summary-{date}.json
```

**Summary Contents:**
- Overall project health score
- Key performance indicators
- Critical issues identification
- Improvement recommendations

### 2. Detailed Technical Reports

```bash
# Báo cáo kỹ thuật chi tiết
node generate_technical_report.js --detailed

# Output: technical-analysis-{date}.html
```

**Technical Report Sections:**
- Data flow analysis
- Performance bottlenecks
- Resource utilization
- Error pattern analysis

### 3. Progress Tracking Reports

```bash
# Track tiến độ theo thời gian
node track_progress.js --start-date=2025-08-01

# Output: progress-tracking-{date}.json
```

## 🚨 Alert System

### Automated Alerts

**Coverage Alerts:**
```javascript
if (coverageRate < 95) {
    sendAlert('LOW_COVERAGE', `Coverage rate: ${coverageRate}%`);
}

if (missingItemsCount > 1000) {
    sendAlert('HIGH_MISSING_COUNT', `Missing ${missingItemsCount} items`);
}
```

**Quality Alerts:**
```javascript
if (duplicateRate > 5) {
    sendAlert('HIGH_DUPLICATE_RATE', `Duplicate rate: ${duplicateRate}%`);
}

if (errorRate > 1) {
    sendAlert('HIGH_ERROR_RATE', `Error rate: ${errorRate}%`);
}
```

## 🔍 Troubleshooting

### Common Analysis Issues:

1. **Large Dataset Performance:**
```bash
# Sử dụng streaming cho files lớn
node --max-old-space-size=8192 analyze_batch_distribution.js
```

2. **Incomplete Data Analysis:**
```bash
# Skip corrupted files
node checkCoverage.js --skip-corrupted --log-skipped
```

3. **Memory Issues với Large Analysis:**
```bash
# Process in chunks
node analyze_deduplication.js --chunk-size=10000
```

## 📊 Integration với Monitoring

### Prometheus Metrics Export:
```javascript
// Export metrics cho monitoring systems
const metrics = {
    coverage_rate: coverageRate,
    duplicate_rate: duplicateRate,
    processing_speed: itemsPerSecond,
    error_rate: errorRate
};

exportToPrometheus(metrics);
```

### Grafana Dashboard:
- Real-time coverage tracking
- Duplicate rate trends
- Processing performance metrics
- Alert visualization

## 🧪 Testing Analysis Tools

### Unit Tests:
```bash
# Test individual analysis functions
npm test src/analysis/

# Test specific analyzer
npm test src/analysis/analyze_batch_distribution.test.js
```

### Integration Tests:
```bash
# Test với sample data
node test_analysis_with_sample.js

# Validate analysis accuracy
node validate_analysis_accuracy.js
```

## 📝 Custom Analysis

### Creating Custom Analyzers:

```javascript
// Template cho custom analyzer
class CustomAnalyzer {
    constructor(config) {
        this.config = config;
    }
    
    async analyze(data) {
        // Custom analysis logic
        return analysisResult;
    }
    
    generateReport(result) {
        // Custom report generation
        return report;
    }
}
```

### Example Custom Analysis:

```javascript
// Character frequency analysis
const charAnalyzer = new CustomAnalyzer({
    analysisType: 'character_frequency',
    outputFormat: 'json'
});

const result = await charAnalyzer.analyze(dictionaryData);
```

---

**Module:** Analysis  
**Maintainer:** Data Analysis Team  
**Last Updated:** 05/08/2025

*Các công cụ analysis này giúp đảm bảo chất lượng dữ liệu và hiệu suất processing. Sử dụng thường xuyên để monitoring project health.*
