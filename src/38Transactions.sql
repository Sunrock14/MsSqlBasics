USE Northwind

-- TRANSACTIONS (İşlemler)
-- Transaction, birden fazla SQL işlemini tek bir atomik birim olarak yönetir.
-- ACID: Atomicity, Consistency, Isolation, Durability

-- 1. Basit Transaction
BEGIN TRANSACTION;
    UPDATE Products SET UnitPrice = UnitPrice * 1.10 WHERE ProductID = 1;
    UPDATE Products SET UnitsInStock = UnitsInStock - 5 WHERE ProductID = 1;
COMMIT TRANSACTION;

-- 2. ROLLBACK
BEGIN TRANSACTION;
    DELETE FROM Products WHERE ProductID = 1;
    -- Hata fark ettik, geri al
    ROLLBACK TRANSACTION;

-- 3. Transaction ile Error Handling
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE Products SET UnitPrice = UnitPrice * 1.10 WHERE CategoryID = 1;
    UPDATE Products SET UnitsInStock = UnitsInStock + 10 WHERE CategoryID = 1;
    COMMIT TRANSACTION;
    PRINT 'Transaction başarılı';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Hata: ' + ERROR_MESSAGE();
END CATCH

-- 4. Nested Transactions
-- İç içe transaction'lar
BEGIN TRANSACTION OuterTran;
    PRINT 'Outer Transaction başladı';
    UPDATE Products SET UnitPrice = 10 WHERE ProductID = 1;

    BEGIN TRANSACTION InnerTran;
        PRINT 'Inner Transaction başladı';
        UPDATE Products SET UnitsInStock = 100 WHERE ProductID = 1;
    COMMIT TRANSACTION InnerTran;

COMMIT TRANSACTION OuterTran;

-- 5. SAVE TRANSACTION (Savepoint)
BEGIN TRANSACTION;
    UPDATE Products SET UnitPrice = 20 WHERE ProductID = 1;
    SAVE TRANSACTION SavePoint1;

    UPDATE Products SET UnitPrice = 30 WHERE ProductID = 2;
    SAVE TRANSACTION SavePoint2;

    UPDATE Products SET UnitPrice = 40 WHERE ProductID = 3;

    -- 3. işlemi geri al, 1 ve 2 kalsın
    ROLLBACK TRANSACTION SavePoint2;
COMMIT TRANSACTION;

-- 6. @@TRANCOUNT
-- Aktif transaction sayısı
PRINT '@@TRANCOUNT: ' + CAST(@@TRANCOUNT AS VARCHAR);  -- 0

BEGIN TRANSACTION;
PRINT '@@TRANCOUNT: ' + CAST(@@TRANCOUNT AS VARCHAR);  -- 1

BEGIN TRANSACTION;
PRINT '@@TRANCOUNT: ' + CAST(@@TRANCOUNT AS VARCHAR);  -- 2

COMMIT TRANSACTION;
PRINT '@@TRANCOUNT: ' + CAST(@@TRANCOUNT AS VARCHAR);  -- 1

COMMIT TRANSACTION;
PRINT '@@TRANCOUNT: ' + CAST(@@TRANCOUNT AS VARCHAR);  -- 0

-- 7. XACT_ABORT
-- Hata durumunda otomatik rollback
SET XACT_ABORT ON;

BEGIN TRANSACTION;
    UPDATE Products SET UnitPrice = 100 WHERE ProductID = 1;
    -- Hata oluşursa otomatik rollback
    UPDATE Products SET UnitPrice = -100 WHERE ProductID = 999;  -- Hata
COMMIT TRANSACTION;

SET XACT_ABORT OFF;

-- 8. Explicit vs Implicit Transactions
-- Explicit (Manuel): BEGIN TRANSACTION ile başlar
-- Implicit (Otomatik): SET IMPLICIT_TRANSACTIONS ON ile

SET IMPLICIT_TRANSACTIONS ON;
    UPDATE Products SET UnitPrice = 100 WHERE ProductID = 1;
COMMIT;  -- Manuel commit gerekli
SET IMPLICIT_TRANSACTIONS OFF;

-- 9. Read Uncommitted (Dirty Read)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SELECT * FROM Products;  -- Commit edilmemiş verileri okuyabilir
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  -- Default

-- 10. Transaction Best Practices
-- - Transaction'ları kısa tutun
-- - User input beklerken transaction içinde olmayın
-- - TRY-CATCH ile error handling yapın
-- - XACT_ABORT kullanın
-- - Deadlock'lara dikkat edin

-- Özet
-- BEGIN TRANSACTION: Transaction başlatır
-- COMMIT: Değişiklikleri kalıcı yapar
-- ROLLBACK: Değişiklikleri geri alır
-- SAVE TRANSACTION: Savepoint oluşturur
-- @@TRANCOUNT: Aktif transaction sayısı
-- XACT_ABORT: Otomatik rollback
-- ACID prensipleri: Atomicity, Consistency, Isolation, Durability

PRINT 'Transactions örnekleri tamamlandı!'
