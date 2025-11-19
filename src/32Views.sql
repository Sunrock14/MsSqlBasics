USE Northwind

-- VIEWS (Görünümler)
-- View, önceden tanımlanmış SELECT sorgularıdır.
-- Sanal tablolar gibi davranır, veri saklamaz.

-- 1. Basit View Oluşturma
CREATE VIEW vw_CustomerOrders AS
SELECT
    c.CustomerID,
    c.CompanyName,
    c.Country,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName, c.Country;
GO

-- View kullanımı
SELECT * FROM vw_CustomerOrders WHERE Country = 'USA';
GO

-- 2. Kompleks View
CREATE VIEW vw_ProductDetails AS
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    s.CompanyName AS SupplierName,
    p.UnitPrice,
    p.UnitsInStock,
    p.UnitPrice * p.UnitsInStock AS StockValue
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID;
GO

SELECT * FROM vw_ProductDetails WHERE CategoryName = 'Beverages';
GO

-- 3. View ile Güvenlik (Sütun Gizleme)
CREATE VIEW vw_EmployeePublic AS
SELECT
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    Title,
    City,
    Country
FROM Employees;
-- Salary gibi hassas bilgiler gösterilmez
GO

-- 4. ALTER VIEW - View Güncelleme
ALTER VIEW vw_CustomerOrders AS
SELECT
    c.CustomerID,
    c.CompanyName,
    c.Country,
    c.City,  -- Yeni sütun eklendi
    COUNT(o.OrderID) AS TotalOrders,
    MAX(o.OrderDate) AS LastOrderDate  -- Yeni sütun
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName, c.Country, c.City;
GO

-- 5. WITH CHECK OPTION
-- View üzerinden yapılan INSERT/UPDATE'lerin view şartlarına uymasını sağlar
CREATE VIEW vw_GermanCustomers AS
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE Country = 'Germany'
WITH CHECK OPTION;
GO

-- Bu çalışır
-- INSERT INTO vw_GermanCustomers VALUES ('NEWID', 'New Company', 'Germany');

-- Bu çalışmaz - CHECK OPTION ihlal eder
-- INSERT INTO vw_GermanCustomers VALUES ('NEWID2', 'New Company 2', 'USA');

-- 6. Indexed View (Materialized View)
-- View'i fiziksel olarak saklar, performans artışı sağlar
CREATE VIEW vw_OrderSummary
WITH SCHEMABINDING  -- Schema binding gerekli
AS
SELECT
    o.CustomerID,
    COUNT_BIG(*) AS OrderCount,  -- COUNT_BIG gerekli
    SUM(ISNULL(od.Quantity, 0)) AS TotalQuantity
FROM dbo.Orders o
INNER JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID;
GO

-- Unique clustered index oluştur (indexed view için gerekli)
CREATE UNIQUE CLUSTERED INDEX IX_vw_OrderSummary
ON vw_OrderSummary (CustomerID);
GO

-- 7. Updateable View
-- Bazı view'ler üzerinden INSERT/UPDATE/DELETE yapılabilir
CREATE VIEW vw_ActiveProducts AS
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE Discontinued = 0;
GO

-- Update yapılabilir (tek tablo, basit view)
-- UPDATE vw_ActiveProducts SET UnitPrice = UnitPrice * 1.05 WHERE ProductID = 1;

-- 8. View ile Partition
CREATE VIEW vw_RecentOrders AS
SELECT * FROM Orders WHERE YEAR(OrderDate) >= 1997;
GO

-- 9. View Metadata Görme
SELECT * FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'vw_CustomerOrders';

-- View tanımını görme
EXEC sp_helptext 'vw_CustomerOrders';

-- 10. DROP VIEW
DROP VIEW IF EXISTS vw_GermanCustomers;
DROP VIEW IF EXISTS vw_EmployeePublic;
DROP VIEW IF EXISTS vw_RecentOrders;
DROP VIEW IF EXISTS vw_ActiveProducts;
DROP VIEW IF EXISTS vw_OrderSummary;
DROP VIEW IF EXISTS vw_ProductDetails;
DROP VIEW IF EXISTS vw_CustomerOrders;
GO

-- Özet
-- View sanal tablolardır, veri saklamazlar
-- Kompleks sorguları basitleştirir ve yeniden kullanılabilir yapar
-- Güvenlik için hassas verileri gizleyebilir
-- WITH CHECK OPTION veri bütünlüğünü korur
-- Indexed view performans artışı sağlar (SCHEMABINDING gerekli)
-- Basit view'ler updateable olabilir
-- ALTER VIEW ile güncellenebilir, DROP VIEW ile silinebilir

PRINT 'Views örnekleri tamamlandı!'
