USE Northwind

-- ADVANCED TOPICS (İleri Seviye Konular)
-- Temporary Tables, Table Variables, OUTPUT Clause, MERGE, Table Hints

-- 1. TEMPORARY TABLES (#temp)
-- # ile başlar, session bazlı geçici tablolar
CREATE TABLE #TempCustomers (
    CustomerID NCHAR(5),
    CompanyName NVARCHAR(40),
    Country NVARCHAR(15)
);

INSERT INTO #TempCustomers
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE Country = 'Germany';

SELECT * FROM #TempCustomers;

-- Global Temp Table (##temp) - tüm sessionlarda görünür
CREATE TABLE ##GlobalTemp (ID INT, Data NVARCHAR(50));
INSERT INTO ##GlobalTemp VALUES (1, 'Global Data');

-- 2. TABLE VARIABLES (@table)
-- Hafızada tutulan geçici tablolar, küçük veri setleri için
DECLARE @ProductTable TABLE (
    ProductID INT,
    ProductName NVARCHAR(40),
    UnitPrice MONEY
);

INSERT INTO @ProductTable
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE CategoryID = 1;

SELECT * FROM @ProductTable;

-- 3. #Temp vs @Table Variable Farkları
-- #Temp Tables:
--   - tempdb'de fiziksel olarak saklanır
--   - Index oluşturulabilir
--   - İstatistikler tutulur
--   - Büyük veri setleri için iyidir
--   - Transaction rollback edilebilir
-- @Table Variables:
--   - Hafızada tutulur
--   - Index sadece inline olarak
--   - İstatistik tutulmaz
--   - Küçük veri setleri için
--   - Transaction rollback edilemez

-- 4. OUTPUT Clause - Detaylı Kullanım
-- INSERT, UPDATE, DELETE işlemlerinde etkilenen satırları gösterir

DECLARE @InsertedProducts TABLE (
    ProductID INT,
    ProductName NVARCHAR(40),
    InsertedDate DATETIME
);

INSERT INTO #TempProducts (ProductName, UnitPrice)
OUTPUT inserted.ProductID, inserted.ProductName, GETDATE()
INTO @InsertedProducts
VALUES ('New Product 1', 25.00), ('New Product 2', 30.00);

SELECT * FROM @InsertedProducts;

-- 5. OUTPUT ile UPDATE
CREATE TABLE #TestProducts (
    ProductID INT IDENTITY(1,1),
    ProductName NVARCHAR(40),
    UnitPrice MONEY
);

INSERT INTO #TestProducts VALUES ('Product A', 10.00), ('Product B', 20.00);

DECLARE @UpdateLog TABLE (
    ProductID INT,
    OldPrice MONEY,
    NewPrice MONEY
);

UPDATE #TestProducts
SET UnitPrice = UnitPrice * 1.10
OUTPUT
    inserted.ProductID,
    deleted.UnitPrice AS OldPrice,
    inserted.UnitPrice AS NewPrice
INTO @UpdateLog;

SELECT * FROM @UpdateLog;

-- 6. MERGE Statement
-- INSERT, UPDATE, DELETE işlemlerini tek komutta yapar
CREATE TABLE #TargetProducts (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(40),
    UnitPrice MONEY
);

CREATE TABLE #SourceProducts (
    ProductID INT,
    ProductName NVARCHAR(40),
    UnitPrice MONEY
);

INSERT INTO #TargetProducts VALUES (1, 'Product A', 10.00), (2, 'Product B', 20.00);
INSERT INTO #SourceProducts VALUES (2, 'Product B Updated', 25.00), (3, 'Product C', 30.00);

MERGE #TargetProducts AS Target
USING #SourceProducts AS Source
ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET
        ProductName = Source.ProductName,
        UnitPrice = Source.UnitPrice
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, UnitPrice)
    VALUES (Source.ProductID, Source.ProductName, Source.UnitPrice)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
OUTPUT $action AS MergeAction, inserted.*, deleted.*;

-- 7. Table Hints (WITH clause)
-- Query performansını etkilemek için kullanılır

-- NOLOCK: Dirty read yapabilir, kilitleme yapmaz
SELECT * FROM Products WITH (NOLOCK) WHERE CategoryID = 1;

-- ROWLOCK: Satır seviyesinde kilit
UPDATE Products WITH (ROWLOCK)
SET UnitPrice = UnitPrice * 1.05
WHERE ProductID = 1;

-- UPDLOCK: Update kilit (deadlock önler)
SELECT * FROM Products WITH (UPDLOCK) WHERE ProductID = 1;

-- TABLOCK: Tablo seviyesinde kilit
SELECT * FROM Products WITH (TABLOCK);

-- INDEX hint: Belirli index kullanımı zorlar
-- SELECT * FROM Products WITH (INDEX(IX_ProductName)) WHERE ProductName = 'Chai';

-- 8. OPTION Hints
-- Query seviyesinde optimize etmek için
SELECT *
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
OPTION (MAXDOP 1);  -- Max Degree of Parallelism

-- 9. Batch Operations
-- GO ile batch ayırma
SELECT 'Batch 1';
GO
SELECT 'Batch 2';
GO

-- 10. Variable Scope
-- GO kullanınca değişkenler sıfırlanır
DECLARE @TestVar INT = 100;
SELECT @TestVar;
GO
-- SELECT @TestVar;  -- HATA! GO sonrası değişken kaybolur

-- 11. Dynamic Table Names
-- Dynamic SQL ile tablo adı belirtme
DECLARE @TableName NVARCHAR(128) = N'Products';
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'SELECT TOP 5 * FROM ' + QUOTENAME(@TableName);
EXEC sp_executesql @SQL;

-- 12. IDENTITY INSERT
-- Identity sütununa manuel değer ekleme
SET IDENTITY_INSERT #TestProducts ON;

INSERT INTO #TestProducts (ProductID, ProductName, UnitPrice)
VALUES (100, 'Manual ID Product', 50.00);

SET IDENTITY_INSERT #TestProducts OFF;

SELECT * FROM #TestProducts;

-- Temizlik
DROP TABLE IF EXISTS #TempCustomers;
DROP TABLE IF EXISTS ##GlobalTemp;
DROP TABLE IF EXISTS #TempProducts;
DROP TABLE IF EXISTS #TestProducts;
DROP TABLE IF EXISTS #TargetProducts;
DROP TABLE IF EXISTS #SourceProducts;

-- Özet
-- #Temp tables session bazlı, tempdb'de saklanır
-- @Table variables hafızada, küçük veri için uygundur
-- OUTPUT clause etkilenen satırları yakalar
-- MERGE tek komutta INSERT/UPDATE/DELETE yapar
-- Table hints (NOLOCK, ROWLOCK, etc.) performans ayarları
-- OPTION hints query optimizer'a ipucu verir
-- Dynamic SQL ile esnek sorgular yazılabilir
-- SET IDENTITY_INSERT ile manuel ID girişi yapılır

PRINT 'Advanced Topics örnekleri tamamlandı!'
