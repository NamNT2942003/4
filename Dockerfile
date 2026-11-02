# ==============================================================================
# Dockerfile - Đóng gói ứng dụng QuickBite Java Backend
# Base Image: eclipse-temurin:17-jre-alpine (Tối ưu kích thước & bảo mật)
# ==============================================================================
FROM eclipse-temurin:17-jre-alpine

# Thiết lập thư mục làm việc mặc định
WORKDIR /app

# Sao chép file .jar được sinh ra từ lệnh ./gradlew clean bootJar vào container
COPY build/libs/*.jar app.jar

# Khai báo cổng ứng dụng lắng nghe
EXPOSE 8080

# Khai báo lệnh thực thi khi container khởi động
ENTRYPOINT ["java", "-jar", "app.jar"]

