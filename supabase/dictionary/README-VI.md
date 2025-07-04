Dưới đây là bản viết lại hoàn chỉnh và chuyên nghiệp của tài liệu `README.md` bằng tiếng Việt, dành cho **Bộ công cụ nhập dữ liệu từ điển Hán-Việt vào Supabase**:

---

# 🈷️ Bộ Công Cụ Nhập Từ Điển Hán - Việt vào Supabase

Giải pháp toàn diện giúp xử lý, xác thực và nhập dữ liệu từ điển Hán-Việt vào Supabase với hiệu suất cao, quản lý vai trò người dùng và cấu hình môi trường linh hoạt.

---

## ⚡ Thiết Lập Nhanh

### 1. Cài đặt các phụ thuộc:

```bash
npm install
```

### 2. Khởi tạo môi trường:

```bash
npm run setup   # Tạo file .env mẫu
nano .env       # Cập nhật thông tin dự án Supabase của bạn
```

### 3. Sinh dữ liệu SQL từ các file JSON:

```bash
npm run import:bulk   # Xử lý toàn bộ file trong thư mục ./import/
```

### 4. Triển khai toàn bộ hệ thống lên Supabase:

```bash
npm run deploy   # Nhập dữ liệu + thiết lập quyền truy cập
```

---

## 🔐 Cấu Hình Môi Trường (.env)

Tạo file `.env` và khai báo các thông tin sau:

```dotenv
# Dành cho script Node.js deploy-node.js
SUPABASE_PROJECT_ID=your-project-id
SUPABASE_DB_PASSWORD=your-database-password

# Dành cho client JavaScript (insert_dict_data.js)
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
SUPABASE_ANON_KEY=your-anon-key
```

### Hướng dẫn lấy thông tin:

