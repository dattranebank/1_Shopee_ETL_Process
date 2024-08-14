# Step 1: Sử dụng một image Python từ Docker Hub
FROM python:3.11.9

# Đặt label (optional)
LABEL authors="Dat Ebank"

# Step 2: Thiết lập thư mục làm việc trong container
WORKDIR /app

# Step 3: Copy toàn bộ source code vào container
COPY . .

# Step 4: Cài đặt các thư viện Python từ requirements.txt
RUN pip install -r requirements.txt

# Step 5: Xác định lệnh khởi chạy ứng dụng
CMD ["python","main.py"]





