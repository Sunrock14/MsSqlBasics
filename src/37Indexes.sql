USE Northwind

-- INDEXES (İndeksler)
-- İndeksler sorgu performansını artırır, veri erişimini hızlandırır.

-- 1. Clustered Index
-- Tablodaki verilerin fiziksel sıralanışını belirler
-- Bir tabloda sadece 1 clustered index olabilir
-- Primary key otomatik olarak clustered index oluşturur

CREATE TABLE #TestEmployees (
    EmployeeID INT PRIMARY KEY,  -- Otomatik clustered index
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Salary MONEY
);

-- Manuel clustered index oluşturma
CREATE TABLE #TestProducts (
    ProductID INT,
    ProductName NVARCHAR(50),
    UnitPrice MONEY
);

CREATE CLUSTERED INDEX IX_TestProducts_ProductID
ON #TestProducts(ProductID);

-- 2. Non-Clustered Index
-- Veri sıralamasını etkilemez, ayrı bir yapıda saklanır
-- Bir tabloda birden fazla non-clustered index olabilir

CREATE NONCLUSTERED INDEX IX_TestEmployees_LastName
ON #TestEmployees(LastName);

-- Multiple column index (composite)
CREATE NONCLUSTERED INDEX IX_TestEmployees_Name
ON #TestEmployees(LastName, FirstName);

-- 3. Unique Index
-- Benzersiz değerleri garanti eder
CREATE UNIQUE INDEX IX_TestEmployees_Email
ON #TestEmployees(FirstName);  -- Örnek amaçlı

-- 4. Included Columns
-- Index'e ek sütunlar dahil ederek covering index oluşturma
CREATE NONCLUSTERED INDEX IX_TestEmployees_Salary
ON #TestEmployees(Salary)
INCLUDE (FirstName, LastName);  -- Bu sütunlar index'te saklanır

-- 5. Filtered Index
-- Belirli bir koşula uyan kayıtlar için index
-- SQL Server 2008+
CREATE NONCLUSTERED INDEX IX_TestEmployees_HighSalary
ON #TestEmployees(Salary)
WHERE Salary > 50000;

-- 6. Index on Computed Column
ALTER TABLE #TestEmployees
ADD FullName AS (FirstName + ' ' + LastName);

CREATE INDEX IX_TestEmployees_FullName
ON #TestEmployees(FullName);

-- 7. Index ile Performance Karşılaştırması
-- Index olmadan
SELECT * FROM Products WHERE ProductName = 'Chai';

-- Index oluştur
CREATE INDEX IX_Products_ProductName ON Products(ProductName);

-- Şimdi daha hızlı
SELECT * FROM Products WHERE ProductName = 'Chai';

-- 8. Index Statistics
-- Index kullanım istatistikleri
SELECT
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE OBJECT_NAME(s.object_id) = 'Products';

-- 9. Index Fragmentation
-- Fragmentation kontrolü
SELECT
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 10
ORDER BY ips.avg_fragmentation_in_percent DESC;

-- 10. Index Maintenance
-- Rebuild: Index'i sıfırdan oluşturur (offline)
ALTER INDEX IX_Products_ProductName ON Products REBUILD;

-- Reorganize: Index'i düzenler (online)
ALTER INDEX IX_Products_ProductName ON Products REORGANIZE;

-- Tüm index'leri rebuild
ALTER INDEX ALL ON Products REBUILD;

-- 11. Disable/Enable Index
ALTER INDEX IX_Products_ProductName ON Products DISABLE;
ALTER INDEX IX_Products_ProductName ON Products REBUILD;  -- Enable için rebuild

-- 12. Drop Index
DROP INDEX IF EXISTS IX_Products_ProductName ON Products;
DROP INDEX IF EXISTS IX_TestEmployees_LastName ON #TestEmployees;
DROP INDEX IF EXISTS IX_TestEmployees_Name ON #TestEmployees;
DROP INDEX IF EXISTS IX_TestEmployees_Email ON #TestEmployees;
DROP INDEX IF EXISTS IX_TestEmployees_Salary ON #TestEmployees;
DROP INDEX IF EXISTS IX_TestEmployees_HighSalary ON #TestEmployees;
DROP INDEX IF EXISTS IX_TestEmployees_FullName ON #TestEmployees;
DROP INDEX IF EXISTS IX_TestProducts_ProductID ON #TestProducts;

-- 13. Index Best Practices
-- - WHERE, JOIN, ORDER BY'da kullanılan sütunlara index
-- - Seçici (selective) sütunlara index (çok benzersiz değerler)
-- - Küçük sütunlara index (INT > NVARCHAR(MAX))
-- - Çok fazla index performansı düşürür (INSERT/UPDATE/DELETE yavaşlar)
-- - Fragmentation düzenli olarak kontrol edilmeli
-- - Kullanılmayan index'ler silinmeli

-- Temizlik
DROP TABLE IF EXISTS #TestEmployees;
DROP TABLE IF EXISTS #TestProducts;

-- Özet
-- Clustered Index: Fiziksel sıralama, tablo başına 1 tane
-- Non-Clustered Index: Ayrı yapı, tablo başına birden fazla
-- Unique Index: Benzersizlik garantisi
-- Filtered Index: Koşullu index
-- Covering Index: INCLUDE ile ek sütunlar
-- Index Maintenance: REBUILD ve REORGANIZE
-- Fragmentation düzenli kontrol edilmeli

PRINT 'Indexes örnekleri tamamlandı!'
