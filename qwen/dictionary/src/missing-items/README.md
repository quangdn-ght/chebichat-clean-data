# Missing Items Module - Xử lý Items và Batches Thiếu

## 📋 Tổng quan

Module Missing Items chuyên xử lý các items hoặc batches bị thiếu trong quá trình processing. Đây là module quan trọng để đảm bảo tính toàn vẹn của dữ liệu và xử lý các lỗi phát sinh trong quá trình tạo từ điển.

## 📁 Files trong Module

### 1. `find_missing_batches.js` - Tìm Batches Thiếu

**Chức năng:**
- 🔍 Scan output directory để identify missing batches
- 📊 Thống kê tỷ lệ completion
- 📋 Generate danh sách batches cần reprocess
- 🎯 Phân tích patterns của missing batches

**Cách sử dụng:**
```bash
node find_missing_batches.js
```

**Output Sample:**
```
=== FINDING MISSING BATCHES ===
Total batches expected: 4,903
Total batches found: 4,756
Missing batches: 147 (3.0%)

Missing batch numbers: [45, 67, 89, 123, 145, ...]

=== MISSING PATTERNS ===
Process 1: 8 missing batches
Process 7: 12 missing batches  
Process 15: 15 missing batches

=== RECOMMENDATIONS ===
- Focus reprocessing on processes with high missing rates
- Check logs for process 15 (highest missing rate)
```

### 2. `check_missing_batches.js` - Kiểm tra Chi tiết Batches Thiếu

**Chức năng:**
- 🔎 Deep analysis của missing batches
- 📈 Correlation analysis với error logs
- 🕰️ Timeline analysis của missing patterns
- 💡 Root cause identification

**Advanced Features:**
- Cross-reference với PM2 logs
- Memory usage correlation
- API error pattern analysis
- Process crash detection

### 3. `identify_missing_items.js` - Định danh Items Thiếu

**Chức năng:**
- 🎯 Item-level missing analysis
- 📊 Compare input vs output items
- 🔍 Identify specific missing entries
- 📋 Generate targeted reprocessing lists

**Workflow:**
```
Input Dictionary → Output Scan → Gap Analysis → Missing Items List
```

### 4. `reprocess_missing_parallel.js` - Xử lý lại Song song

**Chức năng:**
- 🚀 High-performance parallel reprocessing
- ⚡ Multi-worker architecture
- 🔄 Smart retry mechanisms
- 📊 Real-time progress tracking

**Cách sử dụng:**
```bash
# Reprocess với default settings
node reprocess_missing_parallel.js

# Custom parallel settings
node reprocess_missing_parallel.js --workers=8 --batch-size=10
```

**Features:**
- Dynamic worker scaling
- Load balancing optimization
- Failed item retry queue
- Progress persistence

### 5. `reprocess_missing_items.js` - Xử lý lại Items Đơn

**Chức năng:**
- 🎯 Single-threaded careful reprocessing
- 🔍 Detailed error tracking
- 📝 Comprehensive logging
- 🛡️ Safe processing mode

**Use Cases:**
- High-value items requiring careful handling
- Debugging specific processing issues
- Low-resource environment processing
- Quality-focused reprocessing

### 6. `reprocess_final_missing.js` - Xử lý lại Thiếu Cuối

**Chức năng:**
- 🏁 Final pass missing item processing
- 🎯 Handle stubborn missing items
- 🔧 Alternative processing strategies
- 📊 Final completion metrics

**Special Handling:**
- Alternative API endpoints
- Modified prompts
- Reduced batch sizes
- Extended timeout values

### 7. `split_missing_items.js` - Chia Items Thiếu

**Chức năng:**
- ✂️ Split large missing item lists
- 📦 Create manageable chunks
- ⚖️ Load balancing across processes
- 📊 Optimization for parallel processing

**Split Strategies:**
```javascript
const splitStrategies = {
    bySize: (items, chunkSize) => chunk(items, chunkSize),
    byComplexity: (items, workers) => distributeByComplexity(items, workers),
    byPriority: (items, priorities) => groupByPriority(items, priorities)
};
```

### 8. `process_final_missing_items.js` - Xử lý Items Thiếu Cuối

**Chức năng:**
- 🎯 Final processing pass
- 🔧 Fallback processing methods
- 📊 Success rate optimization
- 🏁 Completion validation

### 9. `find_gaps.js` - Tìm Khoảng trống

**Chức năng:**
- 🔍 Identify data gaps
- 📊 Gap pattern analysis
- 🎯 Systematic gap filling
- 📈 Coverage improvement tracking

