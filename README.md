# Shopee ETL Process Project
Chào mọi người, mình là Đạt, đây là project build ETL Process với data từ HTML Shopee file. HTML file này chứa dữ liệu những đơn hàng mà mình đã mua trên Shopee.
## I. Mở đầu
**1.1. OS, IDE, Language & others**
1. [ ] OS: Windows 10 Pro
2. [ ] IDE: PyCharm
3. [ ] Programming Language: Python
4. [ ] Database: MSSQL
5. [ ] BI Tool: Power BI
6. [ ] Version Control: Git, GitHub
7. [ ] Containerization: Docker

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
Tiếp tục nhập lệnh: `docker container run -it -v D:/NewFolder:/app/data -v D:/Output:/app/output python_etl`