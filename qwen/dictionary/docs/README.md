# Công cụ Gộp Từ điển và Tích hợp Hán Việt

## Tổng quan

Dự án này cung cấp các công cụ để gộp dữ liệu từ điển tiếng Trung và tích hợp thông tin Hán Việt, hỗ trợ xử lý dữ liệu từ điển quy mô lớn với khả năng loại bỏ trùng lặp và thống kê chi tiết.

## Cấu trúc File

```
dictionary/
├── mergeDictionary.js          # Script chính để gộp từ điển
├── hanviet.js                  # Script tích hợp Hán Việt cho file đơn lẻ
├── input/
│   ├── tudienhanviet.json      # Từ điển Hán Việt
│   ├── dict-full.json          # Từ điển đầy đủ
│   └── hsk-complete.json       # Dữ liệu HSK
├── output/                     # Thư mục chứa file kết quả
└── README.md                   # File hướng dẫn này
```

## Tính năng chính

### 1. Script gộp từ điển chính (`mergeDictionary.js`)

**Chức năng:**
- ✅ Gộp tất cả file JSON có pattern `dict-processed-process-*.json`
- ✅ Tích hợp dữ liệu Hán Việt từ `tudienhanviet.json`
- ✅ Loại bỏ trùng lặp dựa trên khóa `chinese`
- ✅ Sắp xếp theo thứ tự chữ Hán
- ✅ Thống kê chi tiết và báo cáo
- ✅ Xuất file kết quả với timestamp

**Cách sử dụng:**
```bash
node mergeDictionary.js
```

**Kết quả:**
- File kết quả: `dictionary-final-merged-YYYY-MM-DDTHH-mm-ss-sssZ.json`
- File thống kê: `merge-summary-final-YYYY-MM-DDTHH-mm-ss-sssZ.json`

### 2. Script tích hợp Hán Việt (`hanviet.js`)

**Chức năng:**
- ✅ Tích hợp dữ liệu Hán Việt vào file JSON đơn lẻ
- ✅ Thống kê tỷ lệ khớp Hán Việt
- ✅ Báo cáo chi tiết quá trình xử lý

**Cách sử dụng:**
```bash
node hanviet.js <input-file.json>
```

**Ví dụ:**
```bash
node hanviet.js input/dict-full.json
```

**Kết quả:**
- File đầu ra: `<input-file>_with_hanviet.json`

## Cấu trúc dữ liệu

### Dữ liệu đầu vào
File JSON phải có cấu trúc:
```json
[
  {
    "chinese": "你好",
    "pinyin": "nǐ hǎo",
    "type": "phrase",
    "meaning_vi": "xin chào",
    "meaning_en": "hello",
    "example_cn": "你好，很高兴见到你。",
    "example_vi": "Xin chào, rất vui được gặp bạn.",
    "example_en": "Hello, nice to meet you.",
    "grammar": "greeting",
    "hsk_level": 1,
    "meaning_cn": "问候语"
  }
]
```

### Dữ liệu đầu ra (sau khi tích hợp Hán Việt)
```json
[
  {
    "chinese": "你好",
    "pinyin": "nǐ hǎo",
    "hanviet": "nể hảo",
    "type": "phrase",
    "meaning_vi": "xin chào",
    "meaning_en": "hello",
    "example_cn": "你好，很高兴见到你。",
    "example_vi": "Xin chào, rất vui được gặp bạn.",
    "example_en": "Hello, nice to meet you.",
    "grammar": "greeting",
    "hsk_level": 1,
    "meaning_cn": "问候语"
  }
]
```

## Từ điển Hán Việt

File `input/tudienhanviet.json` chứa ánh xạ từ chữ Hán sang âm Hán Việt:
```json
{
  "你": "nể",
  "好": "hảo",
  "世界": "thế giới",
  "学习": "học tập"
}
```

## Thống kê và Báo cáo

### Thông tin hiển thị trong quá trình xử lý:
- 📊 Số lượng file tìm thấy
- 📄 Tiến độ xử lý từng file
- 🔄 Phát hiện và loại bỏ trùng lặp
- ✅ Số lượng khớp Hán Việt
- 📈 Tỷ lệ phần trăm khớp