1. Truy cập [Supabase Dashboard](https://app.supabase.com)
2. Chọn dự án của bạn
3. Vào mục **Settings → API**:

   * `SUPABASE_URL`: URL của dự án
   * `SUPABASE_ANON_KEY`: Khóa public (dùng trong client)
   * `SUPABASE_SERVICE_ROLE_KEY`: Khóa nội bộ dùng server-side (cần bảo mật)
4. Vào **Settings → Database**:

   * `SUPABASE_PROJECT_ID`: Có thể lấy từ URL hoặc tên host
   * `SUPABASE_DB_PASSWORD`: Do bạn đặt khi tạo dự án

---

## 📦 Cách Sử Dụng

### Nhập một file cụ thể:

```bash
node dictionayImport.js your_data.json
```

### Một số ví dụ nâng cao:

```bash
# Kiểm thử dữ liệu mẫu
node dictionayImport.js test_data.json

# Nhập dữ liệu từ Qwen đã xử lý
node dictionayImport.js ../qwen/dictionary/output/dict-processed-process-1.json

# Hiển thị hướng dẫn sử dụng
node dictionayImport.js
```

### Nhập dữ liệu vào cơ sở dữ liệu:

```bash
# Sau khi có file SQL
psql -d your_database -f output/dictionary_insert.sql

# Hoặc sử dụng chuỗi kết nối:
psql "postgresql://user:pass@host:port/dbname" -f output/dictionary_insert.sql
```

---

## ✅ Xác Thực & Chuẩn Hóa Dữ Liệu

Hệ thống kiểm tra:

* Trường bắt buộc: `chinese`, `pinyin`, `meanings`, `examples`
* Kiểu dữ liệu hợp lệ, không trống
* Giới hạn độ dài phù hợp
* Chuẩn hóa loại từ

### Các loại từ được hỗ trợ:

* `danh từ` (noun)
* `động từ` (verb)
* `tính từ` (adjective)
* `trạng từ` (adverb)
* `đại từ` (pronoun)
* `giới từ` (preposition)
* `liên từ` (conjunction)
* `thán từ` (interjection)
* `số từ` (numeral)
* `lượng từ` (classifier)
* `phó từ` (adverb)
* `other` (mặc định nếu không nhận diện được)

---

## 🚀 Tối Ưu Hiệu Suất

### Nhập liệu:

* Nhập theo từng **batch 1000 bản ghi** (tuỳ chỉnh được)
* Gói toàn bộ trong một **transaction**
* Dùng **streaming** để xử lý file lớn mà không làm đầy bộ nhớ

### Cơ sở dữ liệu:

* **GIN Index**: hỗ trợ tìm kiếm fuzzy (gần đúng)
* **Chỉ mục tổ hợp**: phục vụ các truy vấn phổ biến
* **tsvector**: tích hợp tìm kiếm full-text

### Truy vấn nâng cao:

* Tìm kiếm hỗ trợ tiếng Việt có dấu/không dấu
* Tự động xếp hạng kết quả theo mức độ tương đồng

---

## 📊 Thống Kê & Giám Sát

### Các bảng thống kê tích hợp:

```sql
-- Thống kê tổng quan
SELECT * FROM dictionary_stats;

-- Hiệu năng xử lý
SELECT * FROM dictionary_performance_stats;
```

### Các hàm tìm kiếm nâng cao:

```sql
-- Tìm kiếm theo tiếng Việt
SELECT * FROM search_dictionary_vietnamese('yêu thương') LIMIT 10;

-- Tìm kiếm theo tiếng Trung
SELECT * FROM search_dictionary_chinese('爱') LIMIT 10;
```

---

## 🗂️ Cấu Trúc Thư Mục

```
dictionary/
├── dictionayImport.js          # Script xử lý chính
├── test_data.json              # Dữ liệu mẫu
├── package.json                # Cấu hình Node.js
├── README.md                   # Tài liệu này
├── output/                     # Thư mục chứa file xuất
│   ├── dictionary_insert.sql   # File SQL nhập dữ liệu
│   └── import_log.txt          # Log lỗi xác thực
└── ../db/
    └── dictionary_schema.sql   # Cấu trúc bảng trong PostgreSQL
```

---

## 🛠️ Xử Lý Lỗi Phổ Biến

| Vấn đề                          | Giải pháp                                                |
| ------------------------------- | -------------------------------------------------------- |
| **`pseudo-type anyarray`**      | Đã cập nhật schema để ép kiểu `most_common_vals`         |
| **`enum value does not exist`** | Kiểm tra lại loại từ, fallback về `'other'`              |
| **`JSON parse error`**          | Xác thực file JSON bằng `jq` hoặc validator online       |
| **Out of memory khi import**    | Giảm kích thước batch, chia nhỏ file, tăng RAM hoặc swap |

---

## ⏱️ Tối Ưu Tốc Độ

### Khi nhập dữ liệu:

* Tăng `work_mem`, `maintenance_work_mem` trong cấu hình PostgreSQL
* Dùng ổ cứng SSD
* Tạm tắt các trigger nếu không cần
* Cân nhắc sử dụng `COPY` thay vì `INSERT` khi dữ liệu quá lớn

### Khi tìm kiếm chậm:

* Đảm bảo index đã được tạo
* Chạy `ANALYZE dictionary;`
* Kiểm tra truy vấn bằng `EXPLAIN ANALYZE`

---

## 📋 Ví Dụ Kết Quả

```
🚀 Bắt đầu import từ điển...
📖 Đọc file: test_data.json
📊 Tổng số từ: 12000
🔍 Đang xác thực dữ liệu...
✅ Hợp lệ: 11950
❌ Không hợp lệ: 50
🔧 Đang sinh câu lệnh SQL...
📦 Xử lý 11950 bản ghi trong 12 batch
✓ Batch 1/12 (1000 bản ghi)
...
✓ Batch 12/12 (950 bản ghi)
✅ Hoàn tất. File xuất: output/dictionary_insert.sql
📈 Kích thước file: 12.45 MB

📊 Tóm tắt:
   Tổng số từ: 12000  
   Bản ghi hợp lệ: 11950  
   Bản ghi lỗi: 50  
   Lỗi xác thực: 127  
   Số batch SQL: 12  
   Tỉ lệ thành công: 99.6%
```

---

## 🔮 Định Hướng Phát Triển

* [ ] Hỗ trợ định dạng CSV
* [ ] Nhập liệu dạng incremental (không ghi đè)
* [ ] Tích hợp file phát âm/audio
* [ ] Phân loại theo trình độ HSK
* [ ] Xây dựng API cho nhập dữ liệu thời gian thực
* [ ] Đóng gói toàn bộ bằng Docker

---

## 📜 Giấy Phép

**MIT License** – Tự do sử dụng, chỉnh sửa và phân phối. Vui lòng tham khảo file `LICENSE`.

---

## 🤝 Đóng Góp Phát Triển

1. Fork repository
2. Tạo nhánh tính năng (`feature/your-feature`)
3. Viết code và test với dữ liệu mẫu
4. Gửi pull request

Nếu có câu hỏi hoặc gặp lỗi, hãy tạo [Issue trên GitHub](#).

---

Nếu bạn cần hỗ trợ triển khai thực tế, tích hợp API, hoặc mở rộng thêm các tính năng nâng cao, cứ nhắn thêm nhé!
