# Dự án Từ điển Trung-Việt (Restructured)

## 📁 Cấu trúc Dự án Mới

Dự án đã được tổ chức lại theo tính năng để dễ dàng quản lý và bảo trì:

```
dictionary/
├── 📂 src/                              # Mã nguồn chính
│   ├── 📂 core/                         # Tạo từ điển cốt lõi
│   │   ├── dictionaryGenerate.js        # Script chính tạo từ điển
│   │   ├── dictionaryGenerate.old.js    # Phiên bản cũ (backup)
│   │   └── hanviet.js                   # Xử lý Hán Việt
│   ├── 📂 analysis/                     # Phân tích dữ liệu
│   │   ├── analyze_batch_distribution.js # Phân tích phân bố batch
│   │   ├── analyze_deduplication.js     # Phân tích trùng lặp
│   │   └── checkCoverage.js            # Kiểm tra độ bao phủ
│   ├── 📂 merging/                      # Gộp dữ liệu
│   │   ├── mergeDictionary.js           # Gộp từ điển chính
│   │   ├── mergeReprocessedData.js      # Gộp dữ liệu xử lý lại
│   │   ├── mergeResults.js              # Gộp kết quả
│   │   ├── merge_final_translations.js  # Gộp bản dịch cuối
│   │   ├── merge_parallel_results.js    # Gộp kết quả song song
│   │   ├── merge_reprocessed_items.js   # Gộp items xử lý lại
│   │   └── combine_parallel_results.js  # Kết hợp kết quả song song
│   ├── 📂 missing-items/                # Xử lý items thiếu
│   │   ├── check_missing_batches.js     # Kiểm tra batch thiếu
│   │   ├── find_gaps.js                 # Tìm khoảng trống
│   │   ├── find_missing_batches.js      # Tìm batch thiếu
│   │   ├── identify_missing_items.js    # Định danh items thiếu
│   │   ├── process_final_missing_items.js # Xử lý items thiếu cuối
│   │   ├── reprocess_final_missing.js   # Xử lý lại thiếu cuối
│   │   ├── reprocess_missing_items.js   # Xử lý lại items thiếu
│   │   ├── reprocess_missing_parallel.js # Xử lý lại song song
│   │   ├── reprocessErrorBatches.js     # Xử lý lại batch lỗi
│   │   └── split_missing_items.js       # Chia items thiếu
│   ├── 📂 deduplication/                # Khử trùng lặp
│   │   └── deduplicate_items.js         # Khử trùng lặp items
│   └── 📂 testing/                      # Kiểm thử
│       ├── test_api_direct.js           # Test API trực tiếp
│       └── test-refactored.js           # Test sau refactor
├── 📂 config/                           # Cấu hình
│   ├── ecosystem.config.cjs             # Cấu hình PM2 (CommonJS)
│   ├── ecosystem.config.js              # Cấu hình PM2 (ES6)
│   └── ecosystem.missing.config.cjs     # Cấu hình PM2 cho missing
├── 📂 scripts/                          # Shell scripts
│   ├── pm2.sh                          # Script quản lý PM2
│   ├── dictionary_summary.sh           # Tóm tắt từ điển
│   ├── fix_missing_items.sh            # Sửa items thiếu
│   ├── merge-reprocessed.sh            # Gộp dữ liệu xử lý lại
│   ├── merge_complete_dictionary.sh    # Gộp từ điển hoàn chình
│   ├── merge_complete_dictionary_enhanced.sh # Gộp nâng cao
│   ├── process_final_missing.sh        # Xử lý thiếu cuối
│   ├── process_final_simplified.sh     # Xử lý đơn giản cuối
│   ├── reprocess-errors.sh             # Xử lý lại lỗi
│   └── verify-merged-data.sh           # Xác minh dữ liệu gộp
├── 📂 docs/                            # Tài liệu
│   ├── ERROR_REPROCESSING_GUIDE.md     # Hướng dẫn xử lý lỗi
│   ├── ISSUE_ANALYSIS_AND_SOLUTION.md  # Phân tích vấn đề
│   ├── PARALLEL_PROCESSING_README.md   # Xử lý song song
│   ├── README_MERGE_DICTIONARY.md      # Hướng dẫn gộp từ điển
│   └── SOLUTION_SUMMARY.md             # Tóm tắt giải pháp
├── 📂 input/                           # Dữ liệu đầu vào
├── 📂 output/                          # Dữ liệu đầu ra
├── 📂 logs/                            # File log
├── 📂 missing-items/                   # Items thiếu
├── 📂 missing-items-final/             # Items thiếu cuối
├── 📂 missing-items-split/             # Items thiếu đã chia
├── 📂 output-backup-parallel/          # Backup output song song
├── 📂 output-final/                    # Output cuối cùng
├── .env                                # Cấu hình môi trường
├── dict-promt.txt                      # Template prompt
├── deduplication-report.json           # Báo cáo khử trùng
├── parallel-merge-report.json          # Báo cáo gộp song song
└── README.md                           # Tài liệu chính (cũ)
```

