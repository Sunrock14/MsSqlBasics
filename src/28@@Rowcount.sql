USE Northwind

-- @@ROWCOUNT
-- Son çalıştırılan SQL statement'ın etkilediği satır sayısını döndürür.

-- 1. Temel @@ROWCOUNT Kullanımı
SELECT * FROM Customers WHERE Country = 'Germany';
PRINT 'Etkilenen satır sayısı: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- 2. INSERT ile @@ROWCOUNT
CREATE TABLE #TestTable (
    ID INT IDENTITY(1,1),
    Data NVARCHAR(50)
);

INSERT INTO #TestTable (Data) VALUES ('Test 1'), ('Test 2'), ('Test 3');
PRINT 'Eklenen satır sayısı: ' + CAST(@@ROWCOUNT AS VARCHAR);  -- 3

-- 3. UPDATE ile @@ROWCOUNT
UPDATE #TestTable SET Data = 'Updated';
PRINT 'Güncellenen satır sayısı: ' + CAST(@@ROWCOUNT AS VARCHAR);  -- 3

-- 4. DELETE ile @@ROWCOUNT
DELETE FROM #TestTable WHERE ID = 1;
PRINT 'Silinen satır sayısı: ' + CAST(@@ROWCOUNT AS VARCHAR);  -- 1

-- 5. @@ROWCOUNT ile Conditional Logic
UPDATE Products
SET UnitPrice = UnitPrice * 1.10
WHERE ProductID = 9999;  -- Olmayan ID

IF @@ROWCOUNT = 0
BEGIN
    PRINT 'Hiçbir kayıt güncellenmedi!';
END
ELSE
BEGIN
    PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' kayıt güncellendi.';
END

-- 6. @@ROWCOUNT ile Error Handling
BEGIN TRY
    DELETE FROM Products WHERE ProductID = 9999;

    IF @@ROWCOUNT = 0
        THROW 50000, 'Silinecek kayıt bulunamadı!', 1;

    PRINT 'Silme işlemi başarılı';
END TRY
BEGIN CATCH
    PRINT 'Hata: ' + ERROR_MESSAGE();
END CATCH

-- 7. @@ROWCOUNT ile Transaction Control
BEGIN TRANSACTION;

UPDATE #TestTable SET Data = 'Transaction Test';

IF @@ROWCOUNT > 0
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transaction commit edildi';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transaction geri alındı';
END

-- 8. @@ROWCOUNT ile Loop Control
DECLARE @Counter INT = 0;

WHILE @@ROWCOUNT > 0 OR @Counter = 0
BEGIN
    DELETE TOP (2) FROM #TestTable;
    SET @Counter = @Counter + 1;
    PRINT 'Batch ' + CAST(@Counter AS VARCHAR) + ': ' + CAST(@@ROWCOUNT AS VARCHAR) + ' satır silindi';

    IF @Counter > 10 BREAK;  -- Sonsuz döngüden korunma
END

-- 9. @@ROWCOUNT'un Sıfırlanması
SELECT * FROM Customers WHERE Country = 'Germany';
PRINT '@@ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR);  -- SELECT sonucu

-- Herhangi bir statement @@ROWCOUNT'u sıfırlar
SET NOCOUNT OFF;
PRINT '@@ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR);  -- 0 (PRINT sıfırlar)

-- 10. SET NOCOUNT ile @@ROWCOUNT
SET NOCOUNT ON;  -- "X rows affected" mesajını gizler
INSERT INTO #TestTable (Data) VALUES ('Test');
PRINT '@@ROWCOUNT (NOCOUNT ON): ' + CAST(@@ROWCOUNT AS VARCHAR);  -- Yine de çalışır

SET NOCOUNT OFF;

-- 11. @@ROWCOUNT ile Stored Procedure
-- Stored procedure içinde @@ROWCOUNT kullanımı
-- (Örnek amaçlı - gerçek bir proc oluşturmuyoruz)
/*
CREATE PROCEDURE usp_SafeDelete
    @ProductID INT
AS
BEGIN
    DELETE FROM Products WHERE ProductID = @ProductID;

    IF @@ROWCOUNT = 0
        RETURN -1;  -- Başarısız
    ELSE
        RETURN 0;  -- Başarılı
END
*/

-- 12. ROW_NUMBER() vs @@ROWCOUNT
-- ROW_NUMBER(): Her satıra numara atar
-- @@ROWCOUNT: Toplam satır sayısını verir

SELECT TOP 5
    CustomerID,
    CompanyName,
    ROW_NUMBER() OVER (ORDER BY CustomerID) AS RowNum
FROM Customers;

PRINT 'Toplam satır (@@ROWCOUNT): ' + CAST(@@ROWCOUNT AS VARCHAR);  -- 5

-- Temizlik
DROP TABLE IF EXISTS #TestTable;

-- Özet
-- @@ROWCOUNT son statement'ın etkilediği satır sayısını döndürür
-- INSERT, UPDATE, DELETE, SELECT ile kullanılabilir
-- Condition kontrol ve error handling için kullanışlıdır
-- Her statement @@ROWCOUNT değerini değiştirir
-- SET NOCOUNT ON mesajları gizler ama @@ROWCOUNT'u etkilemez
-- Transaction control için faydalıdır
-- Stored procedure'lerde return value olarak kullanılabilir

PRINT '@@ROWCOUNT örnekleri tamamlandı!'
