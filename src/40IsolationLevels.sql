USE Northwind

-- TRANSACTION ISOLATION LEVELS
-- Transaction'ların birbirinden ne kadar izole olduğunu belirler.
-- Concurrency vs Consistency trade-off

-- İzolasyon Seviyeleri (Düşükten Yükseğe):
-- 1. READ UNCOMMITTED (En düşük)
-- 2. READ COMMITTED (Default)
-- 3. REPEATABLE READ
-- 4. SNAPSHOT
-- 5. SERIALIZABLE (En yüksek)

-- 1. READ UNCOMMITTED
-- Dirty Read: Commit edilmemiş verileri okuyabilir
-- En az kilitlenme, en az tutarlılık

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
    SELECT * FROM Products WHERE CategoryID = 1;
    -- Başka session'da uncommitted değişiklikleri görebilir
COMMIT;

-- Alternatif: NOLOCK hint
SELECT * FROM Products WITH (NOLOCK) WHERE CategoryID = 1;

-- 2. READ COMMITTED (Default)
-- Dirty Read yok, sadece commit edilmiş verileri okur
-- Non-Repeatable Read mümkün

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
    SELECT * FROM Products WHERE ProductID = 1;
    -- Başka session bu satırı update edebilir
    WAITFOR DELAY '00:00:05';  -- 5 saniye bekle
    SELECT * FROM Products WHERE ProductID = 1;  -- Farklı değer görebilir
COMMIT;

-- 3. REPEATABLE READ
-- Non-Repeatable Read yok
-- Phantom Read mümkün

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
    SELECT * FROM Products WHERE CategoryID = 1;
    -- Okunan satırlar kilitlenir, update edilemez
    -- Ama yeni satırlar eklenebilir (Phantom Read)
    WAITFOR DELAY '00:00:05';
    SELECT * FROM Products WHERE CategoryID = 1;  -- Aynı satırlar ama yeni satır eklenmiş olabilir
COMMIT;

-- 4. SNAPSHOT
-- Row versioning kullanır
-- Okuma sırasında kilitlenmez, her transaction kendi snapshot'ını görür

-- Önce database'de snapshot isolation'ı aktifleştirmek gerekir
-- ALTER DATABASE Northwind SET ALLOW_SNAPSHOT_ISOLATION ON;

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
BEGIN TRANSACTION;
    SELECT * FROM Products WHERE ProductID = 1;
    -- Transaction başladığında verilerin snapshot'ı alınır
    -- Diğer session'lar update yapabilir ama bu transaction eski değeri görür
    WAITFOR DELAY '00:00:05';
    SELECT * FROM Products WHERE ProductID = 1;  -- Aynı değer (snapshot)
COMMIT;

-- 5. SERIALIZABLE
-- En yüksek izolasyon seviyesi
-- Phantom Read yok
-- En çok kilitlenme, en az concurrency

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
    SELECT * FROM Products WHERE CategoryID = 1;
    -- Aralık kilidi (range lock)
    -- Başka session ne update ne delete ne de insert yapamaz
    WAITFOR DELAY '00:00:05';
    SELECT * FROM Products WHERE CategoryID = 1;  -- Tamamen aynı sonuç
COMMIT;

-- 6. Read Phenomena (Okuma Anomalileri)
/*
Dirty Read: Uncommitted veri okuma
Non-Repeatable Read: Aynı sorgu farklı sonuç (UPDATE)
Phantom Read: Aynı sorgu farklı satır sayısı (INSERT/DELETE)

İzolasyon Seviyesi     | Dirty | Non-Repeatable | Phantom
-----------------------|-------|----------------|--------
READ UNCOMMITTED       | Evet  | Evet           | Evet
READ COMMITTED         | Hayır | Evet           | Evet
REPEATABLE READ        | Hayır | Hayır          | Evet
SNAPSHOT               | Hayır | Hayır          | Hayır
SERIALIZABLE           | Hayır | Hayır          | Hayır
*/

-- 7. Deadlock Örneği
-- Session 1:
/*
BEGIN TRANSACTION;
UPDATE Products SET UnitPrice = 100 WHERE ProductID = 1;
WAITFOR DELAY '00:00:05';
UPDATE Products SET UnitPrice = 200 WHERE ProductID = 2;
COMMIT;
*/

-- Session 2 (aynı anda):
/*
BEGIN TRANSACTION;
UPDATE Products SET UnitPrice = 300 WHERE ProductID = 2;
WAITFOR DELAY '00:00:05';
UPDATE Products SET UnitPrice = 400 WHERE ProductID = 1;  -- DEADLOCK!
COMMIT;
*/

-- 8. Deadlock Önleme
-- - Aynı sırada resource'lara erişin
-- - Transaction'ları kısa tutun
-- - Uygun isolation level seçin
-- - SET DEADLOCK_PRIORITY LOW (kurban seçimi)

SET DEADLOCK_PRIORITY LOW;

-- 9. Lock Timeout
-- Kilit bekleme süresi (milisaniye)
SET LOCK_TIMEOUT 5000;  -- 5 saniye
-- SET LOCK_TIMEOUT -1;  -- Sınırsız (default)

-- 10. Monitoring Locks
-- Aktif kilitler
SELECT
    resource_type,
    resource_database_id,
    resource_description,
    request_mode,
    request_status
FROM sys.dm_tran_locks
WHERE resource_database_id = DB_ID('Northwind');

-- Default seviyeye dön
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Özet
-- READ UNCOMMITTED: En hızlı, en az tutarlı (Dirty Read)
-- READ COMMITTED: Default, commit edilmiş veri
-- REPEATABLE READ: Non-Repeatable Read yok
-- SNAPSHOT: Row versioning, okuma kilitsiz
-- SERIALIZABLE: En tutarlı, en yavaş
-- Trade-off: Concurrency vs Consistency
-- Deadlock'lardan kaçınmak için dikkatli planlama gerekir

PRINT 'Isolation Levels örnekleri tamamlandı!'