### File thống kê chi tiết (`merge-summary-final-*.json`):
```json
{
  "totalItemsProcessed": 150000,
  "uniqueItems": 145000,
  "duplicatesRemoved": 5000,
  "sourceFiles": 8,
  "hanvietMatches": 120000,
  "hanvietMatchPercentage": 82.8,
  "mergedAt": "2025-07-27T10:30:45.123Z",
  "outputFile": "dictionary-final-merged-2025-07-27T10-30-45-123Z.json",
  "sourceFilePattern": "dict-processed-process-*.json",
  "hanvietDictionaryUsed": true,
  "fileBreakdown": {
    "process_1": 3,
    "process_2": 2,
    "process_7": 3
  }
}
```

## Xử lý lỗi

### Lỗi thường gặp và cách khắc phục:

1. **File không tìm thấy:**
   ```
   ❌ No dict-processed-process-*.json files found to merge
   ```
   - Kiểm tra thư mục `output/` có chứa file đúng pattern
   - Đảm bảo tên file theo format: `dict-processed-process-[số].json`

2. **Lỗi JSON không hợp lệ:**
   ```
   ❌ Error reading file: Unexpected token
   ```
   - Kiểm tra cú pháp JSON trong file đầu vào
   - Sử dụng công cụ validate JSON

3. **Thiếu từ điển Hán Việt:**
   ```
   ⚠️ Warning: Could not load Han-Viet dictionary
   ```
   - Kiểm tra file `input/tudienhanviet.json` có tồn tại
   - Script sẽ tiếp tục chạy nhưng không có dữ liệu Hán Việt

## Tối ưu hóa hiệu suất

### Đối với file lớn:
- Script tự động hiển thị tiến độ mỗi 10,000 mục
- Sử dụng Map để tối ưu tìm kiếm trùng lặp (O(1))
- Xử lý từng file một để tiết kiệm bộ nhớ

### Khuyến nghị:
- RAM tối thiểu: 4GB cho ~100,000 mục từ
- Dung lượng ổ cứng: Dự trữ ít nhất 3x kích thước dữ liệu đầu vào

## Ví dụ sử dụng hoàn chỉnh

### 1. Chuẩn bị dữ liệu:
```bash
# Đảm bảo có file pattern đúng trong thư mục output/
ls output/dict-processed-process-*.json

# Kiểm tra từ điển Hán Việt
ls input/tudienhanviet.json
```

### 2. Chạy script gộp:
```bash
node mergeDictionary.js
```

### 3. Kiểm tra kết quả:
```bash
# Xem file kết quả
ls output/dictionary-final-merged-*.json

# Xem thống kê
cat output/merge-summary-final-*.json
```

### 4. (Tùy chọn) Tích hợp Hán Việt cho file đơn lẻ:
```bash
node hanviet.js input/dict-full.json
```

## Ghi chú kỹ thuật

### Thuật toán loại bỏ trùng lặp:
- Sử dụng Map với key là `item.chinese`
- Giữ lại mục đầu tiên, bỏ qua các mục trùng lặp sau
- Log chi tiết các trùng lặp được phát hiện

### Tích hợp Hán Việt:
- Tìm kiếm trực tiếp trong từ điển: `hanvietDict[chinese]`
- Nếu không tìm thấy, set `hanviet: null`
- Thống kê tỷ lệ khớp cho báo cáo

### Sắp xếp kết quả:
- Sử dụng `localeCompare` với locale 'zh-CN'
- Đảm bảo thứ tự chữ Hán chuẩn

## Hỗ trợ và Đóng góp

### Báo lỗi:
- Mô tả chi tiết lỗi và log console
- Cung cấp mẫu dữ liệu đầu vào (nếu có thể)

### Đóng góp:
- Fork repository và tạo pull request
- Tuân thủ coding style hiện tại
- Thêm test case cho tính năng mới

## Phiên bản và Cập nhật

**Phiên bản hiện tại:** 2.0  
**Cập nhật lần cuối:** 27/07/2025

### Changelog:
- **v2.0:** Tích hợp Hán Việt, loại bỏ trùng lặp, thống kê chi tiết
- **v1.0:** Gộp file JSON cơ bản

---

*README này được viết bằng tiếng Việt để hỗ trợ team phát triển địa phương. Nếu cần hỗ trợ, vui lòng liên hệ team phát triển.*
