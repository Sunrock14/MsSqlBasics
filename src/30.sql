USE Northwind

-- PIVOT & UNPIVOT
-- PIVOT: Satırları sütunlara dönüştürür
-- UNPIVOT: Sütunları satırlara dönüştürür

-- 1. Temel PIVOT Örneği
-- Kategorilere göre ürün sayılarını pivot yapalım
SELECT *
FROM (
    SELECT c.CategoryName, p.ProductID
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
) AS SourceTable
PIVOT (
    COUNT(ProductID)
    FOR CategoryName IN ([Beverages], [Condiments], [Confections], [Dairy Products])
) AS PivotTable;

-- 2. Dynamic Column Names ile PIVOT
-- Ülkelere göre müşteri sayısı
SELECT *
FROM (
    SELECT Country, CustomerID
    FROM Customers
) AS SourceTable
PIVOT (
    COUNT(CustomerID)
    FOR Country IN ([USA], [Germany], [UK], [France], [Spain])
) AS PivotTable;

-- 3. PIVOT ile Aggregate Functions
-- Kategorilere göre ortalama fiyat
SELECT *
FROM (
    SELECT c.CategoryName, p.UnitPrice
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
) AS SourceTable
PIVOT (
    AVG(UnitPrice)
    FOR CategoryName IN ([Beverages], [Condiments], [Seafood])
) AS PivotTable;

-- 4. Multiple Aggregate ile PIVOT
-- Her kategori için hem sayı hem toplam fiyat
SELECT
    'ProductCount' AS Metric,
    [Beverages], [Condiments], [Confections]
FROM (
    SELECT c.CategoryName, p.ProductID
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
) AS SourceTable
PIVOT (
    COUNT(ProductID)
    FOR CategoryName IN ([Beverages], [Condiments], [Confections])
) AS PivotTable

UNION ALL

SELECT
    'AvgPrice' AS Metric,
    [Beverages], [Condiments], [Confections]
FROM (
    SELECT c.CategoryName, p.UnitPrice
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
) AS SourceTable
PIVOT (
    AVG(UnitPrice)
    FOR CategoryName IN ([Beverages], [Condiments], [Confections])
) AS PivotTable;

-- 5. PIVOT ile Date Grouping
-- Yıllara göre sipariş sayısı
SELECT *
FROM (
    SELECT YEAR(OrderDate) AS OrderYear, OrderID
    FROM Orders
) AS SourceTable
PIVOT (
    COUNT(OrderID)
    FOR OrderYear IN ([1996], [1997], [1998])
) AS PivotTable;

-- 6. Dynamic PIVOT (Tüm kategoriler otomatik)
-- SQL Server'da dynamic SQL ile yapılır
DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);

SELECT @columns = STRING_AGG(QUOTENAME(CategoryName), ',')
FROM Categories;

SET @sql = N'
SELECT *
FROM (
    SELECT c.CategoryName, p.ProductID
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
) AS SourceTable
PIVOT (
    COUNT(ProductID)
    FOR CategoryName IN (' + @columns + ')
) AS PivotTable';

PRINT @sql;  -- Sadece görmek için
-- EXEC sp_executesql @sql;  -- Çalıştırmak için

-- 7. UNPIVOT - Sütunları Satırlara Dönüştürme
-- Önce bir pivot tablo oluşturalım
CREATE TABLE #SalesData (
    SalesYear INT,
    Q1 DECIMAL(10,2),
    Q2 DECIMAL(10,2),
    Q3 DECIMAL(10,2),
    Q4 DECIMAL(10,2)
);

INSERT INTO #SalesData VALUES
(2020, 1000, 1500, 1200, 1800),
(2021, 1100, 1600, 1300, 1900),
(2022, 1200, 1700, 1400, 2000);

SELECT * FROM #SalesData;

-- UNPIVOT işlemi
SELECT SalesYear, Quarter, SalesAmount
FROM #SalesData
UNPIVOT (
    SalesAmount FOR Quarter IN (Q1, Q2, Q3, Q4)
) AS UnpivotTable
ORDER BY SalesYear, Quarter;

-- 8. UNPIVOT Alternatifi: CROSS APPLY
SELECT
    SalesYear,
    Quarter,
    SalesAmount
FROM #SalesData
CROSS APPLY (
    VALUES
        ('Q1', Q1),
        ('Q2', Q2),
        ('Q3', Q3),
        ('Q4', Q4)
) AS Unpivoted(Quarter, SalesAmount)
ORDER BY SalesYear, Quarter;

-- 9. PIVOT ile Complex Calculations
-- Müşterilerin yıllara göre toplam siparişleri
SELECT CustomerID, [1996], [1997], [1998]
FROM (
    SELECT c.CustomerID, YEAR(o.OrderDate) AS OrderYear, o.OrderID
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.Country = 'USA'
) AS SourceTable
PIVOT (
    COUNT(OrderID)
    FOR OrderYear IN ([1996], [1997], [1998])
) AS PivotTable;

-- 10. CASE Alternatifi PIVOT'a
-- PIVOT yerine CASE ile yapma (daha eski yöntem)
SELECT
    c.CategoryName,
    SUM(CASE WHEN YEAR(o.OrderDate) = 1996 THEN od.Quantity ELSE 0 END) AS [1996],
    SUM(CASE WHEN YEAR(o.OrderDate) = 1997 THEN od.Quantity ELSE 0 END) AS [1997],
    SUM(CASE WHEN YEAR(o.OrderDate) = 1998 THEN od.Quantity ELSE 0 END) AS [1998]
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY c.CategoryName;

-- Temizlik
DROP TABLE IF EXISTS #SalesData;

-- Özet
-- PIVOT satırları sütunlara dönüştürür
-- UNPIVOT sütunları satırlara dönüştürür
-- PIVOT sözdizimi: PIVOT (AggFunc(column) FOR column IN (values))
-- Dynamic PIVOT için STRING_AGG ve dynamic SQL kullanılır
-- UNPIVOT alternatifi olarak CROSS APPLY kullanılabilir
-- CASE WHEN ile de pivot benzeri sonuç alınabilir
-- Raporlama ve data transformation için kullanışlıdır

PRINT 'PIVOT & UNPIVOT örnekleri tamamlandı!'
