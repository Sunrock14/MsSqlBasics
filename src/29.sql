USE Northwind

-- WINDOW FUNCTIONS (Pencere Fonksiyonları)
-- Window functions, OVER() clause kullanarak satırlar üzerinde hesaplama yapar.
-- GROUP BY'dan farklı olarak, her satır korunur.

-- 1. ROW_NUMBER() - Satır Numarası
-- Her satıra benzersiz bir numara atar
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RowNum
FROM Products;

-- 2. RANK() - Sıralama (Atlamalı)
-- Eşit değerler aynı sırayı alır, sonraki sıra atlanır
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    RANK() OVER (ORDER BY UnitPrice DESC) AS PriceRank
FROM Products;

-- 3. DENSE_RANK() - Sık Sıralama (Atlama Yok)
-- Eşit değerler aynı sırayı alır, ama sonraki sıra atlanmaz
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS DenseRank
FROM Products;

-- 4. PARTITION BY - Gruplara Ayırma
-- Her grup içinde ayrı ayrı sıralama yapar
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.UnitPrice,
    ROW_NUMBER() OVER (PARTITION BY p.CategoryID ORDER BY p.UnitPrice DESC) AS RankInCategory
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;

-- 5. NTILE() - Gruplara Bölme
-- Verileri eşit gruplara böler
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    NTILE(4) OVER (ORDER BY UnitPrice) AS PriceQuartile
FROM Products;

-- 6. LAG() - Önceki Satır Değeri
-- Önceki satırın değerini getirir
SELECT
    OrderID,
    OrderDate,
    LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrderDate,
    DATEDIFF(DAY, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) AS DaysSincePrevious
FROM Orders
ORDER BY OrderDate;

-- 7. LEAD() - Sonraki Satır Değeri
-- Sonraki satırın değerini getirir
SELECT
    OrderID,
    OrderDate,
    LEAD(OrderDate) OVER (ORDER BY OrderDate) AS NextOrderDate,
    DATEDIFF(DAY, OrderDate, LEAD(OrderDate) OVER (ORDER BY OrderDate)) AS DaysUntilNext
FROM Orders
ORDER BY OrderDate;

-- 8. FIRST_VALUE() - İlk Değer
-- Pencere içindeki ilk değeri döndürür
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    FIRST_VALUE(ProductName) OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS MostExpensiveInCategory
FROM Products;

-- 9. LAST_VALUE() - Son Değer
-- Pencere içindeki son değeri döndürür
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    LAST_VALUE(ProductName) OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS CheapestInCategory
FROM Products;

-- 10. Aggregate Functions with OVER()
-- SUM, AVG, COUNT, MIN, MAX gibi fonksiyonlar OVER() ile kullanılabilir
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    AVG(UnitPrice) OVER () AS OverallAvg,
    UnitPrice - AVG(UnitPrice) OVER () AS DifferenceFromAvg,
    SUM(UnitPrice) OVER (ORDER BY ProductID) AS RunningTotal
FROM Products;

-- 11. Moving Average (Hareketli Ortalama)
SELECT
    OrderID,
    OrderDate,
    Freight,
    AVG(Freight) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg3
FROM Orders
ORDER BY OrderDate;

-- 12. Cumulative Sum (Kümülatif Toplam)
SELECT
    OrderID,
    OrderDate,
    Freight,
    SUM(Freight) OVER (ORDER BY OrderDate) AS CumulativeFreight
FROM Orders
ORDER BY OrderDate;

-- 13. Top N per Group
-- Her kategoriden en pahalı 3 ürünü bulma
WITH RankedProducts AS (
    SELECT
        p.ProductName,
        c.CategoryName,
        p.UnitPrice,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS Rank
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT * FROM RankedProducts WHERE Rank <= 3;

-- 14. Percentile Calculation
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    PERCENT_RANK() OVER (ORDER BY UnitPrice) AS PercentRank,
    CUME_DIST() OVER (ORDER BY UnitPrice) AS CumulativeDistribution
FROM Products;

-- 15. Frame Specifications
-- ROWS vs RANGE
SELECT
    ProductID,
    UnitPrice,
    -- ROWS: Fiziksel satır sayısı
    AVG(UnitPrice) OVER (ORDER BY ProductID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS AvgRows,
    -- RANGE: Değer aralığı
    AVG(UnitPrice) OVER (ORDER BY UnitPrice RANGE BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS AvgRange
FROM Products;

-- Özet
-- Window functions her satırı korur (GROUP BY gibi birleştirmez)
-- OVER() clause ile kullanılır
-- PARTITION BY ile gruplara bölünebilir
-- ORDER BY pencere içinde sıralama belirler
-- ROWS/RANGE frame tanımlaması yapar
-- ROW_NUMBER, RANK, DENSE_RANK sıralama fonksiyonları
-- LAG, LEAD, FIRST_VALUE, LAST_VALUE pozisyon fonksiyonları
-- Aggregate fonksiyonlar OVER() ile kullanılabilir

PRINT 'Window Functions örnekleri tamamlandı!'
