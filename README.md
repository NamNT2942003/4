# DevOps Practice - Session 04: Docker Compose & Automation Ecosystem

- **Học viên:** NamNT (NamNTHE176286)
- **Repository:** [NamNT2942003/4](https://github.com/NamNT2942003/4)
- **Dự án thực hành:** StoreX & QuickBite Microservices Ecosystem

---

## Danh mục toàn bộ bài thực hành (Session 04)

| Bài tập | Nội dung | File bàn giao | Minh chứng |
| :--- | :--- | :--- | :--- |
| **Bài tập 1** | Khởi tạo môi trường phát triển cơ bản & Sửa lỗi kết nối mạng (Service Name DNS) | `exercise_01/docker-compose.yml`<br>`README.md` | `evidence_01_error.png`<br>`evidence_02_success.png` |
| **Bài tập 2** | Quản lý dữ liệu bền vững (Volumes) và Dependency với Healthcheck (`service_healthy`) | `exercise_02/docker-compose.yml`<br>`HEALTHCHECK_EXPLANATION.md` | `evidence_01_startup_dependency.png`<br>`evidence_02_data_persistence.png` |
| **Bài tập 3** | Tối ưu hóa biến môi trường (`.env` / `.env.example`) & Cô lập mạng (`storex-net`) | `exercise_03/docker-compose.yml`<br>`exercise_03/.env.example`<br>`.gitignore` | `evidence_01_env_and_network.png`<br>`evidence_02_isolation_and_git.png` |
| **Bài tập 4** | Xây dựng hệ thống Reverse Proxy với Nginx & Định tuyến Microservices qua Docker DNS | `exercise_04/docker-compose.yml`<br>`exercise_04/nginx.conf` | `evidence_01_error_502.png`<br>`evidence_02_success_routing.png` |
| **Bài tập 5** | Thiết kế kiến trúc triển khai Đa môi trường (Multi-environment: Staging vs Production) | `exercise_05/docker-compose.yml`<br>`docker-compose.override.yml`<br>`docker-compose.prod.yml` | `evidence_01_staging.png`<br>`evidence_02_production.png` |
| **Bài tập 6** | Kịch bản Shell Script vận hành & Smoke Test tự động (`compose-control.sh`) | `compose-control.sh`<br>`quickbite-project/` | `control_success.png`<br>`control_failure.png` |

---

## Chi tiết Bài tập 6: Kịch bản Shell Script vận hành & Smoke Test (`compose-control.sh`)

### 1. Mục tiêu và cơ chế hoạt động
Vận hành hệ thống QuickBite tại `/quickbite-project/` thông qua kịch bản `compose-control.sh`:
- **`./compose-control.sh start`**:
  - Chạy `docker compose up -d --build`.
  - Vòng lặp thăm dò `pg_isready` mỗi 2 giây (timeout 10 giây).
  - Kiểm tra endpoint `/actuator/health` của backend. Nếu cả hai đều tốt, in dòng chữ màu xanh lá: **`HỆ THỐNG QUICKBITE HOẠT ĐỘNG ỔN ĐỊNH!`** và thoát mã 0.
  - Nếu xảy ra lỗi: In cảnh báo màu đỏ, trích xuất 20 dòng log backend, tự động dọn dẹp môi trường (`docker compose down`) và thoát mã 1.
- **`./compose-control.sh stop`**: Tạm dừng hệ thống (`docker compose stop`).
- **`./compose-control.sh clean`**: Dọn dẹp toàn bộ tài nguyên bao gồm volume (`docker compose down -v`).

### 2. Minh chứng thực nghiệm
- **Luồng thành công:** `control_success.png` (Database sẵn sàng sau 2s, API `/actuator/health` trả về 200 OK, in thông báo xanh lá).
- **Luồng test bẫy lỗi:** `control_failure.png` (Sửa sai mật khẩu trong `.env`, API báo lỗi 503, in log đỏ, in log backend và tự động dọn dẹp).

---

## Chi tiết các bài tập khác
* **Bài tập 1:** Thư mục [`exercise_01/`](file:///C:/Devop/4/exercise_01/)
* **Bài tập 2:** Thư mục [`exercise_02/`](file:///C:/Devop/4/exercise_02/) & [`HEALTHCHECK_EXPLANATION.md`](file:///C:/Devop/4/HEALTHCHECK_EXPLANATION.md)
* **Bài tập 3:** Thư mục [`exercise_03/`](file:///C:/Devop/4/exercise_03/)
* **Bài tập 4:** Thư mục [`exercise_04/`](file:///C:/Devop/4/exercise_04/)
* **Bài tập 5:** Thư mục [`exercise_05/`](file:///C:/Devop/4/exercise_05/) & [`exercise_05/README.md`](file:///C:/Devop/4/exercise_05/README.md)
* **Bài tập 6:** Thư mục [`quickbite-project/`](file:///C:/Devop/4/quickbite-project/) & [`exercise_06/`](file:///C:/Devop/4/exercise_06/)
