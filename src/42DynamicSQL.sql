USE Northwind

-- DYNAMIC SQL
-- Runtime'da oluşturulan ve çalıştırılan SQL komutları

-- 1. EXEC ile Basit Dynamic SQL
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = 'SELECT * FROM Products WHERE CategoryID = 1';
EXEC(@SQL);

-- 2. sp_executesql (ÖNERİLEN)
-- Parameterized query desteği, SQL injection'dan korur
DECLARE @Query NVARCHAR(MAX);
DECLARE @CategoryID INT = 1;

SET @Query = N'SELECT * FROM Products WHERE CategoryID = @CatID';
EXEC sp_executesql @Query, N'@CatID INT', @CatID = @CategoryID;

-- 3. Dynamic Table Name
DECLARE @TableName NVARCHAR(128) = N'Products';
DECLARE @SQL2 NVARCHAR(MAX);

SET @SQL2 = N'SELECT TOP 5 * FROM ' + QUOTENAME(@TableName);
EXEC sp_executesql @SQL2;

-- 4. Dynamic WHERE Clause
CREATE PROCEDURE usp_SearchProducts
    @ProductName NVARCHAR(50) = NULL,
    @MinPrice MONEY = NULL,
    @MaxPrice MONEY = NULL
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX) = N'SELECT * FROM Products WHERE 1=1';

    IF @ProductName IS NOT NULL
        SET @SQL = @SQL + N' AND ProductName LIKE @ProdName';

    IF @MinPrice IS NOT NULL
        SET @SQL = @SQL + N' AND UnitPrice >= @MinPr';

    IF @MaxPrice IS NOT NULL
        SET @SQL = @SQL + N' AND UnitPrice <= @MaxPr';

    EXEC sp_executesql @SQL,
        N'@ProdName NVARCHAR(50), @MinPr MONEY, @MaxPr MONEY',
        @ProdName = @ProductName,
        @MinPr = @MinPrice,
        @MaxPr = @MaxPrice;
END;
GO

EXEC usp_SearchProducts @ProductName = '%Chai%', @MinPrice = 10;
GO

-- 5. Dynamic Column List
DECLARE @Columns NVARCHAR(MAX);
DECLARE @DynSQL NVARCHAR(MAX);

SET @Columns = N'ProductID, ProductName, UnitPrice';
SET @DynSQL = N'SELECT ' + @Columns + N' FROM Products';
EXEC sp_executesql @DynSQL;

-- 6. Dynamic ORDER BY
DECLARE @SortColumn NVARCHAR(50) = N'UnitPrice';
DECLARE @SortOrder NVARCHAR(4) = N'DESC';
DECLARE @OrderSQL NVARCHAR(MAX);

SET @OrderSQL = N'SELECT TOP 10 * FROM Products ORDER BY ' +
                QUOTENAME(@SortColumn) + N' ' + @SortOrder;
EXEC sp_executesql @OrderSQL;

-- 7. OUTPUT Parameter ile sp_executesql
DECLARE @CountSQL NVARCHAR(MAX);
DECLARE @Count INT;

SET @CountSQL = N'SELECT @Result = COUNT(*) FROM Products WHERE CategoryID = @CatID';
EXEC sp_executesql @CountSQL,
    N'@CatID INT, @Result INT OUTPUT',
    @CatID = 1,
    @Result = @Count OUTPUT;

PRINT 'Product Count: ' + CAST(@Count AS VARCHAR);

-- 8. Dynamic PIVOT
DECLARE @ColumnList NVARCHAR(MAX);
DECLARE @PivotSQL NVARCHAR(MAX);

SELECT @ColumnList = STRING_AGG(QUOTENAME(CategoryName), ',')
FROM Categories;

SET @PivotSQL = N'
SELECT *
FROM (
    SELECT c.CategoryName, p.ProductID
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
) AS SourceTable
PIVOT (
    COUNT(ProductID)
    FOR CategoryName IN (' + @ColumnList + ')
) AS PivotTable';

EXEC sp_executesql @PivotSQL;

-- 9. SQL Injection Önleme
-- KÖTÜ - SQL Injection açığı
/*
DECLARE @UserInput NVARCHAR(50) = N'''; DROP TABLE Products; --';
DECLARE @BadSQL NVARCHAR(MAX);
SET @BadSQL = N'SELECT * FROM Products WHERE ProductName = ''' + @UserInput + '''';
EXEC(@BadSQL);  -- TEHLİKELİ!
*/

-- İYİ - Parameterized query
DECLARE @SafeInput NVARCHAR(50) = N'''; DROP TABLE Products; --';
DECLARE @SafeSQL NVARCHAR(MAX);
SET @SafeSQL = N'SELECT * FROM Products WHERE ProductName = @Name';
EXEC sp_executesql @SafeSQL, N'@Name NVARCHAR(50)', @Name = @SafeInput;

-- 10. Dynamic CREATE TABLE
DECLARE @NewTableName NVARCHAR(128) = N'#DynamicTable';
DECLARE @CreateSQL NVARCHAR(MAX);

SET @CreateSQL = N'CREATE TABLE ' + QUOTENAME(@NewTableName) + N' (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50)
)';
EXEC sp_executesql @CreateSQL;

-- 11. QUOTENAME ile SQL Injection Önleme
-- Doğru kullanım
DECLARE @ColName NVARCHAR(128) = N'ProductName'; -- User input
DECLARE @QuotedSQL NVARCHAR(MAX);
SET @QuotedSQL = N'SELECT ' + QUOTENAME(@ColName) + N' FROM Products';
EXEC sp_executesql @QuotedSQL;

-- 12. Debug: Dynamic SQL'i Yazdırma
DECLARE @DebugSQL NVARCHAR(MAX);
SET @DebugSQL = N'SELECT * FROM Products WHERE CategoryID = 1';
PRINT @DebugSQL;  -- Test için önce yazdır
-- EXEC sp_executesql @DebugSQL;

-- Temizlik
DROP PROCEDURE IF EXISTS usp_SearchProducts;

-- Özet
-- Dynamic SQL runtime'da oluşturulur
-- EXEC: Basit yürütme
-- sp_executesql: Parameterized, daha güvenli (ÖNERİLEN)
-- QUOTENAME: SQL injection'dan korur
-- OUTPUT parameter desteklenir
-- Performance: Plan cache'den yararlanabilir
-- Güvenlik: Her zaman parameterized query kullanın
-- Debug: PRINT ile SQL'i kontrol edin

PRINT 'Dynamic SQL örnekleri tamamlandı!'
PRINT 'UYARI: SQL Injection riskine karşı dikkatli olun!'
