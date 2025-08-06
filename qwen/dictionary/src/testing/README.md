# Testing Module - Kiểm thử và Validation

## 📋 Tổng quan

Module Testing cung cấp các công cụ để test API connectivity, validate data quality, và ensure system functionality. Đây là module quan trọng để đảm bảo reliability và correctness của toàn bộ hệ thống từ điển.

## 📁 Files trong Module

### 1. `test_api_direct.js` - Test API Trực tiếp

**Chức năng:**
- 🌐 Test kết nối trực tiếp với Qwen API
- 🔍 Validate API response format
- ⚡ Test API performance và latency
- 🚨 Detect API issues và rate limits
- 📊 API health monitoring

**Cách sử dụng:**
```bash
node test_api_direct.js
```

**Features:**
- ✅ Single word translation test
- ✅ Batch translation test
- ✅ Error handling validation
- ✅ Response format verification
- ✅ Performance benchmarking

**Output Sample:**
```
Testing API with single word: ["圫"]

=== RAW API RESPONSE ===
{
  "choices": [{
    "message": {
      "content": "{\"chinese\": \"圫\", \"meaning_vi\": \"tụ họp, thôn làng\"}"
    }
  }]
}

=== PARSED RESULT ===
✅ Valid JSON format
✅ Required fields present
✅ Response time: 1.2s
✅ API connection successful

=== PERFORMANCE METRICS ===
Request latency: 1,234ms
Response size: 156 bytes
Success rate: 100%
```

### 2. `test-refactored.js` - Test Sau Refactor

**Chức năng:**
- 🔄 Test functionality sau khi refactor code
- 🧪 Integration testing với restructured modules
- ✅ Validate backward compatibility
- 📊 Performance comparison tests
- 🎯 End-to-end workflow testing

**Test Coverage:**
- Core module functionality
- Merging operations
- Missing items handling
- Deduplication logic
- Cross-module integration

**Cách sử dụng:**
```bash
node test-refactored.js
```

**Test Scenarios:**
```javascript
const testScenarios = [
    {
        name: 'Core Dictionary Generation',
        test: () => testDictionaryGeneration(),
        expectedResult: 'valid_output_files'
    },
    {
        name: 'Missing Items Detection',
        test: () => testMissingItemsDetection(),
        expectedResult: 'accurate_missing_list'
    },
    {
        name: 'Deduplication Process',
        test: () => testDeduplication(),
        expectedResult: 'no_duplicates_found'
    }
];
```

## 🧪 Test Categories

### 1. Unit Tests

**API Tests:**
```javascript
describe('API Connectivity', () => {
    test('should connect to Qwen API successfully', async () => {
        const response = await testApiConnection();
        expect(response.status).toBe('success');
    });
    
    test('should handle rate limiting gracefully', async () => {
        const rateLimitTest = await testRateLimit();
        expect(rateLimitTest.handledGracefully).toBe(true);
    });
    
    test('should validate response format', () => {
        const mockResponse = getMockResponse();
        const isValid = validateResponseFormat(mockResponse);
        expect(isValid).toBe(true);
    });
});
```

**Data Processing Tests:**
```javascript
describe('Data Processing', () => {
    test('should process Chinese characters correctly', () => {
        const testChars = ['你好', '世界', '中文'];
        testChars.forEach(char => {
            expect(isValidChinese(char)).toBe(true);
        });
    });
    
    test('should merge data without losing items', () => {
        const mockData1 = generateMockData(100);
        const mockData2 = generateMockData(100);
        const merged = mergeData(mockData1, mockData2);
        expect(merged.length).toBe(200);
    });
});
```

### 2. Integration Tests

**End-to-End Workflow:**
```javascript
describe('End-to-End Workflow', () => {
    test('complete dictionary generation workflow', async () => {
        // 1. Generate sample dictionary
        const generated = await runDictionaryGeneration({
            sampleSize: 50,
            mockApi: true
        });
        
        // 2. Find missing items
        const missing = await findMissingItems(generated);
        
        // 3. Reprocess missing
        const reprocessed = await reprocessMissing(missing);
        
        // 4. Merge results
        const merged = await mergeResults([generated, reprocessed]);
        
        // 5. Deduplicate
        const final = await deduplicate(merged);
        
        // Validate final result
        expect(final.length).toBeGreaterThan(0);
        expect(hasDuplicates(final)).toBe(false);
        expect(hasAllRequiredFields(final)).toBe(true);
    });
});
```