### 10. `reprocessErrorBatches.js` - Xử lý lại Batches Lỗi

**Chức năng:**
- 🚨 Error batch recovery
- 🔄 Smart retry logic
- 📊 Error pattern analysis
- 🛠️ Batch repair mechanisms

## 🔧 Processing Strategies

### 1. Parallel Processing Strategy

**High-Performance Reprocessing:**
```javascript
const parallelConfig = {
    maxWorkers: 8,
    workerMemoryLimit: '2GB',
    batchSize: 10,
    retryAttempts: 3,
    retryDelay: 1000,
    loadBalancing: 'dynamic'
};
```

**Worker Management:**
```javascript
class MissingItemWorker {
    constructor(workerId, config) {
        this.workerId = workerId;
        this.config = config;
        this.processedCount = 0;
        this.errorCount = 0;
    }
    
    async processItems(items) {
        for (const item of items) {
            try {
                const result = await this.processItem(item);
                this.handleSuccess(result);
            } catch (error) {
                this.handleError(item, error);
            }
        }
    }
}
```

### 2. Sequential Processing Strategy

**Careful Reprocessing:**
```javascript
const sequentialConfig = {
    itemDelay: 500,          // Delay between items
    errorLogging: 'detailed',
    validateEach: true,
    stopOnError: false,
    maxRetries: 5
};
```

### 3. Adaptive Processing Strategy

**Smart Strategy Selection:**
```javascript
const adaptiveProcessor = {
    selectStrategy(missingItems) {
        if (missingItems.length > 1000) {
            return 'parallel';
        } else if (this.hasHighErrorRate()) {
            return 'sequential';
        } else {
            return 'hybrid';
        }
    }
};
```

## 📊 Missing Item Analysis

### Gap Analysis Algorithm:
```javascript
class GapAnalyzer {
    constructor(inputData, outputData) {
        this.inputSet = new Set(inputData.map(item => item.chinese));
        this.outputSet = new Set(outputData.map(item => item.chinese));
    }
    
    findMissing() {
        return Array.from(this.inputSet)
            .filter(chinese => !this.outputSet.has(chinese));
    }
    
    analyzePatterns(missingItems) {
        return {
            characterFrequency: this.analyzeCharacterFrequency(missingItems),
            lengthDistribution: this.analyzeLengthDistribution(missingItems),
            complexityScore: this.calculateComplexityScore(missingItems)
        };
    }
}
```

### Missing Patterns Detection:
```javascript
const patternDetector = {
    // Detect systematic missing patterns
    detectSystematicGaps(missingBatches) {
        const gaps = [];
        for (let i = 1; i < missingBatches.length; i++) {
            const gap = missingBatches[i] - missingBatches[i-1];
            if (gap > 1) {
                gaps.push(gap);
            }
        }
        return this.analyzeGapPattern(gaps);
    },
    
    // Detect process-specific issues
    detectProcessIssues(missingByProcess) {
        const issueThreshold = 0.05; // 5% missing rate
        return Object.entries(missingByProcess)
            .filter(([process, missing]) => missing.rate > issueThreshold)
            .map(([process, data]) => ({
                process,
                issueType: this.classifyIssue(data),
                severity: this.calculateSeverity(data)
            }));
    }
};
```

## 🔄 Recovery Workflows

### 1. Standard Recovery Workflow

```
Find Missing → Analyze Patterns → Choose Strategy → Reprocess → Validate → Merge
```

**Implementation:**
```bash
#!/bin/bash
# Standard recovery script

echo "🔍 Finding missing batches..."
node find_missing_batches.js

echo "📊 Analyzing missing patterns..."  
node analyze_missing_patterns.js

echo "🚀 Starting parallel reprocessing..."
node reprocess_missing_parallel.js

echo "✅ Validating results..."
node validate_reprocessed.js

echo "🔄 Merging results..."
cd ../merging
node merge_reprocessed_items.js
```

### 2. Emergency Recovery Workflow

```
Emergency Stop → Assessment → Safe Mode → Recovery → Validation
```

**Emergency Procedures:**
```javascript
const emergencyRecovery = {
    async handleCrash(crashInfo) {
        // 1. Stop all processes
        await this.stopAllProcesses();
        
        // 2. Assess damage
        const damage = await this.assessDamage();
        
        // 3. Safe recovery
        return await this.safeRecovery(damage);
    },
    
    async safeRecovery(damage) {
        const strategy = this.selectRecoveryStrategy(damage);
        return await this.executeRecovery(strategy);
    }
};
```

