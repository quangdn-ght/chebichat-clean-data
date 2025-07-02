# Bộ Xử Lý Văn Bản Tiếng Trung

Một package Node.js toàn diện để xử lý văn bản tiếng Trung và phân tích mức độ từ vựng HSK. Package này cung cấp các công cụ để phân đoạn văn bản, phân tích cấp độ HSK, tạo chú âm pinyin và hợp nhất dữ liệu.

## Tính Năng

- 🔤 **Phân Đoạn Văn Bản Tiếng Trung**: Xử lý văn bản nâng cao với nodejieba
- 🎯 **Phân Tích Cấp Độ HSK**: Phân loại từ vựng theo các cấp độ HSK (1-6)
- 📝 **Tạo Chú Âm Pinyin**: Sử dụng thư viện pinyin-pro để tạo chú âm chính xác
- 🔀 **Hợp Nhất Dữ Liệu**: Kết hợp dataset với bản dịch tiếng Việt
- 📊 **Thống Kê**: Phân tích và báo cáo toàn diện
- 🏗️ **Kiến Trúc Module**: Các thành phần tái sử dụng dễ bảo trì

## Cài Đặt

```bash
# Cài đặt các dependencies
npm install

# Hoặc cài đặt thủ công
npm install nodejieba pinyin-pro
```

## Cấu Trúc Thư Mục

```
qwen/
├── src/                          # Mã nguồn chính
│   ├── ChineseTextProcessor.js   # Xử lý và phân đoạn văn bản tiếng Trung
│   ├── HSKAnalyzer.js           # Phân tích cấp độ HSK
│   ├── PinyinGenerator.js       # Tạo chú âm pinyin
│   └── DataMerger.js            # Hợp nhất và xử lý dữ liệu
├── output/                       # Thư mục chứa kết quả
├── lib/                         # Thư viện từ điển HSK
├── app.js                       # Ứng dụng chính
├── test.js                      # File test toàn diện
├── index.js                     # Entry point
├── package.json                 # Cấu hình package
├── import.json                  # Dữ liệu mẫu để test
└── README.md                    # Tài liệu này
```

## Hướng Dẫn Sử Dụng

### 1. Chạy Ứng Dụng Chính

```bash
# Chạy ứng dụng chính
npm start
# hoặc
node app.js
```

Lệnh này sẽ xử lý file `result.json` và xuất kết quả ra `./output/step6_hsk_analysis.json`

### 2. Chạy Test Toàn Diện

```bash
# Chạy tất cả các test
npm test
# hoặc
node test.js
```

### 3. Các Test Case Chi Tiết

#### Test 1: Xử Lý Văn Bản Tiếng Trung
- **Mục đích**: Kiểm tra khả năng phân đoạn văn bản tiếng Trung
- **Input**: `"别人在熬夜的时候，你在睡觉"`
- **Output**: Danh sách từ được phân đoạn và thống kê

```javascript
const processor = new ChineseTextProcessor();
const words = processor.segmentText(sampleText);
const stats = processor.getTextStatistics(sampleText);
```

#### Test 2: Phân Tích Cấp Độ HSK
- **Mục đích**: Phân loại từ vựng theo cấp độ HSK 1-6
- **Input**: Danh sách từ đã phân đoạn
- **Output**: Từ vựng được nhóm theo cấp độ HSK

```javascript
const hskAnalyzer = new HSKAnalyzer();
const hskResult = hskAnalyzer.analyzeWords(words);
const statistics = hskAnalyzer.getStatistics(hskResult);
```

**Kết quả mẫu:**
```json
{
  "hsk1": ["时候", "睡觉"],
  "hsk2": ["别人"],
  "hsk3": [],
  "hsk4": [],
  "hsk5": ["熬夜"],
  "hsk6": [],
  "other": []
}
```

#### Test 3: Tạo Chú Âm Pinyin
- **Mục đích**: Tạo chú âm pinyin chính xác bằng thư viện pinyin-pro
- **Input**: Văn bản tiếng Trung
- **Output**: Chú âm pinyin với dấu thanh

```javascript
const pinyinGenerator = new PinyinGenerator();
const pinyin = pinyinGenerator.generatePinyin(sampleText);
```

**Kết quả mẫu:**
```
Input:  别人在熬夜的时候，你在睡觉
Pinyin: bié rén zài áo yè de shí hòu ， nǐ zài shuì jiào
```

#### Test 4: Hợp Nhất Dữ Liệu
- **Mục đích**: Kết hợp văn bản tiếng Trung với bản dịch tiếng Việt
- **Input**: Dữ liệu JSON chứa bản gốc và bản dịch
- **Output**: File JSON hoàn chỉnh với HSK levels và pinyin

#### Test 5: Xử Lý File import.json
- **Mục đích**: Xử lý toàn bộ dataset từ file import.json
- **Input**: 241 items từ import.json
- **Output**: File đầy đủ với phân tích HSK và pinyin

### 4. Định Dạng Dữ Liệu

#### Định Dạng Input
```json
[
  {
    "original": "别人在熬夜的时候，你在睡觉；别人已经起床，你还在挣扎再多睡几分钟。",
    "vietnamese": "Khi người khác đang thức khuya, bạn lại đi ngủ; khi người khác đã thức dậy, bạn vẫn cố gắng nán lại thêm vài phút."
  }
]
```

