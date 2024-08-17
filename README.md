# Shopee ETL Process Project
Chào mọi người, mình là Đạt, đây là project build ETL Process với data từ HTML Shopee file. HTML file này chứa dữ liệu những đơn hàng mà mình đã mua trên Shopee.
## I. Mở đầu
**1.1. OS, IDE, Language & others**
1. [ ] OS: Windows 10 Pro, 22H2, 19045.4780
2. [ ] IDE: PyCharm
3. [ ] Programming Language: Python
4. [ ] Database: MSSQL
5. [ ] BI Tool: Power BI
6. [ ] Version Control: Git, GitHub
7. [ ] Containerization: Docker, Docker Hub

**1.2. Giới thiệu project**\
Mức độ khó của project: Easy/Beginner\
**1.3. Install Python pakages**\
`pip install beautifulsoup4`\
`pip install lxml`\
`pip install pandas`\
`pip install colorama`
## II. Docker
**2.1. Install Docker**\
Xem hướng dẫn cài đặt trên Google, Youtube =)))\
**2.2. Build Docker Image**\
Khởi động Docker và nhập lệnh: `docker image build -t python_etl .`\
**2.3. Run Docker Container**\
Đầu tiên, ta tạo 3 thư mục lần lượt là `H:/Input`, `H:/Output_csv`\, `H:/Output_log`\
Tiếp theo, nhập lệnh: `docker container run -it -v H:/Input:/app/input -v H:/Output_csv:/app/output -v H:/Output_log:/app/log_files python_etl`\
**2.4. Upload Docker Image to Docker Hub**\
Ta mở CMD với quyền Administrator và nhập các lệnh: `docker login`\
`docker image tag python_etl datebank/python_etl_repository:latest`\
`docker image tag python_etl datebank/python_etl_repository:latest`\
`docker image push datebank/python_etl_repository:latest`