## 🎯 Tính năng chính theo từng Module

### 1. 🔧 Core (src/core/)
**Chức năng chính:** Tạo và xử lý từ điển cốt lõi

- **`dictionaryGenerate.js`**: Script chính để tạo từ điển từ API
  - Hỗ trợ xử lý song song với multiple processes
  - Tích hợp với Qwen API để dịch từ Trung sang Việt
  - Quản lý batch processing và error handling

- **`hanviet.js`**: Tích hợp âm Hán Việt vào từ điển
  - Ánh xạ chữ Hán sang âm Hán Việt
  - Thống kê tỷ lệ khớp

### 2. 📊 Analysis (src/analysis/)
**Chức năng chính:** Phân tích và thống kê dữ liệu

- **`analyze_batch_distribution.js`**: Phân tích phân bố batch
- **`analyze_deduplication.js`**: Phân tích tình trạng trùng lặp
- **`checkCoverage.js`**: Kiểm tra độ bao phủ dữ liệu

### 3. 🔄 Merging (src/merging/)
**Chức năng chính:** Gộp và kết hợp dữ liệu

- **`mergeDictionary.js`**: Script chính gộp từ điển
- **`merge_parallel_results.js`**: Gộp kết quả xử lý song song
- **`combine_parallel_results.js`**: Kết hợp các kết quả song song

### 4. 🔍 Missing Items (src/missing-items/)
**Chức năng chính:** Xử lý items và batches bị thiếu

- **`find_missing_batches.js`**: Tìm các batch bị thiếu
- **`reprocess_missing_parallel.js`**: Xử lý lại items thiếu song song
- **`split_missing_items.js`**: Chia nhỏ items thiếu để xử lý

### 5. 🧹 Deduplication (src/deduplication/)
**Chức năng chính:** Khử trùng lặp

- **`deduplicate_items.js`**: Loại bỏ các items trùng lặp

### 6. 🧪 Testing (src/testing/)
**Chức năng chính:** Kiểm thử và validation

- **`test_api_direct.js`**: Test API trực tiếp
- **`test-refactored.js`**: Test sau khi refactor

### 7. ⚙️ Config (config/)
**Chức năng chính:** Cấu hình hệ thống

- **`ecosystem.config.js`**: Cấu hình PM2 cho production
- **`ecosystem.missing.config.cjs`**: Cấu hình PM2 cho xử lý missing

### 8. 📜 Scripts (scripts/)
**Chức năng chính:** Automation scripts

- **`pm2.sh`**: Quản lý PM2 processes
- **`merge_complete_dictionary.sh`**: Script gộp từ điển hoàn chỉnh

## 🚀 Cách sử dụng

### Khởi chạy cơ bản:

```bash
# 1. Tạo từ điển mới
cd src/core
node dictionaryGenerate.js --process-id=1 --total-processes=10

# 2. Gộp kết quả
cd ../merging
node mergeDictionary.js

# 3. Kiểm tra missing items
cd ../missing-items
node find_missing_batches.js

# 4. Xử lý missing items
node reprocess_missing_parallel.js

# 5. Khử trùng lặp
cd ../deduplication
node deduplicate_items.js
```

### Sử dụng PM2 (Production):

```bash
# Khởi động tất cả processes
./scripts/pm2.sh start

# Kiểm tra status
pm2 status

# Xem logs
pm2 logs
```

### Kiểm tra và phân tích:

```bash
# Phân tích batch distribution
cd src/analysis
node analyze_batch_distribution.js

# Kiểm tra coverage
node checkCoverage.js

# Test API
cd ../testing
node test_api_direct.js
```

