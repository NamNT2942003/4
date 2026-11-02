#!/bin/bash
# Kịch bản kiểm tra Bài tập 3: Biến môi trường (.env) và Cô lập mạng (storex-net)

echo "=== 1. Chuẩn bị file .env từ .env.example (nếu chưa có) ==="
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Đã tạo .env từ template."
fi

echo "=== 2. Khởi chạy StoreX Stack trên Custom Network storex-net ==="
docker compose up -d

echo "=== 3. Kiểm tra trạng thái container và Port Mapping ==="
docker compose ps

echo "=== 4. Kiểm tra Logs Backend đọc biến môi trường từ .env ==="
docker compose logs backend

echo "=== 5. Kiểm tra Subnet và các Container gắn vào storex-net ==="
docker network inspect exercise_03_storex-net 2>/dev/null || docker network inspect storex-net

echo "=== 6. Kiểm tra Endpoint Backend từ máy Host (Port 8080) ==="
curl -i http://localhost:8080

echo "=== 7. Kiểm tra truy cập Database từ máy Host (Port 5432 - Phải bị chặn) ==="
nc -zv 127.0.0.1 5432 2>&1 || echo "Port 5432 bị chặn thành công! Database đã được cô lập an toàn."