#### Định Dạng Output
```json
{
  "original": "别人在熬夜的时候，你在睡觉...",
  "words": {
    "hsk1": ["在", "的", "时候", "你", "睡觉"],
    "hsk2": ["别人", "已经", "还", "但"],
    "hsk3": ["该", "手机", "加班"],
    "hsk4": ["却", "坚持到底", "连"],
    "hsk5": ["熬夜", "挣扎"],
    "hsk6": ["碌碌无为"],
    "other": ["起床", "再", "多"]
  },
  "pinyin": "bié rén zài áo yè de shí hòu...",
  "vietnamese": "Khi người khác đang thức khuya...",
  "category": "life",
  "source": "999 letters to yourself",
  "statistics": {
    "total": 48,
    "byLevel": {
      "hsk1": 4,
      "hsk2": 10,
      "hsk3": 5,
      "hsk4": 6,
      "hsk5": 2,
      "hsk6": 1,
      "other": 20
    }
  }
}
```

### 5. Kết Quả Xử Lý Mẫu

Khi xử lý file `import.json` (241 items), package đã thành công:

- ✅ **Xử lý**: 241/241 items (100% thành công)
- 📝 **Tổng từ vựng**: 6,560 từ tiếng Trung
- 🎯 **Phân bố HSK**:
  - HSK1: 424 từ (6.5%)
  - HSK2: 293 từ (4.5%)
  - HSK3: 38 từ (0.6%)
  - HSK4: 165 từ (2.5%)
  - HSK5: 17 từ (0.3%)
  - HSK6: 9 từ (0.1%)
  - Khác: 5,614 từ (85.6%)

### 6. Sử Dụng Programmatic

#### Sử Dụng Cơ Bản
```javascript
const { DataMerger } = require('./index');

const processor = new DataMerger({
  defaultCategory: 'life',
  defaultSource: '999 letters to yourself',
  includeStatistics: true
});

// Xử lý dữ liệu
await processor.processData('./input.json', './output/result.json');
```

#### Sử Dụng Từng Component

**ChineseTextProcessor - Xử lý văn bản**
```javascript
const { ChineseTextProcessor } = require('./index');
const processor = new ChineseTextProcessor();
const words = processor.segmentText('中文文本');
const stats = processor.getTextStatistics('中文文本');
```

**HSKAnalyzer - Phân tích HSK**
```javascript
const { HSKAnalyzer } = require('./index');
const analyzer = new HSKAnalyzer();
const analysis = analyzer.analyzeWords(['你好', '世界']);
const statistics = analyzer.getStatistics(analysis);
```

**PinyinGenerator - Tạo pinyin**
```javascript
const { PinyinGenerator } = require('./index');
const generator = new PinyinGenerator();
const pinyin = generator.generatePinyin('你好世界');
```

### 7. Xử Lý File Tùy Chỉnh

Bạn có thể xử lý bất kỳ file JSON nào có cấu trúc tương tự:

```bash
# Ví dụ: Xử lý file custom.json
node -e "
const { DataMerger } = require('./index');
const fs = require('fs').promises;
(async () => {
  const merger = new DataMerger();
  const data = JSON.parse(await fs.readFile('./custom.json', 'utf8'));
  await merger.processData(data, './output/custom_output.json');
})();"
```

### 8. Scripts Có Sẵn

```bash
# Chạy ứng dụng chính
npm start

# Chạy test toàn diện
npm test

# Test riêng pinyin
node test_pinyin.js

# Demo workflow hoàn chỉnh
node demo.js

# Xem kết quả xử lý
node show_results.js
```

### 9. Lỗi Thường Gặp và Cách Khắc Phục

#### Lỗi: "HSK data file not found"
- **Nguyên nhân**: Không tìm thấy file từ điển HSK
- **Khắc phục**: Package sẽ tự động sử dụng phương pháp dự phòng

#### Lỗi: "Pinyin-pro failed"
- **Nguyên nhân**: Thư viện pinyin-pro gặp sự cố
- **Khắc phục**: Package sẽ tự động chuyển sang phương pháp dự phòng

#### Lỗi: File input không đúng định dạng
- **Nguyên nhân**: File JSON không có cấu trúc đúng
- **Khắc phục**: Đảm bảo file có định dạng:
```json
[
  {
    "original": "text in Chinese",
    "vietnamese": "bản dịch tiếng Việt"
  }
]
```

### 10. Dependencies

- **nodejieba**: Phân đoạn văn bản tiếng Trung
- **pinyin-pro**: Tạo chú âm pinyin chính xác
- **fs**: Thao tác với file system
- **path**: Xử lý đường dẫn

### 11. Tính Năng Nâng Cao

#### Tùy Chỉnh DataMerger
```javascript
const merger = new DataMerger({
  defaultCategory: 'custom',     // Danh mục mặc định
  defaultSource: 'my-source',    // Nguồn mặc định
  outputFormat: 'json',          // Định dạng output
  includeStatistics: true       // Bao gồm thống kê
});
```

#### Lọc Kết Quả Theo HSK Level
```javascript
const hskAnalyzer = new HSKAnalyzer();
const result = hskAnalyzer.analyzeWords(words);

// Chỉ lấy từ HSK 1-3
const basicWords = [...result.hsk1, ...result.hsk2, ...result.hsk3];

// Thống kê coverage
const stats = hskAnalyzer.getStatistics(result);
console.log(`HSK1 coverage: ${stats.coverage.hsk1}%`);
```

### 12. Kết Luận

Package Chinese Text Processor cung cấp một giải pháp hoàn chỉnh để:
- Xử lý và phân tích văn bản tiếng Trung
- Tạo chú âm pinyin chính xác
- Phân loại từ vựng theo cấp độ HSK
- Hợp nhất với bản dịch tiếng Việt
- Tạo báo cáo thống kê chi tiết

Sử dụng package này để xây dựng các ứng dụng học tiếng Trung, phân tích văn bản hoặc tạo tài liệu học tập có cấu trúc.

## License

MIT

---

*Tài liệu được cập nhật lần cuối: 30/06/2025*