## 📋 Workflow Chuẩn

### 1. Tạo từ điển mới:
```bash
# Cấu hình .env
cp .env.example .env
# Chỉnh sửa API key và settings

# Chạy generation với multiple processes
./scripts/pm2.sh start-generation
```

### 2. Xử lý kết quả:
```bash
# Tìm missing batches
cd src/missing-items
node find_missing_batches.js

# Xử lý missing items
node reprocess_missing_parallel.js

# Gộp tất cả kết quả
cd ../merging
node merge_parallel_results.js
```

### 3. Làm sạch dữ liệu:
```bash
# Khử trùng lặp
cd src/deduplication
node deduplicate_items.js

# Tích hợp Hán Việt
cd ../core
node hanviet.js input/final-dictionary.json
```

### 4. Validation và báo cáo:
```bash
# Kiểm tra coverage
cd src/analysis
node checkCoverage.js

# Tạo báo cáo cuối
./scripts/dictionary_summary.sh
```

## 🔧 Cấu hình Môi trường

### File .env:
```bash
# API Configuration
DASHSCOPE_API_KEY=your_api_key_here
API_BASE_URL=https://dashscope-intl.aliyuncs.com/compatible-mode/v1

# Processing Configuration
BATCH_SIZE=20
BATCH_DELAY=2000
MAX_RETRIES=3

# Parallel Processing
DEFAULT_TOTAL_PROCESSES=30
DEFAULT_BATCHES_PER_PROCESS=60

# Output Configuration
OUTPUT_DIR=./output
LOG_LEVEL=info
```

## 📊 Monitoring và Logging

### PM2 Monitoring:
```bash
# Xem dashboard
pm2 monit

# Xem logs realtime
pm2 logs --lines 100

# Restart process bị lỗi
pm2 restart ecosystem.config.js
```

### Log Files:
- `logs/generation-*.log`: Logs của quá trình generation
- `logs/merge-*.log`: Logs của quá trình merging
- `logs/error-*.log`: Error logs

## 🛠️ Troubleshooting

### Lỗi thường gặp:

1. **API Rate Limit:**
   - Tăng `BATCH_DELAY` trong .env
   - Giảm số `TOTAL_PROCESSES`

2. **Missing Batches:**
   - Chạy `find_missing_batches.js`
   - Sử dụng `reprocess_missing_parallel.js`

3. **Memory Issues:**
   - Giảm `BATCH_SIZE`
   - Tăng `--max-old-space-size` cho Node.js

4. **PM2 Process Crashed:**
   - Kiểm tra logs: `pm2 logs`
   - Restart: `pm2 restart all`

### Debug Commands:
```bash
# Kiểm tra tình trạng files
ls -la output/ | wc -l

# Kiểm tra file size
du -sh output/

# Test API connectivity
cd src/testing
node test_api_direct.js
```

## 📈 Performance Tips

### Tối ưu hóa:
1. **Parallel Processing**: Sử dụng multiple PM2 processes
2. **Batch Size**: Điều chỉnh dựa trên API limits
3. **Memory Management**: Monitor và restart processes định kỳ
4. **Disk I/O**: Sử dụng SSD cho output directories

### Monitoring:
```bash
# CPU và Memory usage
htop

# Disk usage
df -h

# Network usage
iftop
```

## 🤝 Contributing

### Quy tắc đóng góp:
1. Tạo branch mới cho mỗi feature
2. Tuân thủ coding style hiện tại
3. Thêm tests cho features mới
4. Update documentation

### Code Style:
- Sử dụng ES6 modules
- Comment bằng tiếng Việt cho business logic
- Error handling đầy đủ
- Logging chi tiết

## 📝 Notes

### Migration từ cấu trúc cũ:
- Tất cả scripts đã được di chuyển vào thư mục tương ứng
- Paths cần được update trong scripts
- PM2 configs đã được tách riêng

### Backward Compatibility:
- Các scripts cũ vẫn hoạt động với path updates
- APIs không thay đổi
- Data format consistency

---

**Phiên bản:** 3.0 (Restructured)  
**Cập nhật:** 05/08/2025  
**Tác giả:** Dictionary Team  

*README này mô tả cấu trúc mới sau khi restructure. Tham khảo `docs/` để biết thêm chi tiết về từng component.*
