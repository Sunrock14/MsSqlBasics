USE Northwind

-- WITH Clause (Common Table Expressions - CTE)
-- CTE, geçici bir sonuç kümesi oluşturur ve sorgu içinde kullanılmasını sağlar.
-- CTE'ler okunabilirliği artırır ve karmaşık sorguları basitleştirir.

-- 1. Basit CTE Kullanımı
-- Temel CTE sözdizimi
WITH CustomerCTE AS (
    SELECT CustomerID, CompanyName, City, Country
    FROM Customers
    WHERE Country = 'Germany'
)
SELECT * FROM CustomerCTE;

-- 2. CTE ile Aggregate Kullanımı
-- Sipariş sayısını hesaplayan CTE
WITH OrderCount AS (
    SELECT CustomerID, COUNT(OrderID) AS TotalOrders
    FROM Orders
    GROUP BY CustomerID
)
SELECT
    c.CompanyName,
    oc.TotalOrders
FROM OrderCount oc
INNER JOIN Customers c ON oc.CustomerID = c.CustomerID
WHERE oc.TotalOrders > 5
ORDER BY oc.TotalOrders DESC;

-- 3. Birden Fazla CTE Kullanımı
-- Virgül ile ayırarak birden fazla CTE tanımlayabilirsiniz
WITH
CustomerOrders AS (
    SELECT CustomerID, COUNT(OrderID) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
),
HighValueCustomers AS (
    SELECT CustomerID, CompanyName
    FROM Customers
    WHERE Country IN ('USA', 'UK', 'Germany')
)
SELECT
    hvc.CompanyName,
    hvc.CustomerID,
    ISNULL(co.OrderCount, 0) AS TotalOrders
FROM HighValueCustomers hvc
LEFT JOIN CustomerOrders co ON hvc.CustomerID = co.CustomerID
ORDER BY TotalOrders DESC;

