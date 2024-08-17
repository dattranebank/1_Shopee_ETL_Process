# Đã tối ưu Dockerfile
# Step 1: Sử dụng một image Python từ Docker Hub
FROM python:3.11.9
RUN apt-get update && apt-get install -y tzdata

# Thiết lập múi giờ (thay đổi theo múi giờ của bạn)
ENV TZ=Asia/Ho_Chi_Minh
# Đặt label (optional)
LABEL author="Dat Ebank"

# Step 2: Thiết lập thư mục làm việc trong container
WORKDIR /app

# Step 3: Copy requirements.txt vào container trước
COPY requirements.txt /app

# Step 4: Cài đặt pip
RUN pip install -r requirements.txt

# Step 5: Copy toàn bộ source code còn lại vào container
COPY . .

# Step 6: Xác định lệnh khởi chạy ứng dụng
CMD ["python","main.py"]





