-- Sử dụng database
USE SHOPEE_DB


-- Delete data from table
DELETE FROM T03_ORDER_DETAILS_HISTORY
DELETE FROM T02_ORDERS_HISTORY
DELETE FROM T01_SELLERS


-- Insert .csv file into 3 tables
BULK INSERT T01_SELLERS
FROM 'H:\Output\T01_SELLERS.csv'
WITH
(
	FORMAT='CSV',
	FIRSTROW=2,
	CODEPAGE ='65001', -- mã hóa UTF-8
	ROWTERMINATOR = '0x0a' -- Thêm dòng này là bởi vì Dat Ebank có xuất .csv file từ Docker Container, Linux OS
)

BULK INSERT T02_ORDERS_HISTORY
FROM 'H:\Output\T02_ORDERS_HISTORY.csv'
WITH
(
	FORMAT='CSV',
	FIRSTROW=2,
	CODEPAGE='65001', -- mã hóa UTF-8
	ROWTERMINATOR = '0x0a' -- Thêm dòng này là bởi vì Dat Ebank có xuất .csv file từ Docker Container, Linux OS
)

BULK INSERT T03_ORDER_DETAILS_HISTORY
FROM 'H:\Output\T03_ORDER_DETAILS_HISTORY.csv'
WITH
(
	FORMAT='CSV',
	FIRSTROW=2,
	CODEPAGE='65001', -- mã hóa UTF-8
	ROWTERMINATOR = '0x0a' -- Thêm dòng này là bởi vì Dat Ebank có xuất .csv file từ Docker Container, Linux OS
)

-- QUERY
SELECT *
FROM T01_SELLERS

SELECT *
FROM T02_ORDERS_HISTORY

SELECT *
FROM T03_ORDER_DETAILS_HISTORY

-- Truy vấn về nhà bán hàng
-- 1. Đếm số lượng nhà bán hàng
SELECT COUNT(T01.SellerID) as 'Số lượng nhà bán hàng'
FROM T01_SELLERS T01

-- 2. Thống kê nhà bán hàng theo từng SellerType
SELECT T01.SellerType, COUNT(*) as 'Số lượng'
FROM T01_SELLERS T01
GROUP BY T01.SellerType

-- 3. Thống kê số lần Dat Tran mua hàng theo từng nhà bán hàng
SELECT T01.SellerName, COUNT(T02.OrderID) as 'Số lần mua'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName;

-- 4. Thống kê các nhà bán hàng có số lần được mua nhiều nhất
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

-- 5. Thống kê các nhà bán hàng có số lần được mua ít nhất
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

-- 6. Thống kê tổng số tiền mà Dat Tran đã mua theo từng nhà bán hàng
SELECT T01.SellerName, SUM(T02.InvoiceAmount) as 'Tổng số tiền'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerName;

-- 7. Thống kê tổng số tiền lớn nhất mà Dat Tran đã mua theo từng nhà bán hàng
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

-- 8. Thống kê tổng số tiền nhỏ nhất mà Dat Tran đã mua theo nhà bán hàng
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
-- 9. Tổng số đơn hàng Dat Tran đã mua
SELECT COUNT(OrderID) as 'Tổng số đơn hàng đã mua'
FROM T02_ORDERS_HISTORY T02

-- 10. Tính tổng số tiền của tất cả các đơn hàng Dat Tran đã mua
SELECT SUM(T02.InvoiceAmount) as 'Tổng số tiền'
FROM T02_ORDERS_HISTORY T02

-- 11. Thống kê tổng số tiền mà Dat Tran đã mua theo SellerType
SELECT T01.SellerType, SUM(T02.InvoiceAmount) as 'Tổng số tiền'
FROM T01_SELLERS T01
INNER JOIN T02_ORDERS_HISTORY T02
ON T01.SellerID=T02.SellerID
GROUP BY T01.SellerType

-- 12. Tổng số lượng sản phẩm Dat Tran đã mua (một đơn hàng có một hoặc nhiều sản phẩm)
SELECT COUNT(T03.OrderDetailID) as 'Tổng số lượng sản phẩm đã mua'
FROM T03_ORDER_DETAILS_HISTORY T03


-- ĐƠN HÀNG
-- 13. Đơn hàng đắt nhất Dat Tran đã mua là bao nhiêu? Hiển thị OrderID, SellerName, InvoiceAmount
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

-- 14. Đơn hàng rẻ nhất Dat Tran đã mua là bao nhiêu? Hiển thị OrderID, SellerName, InvoiceAmount
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

-- 15. Thống kê số lượng sản phẩm của mỗi đơn hàng
-- 16. Đơn hàng có nhiều sản phẩm nhất, đơn hàng có ít sản phẩm nhất và mỗi đơn hàng này có những sản phẩm nào?
-- 17. 

