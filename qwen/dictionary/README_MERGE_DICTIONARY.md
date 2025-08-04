# Hướng dẫn sử dụng công cụ gộp từ điển (Dictionary Merger)

## Tổng quan

Công cụ này được thiết kế để gộp tất cả các file JSON từ thư mục `./output/` có tên theo mẫu `dict-processed-process-*.json` thành một file từ điển thống nhất, kèm theo việc tích hợp dữ liệu Hán-Việt từ từ điển `tudienhanviet.json`.

## Cấu trúc thư mục

```
dictionary/
├── mergeDictionary.js          # Script chính để gộp từ điển
├── hanviet.js                 # Script tham khảo cho logic Hán-Việt (không sử dụng trực tiếp)
├── input/
│   └── tudienhanviet.json     # Từ điển Hán-Việt
└── output/
    ├── dict-processed-process-1.json    # File đầu vào cần gộp
    ├── dict-processed-process-2.json    # File đầu vào cần gộp
    ├── ...                              # Các file khác theo mẫu
    ├── dictionary-final-merged-*.json   # File kết quả sau khi gộp
    └── merge-summary-final-*.json       # File thống kê chi tiết
```

## Tính năng chính

### 1. Gộp file JSON
- Tự động tìm và gộp tất cả file có tên theo mẫu `dict-processed-process-*.json`
- Loại bỏ các từ trùng lặp dựa trên key `chinese`
- Sắp xếp kết quả theo thứ tự chữ Trung Quốc

### 2. Tích hợp dữ liệu Hán-Việt
- Tự động tra cứu và thêm phiên âm Hán-Việt cho mỗi từ
- Sử dụng từ điển `tudienhanviet.json` làm nguồn dữ liệu
- Báo cáo tỷ lệ khớp Hán-Việt trong kết quả cuối

### 3. Thống kê chi tiết
- Đếm tổng số từ đã xử lý
- Số từ duy nhất sau khi loại bỏ trùng lặp
- Số từ trùng lặp đã loại bỏ
- Tỷ lệ khớp với từ điển Hán-Việt
- Thống kê theo từng file nguồn

## Cách sử dụng

### Bước 1: Chuẩn bị dữ liệu
Đảm bảo có các file sau:
- Các file JSON cần gộp trong thư mục `./output/` với tên theo mẫu `dict-processed-process-*.json`
- File từ điển Hán-Việt tại `./input/tudienhanviet.json`

### Bước 2: Chạy script
```bash
cd /path/to/dictionary/
node mergeDictionary.js
```

### Bước 3: Kiểm tra kết quả
Sau khi chạy thành công, bạn sẽ có:
- File từ điển gộp: `./output/dictionary-final-merged-[timestamp].json`
- File thống kê: `./output/merge-summary-final-[timestamp].json`

## Cấu trúc dữ liệu

### Dữ liệu đầu vào (input)
Mỗi file JSON đầu vào chứa một mảng các object với cấu trúc:
```json
{
  "chinese": "汉字",
  "pinyin": "hàn zì",
  "type": "noun",
  "meaning_vi": "chữ Hán",
  "meaning_en": "Chinese character",
  "example_cn": "这是汉字",
  "example_vi": "Đây là chữ Hán",
  "example_en": "This is Chinese character",
  "grammar": "danh từ",
  "hsk_level": 3,
  "meaning_cn": "汉语文字"
}
```

### Dữ liệu đầu ra (output)
File kết quả có cấu trúc tương tự nhưng được bổ sung trường `hanviet`:
```json
{
  "chinese": "汉字",
  "pinyin": "hàn zì",
  "hanviet": "hán tự",
  "type": "noun",
  "meaning_vi": "chữ Hán",
  "meaning_en": "Chinese character",
  "example_cn": "这是汉字",
  "example_vi": "Đây là chữ Hán",
  "example_en": "This is Chinese character",
  "grammar": "danh từ",
  "hsk_level": 3,
  "meaning_cn": "汉语文字"
}
```

## Thông tin thống kê

Script sẽ tạo ra file thống kê chi tiết bao gồm:
- `totalItemsProcessed`: Tổng số từ đã xử lý
- `uniqueItems`: Số từ duy nhất trong kết quả cuối
- `duplicatesRemoved`: Số từ trùng lặp đã loại bỏ
- `sourceFiles`: Số file nguồn đã xử lý
- `hanvietMatches`: Số từ khớp với từ điển Hán-Việt
- `hanvietMatchPercentage`: Tỷ lệ phần trăm khớp Hán-Việt
- `mergedAt`: Thời gian thực hiện gộp
- `outputFile`: Đường dẫn file kết quả
- `fileBreakdown`: Thống kê theo từng process

## Xử lý lỗi

### Lỗi thường gặp và cách khắc phục:

1. **Không tìm thấy file đầu vào**
   - Kiểm tra các file `dict-processed-process-*.json` có tồn tại trong thư mục `./output/`
   - Đảm bảo tên file đúng theo mẫu

2. **Không tìm thấy từ điển Hán-Việt**
   - Kiểm tra file `tudienhanviet.json` có tồn tại trong thư mục `./input/`
   - Script vẫn sẽ chạy nhưng không có dữ liệu Hán-Việt

3. **Lỗi JSON không hợp lệ**
   - Kiểm tra format JSON của các file đầu vào
   - Script sẽ bỏ qua file có lỗi và tiếp tục với các file khác

## Log và theo dõi

Script cung cấp log chi tiết trong quá trình chạy:
- 🔍 Tìm kiếm file
- 📂 Tải dữ liệu
- 📄 Xử lý từng file
- 🔄 Phát hiện trùng lặp
- ✅ Thống kê từng file
- 📊 Tổng kết cuối cùng

## Lưu ý quan trọng

1. **Độc lập hoàn toàn**: Script không cần tham số dòng lệnh, tự động tìm và xử lý file
2. **An toàn dữ liệu**: Không ghi đè file gốc, tạo file mới với timestamp
3. **Hiệu suất**: Sử dụng Map để đảm bảo hiệu suất tốt với dữ liệu lớn
4. **Tương thích**: Hoạt động với Node.js ES modules

## So sánh với hanviet.js

| Tính năng | mergeDictionary.js | hanviet.js |
|-----------|-------------------|------------|
| Gộp nhiều file | ✅ | ❌ |
| Loại bỏ trùng lặp | ✅ | ❌ |
| Tích hợp Hán-Việt | ✅ | ✅ |
| Cần tham số CLI | ❌ | ✅ |
| Thống kê chi tiết | ✅ | ✅ |
| Tự động tìm file | ✅ | ❌ |

## Hỗ trợ

Nếu gặp vấn đề hoặc cần hỗ trợ, vui lòng:
1. Kiểm tra log chi tiết trong terminal
2. Xem file thống kê để hiểu rõ quá trình xử lý
3. Đảm bảo cấu trúc thư mục và file đúng như mô tả

---

*Phiên bản: 1.0 - Cập nhật: Tháng 7, 2025*
