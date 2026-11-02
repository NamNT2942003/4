#!/bin/bash
# Kịch bản kiểm tra Bài tập 4: Reverse Proxy Nginx & Microservices Routing

echo "=== 1. Khởi chạy hệ thống Nginx Proxy + User Service + Product Service ==="
docker compose up -d

echo "=== 2. Kiểm tra trạng thái các container ==="
docker compose ps

echo "=== 3. Kiểm tra định tuyến qua Nginx đến User Service (/users/) ==="
curl -i http://localhost/users/

echo "=== 4. Kiểm tra định tuyến qua Nginx đến Product Service (/products/) ==="
curl -i http://localhost/products/

echo "=== 5. Kiểm tra Access Logs của Nginx ==="
docker compose logs nginx_proxy --tail 10
