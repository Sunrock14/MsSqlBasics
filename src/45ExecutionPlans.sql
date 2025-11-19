USE Northwind

-- EXECUTION PLANS & QUERY OPTIMIZATION
-- Sorguların nasıl çalıştığını anlama ve optimize etme

-- 1. Actual Execution Plan
-- SSMS'te Ctrl+M veya "Include Actual Execution Plan" aktif olmalı
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT * FROM Products WHERE ProductID = 1;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- 2. Estimated Execution Plan
-- Sorguyu çalıştırmadan plan görme
-- SSMS: Ctrl+L veya "Display Estimated Execution Plan"
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM Products WHERE CategoryID = 1;
GO
SET SHOWPLAN_TEXT OFF;
GO

-- 3. SET STATISTICS PROFILE
-- Detaylı execution bilgisi
SET STATISTICS PROFILE ON;
SELECT * FROM Products WHERE UnitPrice > 20;
SET STATISTICS PROFILE OFF;

-- 4. Table Scan vs Index Seek
-- BAD: Table Scan (yavaş)
SELECT * FROM Products WHERE UnitPrice = 18;

-- Index ekle
CREATE INDEX IX_Products_UnitPrice ON Products(UnitPrice);

-- GOOD: Index Seek (hızlı)
SELECT * FROM Products WHERE UnitPrice = 18;

DROP INDEX IX_Products_UnitPrice ON Products;

-- 5. Key Lookup
-- Non-clustered index kullanır ama cluster'a geri dönmesi gerekir
CREATE NONCLUSTERED INDEX IX_Products_ProductName ON Products(ProductName);

-- Key Lookup olur (ProductName index'te ama UnitPrice değil)
SELECT ProductName, UnitPrice FROM Products WHERE ProductName = 'Chai';

-- Covering Index ile Key Lookup önlenir
DROP INDEX IX_Products_ProductName ON Products;
CREATE NONCLUSTERED INDEX IX_Products_ProductName
ON Products(ProductName) INCLUDE (UnitPrice);

-- Artık Key Lookup yok
SELECT ProductName, UnitPrice FROM Products WHERE ProductName = 'Chai';

DROP INDEX IX_Products_ProductName ON Products;

-- 6. Parameter Sniffing
-- İlk parametreye göre plan cache'lenir
CREATE PROCEDURE usp_GetProducts @CategoryID INT
AS
BEGIN
    SELECT * FROM Products WHERE CategoryID = @CategoryID;
END;
GO

-- İlk çalışma: CategoryID=1 için optimize edilir
EXEC usp_GetProducts @CategoryID = 1;

-- İkinci çalışma: Aynı planı kullanır (belki uygun değildir)
EXEC usp_GetProducts @CategoryID = 8;

-- Çözüm 1: OPTION (RECOMPILE)
ALTER PROCEDURE usp_GetProducts @CategoryID INT
AS
BEGIN
    SELECT * FROM Products WHERE CategoryID = @CategoryID
    OPTION (RECOMPILE);
END;
GO

-- Çözüm 2: OPTION (OPTIMIZE FOR)
ALTER PROCEDURE usp_GetProducts @CategoryID INT
AS
BEGIN
    SELECT * FROM Products WHERE CategoryID = @CategoryID
    OPTION (OPTIMIZE FOR (@CategoryID = 1));
END;
GO

DROP PROCEDURE usp_GetProducts;

-- 7. Missing Index DMV
-- SQL Server'ın önerdiği index'ler
SELECT
    migs.avg_user_impact,
    migs.avg_total_user_cost,
    migs.user_seeks,
    migs.user_scans,
    mid.statement AS TableName,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs
    ON mig.index_group_handle = migs.group_handle
INNER JOIN sys.dm_db_missing_index_details mid
    ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID('Northwind')
ORDER BY migs.avg_user_impact DESC;

-- 8. Query Store (SQL Server 2016+)
-- Plan regression detection
/*
ALTER DATABASE Northwind SET QUERY_STORE = ON;

-- Query Store'dan plan karşılaştırma
SELECT
    q.query_id,
    qt.query_sql_text,
    p.plan_id,
    rs.avg_duration,
    rs.avg_logical_io_reads
FROM sys.query_store_query q
INNER JOIN sys.query_store_query_text qt ON q.query_text_id = qt.query_text_id
INNER JOIN sys.query_store_plan p ON q.query_id = p.query_id
INNER JOIN sys.query_store_runtime_stats rs ON p.plan_id = rs.plan_id
ORDER BY rs.avg_duration DESC;
*/

-- 9. Index Usage Statistics
SELECT
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates,
    s.last_user_seek,
    s.last_user_scan
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE OBJECT_NAME(s.object_id) = 'Products'
ORDER BY s.user_seeks + s.user_scans + s.user_lookups DESC;

-- 10. Expensive Queries
-- En yüksek CPU kullanan sorgular
SELECT TOP 10
    qs.execution_count,
    qs.total_worker_time / 1000000 AS total_cpu_time_sec,
    qs.total_elapsed_time / 1000000 AS total_elapsed_time_sec,
    SUBSTRING(qt.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(qt.text)
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset)/2) + 1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY qs.total_worker_time DESC;

-- 11. Optimization Tips
-- - WHERE, JOIN, ORDER BY sütunlarına index
-- - SELECT * yerine gerekli sütunları seçin
-- - Covering index kullanın
-- - Statistics güncel tutun
-- - Fragmentasyon kontrol edin
-- - Parameter sniffing'e dikkat
-- - SARGABLE sorgular yazın (indexed column'da function kullanmayın)

-- KÖTÜ: Function index'i kullanamaz
SELECT * FROM Orders WHERE YEAR(OrderDate) = 1997;

-- İYİ: Index kullanabilir
SELECT * FROM Orders WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01';

-- 12. Plan Cache Temizleme
-- Test için - PRODUCTION'DA DİKKATLİ!
-- DBCC FREEPROCCACHE;  -- Tüm plan cache
-- DBCC DROPCLEANBUFFERS;  -- Buffer cache

-- Özet
-- Execution Plan sorgu performansını anlamak için kritik
-- Table Scan < Index Scan < Index Seek
-- Covering Index Key Lookup'u önler
-- Missing Index DMV'ler index önerileri verir
-- Parameter Sniffing problemi RECOMPILE ile çözülür
-- Query Store plan regression'ı tespit eder
-- SARGABLE sorgular yazın
-- Statistics ve index maintenance önemli

PRINT 'Execution Plans & Query Optimization örnekleri tamamlandı!'
PRINT 'Performance tuning sürekli bir süreçtir!'