-- 4. CTE ile JOIN Kullanımı
-- Ürün ve kategori bilgilerini birleştiren CTE
WITH ProductDetails AS (
    SELECT
        p.ProductID,
        p.ProductName,
        p.UnitPrice,
        c.CategoryName
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT
    CategoryName,
    COUNT(*) AS ProductCount,
    AVG(UnitPrice) AS AvgPrice,
    MIN(UnitPrice) AS MinPrice,
    MAX(UnitPrice) AS MaxPrice
FROM ProductDetails
GROUP BY CategoryName
ORDER BY AvgPrice DESC;

-- 5. Recursive CTE (Özyinelemeli CTE)
-- Hiyerarşik veriler için kullanılır
-- Örnek: Çalışan hiyerarşisi (Manager-Employee ilişkisi)
WITH EmployeeHierarchy AS (
    -- Anchor member (temel sorgu): En üst seviye yöneticiler
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        ReportsTo,
        CAST(FirstName + ' ' + LastName AS VARCHAR(255)) AS FullName,
        0 AS Level
    FROM Employees
    WHERE ReportsTo IS NULL

    UNION ALL

    -- Recursive member (özyinelemeli kısım): Alt seviye çalışanlar
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.ReportsTo,
        CAST(eh.FullName + ' -> ' + e.FirstName + ' ' + e.LastName AS VARCHAR(255)),
        eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ReportsTo = eh.EmployeeID
)
SELECT
    EmployeeID,
    REPLICATE('  ', Level) + FirstName + ' ' + LastName AS EmployeeName,
    Level,
    FullName AS HierarchyPath
FROM EmployeeHierarchy
ORDER BY Level, LastName;

-- 6. CTE ile Subquery Yerine Kullanım
-- Karmaşık subquery yerine daha okunabilir CTE kullanımı
-- Ortalama sipariş değerinden yüksek siparişleri bulma
WITH AvgOrderValue AS (
    SELECT AVG(UnitPrice * Quantity) AS AvgValue
    FROM [Order Details]
)
SELECT
    o.OrderID,
    c.CompanyName,
    SUM(od.UnitPrice * od.Quantity) AS OrderTotal
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
CROSS JOIN AvgOrderValue aov
GROUP BY o.OrderID, c.CompanyName
HAVING SUM(od.UnitPrice * od.Quantity) > aov.AvgValue
ORDER BY OrderTotal DESC;

-- 7. CTE ile Sayfalama (Pagination)
-- ROW_NUMBER ile sayfalama yapma
WITH PagedProducts AS (
    SELECT
        ProductID,
        ProductName,
        UnitPrice,
        ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RowNum
    FROM Products
)
SELECT ProductID, ProductName, UnitPrice
FROM PagedProducts
WHERE RowNum BETWEEN 11 AND 20;  -- Sayfa 2 (her sayfa 10 kayıt)

-- 8. CTE ile Veri Temizleme
-- Mükerrer kayıtları tespit etme
WITH DuplicateCheck AS (
    SELECT
        CompanyName,
        City,
        COUNT(*) AS DuplicateCount,
        ROW_NUMBER() OVER (PARTITION BY CompanyName, City ORDER BY CustomerID) AS RowNum
    FROM Customers
    GROUP BY CompanyName, City, CustomerID
)
SELECT CompanyName, City, DuplicateCount
FROM DuplicateCheck
WHERE RowNum > 1;

-- 9. CTE ile Running Total (Kümülatif Toplam)
-- Her siparişin kümülatif toplamını hesaplama
WITH OrderedProducts AS (
    SELECT
        ProductID,
        ProductName,
        UnitPrice,
        ROW_NUMBER() OVER (ORDER BY ProductID) AS RowNum
    FROM Products
)
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    SUM(UnitPrice) OVER (ORDER BY RowNum) AS RunningTotal
FROM OrderedProducts;

-- 10. CTE ile Yüzdelik Hesaplama
-- Her kategorinin toplam satışlardaki payını hesaplama
WITH CategorySales AS (
    SELECT
        c.CategoryName,
        SUM(od.UnitPrice * od.Quantity) AS TotalSales
    FROM [Order Details] od
    INNER JOIN Products p ON od.ProductID = p.ProductID
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    GROUP BY c.CategoryName
),
TotalSalesSum AS (
    SELECT SUM(TotalSales) AS GrandTotal
    FROM CategorySales
)
SELECT
    cs.CategoryName,
    cs.TotalSales,
    CAST(cs.TotalSales * 100.0 / tss.GrandTotal AS DECIMAL(5,2)) AS PercentageOfTotal
FROM CategorySales cs
CROSS JOIN TotalSalesSum tss
ORDER BY cs.TotalSales DESC;

-- 11. CTE ile Date Range Analizi
-- Belirli tarih aralığındaki siparişleri analiz etme
WITH MonthlyOrders AS (
    SELECT
        YEAR(OrderDate) AS OrderYear,
        MONTH(OrderDate) AS OrderMonth,
        COUNT(OrderID) AS OrderCount,
        SUM(Freight) AS TotalFreight
    FROM Orders
    WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT
    OrderYear,
    OrderMonth,
    OrderCount,
    TotalFreight,
    AVG(TotalFreight) OVER () AS AvgMonthlyFreight,
    TotalFreight - AVG(TotalFreight) OVER () AS DeviationFromAvg
FROM MonthlyOrders
ORDER BY OrderYear, OrderMonth;

-- 12. CTE ile Top N Her Grup İçin
-- Her kategoriden en pahalı 3 ürünü getirme
WITH RankedProducts AS (
    SELECT
        p.ProductName,
        p.UnitPrice,
        c.CategoryName,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS PriceRank
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT CategoryName, ProductName, UnitPrice, PriceRank
FROM RankedProducts
WHERE PriceRank <= 3
ORDER BY CategoryName, PriceRank;

-- 13. CTE ile Gap Analysis (Boşluk Analizi)
-- Ardışık olmayan sipariş ID'lerini bulma
WITH OrderSequence AS (
    SELECT
        OrderID,
        LAG(OrderID) OVER (ORDER BY OrderID) AS PreviousOrderID
    FROM Orders
)
SELECT
    PreviousOrderID AS LastOrderID,
    OrderID AS CurrentOrderID,
    OrderID - PreviousOrderID - 1 AS GapSize
FROM OrderSequence
WHERE OrderID - PreviousOrderID > 1
ORDER BY GapSize DESC;

-- 14. CTE ile Update İşlemi
-- CTE kullanarak güncelleme yapma
WITH ProductsToUpdate AS (
    SELECT ProductID, UnitPrice
    FROM Products
    WHERE UnitsInStock < 10 AND UnitPrice < 20
)
UPDATE Products
SET UnitPrice = UnitPrice * 1.10
WHERE ProductID IN (SELECT ProductID FROM ProductsToUpdate);

-- 15. CTE ile Delete İşlemi
-- CTE kullanarak silme yapma (dikkatli kullanın!)
-- Not: Bu sadece örnek amaçlıdır, gerçek verileri silmeden test edin!
WITH OldOrders AS (
    SELECT OrderID
    FROM Orders
    WHERE OrderDate < '1996-01-01'
)
-- DELETE FROM Orders WHERE OrderID IN (SELECT OrderID FROM OldOrders);
-- Yukarıdaki satır yorum satırı - gerçek silme yapmaz
SELECT * FROM OldOrders;  -- Sadece görmek için


-- Özet
-- CTE (Common Table Expression), WITH anahtar kelimesi ile tanımlanır
-- CTE'ler geçicidir, sadece tanımlandıkları sorgu içinde geçerlidir
-- Birden fazla CTE virgülle ayrılarak tanımlanabilir
-- Recursive CTE'ler hiyerarşik veri yapıları için kullanılır
-- CTE'ler karmaşık subquery'leri basitleştirir ve okunabilirliği artırır
-- CTE'ler SELECT, INSERT, UPDATE, DELETE işlemlerinde kullanılabilir
-- Performance açısından VIEW veya subquery ile benzerdir, ama okunabilirlik sağlar

PRINT 'CTE (WITH Clause) örnekleri tamamlandı!'