### 3. Incremental Recovery

```
Checkpoint → Resume → Progress → Checkpoint → ...
```

**Checkpoint System:**
```javascript
class CheckpointManager {
    constructor() {
        this.checkpointFile = 'recovery-checkpoint.json';
    }
    
    async saveCheckpoint(progress) {
        await fs.writeFile(this.checkpointFile, JSON.stringify({
            timestamp: new Date().toISOString(),
            processedItems: progress.processedItems,
            remainingItems: progress.remainingItems,
            currentBatch: progress.currentBatch,
            errorCount: progress.errorCount
        }));
    }
    
    async loadCheckpoint() {
        try {
            const data = await fs.readFile(this.checkpointFile, 'utf8');
            return JSON.parse(data);
        } catch (error) {
            return null; // No checkpoint found
        }
    }
}
```

## 📊 Monitoring và Alerting

### Real-time Monitoring:
```javascript
const missingItemsMonitor = {
    metrics: {
        missingRate: 0,
        reprocessingSpeed: 0,
        errorRate: 0,
        completionETA: null
    },
    
    updateMetrics() {
        this.metrics.missingRate = this.calculateMissingRate();
        this.metrics.reprocessingSpeed = this.calculateProcessingSpeed();
        this.metrics.errorRate = this.calculateErrorRate();
        this.metrics.completionETA = this.estimateCompletion();
    },
    
    checkAlerts() {
        if (this.metrics.missingRate > 0.05) {
            this.sendAlert('HIGH_MISSING_RATE');
        }
        if (this.metrics.errorRate > 0.02) {
            this.sendAlert('HIGH_ERROR_RATE');
        }
    }
};
```

### Progress Tracking:
```bash
# Real-time progress display
=== MISSING ITEMS REPROCESSING ===
Progress: [████████░░] 80% (800/1000)
Speed: 45 items/min
ETA: 4 minutes 30 seconds
Errors: 3 (0.4%)
Current Worker: Process #7 handling batch 156
```

## 🚨 Error Handling

### Error Classification:
```javascript
const errorClassifier = {
    API_ERROR: 'api_connection_failed',
    RATE_LIMIT: 'rate_limit_exceeded', 
    INVALID_RESPONSE: 'invalid_api_response',
    TIMEOUT: 'request_timeout',
    MEMORY_ERROR: 'out_of_memory',
    DISK_ERROR: 'disk_full',
    UNKNOWN: 'unknown_error'
};
```

### Recovery Strategies by Error Type:
```javascript
const recoveryStrategies = {
    [errorClassifier.RATE_LIMIT]: {
        action: 'increase_delay',
        delay: 5000,
        retryCount: 3
    },
    [errorClassifier.TIMEOUT]: {
        action: 'reduce_batch_size',
        newBatchSize: 5,
        retryCount: 2
    },
    [errorClassifier.MEMORY_ERROR]: {
        action: 'restart_worker',
        memoryLimit: '1GB',
        retryCount: 1
    }
};
```

## 🧪 Testing và Validation

### Test Missing Item Recovery:
```bash
# Create artificial missing items for testing
node create_test_gaps.js --count=100

# Test recovery workflow
node test_missing_recovery.js

# Validate recovery results
node validate_recovery.js
```

### Performance Testing:
```bash
# Load test missing item processing
node loadtest_missing_processing.js --items=10000

# Memory usage testing
node test_memory_usage.js --duration=30m
```

## 📝 Configuration

### Missing Items Configuration:
```javascript
const missingItemsConfig = {
    // Detection settings
    scanPattern: 'dict_batch_*_process_*.json',
    expectedBatchPattern: /dict_batch_(\d+)_of_(\d+)_process_(\d+)\.json/,
    
    // Processing settings
    parallelWorkers: 6,
    batchSize: 15,
    retryAttempts: 3,
    retryDelay: 2000,
    
    // Safety settings
    maxErrorRate: 0.05,
    emergencyStopThreshold: 0.1,
    checkpointInterval: 100,
    
    // Output settings
    outputPattern: 'missing_batch_{batchNum}_recovered.json',
    logLevel: 'info',
    progressReportInterval: 5000
};
```

---

**Module:** Missing Items  
**Maintainer:** Data Recovery Team  
**Last Updated:** 05/08/2025

*Module Missing Items đảm bảo tính toàn vẹn dữ liệu. Luôn chạy find_missing_batches.js trước khi merge final results.*
