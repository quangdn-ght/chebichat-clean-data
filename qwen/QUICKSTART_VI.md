# Hướng Dẫn Nhanh - Chinese Text Processor

## Bắt Đầu Nhanh

### 1. Cài Đặt và Chạy Test
```bash
# Di chuyển vào thư mục dự án
cd /home/ght/project/chebichat/cleanData/qwen

# Cài đặt dependencies (nếu chưa có)
npm install

# Chạy test toàn diện
npm test
```

### 2. Test Cases Chính

#### Test 1: Phân Đoạn Văn Bản
- Input: `"别人在熬夜的时候，你在睡觉"`
- Kết quả: `["别人", "熬夜", "时候", "睡觉"]`

#### Test 2: Phân Tích HSK
- Phân loại từ theo cấp độ HSK 1-6
- Hiển thị thống kê phân bố

#### Test 3: Tạo Pinyin
- Sử dụng thư viện `pinyin-pro`
- Kết quả: `"bié rén zài áo yè de shí hòu ， nǐ zài shuì jiào"`

#### Test 4: Hợp Nhất Dữ Liệu
- Kết hợp văn bản Trung + bản dịch Việt
- Tạo file JSON hoàn chỉnh

#### Test 5: Xử Lý File Lớn
- Xử lý 241 items từ `import.json`
- Tạo báo cáo thống kê đầy đủ

### 3. Kết Quả Mong Đợi

```
🧪 Running Chinese Text Processor Tests
=====================================

📝 Test 1: Chinese Text Processing
✅ Chinese text processor initialized
Input: 别人在熬夜的时候，你在睡觉
Words: 别人, 熬夜, 时候, 睡觉
Stats: {
  characterCount: 13,
  wordCount: 4,
  uniqueWordCount: 4,
  averageWordLength: 2
}

🎯 Test 2: HSK Level Analysis
HSK Analysis: {
  hsk1: [ '时候', '睡觉' ],
  hsk2: [ '别人' ],
  hsk5: [ '熬夜' ]
}

🔤 Test 3: Pinyin Generation
Input: 别人在熬夜的时候，你在睡觉
Pinyin: bié rén zài áo yè de shí hòu ， nǐ zài shuì jiào

🔀 Test 4: Data Merger
✅ Processed 1 items

📁 Test 5: Processing import.json
✅ Successfully processed: 241/241 items
📝 Total Chinese words extracted: 6,560
🎯 HSK Distribution:
   HSK1: 424 words (6.5%)
   HSK2: 293 words (4.5%)
   HSK3: 38 words (0.6%)
   HSK4: 165 words (2.5%)
   HSK5: 17 words (0.3%)
   HSK6: 9 words (0.1%)
   OTHER: 5,614 words (85.6%)

✅ All tests completed!
```

### 4. Files Output

Sau khi chạy test, check các file trong `./output/`:
- `test_output.json` - Kết quả test đơn giản
- `import_processed.json` - Kết quả xử lý import.json đầy đủ

### 5. Sử Dụng Riêng Lẻ

```javascript
// Test pinyin riêng
node test_pinyin.js

// Demo workflow
node demo.js

// Xem kết quả
node show_results.js
```

### 6. Troubleshooting

- **Nếu test bị treo**: Sử dụng `Ctrl+C` để dừng
- **Nếu thiếu dependencies**: Chạy `npm install`
- **Nếu lỗi pinyin**: Package sẽ tự động fallback

### 7. Tùy Chỉnh Input

Để test với file riêng, tạo file JSON với format:
```json
[
  {
    "original": "中文文本",
    "vietnamese": "bản dịch tiếng Việt"
  }
]
```

Rồi chạy:
```bash
node -e "
const { DataMerger } = require('./index');
const fs = require('fs').promises;
(async () => {
  const merger = new DataMerger();
  const data = JSON.parse(await fs.readFile('./your-file.json', 'utf8'));
  await merger.processData(data, './output/your-output.json');
})();"
```
