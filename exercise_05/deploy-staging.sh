#!/bin/bash
# Kịch bản triển khai môi trường Staging / Dev
# Cơ chế: Docker Compose tự động nạp và hợp nhất docker-compose.yml và docker-compose.override.yml

echo "=========================================================="
echo "  Deploying StoreX to STAGING Environment"
echo "  Features: 1 Replica, Debug Ports (8080 & 5432) Exposed"
echo "=========================================================="

docker compose down 2>/dev/null
docker compose up -d

echo ""
echo "=== Trạng thái các container Staging ==="
docker compose ps

echo ""
echo "=== Kiểm tra Endpoint API Staging ==="
sleep 2
curl -i http://localhost:8080
