# Hướng dẫn Setup và Sử dụng Service Role Key

## � Service Role Key là gì?

Service Role Key là một JWT token đặc biệt có **quyền admin hoàn toàn** trên Supabase database của bạn. Nó:
- Bypass tất cả Row Level Security (RLS) policies
- Có thể đọc/ghi/xóa bất kỳ dữ liệu nào
- Cần thiết cho việc import dữ liệu bulk

## 🚀 Quick Setup (Khuyến nghị)

### Bước 1: Chạy script setup
```bash
cd /home/ght/project/chebichat/cleanData/supabase
npm run setup
```

Script này sẽ:
- Tạo file .env nếu chưa có
- Kiểm tra và validate service role key
- Test quyền đọc/ghi database
- Đưa ra hướng dẫn chi tiết nếu có lỗi

### Bước 2: Lấy Service Role Key

1. **Đi đến Supabase Dashboard:**
   - Truy cập: https://app.supabase.com
   - Đăng nhập và chọn project của bạn

2. **Navigate đến API Settings:**
   - Sidebar: Settings → API
   - Hoặc URL: https://app.supabase.com/project/[your-project-id]/settings/api

3. **Copy Service Role Key:**
   - Tìm section "Project API keys"
   - Copy "service_role" key (key dài ~200+ ký tự, bắt đầu bằng `eyJ`)
   - **KHÔNG PHẢI** "anon public" key

4. **Thêm vào file .env:**
   ```bash
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

### Bước 3: Validate setup
```bash
npm run setup
```

Nếu thành công, bạn sẽ thấy:
```
✅ Quyền đọc OK
✅ Quyền ghi OK  
✅ Test record đã được xóa
🎉 Service Role Key hoạt động hoàn hảo!
```

### Bước 4: Import dữ liệu
```bash
npm run insert
```

## 📋 Scripts có sẵn

```bash
npm run setup        # Validate service role key setup
npm run insert       # Import dữ liệu (cần service role key)
npm run insert-admin # Import với insert_admin.js  
npm run test         # Test database connection
```

### Giải pháp 2: Tắt RLS tạm thời (Không khuyến nghị cho production)

Chạy SQL commands sau trong Supabase SQL Editor:

```sql
-- Tắt RLS cho các bảng chính
ALTER TABLE processing_batches DISABLE ROW LEVEL SECURITY;
ALTER TABLE letters DISABLE ROW LEVEL SECURITY;
ALTER TABLE letter_words DISABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary_frequency DISABLE ROW LEVEL SECURITY;
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE sources DISABLE ROW LEVEL SECURITY;
```

**Sau khi import xong, nhớ bật lại:**
```sql
-- Bật lại RLS
ALTER TABLE processing_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE letters ENABLE ROW LEVEL SECURITY;
ALTER TABLE letter_words ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary_frequency ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE sources ENABLE ROW LEVEL SECURITY;
```

### Giải pháp 3: Tạo RLS Policies cho phép insert

Chạy SQL sau để tạo policies cho phép insert dữ liệu:

```sql
-- Policy cho processing_batches
CREATE POLICY "Allow insert for data import" ON processing_batches
  FOR INSERT WITH CHECK (true);

-- Policy cho letters
CREATE POLICY "Allow insert for data import" ON letters
  FOR INSERT WITH CHECK (true);

-- Policy cho letter_words
CREATE POLICY "Allow insert for data import" ON letter_words
  FOR INSERT WITH CHECK (true);

-- Policy cho vocabulary_frequency
CREATE POLICY "Allow insert for data import" ON vocabulary_frequency
  FOR INSERT WITH CHECK (true);

-- Policy cho categories
CREATE POLICY "Allow insert for data import" ON categories
  FOR INSERT WITH CHECK (true);

-- Policy cho sources
CREATE POLICY "Allow insert for data import" ON sources
  FOR INSERT WITH CHECK (true);
```

## 🚀 Giải pháp cho Punycode Warning

Punycode warning là từ dependencies cũ. Đã được fix bằng cách:

1. **Thêm flags vào package.json:**
   - `--no-deprecation`: Ẩn deprecation warnings
   - `--no-warnings`: Ẩn tất cả warnings

2. **Sử dụng scripts mới:**
   ```bash
   npm run insert-admin    # Không có warnings
   npm run test           # Không có warnings
   ```

## 📋 Các scripts có sẵn

```bash
# Scripts chính (không có warnings)
npm run insert-admin     # Chèn dữ liệu với admin privileges
npm run test            # Test kết nối database

# Scripts với full output (có warnings)
npm run insert-verbose  # Chèn dữ liệu với full logs
npm run test-verbose    # Test với full logs

# Utilities
npm run update-deps     # Cập nhật dependencies
```

## 🔍 Kiểm tra và debug

1. **Test kết nối:**
   ```bash
   npm run test
   ```

2. **Kiểm tra file .env:**
   ```bash
   cat .env
   ```

3. **Chạy với verbose để xem chi tiết lỗi:**
   ```bash
   npm run insert-verbose
   ```

## 📁 Cấu trúc file dữ liệu

Đảm bảo file JSON có cấu trúc đúng:

```json
{
  "metadata": {
    "totalItems": 241,
    "successfulItems": 241,
    "failedItems": 0,
    "summary": {
      "totalWords": 6560,
      "hskDistribution": {...}
    }
  },
  "data": [
    {
      "original": "中文文本",
      "pinyin": "zhōng wén wén běn",
      "vietnamese": "Văn bản tiếng Trung",
      "words": {
        "hsk1": ["词", "汇"],
        "hsk2": ["更多", "词汇"]
      },
      "textStats": {
        "characterCount": 100,
        "wordCount": 50,
        "vocabulary": {
          "词": 2,
          "汇": 1
        }
      }
    }
  ]
}
```

## ⚡ Quick Fix

Nếu muốn fix nhanh và chạy ngay:

1. **Copy service role key vào .env**
2. **Chạy:**
   ```bash
   npm run insert-admin
   ```

Script `insert_admin.js` đã được tối ưu để:
- Bypass RLS với service role key
- Xử lý lỗi tốt hơn
- Hiển thị progress chi tiết
- Tự động retry khi gặp lỗi nhỏ
