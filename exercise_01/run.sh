#!/bin/bash
# Script kiểm tra giải pháp Docker Compose cho StoreX

echo "=== 1. Dọn dẹp môi trường cũ ==="
docker compose down -v 2>/dev/null

echo "=== 2. Khởi chạy StoreX Stack (Backend + Postgres) ==="
docker compose up -d

echo "=== 3. Chờ dịch vụ khởi động và kiểm tra trạng thái ==="
sleep 5
docker compose ps

echo "=== 4. Kiểm tra Logs kết nối Backend -> PostgreSQL ==="
docker compose logs backend

echo "=== 5. Kiểm thử Endpoint API Backend ==="
curl -i http://localhost:8080
