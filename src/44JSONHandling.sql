USE Northwind

-- JSON HANDLING (SQL Server 2016+)
-- SQL Server'da JSON verilerini okuma, yazma ve işleme

-- 1. FOR JSON AUTO
-- SQL sonucunu JSON formatına çevirir
SELECT TOP 3
    ProductID,
    ProductName,
    UnitPrice
FROM Products
FOR JSON AUTO;

-- 2. FOR JSON PATH
-- Custom JSON yapısı oluşturma
SELECT TOP 3
    ProductID AS 'product.id',
    ProductName AS 'product.name',
    UnitPrice AS 'product.price'
FROM Products
FOR JSON PATH;

-- 3. FOR JSON with ROOT
SELECT TOP 3 ProductID, ProductName, UnitPrice
FROM Products
FOR JSON AUTO, ROOT('products');

-- 4. ISJSON() - JSON Validation
DECLARE @json NVARCHAR(MAX) = '{"name":"Chai","price":18}';
SELECT ISJSON(@json) AS IsValidJSON;  -- 1 (valid)

DECLARE @badJson NVARCHAR(MAX) = '{invalid json}';
SELECT ISJSON(@badJson) AS IsValidJSON;  -- 0 (invalid)

-- 5. JSON_VALUE() - Tek Değer Çıkarma
DECLARE @productJson NVARCHAR(MAX) = '{"ProductID":1,"ProductName":"Chai","UnitPrice":18.00}';

SELECT
    JSON_VALUE(@productJson, '$.ProductID') AS ProductID,
    JSON_VALUE(@productJson, '$.ProductName') AS ProductName,
    JSON_VALUE(@productJson, '$.UnitPrice') AS UnitPrice;

-- 6. JSON_QUERY() - JSON Object/Array Çıkarma
DECLARE @complexJson NVARCHAR(MAX) = '{
    "product": {
        "id": 1,
        "name": "Chai"
    },
    "categories": ["Beverages", "Hot Drinks"]
}';

SELECT JSON_QUERY(@complexJson, '$.product') AS ProductObject;
SELECT JSON_QUERY(@complexJson, '$.categories') AS CategoriesArray;

-- 7. JSON_MODIFY() - JSON Değiştirme
DECLARE @json2 NVARCHAR(MAX) = '{"name":"Chai","price":18}';

-- Update existing value
SET @json2 = JSON_MODIFY(@json2, '$.price', 20);
SELECT @json2;

-- Add new property
SET @json2 = JSON_MODIFY(@json2, '$.category', 'Beverages');
SELECT @json2;

-- Delete property (set to NULL)
SET @json2 = JSON_MODIFY(@json2, '$.category', NULL);
SELECT @json2;

-- 8. OPENJSON() - JSON'u Tabloya Çevirme
DECLARE @jsonArray NVARCHAR(MAX) = '[
    {"ProductID":1,"ProductName":"Chai","UnitPrice":18},
    {"ProductID":2,"ProductName":"Chang","UnitPrice":19}
]';

SELECT *
FROM OPENJSON(@jsonArray)
WITH (
    ProductID INT '$.ProductID',
    ProductName NVARCHAR(50) '$.ProductName',
    UnitPrice MONEY '$.UnitPrice'
);

-- 9. OPENJSON without WITH Clause
-- Returns key-value pairs
SELECT * FROM OPENJSON('{"name":"Chai","price":18}');

-- 10. Nested JSON
DECLARE @nestedJson NVARCHAR(MAX) = '{
    "order": {
        "id": 123,
        "customer": {
            "name": "John Doe",
            "email": "john@example.com"
        },
        "items": [
            {"product":"Chai", "quantity":2},
            {"product":"Chang", "quantity":1}
        ]
    }
}';

-- Extract nested values
SELECT
    JSON_VALUE(@nestedJson, '$.order.id') AS OrderID,
    JSON_VALUE(@nestedJson, '$.order.customer.name') AS CustomerName,
    JSON_VALUE(@nestedJson, '$.order.customer.email') AS Email;

-- Extract array items
SELECT *
FROM OPENJSON(@nestedJson, '$.order.items')
WITH (
    product NVARCHAR(50) '$.product',
    quantity INT '$.quantity'
);

-- 11. Storing JSON in Database
CREATE TABLE #JsonData (
    ID INT IDENTITY(1,1),
    JsonContent NVARCHAR(MAX) CHECK (ISJSON(JsonContent) = 1)
);

INSERT INTO #JsonData (JsonContent)
VALUES
('{"name":"Product 1","price":10}'),
('{"name":"Product 2","price":20}');

SELECT
    ID,
    JSON_VALUE(JsonContent, '$.name') AS ProductName,
    JSON_VALUE(JsonContent, '$.price') AS Price
FROM #JsonData;

-- 12. JSON_PATH_EXISTS() (SQL Server 2022+)
-- Path varlığını kontrol eder
-- SELECT JSON_PATH_EXISTS(@json, '$.name');

-- 13. Creating Complex JSON
SELECT
    o.OrderID,
    o.OrderDate,
    (
        SELECT
            p.ProductName,
            od.Quantity,
            od.UnitPrice
        FROM [Order Details] od
        INNER JOIN Products p ON od.ProductID = p.ProductID
        WHERE od.OrderID = o.OrderID
        FOR JSON PATH
    ) AS OrderItems
FROM Orders o
WHERE o.OrderID = 10248
FOR JSON PATH;

-- 14. JSON Aggregation
-- STRING_AGG kullanarak manuel JSON oluşturma
SELECT '{' +
    '"ProductID":' + CAST(ProductID AS VARCHAR) + ',' +
    '"ProductName":"' + ProductName + '",' +
    '"UnitPrice":' + CAST(UnitPrice AS VARCHAR) +
'}'
FROM Products
WHERE ProductID = 1;

-- Temizlik
DROP TABLE IF EXISTS #JsonData;

-- Özet
-- FOR JSON: SQL'den JSON'a (AUTO, PATH)
-- ISJSON(): JSON validasyonu
-- JSON_VALUE(): Scalar değer çıkarma
-- JSON_QUERY(): Object/Array çıkarma
-- JSON_MODIFY(): JSON değiştirme
-- OPENJSON(): JSON'dan tabloya
-- JSON index desteklenmez, computed column + index kullanılabilir
-- CHECK constraint ile JSON validasyonu yapılabilir

PRINT 'JSON Handling örnekleri tamamlandı!'
PRINT 'NOT: JSON özellikleri SQL Server 2016+ gerektirir'
