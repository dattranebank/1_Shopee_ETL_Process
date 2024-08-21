# Shopee ETL Process Project
Chào mọi người, mình là Đạt, đây là project build ETL Process với data từ HTML Shopee file. HTML file này chứa dữ liệu những đơn hàng mà mình đã mua trên Shopee.
## I. Mở đầu
### 1.1. OS, IDE, Language & others
1. [ ] OS: Windows 10 Pro, 22H2, 19045.4780
2. [ ] IDE: PyCharm
3. [ ] Programming Language: Python
4. [ ] Database: MSSQL
5. [ ] BI Tool: Power BI
6. [ ] Version Control: Git, GitHub
7. [ ] Containerization: Docker, Docker Hub

### 1.2. Giới thiệu project
* **Mô tả:** Dự án này nhằm xây dựng một quy trình ETL (Extract, Transform, Load) để xử lý dữ liệu từ các tệp HTML được xuất từ Shopee. Quy trình ETL bao gồm việc trích xuất dữ liệu từ các tệp HTML, biến đổi dữ liệu theo định dạng mong muốn, và nạp dữ liệu vào cơ sở dữ liệu MSSQL để phân tích và trực quan hóa bằng Power BI.
* **Mức độ khó của project:** Easy/Beginner
* **Data Sources:** HTML file về những đơn hàng đã mua trên Shopee

### 1.3. ETL
1. **Extract:** Đọc và phân tích các tệp HTML để trích xuất thông tin đơn hàng.
2. **Transform:** Làm sạch và biến đổi dữ liệu thành định dạng phù hợp với cơ sở dữ liệu MSSQL.
3. **Load:** Nạp dữ liệu vào cơ sở dữ liệu MSSQL và chuẩn bị dữ liệu cho việc phân tích và báo cáo trong Power BI.
4. **Deploy:** Sử dụng Docker để đóng gói và triển khai ứng dụng ETL, đảm bảo tính nhất quán và dễ dàng trong việc quản lý môi trường.
   
![image](https://github.com/user-attachments/assets/c51f7e0b-778a-4ab2-877e-653cf250de53)

## II. Run within PyCharm
### 2.1. Install Python 3.11.9 Interpreter
Link cài đặt: https://www.python.org/downloads/release/python-3119/ \
Tải phiên bản _Windows installer (64-bit) | Windows | Recommended_

### 2.2. Install PyCharm Community Edition
Link cài đặt: https://www.jetbrains.com/pycharm/download/?section=windows

### 2.3. Install Python pakages
`pip install beautifulsoup4`\
`pip install lxml`\
`pip install pandas`\
`pip install colorama`

## III. Docker Image Build and Container Run
### 3.1. Install Docker
Link cài đặt: https://www.docker.com/

### 3.2. Build Docker Image
Khởi động Docker và nhập lệnh: `docker image build -t python_etl .`\
Giải thích: Ta đặt tên Docker Image là `python_etl`

### 3.3. Run Docker Container
Đầu tiên, ta tạo thư mục `H:/Input`\
Tiếp theo, nhập lệnh: `docker container run -it -v H:/Input:/app/input -v H:/Output_csv:/app/output -v H:/Output_log:/app/log_files python_etl`
### 3.4. Upload Docker Image to Docker Hub
Ta mở CMD với quyền Administrator và nhập các lệnh: `docker login`\
`docker image tag python_etl datebank/python_etl_repository:latest`\
`docker image push datebank/python_etl_repository:latest`

## IV. MSSQL & Power BI
### 4.1. Tải và cài đặt MSSQL
=> Đang cập nhật
### 4.2. Tải và cài đặt Power BI
=> Đang cập nhật

## V. Apache Airflow
### 5.1. Tải và cài đặt Apache Airflow
=> Đang cập nhật
