USE Northwind

-- TRIGGERS (Tetikleyiciler)
-- Trigger, belirli bir olay gerçekleştiğinde otomatik çalışan kod bloğudur.
-- INSERT, UPDATE, DELETE işlemlerinde tetiklenir.

-- 1. AFTER INSERT Trigger
CREATE TABLE ProductLog (
    LogID INT IDENTITY(1,1),
    ProductID INT,
    Action NVARCHAR(50),
    LogDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_Products_AfterInsert
ON Products
AFTER INSERT
AS
BEGIN
    INSERT INTO ProductLog (ProductID, Action)
    SELECT ProductID, 'INSERT'
    FROM inserted;
END;
GO

-- Test: INSERT INTO Products (ProductName, UnitPrice) VALUES ('Test', 10);

-- 2. AFTER UPDATE Trigger
CREATE TRIGGER trg_Products_AfterUpdate
ON Products
AFTER UPDATE
AS
BEGIN
    INSERT INTO ProductLog (ProductID, Action)
    SELECT ProductID, 'UPDATE: Price Changed'
    FROM inserted i
    INNER JOIN deleted d ON i.ProductID = d.ProductID
    WHERE i.UnitPrice <> d.UnitPrice;
END;
GO

-- 3. AFTER DELETE Trigger
CREATE TRIGGER trg_Products_AfterDelete
ON Products
AFTER DELETE
AS
BEGIN
    INSERT INTO ProductLog (ProductID, Action)
    SELECT ProductID, 'DELETE'
    FROM deleted;
END;
GO

-- 4. INSTEAD OF Trigger
-- Asıl işlemi yapmaz, trigger içindeki kodu çalıştırır
CREATE VIEW vw_ProductsView AS
SELECT ProductID, ProductName, UnitPrice FROM Products;
GO

CREATE TRIGGER trg_vw_ProductsView_InsteadOfDelete
ON vw_ProductsView
INSTEAD OF DELETE
AS
BEGIN
    -- Gerçekten silmek yerine discontinued yap
    UPDATE Products
    SET Discontinued = 1
    WHERE ProductID IN (SELECT ProductID FROM deleted);

    PRINT 'Ürün silindi yerine discontinued yapıldı';
END;
GO

-- 5. Multiple Triggers
-- Bir tabloda birden fazla trigger olabilir
CREATE TRIGGER trg_Products_AuditTrail
ON Products
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Action NVARCHAR(10);

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Action = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Action = 'INSERT';

    INSERT INTO ProductLog (ProductID, Action)
    SELECT ProductID, @Action
    FROM inserted;
END;
GO

-- 6. Trigger ile Validation
CREATE TRIGGER trg_Products_ValidatePrice
ON Products
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE UnitPrice < 0)
    BEGIN
        RAISERROR ('Fiyat 0''dan küçük olamaz!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 7. Trigger ile Cascade Update
CREATE TABLE #Categories (CategoryID INT PRIMARY KEY, CategoryName NVARCHAR(50));
CREATE TABLE #Products (ProductID INT PRIMARY KEY, CategoryID INT, ProductName NVARCHAR(50));
GO

CREATE TRIGGER trg_Categories_CascadeUpdate
ON #Categories
AFTER UPDATE
AS
BEGIN
    IF UPDATE(CategoryID)
    BEGIN
        UPDATE #Products
        SET CategoryID = i.CategoryID
        FROM #Products p
        INNER JOIN inserted i ON p.CategoryID = i.CategoryID;
    END
END;
GO

-- 8. Nested Triggers
-- Trigger içinden başka trigger tetiklenebilir (dikkatli kullanılmalı)
EXEC sp_configure 'nested triggers', 1;
RECONFIGURE;

-- 9. Trigger Disable/Enable
ALTER TABLE Products DISABLE TRIGGER trg_Products_AfterInsert;
ALTER TABLE Products ENABLE TRIGGER trg_Products_AfterInsert;

-- 10. DROP TRIGGER
DROP TRIGGER IF EXISTS trg_Products_AfterInsert;
DROP TRIGGER IF EXISTS trg_Products_AfterUpdate;
DROP TRIGGER IF EXISTS trg_Products_AfterDelete;
DROP TRIGGER IF EXISTS trg_Products_AuditTrail;
DROP TRIGGER IF EXISTS trg_Products_ValidatePrice;
DROP TRIGGER IF EXISTS trg_vw_ProductsView_InsteadOfDelete;
DROP TRIGGER IF EXISTS trg_Categories_CascadeUpdate;
GO

DROP VIEW IF EXISTS vw_ProductsView;
DROP TABLE IF EXISTS ProductLog;
DROP TABLE IF EXISTS #Products;
DROP TABLE IF EXISTS #Categories;
GO

-- Özet
-- Trigger otomatik çalışan kod bloklarıdır
-- AFTER trigger: İşlem sonrası çalışır
-- INSTEAD OF trigger: İşlem yerine çalışır
-- inserted tablosu: Eklenen/Güncellenen kayıtlar
-- deleted tablosu: Silinen/Eski kayıtlar
-- Audit, validation, cascade operations için kullanılır
-- Performance maliyeti vardır, dikkatli kullanılmalı

PRINT 'Triggers örnekleri tamamlandı!'
