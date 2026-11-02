#!/bin/bash
# Kịch bản triển khai môi trường Production
# Cơ chế: Kết hợp docker-compose.yml (base) và docker-compose.prod.yml (production overrides)

echo "=========================================================="
echo "  Deploying StoreX to PRODUCTION Environment"
echo "  Features: 3 Replicas Backend, Restart Policy Always,"
echo "            Resource Limits (512MB RAM, 0.5 CPU)"
echo "=========================================================="

docker compose -f docker-compose.yml -f docker-compose.prod.yml down 2>/dev/null
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

echo ""
echo "=== Trạng thái các container Production ==="
docker compose -f docker-compose.yml -f docker-compose.prod.yml ps

echo ""
echo "=== Kiểm tra Resource Limits & Restart Policy trên Container ==="
docker inspect exercise_05-backend-1 --format 'Container: {{.Name}} | RestartPolicy: {{.HostConfig.RestartPolicy.Name}} | MemoryLimit: {{.HostConfig.Memory}} bytes | NanoCPUs: {{.HostConfig.NanoCPUs}}'

