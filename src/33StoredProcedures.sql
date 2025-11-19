USE Northwind

-- STORED PROCEDURES (Saklı Yordamlar)
-- Stored Procedure, önceden derlenmiş SQL kod blokudur.
-- Parametre alabilir, değer döndürebilir, performans artışı sağlar.

-- 1. Basit Stored Procedure
CREATE PROCEDURE usp_GetAllCustomers
AS
BEGIN
    SELECT CustomerID, CompanyName, Country
    FROM Customers
    ORDER BY CompanyName;
END;
GO

-- Çalıştırma
EXEC usp_GetAllCustomers;
GO

-- 2. Input Parametreli Procedure
CREATE PROCEDURE usp_GetCustomersByCountry
    @Country NVARCHAR(15)
AS
BEGIN
    SELECT CustomerID, CompanyName, City
    FROM Customers
    WHERE Country = @Country
    ORDER BY CompanyName;
END;
GO

EXEC usp_GetCustomersByCountry @Country = 'Germany';
EXEC usp_GetCustomersByCountry 'USA';  -- Parametre adı olmadan da çalışır
GO

-- 3. Multiple Parameters
CREATE PROCEDURE usp_GetProductsByPriceRange
    @MinPrice MONEY,
    @MaxPrice MONEY
AS
BEGIN
    SELECT ProductID, ProductName, UnitPrice
    FROM Products
    WHERE UnitPrice BETWEEN @MinPrice AND @MaxPrice
    ORDER BY UnitPrice;
END;
GO

EXEC usp_GetProductsByPriceRange @MinPrice = 10, @MaxPrice = 20;
GO

-- 4. Default Parameter Values
CREATE PROCEDURE usp_GetTopProducts
    @TopCount INT = 10,  -- Default değer
    @CategoryID INT = NULL
AS
BEGIN
    SELECT TOP (@TopCount) ProductID, ProductName, UnitPrice
    FROM Products
    WHERE (@CategoryID IS NULL OR CategoryID = @CategoryID)
    ORDER BY UnitPrice DESC;
END;
GO

EXEC usp_GetTopProducts;  -- Default 10
EXEC usp_GetTopProducts @TopCount = 5;
EXEC usp_GetTopProducts @TopCount = 5, @CategoryID = 1;
GO

-- 5. OUTPUT Parameters
CREATE PROCEDURE usp_GetProductCount
    @CategoryID INT,
    @ProductCount INT OUTPUT
AS
BEGIN
    SELECT @ProductCount = COUNT(*)
    FROM Products
    WHERE CategoryID = @CategoryID;
END;
GO

DECLARE @Count INT;
EXEC usp_GetProductCount @CategoryID = 1, @ProductCount = @Count OUTPUT;
PRINT 'Product Count: ' + CAST(@Count AS VARCHAR);
GO

-- 6. RETURN Statement
CREATE PROCEDURE usp_AddProduct
    @ProductName NVARCHAR(40),
    @UnitPrice MONEY
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Products WHERE ProductName = @ProductName)
    BEGIN
        RETURN -1;  -- Zaten var
    END

    INSERT INTO Products (ProductName, UnitPrice)
    VALUES (@ProductName, @UnitPrice);

    RETURN 0;  -- Başarılı
END;
GO

DECLARE @Result INT;
EXEC @Result = usp_AddProduct @ProductName = 'Test Product', @UnitPrice = 25.00;
IF @Result = 0
    PRINT 'Başarılı';
ELSE
    PRINT 'Hata: Ürün zaten var';
GO

-- 7. Error Handling in Procedures
CREATE PROCEDURE usp_UpdateProductPrice
    @ProductID INT,
    @NewPrice MONEY
AS
BEGIN
    BEGIN TRY
        UPDATE Products
        SET UnitPrice = @NewPrice
        WHERE ProductID = @ProductID;

        IF @@ROWCOUNT = 0
            THROW 50000, 'Ürün bulunamadı', 1;

        PRINT 'Fiyat güncellendi';
    END TRY
    BEGIN CATCH
        PRINT 'Hata: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

-- 8. Transaction in Procedures
CREATE PROCEDURE usp_TransferStock
    @FromProductID INT,
    @ToProductID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Products
        SET UnitsInStock = UnitsInStock - @Quantity
        WHERE ProductID = @FromProductID;

        UPDATE Products
        SET UnitsInStock = UnitsInStock + @Quantity
        WHERE ProductID = @ToProductID;

        COMMIT TRANSACTION;
        PRINT 'Transfer başarılı';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Hata: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

-- 9. ALTER PROCEDURE
ALTER PROCEDURE usp_GetAllCustomers
AS
BEGIN
    SET NOCOUNT ON;  -- "X rows affected" mesajını gizle
    SELECT CustomerID, CompanyName, Country, City  -- City eklendi
    FROM Customers
    ORDER BY CompanyName;
END;
GO

-- 10. Procedure Metadata
SELECT * FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME LIKE 'usp_%';

-- Procedure tanımını görme
EXEC sp_helptext 'usp_GetAllCustomers';

-- 11. DROP PROCEDURE
DROP PROCEDURE IF EXISTS usp_GetAllCustomers;
DROP PROCEDURE IF EXISTS usp_GetCustomersByCountry;
DROP PROCEDURE IF EXISTS usp_GetProductsByPriceRange;
DROP PROCEDURE IF EXISTS usp_GetTopProducts;
DROP PROCEDURE IF EXISTS usp_GetProductCount;
DROP PROCEDURE IF EXISTS usp_AddProduct;
DROP PROCEDURE IF EXISTS usp_UpdateProductPrice;
DROP PROCEDURE IF EXISTS usp_TransferStock;
GO

-- Özet
-- Stored Procedure önceden derlenmiş SQL kodu
-- Input/Output parametreleri alabilir
-- RETURN ile integer değer döndürülebilir
-- Default parameter değerleri tanımlanabilir
-- TRY-CATCH ile error handling yapılabilir
-- Transaction yönetimi içerebilir
-- SET NOCOUNT ON ile mesajlar gizlenebilir
-- Performans ve güvenlik avantajı sağlar

PRINT 'Stored Procedures örnekleri tamamlandı!'
