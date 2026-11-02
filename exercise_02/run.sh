#!/bin/bash
# Kịch bản kiểm tra toàn diện Bài tập 2: Healthcheck, Dependency & Volume Persistence

echo "=== 1. Khởi chạy StoreX Stack với Healthcheck ==="
docker compose up -d

echo "=== 2. Kiểm tra trạng thái Healthy của các Container ==="
sleep 6
docker compose ps

echo "=== 3. Kiểm tra log khởi động tuần tự của Backend ==="
docker compose logs backend

echo "=== 4. Tạo bảng và chèn dữ liệu mẫu vào PostgreSQL ==="
docker compose exec -T postgres psql -U admin -d storex_db -c "
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO products (name, price) VALUES 
('Laptop Dell XPS 15', 1850),
('Apple MacBook Pro M3', 2200),
('Sony WH-1000XM5', 380);
SELECT * FROM products;
"

echo "=== 5. Mô phỏng sự cố: Xóa toàn bộ container với docker compose down ==="
docker compose down

echo "=== 6. Khởi chạy lại container mới từ đầu ==="
docker compose up -d
sleep 6

echo "=== 7. Kiểm chứng dữ liệu bền vững qua Volume postgres_data ==="
docker compose exec -T postgres psql -U admin -d storex_db -c "SELECT * FROM products;"
