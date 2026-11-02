# StoreX DevOps Practice - Session 04: Docker Compose Ecosystem

- **Học viên:** NamNT (NamNTHE176286)
- **Repository:** [NamNT2942003/4](https://github.com/NamNT2942003/4)
- **Dự án thực hành:** StoreX Microservices Architecture (Multi-environment, Reverse Proxy, Custom Network, Persistence Volumes, Healthcheck)

---

## Danh mục toàn bộ bài thực hành (Session 04)

| Bài tập | Nội dung | File bàn giao | Minh chứng |
| :--- | :--- | :--- | :--- |
| **Bài tập 1** | Khởi tạo môi trường phát triển cơ bản & Sửa lỗi kết nối mạng (Service Name DNS) | `exercise_01/docker-compose.yml`<br>`README.md` | `evidence_01_error.png`<br>`evidence_02_success.png` |
| **Bài tập 2** | Quản lý dữ liệu bền vững (Volumes) và Dependency với Healthcheck (`service_healthy`) | `exercise_02/docker-compose.yml`<br>`HEALTHCHECK_EXPLANATION.md` | `evidence_01_startup_dependency.png`<br>`evidence_02_data_persistence.png` |
| **Bài tập 3** | Tối ưu hóa biến môi trường (`.env` / `.env.example`) & Cô lập mạng (`storex-net`) | `exercise_03/docker-compose.yml`<br>`exercise_03/.env.example`<br>`.gitignore` | `evidence_01_env_and_network.png`<br>`evidence_02_isolation_and_git.png` |
| **Bài tập 4** | Xây dựng hệ thống Reverse Proxy với Nginx & Định tuyến Microservices qua Docker DNS | `exercise_04/docker-compose.yml`<br>`exercise_04/nginx.conf` | `evidence_01_error_502.png`<br>`evidence_02_success_routing.png` |
| **Bài tập 5** | Thiết kế kiến trúc triển khai Đa môi trường (Multi-environment: Staging vs Production) | `exercise_05/docker-compose.yml`<br>`docker-compose.override.yml`<br>`docker-compose.prod.yml` | `evidence_01_staging.png`<br>`evidence_02_production.png` |

---

## Chi tiết Bài tập 5: Thiết kế kiến trúc triển khai Đa môi trường

### 1. Nguyên tắc thiết kế (DRY & File Override)
- **`docker-compose.yml` (Base):** Khai báo các thuộc tính chung không đổi (image name, base environment, volumes).
- **`docker-compose.override.yml` (Staging):** Tự động nạp khi dev chạy `docker compose up` không tham số. Cấu hình 1 replica, mở port debug `8080` (API) và `5432` (PostgreSQL), `ENV=staging`.
- **`docker-compose.prod.yml` (Production):** Kích hoạt bằng lệnh tường minh. Scale 3 replicas backend, cấu hình `restart: always`, giới hạn tài nguyên `memory: 512M`, `cpus: '0.50'`.

### 2. Lệnh khởi chạy cho từng môi trường

* **Khởi chạy môi trường Staging:**
  ```bash
  docker compose up -d
  # Tự động kết hợp docker-compose.yml + docker-compose.override.yml
  ```

* **Khởi chạy môi trường Production:**
  ```bash
  docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
  # Kết hợp base + production override, bỏ qua staging override
  ```

### 3. Minh chứng thực nghiệm
- **Staging:** `exercise_05/evidence_01_staging.png` (1 replica, port debug mở, `ENV=staging`).
- **Production:** `exercise_05/evidence_02_production.png` (3 replicas, `restart: always`, giới hạn cứng 512MB RAM và 0.5 CPU qua Docker cgroups).

---

## Tham khảo chi tiết các bài tập khác
* **Bài tập 1:** Thư mục [`exercise_01/`](file:///C:/Devop/4/exercise_01/)
* **Bài tập 2:** Thư mục [`exercise_02/`](file:///C:/Devop/4/exercise_02/) & [`HEALTHCHECK_EXPLANATION.md`](file:///C:/Devop/4/HEALTHCHECK_EXPLANATION.md)
* **Bài tập 3:** Thư mục [`exercise_03/`](file:///C:/Devop/4/exercise_03/)
* **Bài tập 4:** Thư mục [`exercise_04/`](file:///C:/Devop/4/exercise_04/)
* **Bài tập 5:** Thư mục [`exercise_05/`](file:///C:/Devop/4/exercise_05/) & [`exercise_05/README.md`](file:///C:/Devop/4/exercise_05/README.md)