**Module Integration:**
```javascript
describe('Module Integration', () => {
    test('core and merging modules integration', async () => {
        const coreOutput = await simulateCoreProcessing();
        const mergeResult = await testMerging(coreOutput);
        
        expect(mergeResult.success).toBe(true);
        expect(mergeResult.itemCount).toEqual(coreOutput.itemCount);
    });
    
    test('missing items and deduplication integration', async () => {
        const missingItems = generateMissingItems();
        const processed = await processMissingItems(missingItems);
        const deduplicated = await deduplicate(processed);
        
        expect(deduplicated.duplicateCount).toBe(0);
    });
});
```

### 3. Performance Tests

**Load Testing:**
```javascript
describe('Performance Tests', () => {
    test('should handle large datasets efficiently', async () => {
        const largeDataset = generateLargeDataset(100000);
        const startTime = performance.now();
        
        const result = await processLargeDataset(largeDataset);
        
        const endTime = performance.now();
        const processingTime = endTime - startTime;
        
        expect(processingTime).toBeLessThan(300000); // 5 minutes max
        expect(result.processedCount).toBe(100000);
    });
    
    test('memory usage should stay within limits', async () => {
        const initialMemory = process.memoryUsage().heapUsed;
        
        await processMemoryIntensiveTask();
        
        const finalMemory = process.memoryUsage().heapUsed;
        const memoryIncrease = finalMemory - initialMemory;
        
        expect(memoryIncrease).toBeLessThan(1024 * 1024 * 1024); // 1GB limit
    });
});
```

**API Performance:**
```javascript
describe('API Performance', () => {
    test('API response time should be acceptable', async () => {
        const testWords = ['你好', '世界', '学习'];
        const responseTimes = [];
        
        for (const word of testWords) {
            const startTime = performance.now();
            await callAPI(word);
            const endTime = performance.now();
            responseTimes.push(endTime - startTime);
        }
        
        const avgResponseTime = responseTimes.reduce((a, b) => a + b) / responseTimes.length;
        expect(avgResponseTime).toBeLessThan(3000); // 3 seconds max
    });
});
```

## 🔧 Test Utilities

### Mock Data Generators:
```javascript
class MockDataGenerator {
    generateMockDictionaryItem() {
        return {
            chinese: this.generateRandomChinese(),
            pinyin: this.generateRandomPinyin(),
            meaning_vi: this.generateRandomVietnamese(),
            meaning_en: this.generateRandomEnglish(),
            example_cn: this.generateRandomExample(),
            hsk_level: Math.floor(Math.random() * 6) + 1
        };
    }
    
    generateRandomChinese() {
        const chars = ['你', '好', '世', '界', '学', '习', '中', '文'];
        const length = Math.floor(Math.random() * 3) + 1;
        return Array.from({length}, () => 
            chars[Math.floor(Math.random() * chars.length)]
        ).join('');
    }
    
    generateLargeDataset(size) {
        return Array.from({length: size}, () => this.generateMockDictionaryItem());
    }
}
```

### Test Helpers:
```javascript
class TestHelpers {
    static async cleanupTestFiles() {
        const testFiles = await glob('test_output_*.json');
        await Promise.all(testFiles.map(file => fs.unlink(file)));
    }
    
    static validateDictionaryItem(item) {
        const requiredFields = ['chinese', 'meaning_vi'];
        return requiredFields.every(field => item[field]);
    }
    
    static async measureExecutionTime(fn) {
        const start = performance.now();
        const result = await fn();
        const end = performance.now();
        return { result, executionTime: end - start };
    }
    
    static compareDatasets(dataset1, dataset2) {
        return {
            sizeDifference: dataset1.length - dataset2.length,
            duplicatesInFirst: this.findDuplicates(dataset1),
            duplicatesInSecond: this.findDuplicates(dataset2),
            commonItems: this.findCommonItems(dataset1, dataset2)
        };
    }
}
```

### API Test Framework:
```javascript
class APITestFramework {
    constructor() {
        this.testResults = [];
        this.config = {
            timeout: 10000,
            retries: 3,
            rateLimitDelay: 1000
        };
    }
    
    async runAPITest(testCase) {
        try {
            const result = await this.executeWithRetry(testCase.apiCall);
            return this.validateResult(result, testCase.expectedFormat);
        } catch (error) {
            return this.handleTestError(error, testCase);
        }
    }
    
    async executeWithRetry(apiCall, retries = this.config.retries) {
        try {
            return await apiCall();
        } catch (error) {
            if (retries > 0 && this.isRetryableError(error)) {
                await this.delay(this.config.rateLimitDelay);
                return this.executeWithRetry(apiCall, retries - 1);
            }
            throw error;
        }
    }
}
```

