USE Northwind

-- ERROR HANDLING (Hata Yönetimi)
-- TRY-CATCH blokları ile hata yakalama ve yönetme

-- 1. Basit TRY-CATCH
BEGIN TRY
    SELECT 1/0;  -- Divide by zero hatası
END TRY
BEGIN CATCH
    PRINT 'Hata oluştu!';
END CATCH

-- 2. Error Functions
BEGIN TRY
    UPDATE Products SET UnitPrice = 'ABC' WHERE ProductID = 1;  -- Type mismatch
END TRY
BEGIN CATCH
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
    PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
END CATCH

-- 3. THROW Statement
-- Hata fırlatma (SQL Server 2012+)
BEGIN TRY
    DECLARE @Price MONEY = -10;
    IF @Price < 0
        THROW 50000, 'Fiyat 0''dan küçük olamaz!', 1;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

-- 4. RAISERROR (Eski Yöntem)
BEGIN TRY
    RAISERROR ('Custom error message', 16, 1);
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

-- 5. Transaction ile Error Handling
CREATE TABLE #ErrorLog (
    LogID INT IDENTITY(1,1),
    ErrorMessage NVARCHAR(MAX),
    ErrorDate DATETIME DEFAULT GETDATE()
);

BEGIN TRANSACTION;
BEGIN TRY
    -- Riskli işlemler
    UPDATE Products SET UnitPrice = UnitPrice * 1.10 WHERE CategoryID = 1;
    -- Simulated error
    IF (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = 1) > 50
        THROW 50001, 'Ortalama fiyat çok yüksek!', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    INSERT INTO #ErrorLog (ErrorMessage)
    VALUES (ERROR_MESSAGE());
    PRINT 'Transaction geri alındı';
END CATCH

SELECT * FROM #ErrorLog;

-- 6. Nested TRY-CATCH
BEGIN TRY
    PRINT 'Outer TRY';
    BEGIN TRY
        PRINT 'Inner TRY';
        SELECT 1/0;
    END TRY
    BEGIN CATCH
        PRINT 'Inner CATCH: ' + ERROR_MESSAGE();
        THROW;  -- Outer CATCH'e fırlat
    END CATCH
END TRY
BEGIN CATCH
    PRINT 'Outer CATCH: ' + ERROR_MESSAGE();
END CATCH

-- 7. Custom Error Messages
-- sp_addmessage ile custom error
EXEC sp_addmessage
    @msgnum = 50001,
    @severity = 16,
    @msgtext = 'Bu bir custom error mesajıdır: %s',
    @lang = 'us_english';

BEGIN TRY
    RAISERROR (50001, 16, 1, 'Parameter değeri');
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

-- 8. Error Logging Procedure
CREATE PROCEDURE usp_LogError
AS
BEGIN
    INSERT INTO #ErrorLog (ErrorMessage)
    VALUES (
        'Error ' + CAST(ERROR_NUMBER() AS VARCHAR) +
        ': ' + ERROR_MESSAGE() +
        ' at line ' + CAST(ERROR_LINE() AS VARCHAR)
    );
END;
GO

BEGIN TRY
    SELECT 1/0;
END TRY
BEGIN CATCH
    EXEC usp_LogError;
END CATCH

-- 9. TRY_CONVERT, TRY_CAST, TRY_PARSE
-- Hata vermeden dönüşüm yapar, başarısızda NULL döner
SELECT TRY_CONVERT(INT, 'ABC') AS Result;  -- NULL
SELECT TRY_CAST('123' AS INT) AS Result;  -- 123
SELECT TRY_PARSE('01/25/2023' AS DATE) AS Result;  -- 2023-01-25

-- 10. ISNUMERIC ve Validation
-- Sayısal kontrolü
DECLARE @Value NVARCHAR(10) = '123';
IF ISNUMERIC(@Value) = 1
    PRINT 'Sayısal değer';
ELSE
    PRINT 'Sayısal değil';

-- Temizlik
DROP PROCEDURE IF EXISTS usp_LogError;
DROP TABLE IF EXISTS #ErrorLog;
EXEC sp_dropmessage @msgnum = 50001, @lang = 'us_english';

-- Özet
-- TRY-CATCH: Hata yakalama blokları
-- ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE(): Hata bilgileri
-- THROW: Modern hata fırlatma (SQL 2012+)
-- RAISERROR: Eski hata fırlatma yöntemi
-- TRY_CONVERT, TRY_CAST: Güvenli dönüşüm
-- Transaction ile birlikte kullanarak veri bütünlüğü sağlanır
-- Error logging best practice'dir

PRINT 'Error Handling örnekleri tamamlandı!'
