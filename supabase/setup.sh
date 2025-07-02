#!/bin/bash

# Script setup nhanh cho Supabase
# Quick setup script for Supabase

echo "🚀 Thiết lập Supabase cho project Chinese Text Learning"
echo "🚀 Setting up Supabase for Chinese Text Learning project"
echo ""

# Kiểm tra file .env
if [ ! -f .env ]; then
    echo "📝 Tạo file .env từ template..."
    cp .env.template .env
    echo "✅ Đã tạo file .env"
else
    echo "✅ File .env đã tồn tại"
fi

echo ""
echo "🔑 QUAN TRỌNG: Bạn cần lấy Service Role Key từ Supabase Dashboard"
echo "🔑 IMPORTANT: You need to get the Service Role Key from Supabase Dashboard"
echo ""
echo "📋 HƯỚNG DẪN / INSTRUCTIONS:"
echo "1. Đi đến Supabase Dashboard: https://app.supabase.com"
echo "2. Chọn project của bạn / Select your project"
echo "3. Đi đến: Settings → API → Project API keys"
echo "4. Copy 'service_role' key (secret key)"
echo "5. Thêm vào file .env:"
echo ""
echo "   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
echo ""

# Kiểm tra các biến môi trường
if grep -q "SUPABASE_URL=https://your-project" .env; then
    echo "⚠️  Cần cập nhật SUPABASE_URL trong file .env"
fi

if grep -q "SUPABASE_ANON_KEY=your-anon-key" .env; then
    echo "⚠️  Cần cập nhật SUPABASE_ANON_KEY trong file .env"
fi

if grep -q "SUPABASE_SERVICE_ROLE_KEY=your-service-role-key" .env; then
    echo "⚠️  Cần cập nhật SUPABASE_SERVICE_ROLE_KEY trong file .env"
fi

echo ""
echo "🧪 Sau khi cập nhật .env, chạy test:"
echo "🧪 After updating .env, run test:"
echo "   npm run test"
echo ""
echo "💾 Để chèn dữ liệu:"
echo "💾 To insert data:"
echo "   npm run insert-admin"
echo ""
echo "📖 Xem thêm trong TROUBLESHOOTING.md"
echo "📖 See more in TROUBLESHOOTING.md"
