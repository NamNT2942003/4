# Giải thích cơ chế Healthcheck & Quản lý Volume trong Docker Compose

- **Dự án:** StoreX Ecosystem
- **Học viên:** NamNT (NamNTHE176286)
- **Bài tập 2:** Quản lý dữ liệu (Volumes) và Dependency giữa các container

---

## 1. Vấn đề của cấu hình ban đầu
- **Crash do Race Condition:** Cấu hình `depends_on: [postgres, redis]` mặc định chỉ kiểm tra trạng thái **container đã start (running)** ở cấp độ hệ điều hành. Tuy nhiên, một container ở trạng thái `running` không đồng nghĩa với việc ứng dụng bên trong (PostgreSQL, Redis) đã sẵn sàng phục vụ:
  - PostgreSQL cần 5 - 15 giây để khởi tạo database cluster, chạy bootstrap script, cấp quyền và mở cổng socket tiếp nhận kết nối.
  - Redis cần thời gian load dataset (nếu có) và bind port `6379`.
  - Backend Spring Boot khởi động ngay lập tức và cố gắng kết nối tới DB/Cache -> Gặp lỗi `Connection refused` và crash ngay tức thì.
- **Mất mát dữ liệu (Data Loss):** Không khai báo Volume khiến toàn bộ dữ liệu PostgreSQL được ghi tạm vào writable container layer. Khi thực hiện `docker-compose down`, container bị hủy bỏ đồng nghĩa toàn bộ database bị xóa sạch.

---

## 2. Cơ chế Healthcheck đã áp dụng

Docker Healthcheck cho phép kiểm tra định kỳ tính sẵn sàng thực sự (**Readiness Probe**) của ứng dụng bên trong container bằng câu lệnh kiểm tra chuyên biệt.

### 2.1. Cấu hình Healthcheck cho PostgreSQL
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U admin -d storex_db"]
  interval: 5s
  timeout: 5s
  retries: 5
  start_period: 10s
```
- **`test`**: Sử dụng tiện ích tiêu chuẩn `pg_isready` của PostgreSQL với cờ `-U admin` và `-d storex_db`. Tiện ích này gửi tín hiệu thăm dò đến Unix/TCP socket và chỉ trả về exit code `0` khi server PostgreSQL đã thực sự hoàn tất khởi động và sẵn sàng nhận connection.
- **`interval: 5s`**: Thực hiện kiểm tra lại sau mỗi 5 giây.
- **`timeout: 5s`**: Nếu câu lệnh kiểm tra không phản hồi trong 5 giây thì tính là thất bại.
- **`retries: 5`**: Số lần thử lại tối đa trước khi container bị đánh dấu là `unhealthy`.
- **`start_period: 10s`**: Thời gian ân hạn khởi động (grace period). Trong 10 giây đầu tiên, các lần kiểm tra thất bại sẽ không tính vào số lần `retries`, cho phép database cluster khởi tạo bình thường mà không bị coi là lỗi.

### 2.2. Cấu hình Healthcheck cho Redis
```yaml
healthcheck:
  test: ["CMD", "redis-cli", "ping"]
  interval: 5s
  timeout: 3s
  retries: 5
  start_period: 5s
```
- **`test`**: Dùng `redis-cli ping` gửi lệnh `PING` tới Redis server nội bộ. Khi Redis sẵn sàng, nó trả về `PONG` với exit code `0`.
- **`interval: 5s`**, **`timeout: 3s`**, **`retries: 5`**, **`start_period: 5s`**: Đảm bảo phát hiện trạng thái sẵn sàng của Redis nhanh chóng và tin cậy.

---

## 3. Cơ chế kiểm soát thứ tự khởi động với `depends_on: condition: service_healthy`

```yaml
backend:
  image: storex-backend:v2
  ports:
    - "8080:8080"
  depends_on:
    postgres:
      condition: service_healthy
    redis:
      condition: service_healthy
```

- Thay vì khởi động Backend ngay khi container `postgres` và `redis` vừa bật, Docker Compose sẽ giữ container `backend` ở trạng thái chờ.
- Docker Compose theo dõi kết quả healthcheck của cả hai container phụ thuộc. Chỉ khi cả `postgres` và `redis` chuyển sang trạng thái **`healthy`**, container `backend` mới được phép khởi động.
- Điều này loại bỏ hoàn toàn hiện tượng race condition và đảm bảo backend luôn kết nối thành công ngay trong lần thử đầu tiên.

---

## 4. Cơ chế lưu trữ bền vững với Named Volumes

```yaml
services:
  postgres:
    ...
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
    driver: local
```

- **Tách biệt vòng đời dữ liệu:** Thư mục `/var/lib/postgresql/data` (nơi PostgreSQL lưu trữ table, index, WAL logs) được ánh xạ trực tiếp vào Named Volume `postgres_data` do Docker daemon quản lý trên máy host.
- **Bền vững qua các chu kỳ tái tạo:** Khi chạy lệnh `docker compose down`, các container bị xóa nhưng Named Volume `postgres_data` vẫn được giữ nguyên vẹn.
- Khi chạy lệnh `docker compose up -d`, container `postgres` mới được gắn lại volume `postgres_data` cũ và khôi phục toàn bộ bảng cũng như dữ liệu đã ghi trước đó.
