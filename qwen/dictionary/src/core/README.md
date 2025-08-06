# Core Module - Tạo Từ điển Cốt lõi

## 📋 Tổng quan

Module Core chứa các script chính để tạo và xử lý từ điển Trung-Việt. Đây là phần trung tâm của hệ thống, chịu trách nhiệm tương tác với API và tạo ra dữ liệu từ điển.

## 📁 Files trong Module

### 1. `dictionaryGenerate.js` - Script Chính Tạo Từ điển

**Chức năng:**
- 🚀 Tạo từ điển từ API Qwen với xử lý song song
- 🔄 Hỗ trợ multiple processes cho hiệu suất cao
- ⚡ Batch processing với error handling
- 📊 Progress tracking và logging chi tiết

**Cách sử dụng:**
```bash
# Chạy đơn process
node dictionaryGenerate.js

# Chạy với multiple processes
node dictionaryGenerate.js --process-id=1 --total-processes=10 --batches-per-process=50
```

**Tham số:**
- `--process-id`: ID của process hiện tại (1-N)
- `--total-processes`: Tổng số processes chạy song song
- `--batches-per-process`: Số batches mỗi process xử lý

**Environment Variables:**
```bash
DASHSCOPE_API_KEY=your_api_key
BATCH_SIZE=20                    # Số items mỗi batch
BATCH_DELAY=2000                 # Delay giữa các requests (ms)
```

**Output:**
- File: `output/dict_batch_{batchNum}_of_{totalBatches}_process_{processId}.json`
- Format: Array of dictionary items

### 2. `hanviet.js` - Tích hợp Hán Việt

**Chức năng:**
- 📚 Tích hợp âm Hán Việt vào từ điển
- 🔍 Ánh xạ từ chữ Hán sang âm đọc Hán Việt
- 📈 Thống kê tỷ lệ khớp và báo cáo

**Cách sử dụng:**
```bash
# Tích hợp Hán Việt cho file đơn lẻ
node hanviet.js ../input/dictionary.json

# Output: dictionary_with_hanviet.json
```

**Input Requirements:**
- File JSON với structure có field `chinese`
- File Hán Việt dictionary tại `../input/tudienhanviet.json`

**Output Format:**
```json
{
  "chinese": "你好",
  "hanviet": "nể hảo",
  "pinyin": "nǐ hǎo",
  "meaning_vi": "xin chào"
}
```

### 3. `dictionaryGenerate.old.js` - Backup Version

**Chức năng:**
- 🗄️ Phiên bản cũ của dictionary generator
- 🔒 Được giữ lại để tham khảo và rollback
- ⚠️ Không nên sử dụng cho production

## 🔧 Cấu hình API

### Qwen API Configuration
```javascript
const openai = new OpenAI({
    apiKey: process.env.DASHSCOPE_API_KEY,
    baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});
```

### Prompt Template
File `../../dict-promt.txt` chứa system prompt để API:
- Định dạng output JSON chuẩn
- Hướng dẫn dịch thuật chính xác
- Cấu trúc response format

## 📊 Data Flow

```
Input Data (DICTIONARY.json)
         ↓
    Batch Processing (dictionaryGenerate.js)
         ↓
    API Translation (Qwen)
         ↓
    Batch Results (output/*.json)
         ↓
    Hanviet Integration (hanviet.js)
         ↓
    Final Dictionary with Hanviet
```

## 🚨 Error Handling

### API Errors:
- **Rate Limit**: Tự động retry với exponential backoff
- **Network Issues**: Retry mechanism với max attempts
- **Invalid Response**: Log error và skip item

### Common Issues:

1. **API Key Invalid:**
```bash
Error: DASHSCOPE_API_KEY environment variable is not set
```
**Solution:** Kiểm tra .env file và API key

2. **Rate Limit Exceeded:**
```bash
Rate limit exceeded, waiting...
```
**Solution:** Tăng BATCH_DELAY hoặc giảm BATCH_SIZE

3. **Memory Issues:**
```bash
JavaScript heap out of memory
```
**Solution:** 
```bash
node --max-old-space-size=4096 dictionaryGenerate.js
```

## 📈 Performance Optimization

### Optimal Settings:
```bash
# Cho server mạnh
BATCH_SIZE=50
BATCH_DELAY=1000
TOTAL_PROCESSES=20

# Cho server trung bình
BATCH_SIZE=20
BATCH_DELAY=2000
TOTAL_PROCESSES=10

# Cho API limits nghiêm ngặt
BATCH_SIZE=10
BATCH_DELAY=5000
TOTAL_PROCESSES=5
```

### Monitoring:
```bash
# CPU usage
htop

# Memory usage
free -h

# Disk I/O
iotop

# Network
nethogs
```

## 🧪 Testing

### Test API Connection:
```bash
cd ../testing
node test_api_direct.js
```

### Validate Output:
```bash
# Kiểm tra số lượng files output
ls -la ../../output/dict_batch_*.json | wc -l

# Kiểm tra file size
du -sh ../../output/

# Sample data validation
head -20 ../../output/dict_batch_1_*.json
```

## 📝 Logs

### Log Levels:
- `INFO`: Progress updates, batch completion
- `WARN`: Retry attempts, partial failures  
- `ERROR`: API failures, file I/O errors
- `DEBUG`: Detailed API responses, timing info

### Log Locations:
- Console output: Real-time progress
- File logs: `../../logs/generation-{date}.log`
- Error logs: `../../logs/error-{date}.log`

## 🔄 Recovery Procedures

### Từ Crashed Process:
1. Kiểm tra log files để xác định batch cuối thành công
2. Update process configuration để skip completed batches
3. Restart từ batch tiếp theo

### Từ Incomplete Batches:
```bash
# Tìm batches thiếu
cd ../missing-items
node find_missing_batches.js

# Reprocess
node reprocess_missing_parallel.js
```

## 🛡️ Best Practices

### 1. Production Deployment:
- Sử dụng PM2 để manage processes
- Set up monitoring và alerting
- Regular backup của output directory
- Monitor API usage và costs

### 2. Resource Management:
- Limit concurrent processes dựa trên server capacity
- Monitor memory usage và disk space
- Implement rate limiting phù hợp với API limits

### 3. Data Quality:
- Validate API responses trước khi save
- Implement checksum verification
- Regular data integrity checks

---

**Module:** Core  
**Maintainer:** Dictionary Team  
**Last Updated:** 05/08/2025