## 📊 Test Reporting

### Test Report Generation:
```javascript
class TestReporter {
    generateReport(testResults) {
        return {
            summary: this.generateSummary(testResults),
            details: this.generateDetails(testResults),
            performance: this.generatePerformanceReport(testResults),
            coverage: this.generateCoverageReport(testResults)
        };
    }
    
    generateSummary(results) {
        const total = results.length;
        const passed = results.filter(r => r.status === 'passed').length;
        const failed = results.filter(r => r.status === 'failed').length;
        
        return {
            total,
            passed,
            failed,
            successRate: (passed / total * 100).toFixed(1) + '%'
        };
    }
}
```

### Console Output Example:
```
=== DICTIONARY SYSTEM TEST RESULTS ===

API Tests:
✅ API Connection: PASSED (1.2s)
✅ Rate Limit Handling: PASSED (0.8s)
✅ Response Validation: PASSED (0.3s)
❌ Large Batch Test: FAILED (timeout)

Integration Tests:
✅ Core-Merge Integration: PASSED (15.4s)
✅ Missing Items Flow: PASSED (8.7s)
✅ Deduplication Integration: PASSED (12.1s)

Performance Tests:
✅ Large Dataset Processing: PASSED (4m 23s)
⚠️ Memory Usage: WARNING (exceeded 80% of limit)
✅ API Response Time: PASSED (avg: 1.8s)

=== SUMMARY ===
Total Tests: 9
Passed: 7 (77.8%)
Failed: 1 (11.1%)
Warnings: 1 (11.1%)

Overall Status: ⚠️ MOSTLY PASSING (with warnings)
```

## 🚨 Error Testing

### Error Simulation:
```javascript
class ErrorSimulator {
    simulateAPIErrors() {
        return {
            rateLimitError: () => this.mockRateLimitResponse(),
            networkError: () => this.mockNetworkFailure(),
            invalidResponse: () => this.mockInvalidJSON(),
            timeoutError: () => this.mockTimeout()
        };
    }
    
    simulateDataCorruption() {
        return {
            corruptedJSON: () => this.generateCorruptedJSON(),
            missingFields: () => this.generateIncompleteData(),
            invalidCharacters: () => this.generateInvalidChineseChars()
        };
    }
}
```

### Recovery Testing:
```javascript
describe('Error Recovery', () => {
    test('should recover from API failures gracefully', async () => {
        const errorSimulator = new ErrorSimulator();
        
        // Simulate API failure
        const apiError = errorSimulator.simulateAPIErrors().networkError();
        
        // Test recovery mechanism
        const recovery = await testErrorRecovery(apiError);
        
        expect(recovery.recovered).toBe(true);
        expect(recovery.dataLoss).toBe(false);
    });
});
```

## 🛠️ Configuration

### Test Configuration:
```javascript
const testConfig = {
    // API testing
    api: {
        baseURL: process.env.DASHSCOPE_API_KEY ? 'production' : 'mock',
        timeout: 10000,
        maxRetries: 3,
        rateLimitDelay: 1000
    },
    
    // Performance testing
    performance: {
        maxExecutionTime: 300000,    // 5 minutes
        maxMemoryUsage: 1024 * 1024 * 1024, // 1GB
        sampleSizes: [100, 1000, 10000, 100000]
    },
    
    // Data testing
    data: {
        mockDataSize: 1000,
        requiredFields: ['chinese', 'meaning_vi'],
        optionalFields: ['pinyin', 'hanviet', 'example_cn'],
        validationRules: {
            chinese: /^[\u4e00-\u9fff]+$/,
            pinyin: /^[a-zA-ZāáǎàēéěèīíǐìōóǒòūúǔùüǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙÜǗǙǛ\s]+$/
        }
    }
};
```

---

**Module:** Testing  
**Maintainer:** QA Team  
**Last Updated:** 05/08/2025

*Module Testing đảm bảo quality và reliability của toàn bộ hệ thống. Chạy tests trước mọi deployment.*
