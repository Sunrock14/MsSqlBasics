USE Northwind

-- USER-DEFINED FUNCTIONS (Kullanıcı Tanımlı Fonksiyonlar)
-- Scalar Functions: Tek değer döndürür
-- Table-Valued Functions: Tablo döndürür

-- 1. SCALAR FUNCTION - Tek Değer Döndüren
CREATE FUNCTION dbo.fn_GetCustomerOrderCount
(
    @CustomerID NCHAR(5)
)
RETURNS INT
AS
BEGIN
    DECLARE @OrderCount INT;

    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;

    RETURN @OrderCount;
END;
GO

-- Kullanımı
SELECT dbo.fn_GetCustomerOrderCount('ALFKI') AS OrderCount;

SELECT
    CustomerID,
    CompanyName,
    dbo.fn_GetCustomerOrderCount(CustomerID) AS TotalOrders
FROM Customers
WHERE Country = 'Germany';
GO

-- 2. Scalar Function - Hesaplama
CREATE FUNCTION dbo.fn_CalculateDiscount
(
    @Price MONEY,
    @DiscountPercent DECIMAL(5,2)
)
RETURNS MONEY
AS
BEGIN
    RETURN @Price * (1 - @DiscountPercent / 100.0);
END;
GO

SELECT
    ProductID,
    ProductName,
    UnitPrice,
    dbo.fn_CalculateDiscount(UnitPrice, 10) AS DiscountedPrice
FROM Products;
GO

-- 3. Inline Table-Valued Function (ITVF)
-- En performanslı function tipi
CREATE FUNCTION dbo.fn_GetProductsByCategory
(
    @CategoryID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        ProductID,
        ProductName,
        UnitPrice,
        UnitsInStock
    FROM Products
    WHERE CategoryID = @CategoryID
);
GO

SELECT * FROM dbo.fn_GetProductsByCategory(1);

-- JOIN ile kullanımı
SELECT
    c.CategoryName,
    p.ProductName,
    p.UnitPrice
FROM Categories c
CROSS APPLY dbo.fn_GetProductsByCategory(c.CategoryID) p
ORDER BY c.CategoryName, p.ProductName;
GO

-- 4. Multi-Statement Table-Valued Function (MTVF)
-- Kompleks logic içerebilir
CREATE FUNCTION dbo.fn_GetProductSummary
(
    @MinPrice MONEY
)
RETURNS @ResultTable TABLE
(
    CategoryName NVARCHAR(15),
    ProductCount INT,
    AvgPrice MONEY,
    TotalStock INT
)
AS
BEGIN
    INSERT INTO @ResultTable
    SELECT
        c.CategoryName,
        COUNT(*) AS ProductCount,
        AVG(p.UnitPrice) AS AvgPrice,
        SUM(p.UnitsInStock) AS TotalStock
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE p.UnitPrice >= @MinPrice
    GROUP BY c.CategoryName;

    RETURN;
END;
GO

SELECT * FROM dbo.fn_GetProductSummary(20);
GO

-- 5. Function ile String İşlemleri
CREATE FUNCTION dbo.fn_FormatPhoneNumber
(
    @Phone NVARCHAR(24)
)
RETURNS NVARCHAR(24)
AS
BEGIN
    IF @Phone IS NULL
        RETURN 'N/A';

    RETURN '(+) ' + LTRIM(RTRIM(@Phone));
END;
GO

SELECT
    CompanyName,
    dbo.fn_FormatPhoneNumber(Phone) AS FormattedPhone
FROM Customers;
GO

-- 6. Function ile Date İşlemleri
CREATE FUNCTION dbo.fn_GetQuarter
(
    @Date DATETIME
)
RETURNS INT
AS
BEGIN
    RETURN CEILING(MONTH(@Date) / 3.0);
END;
GO

SELECT
    OrderID,
    OrderDate,
    dbo.fn_GetQuarter(OrderDate) AS Quarter
FROM Orders
WHERE YEAR(OrderDate) = 1997;
GO

-- 7. Function ile Aggregate
CREATE FUNCTION dbo.fn_GetTotalSales
(
    @OrderID INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;

    SELECT @Total = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO

SELECT
    OrderID,
    OrderDate,
    dbo.fn_GetTotalSales(OrderID) AS TotalSales
FROM Orders
WHERE YEAR(OrderDate) = 1997
ORDER BY TotalSales DESC;
GO

-- 8. Deterministic vs Non-Deterministic
-- Deterministic: Aynı input için her zaman aynı output
-- Non-Deterministic: GETDATE(), NEWID() gibi fonksiyonlar kullanılamaz

-- Bu HATALI (GETDATE() non-deterministic)
/*
CREATE FUNCTION dbo.fn_GetAge (@BirthDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @BirthDate, GETDATE());
END;
*/

-- 9. Function Metadata
SELECT * FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'FUNCTION';

-- Function tanımını görme
EXEC sp_helptext 'dbo.fn_GetCustomerOrderCount';

-- 10. DROP FUNCTION
DROP FUNCTION IF EXISTS dbo.fn_GetCustomerOrderCount;
DROP FUNCTION IF EXISTS dbo.fn_CalculateDiscount;
DROP FUNCTION IF EXISTS dbo.fn_GetProductsByCategory;
DROP FUNCTION IF EXISTS dbo.fn_GetProductSummary;
DROP FUNCTION IF EXISTS dbo.fn_FormatPhoneNumber;
DROP FUNCTION IF EXISTS dbo.fn_GetQuarter;
DROP FUNCTION IF EXISTS dbo.fn_GetTotalSales;
GO

-- Özet
-- Scalar Function: Tek değer döndürür
-- Inline Table-Valued Function: Tablo döndürür (performanslı)
-- Multi-Statement Table-Valued Function: Kompleks logic
-- Function'lar SELECT içinde kullanılabilir
-- CROSS APPLY/OUTER APPLY ile JOIN yapılabilir
-- Deterministic function'lar indexlenebilir
-- Procedure'den farkı: Side-effect olmaması gerekir

PRINT 'User-Defined Functions örnekleri tamamlandı!'
