-- Sử dụng database
USE SHOPEE_DB


-- Delete data from table
DELETE FROM T01_SELLERS


-- Insert .csv file into 3 tables
BULK INSERT T01_SELLERS
FROM 'H:\Web Scraping\1. BeautifulSoup\Shopee\T01_SELLERS.csv'
WITH
(
	FORMAT='CSV',
	FIRSTROW=2,
	CODEPAGE ='65001' -- mã hóa UTF-8
)

BULK INSERT T02_ORDERS_HISTORY
FROM 'H:\Web Scraping\1. BeautifulSoup\Shopee\T02_ORDERS_HISTORY.csv'
WITH
(
	FORMAT='CSV',
	FIRSTROW=2,
	CODEPAGE='65001' -- mã hóa UTF-8
)

BULK INSERT T03_ORDER_DETAILS_HISTORY
FROM 'H:\Web Scraping\1. BeautifulSoup\Shopee\T03_ORDER_DETAILS_HISTORY.csv'
WITH
(
	FORMAT='CSV',
	FIRSTROW=2,
	CODEPAGE='65001' -- mã hóa UTF-8
)

-- QUERY
SELECT *
FROM T01_SELLERS

SELECT *
FROM T02_ORDERS_HISTORY

SELECT *
FROM T03_ORDER_DETAILS_HISTORY

-- Truy vấn về nhà bán hàng
-- 1. Số lượng nhà bán hàng mà Dat Tran đã mua đơn hàng
SELECT COUNT(T01.SellerID) as 'Số lượng nhà bán hàng'
FROM T01_SELLERS T01

-- 2. Số lượng nhà bán hàng theo từng SellerType
SELECT T01.SellerType, COUNT(*) as 'Số lượng'
FROM T01_SELLERS T01
GROUP BY T01.SellerType

-- 3. Hiển thị số lượt Dat Tran mua hàng theo mỗi nhà bán hàng
SELECT T01.SellerName, COUNT(T02.OrderID) as 'Số lượt mua'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName;

-- 4. Hiển thị các nhà bán hàng có số lượt mua nhiều nhất
WITH PurchaseCount_CTE AS
(
	SELECT COUNT(T02.OrderID) AS PurchaseCount
	FROM T01_SELLERS T01
	INNER JOIN T02_ORDERS_HISTORY T02
	ON T01.SellerID=T02.SellerID
	GROUP BY T01.SellerName
)
SELECT T01.SellerName, COUNT(T02.OrderID) as 'Số lượt mua'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName
HAVING COUNT(T02.OrderID) = (SELECT MAX(PurchaseCount) 
								FROM PurchaseCount_CTE)

-- 5. Hiển thị các nhà bán hàng có số lượt mua ít nhất
WITH PurchaseCount_CTE AS
(
	SELECT COUNT(T02.OrderID) AS PurchaseCount
	FROM T01_SELLERS T01
	INNER JOIN T02_ORDERS_HISTORY T02
	ON T01.SellerID=T02.SellerID
	GROUP BY T01.SellerName
)
SELECT T01.SellerName, COUNT(T02.OrderID) as 'Số lượt mua'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName
HAVING COUNT(T02.OrderID) = (SELECT MIN(PurchaseCount) 
								FROM PurchaseCount_CTE)

-- 6. Hiển thị tổng số tiền mà Dat Tran đã mua theo từng nhà bán hàng
SELECT T01.SellerName, SUM(T02.InvoiceAmount) as 'Tổng số tiền'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName;

-- 7. Hiển thị tổng số tiền lớn nhất mà Dat Tran đã mua theo nhà bán hàng
WITH MAX_INVOICE_CTE AS 
(
	SELECT T01.SellerName, SUM(T02.InvoiceAmount) as 'InvoiceAmount'
	FROM T01_SELLERS T01
	INNER JOIN T02_ORDERS_HISTORY T02
	ON T01.SellerID=T02.SellerID
	GROUP BY T01.SellerName
)
SELECT T01.SellerName, SUM(T02.InvoiceAmount) as 'Tổng số tiền'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName
HAVING SUM(T02.InvoiceAmount)=(SELECT MAX(InvoiceAmount) FROM MAX_INVOICE_CTE)

-- 8. Hiển thị tổng số tiền nhỏ nhất mà Dat Tran đã mua theo nhà bán hàng
WITH MAX_INVOICE_CTE AS 
(
	SELECT T01.SellerName, SUM(T02.InvoiceAmount) as 'InvoiceAmount'
	FROM T01_SELLERS T01
	INNER JOIN T02_ORDERS_HISTORY T02
	ON T01.SellerID=T02.SellerID
	GROUP BY T01.SellerName
)
SELECT T01.SellerName, SUM(T02.InvoiceAmount) as 'Tổng số tiền'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName
HAVING SUM(T02.InvoiceAmount)=(SELECT MIN(InvoiceAmount) FROM MAX_INVOICE_CTE)

-- Truy vấn về đơn hàng đã mua
-- 1. Tổng số đơn hàng Dat Tran đã mua
SELECT COUNT(OrderID) as 'Tổng số đơn hàng đã mua'
FROM T02_ORDERS_HISTORY T02

-- 2. Tổng số tiền của tất cả các đơn hàng Dat Tran đã mua
SELECT SUM(T02.InvoiceAmount) as 'Tổng số tiền'
FROM T02_ORDERS_HISTORY T02

-- 3. Tổng số lượng sản phẩm Dat Tran đã mua (một đơn hàng có 1 hoặc nhiều sản phẩm)
SELECT COUNT(T03.OrderDetailID) as 'Tổng số lượng sản phẩm đã mua'
FROM T03_ORDER_DETAILS_HISTORY T03

-- ĐƠN HÀNG
-- 4. Đơn hàng đắt nhất Dat Tran đã mua là bao nhiêu? Hiển thị OrderID, SellerName, InvoiceAmount
SELECT TOP 1 OrderID, SellerName, InvoiceAmount
FROM T02_ORDERS_HISTORY T02
LEFT JOIN T01_SELLERS T01
ON T02.SellerID=T01.SellerID
ORDER BY T02.InvoiceAmount DESC
-- Hiển thị OrderID có những sản phẩm nào
SELECT *
FROM T03_ORDER_DETAILS_HISTORY T03
WHERE T03.OrderID=(SELECT TOP 1 OrderID
					FROM T02_ORDERS_HISTORY T02
					LEFT JOIN T01_SELLERS T01
					ON T02.SellerID=T01.SellerID
					ORDER BY T02.InvoiceAmount DESC)

-- 5. Đơn hàng rẻ nhất Dat Tran đã mua là bao nhiêu? Hiển thị OrderID, SellerName, InvoiceAmount
SELECT TOP 1 OrderID, SellerName, InvoiceAmount
FROM T02_ORDERS_HISTORY T02
LEFT JOIN T01_SELLERS T01
ON T02.SellerID=T01.SellerID
ORDER BY T02.InvoiceAmount ASC
-- Hiển thị OrderID có những sản phẩm nào
SELECT *
FROM T03_ORDER_DETAILS_HISTORY T03
WHERE T03.OrderID=(SELECT TOP 1 OrderID
					FROM T02_ORDERS_HISTORY T02
					LEFT JOIN T01_SELLERS T01
					ON T02.SellerID=T01.SellerID
					ORDER BY T02.InvoiceAmount ASC)

-- 6. 

