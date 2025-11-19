USE Northwind

-- SUBQUERY (Alt Sorgu)
-- Subquery, bir SQL sorgusu içinde kullanılan başka bir SQL sorgusudur.
-- Alt sorgular WHERE, FROM, SELECT, HAVING gibi yerlerde kullanılabilir.

-- 1. WHERE Clause'da Scalar Subquery
-- Tek bir değer döndüren alt sorgu
-- Ortalama fiyatın üzerinde olan ürünleri bulma
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC;

-- 2. WHERE Clause'da IN ile Subquery
-- Birden fazla değer döndüren alt sorgu
-- En az bir sipariş vermiş müşterileri listeleme
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID
    FROM Orders
)
ORDER BY CompanyName;

-- 3. WHERE Clause'da NOT IN ile Subquery
-- Hiç sipariş vermemiş müşterileri bulma
SELECT CustomerID, CompanyName, Country
FROM Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM Orders
    WHERE CustomerID IS NOT NULL
)
ORDER BY CompanyName;

-- 4. WHERE Clause'da EXISTS ile Subquery
-- EXISTS, alt sorgunun sonuç döndürüp döndürmediğini kontrol eder
-- En az bir sipariş vermiş müşterileri bulma (EXISTS ile)
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
)
ORDER BY c.CompanyName;

-- 5. WHERE Clause'da NOT EXISTS ile Subquery
-- Hiç sipariş vermemiş müşterileri bulma (NOT EXISTS ile)
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
)
ORDER BY c.CompanyName;

-- 6. WHERE Clause'da ANY ile Subquery
-- Herhangi bir koşulu karşılayan kayıtlar
-- Londra'daki herhangi bir müşteriden daha fazla sipariş vermiş müşteriler
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > ANY (
    SELECT COUNT(*)
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE c.City = 'London'
    GROUP BY o.CustomerID
)
ORDER BY OrderCount DESC;

-- 7. WHERE Clause'da ALL ile Subquery
-- Tüm koşulları karşılayan kayıtlar
-- Tüm ürünlerin ortalama fiyatından pahalı olan ürünler
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > ALL (
    SELECT AVG(UnitPrice)
    FROM Products
    GROUP BY CategoryID
)
ORDER BY UnitPrice DESC;

-- 8. FROM Clause'da Subquery (Derived Table)
-- Alt sorguyu tablo gibi kullanma
-- Her kategorinin ortalama fiyatını bulan alt sorgu
SELECT
    CategoryName,
    AvgPrice,
    CAST(AvgPrice AS DECIMAL(10,2)) AS FormattedPrice
FROM (
    SELECT
        c.CategoryName,
        AVG(p.UnitPrice) AS AvgPrice
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    GROUP BY c.CategoryName
) AS CategoryAverage
ORDER BY AvgPrice DESC;

-- 9. SELECT Clause'da Subquery (Scalar Subquery)
-- Her müşteri için toplam sipariş sayısını gösterme
SELECT
    c.CustomerID,
    c.CompanyName,
    (SELECT COUNT(*) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS TotalOrders,
    (SELECT MAX(OrderDate) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS LastOrderDate
FROM Customers c
WHERE c.Country = 'USA'
ORDER BY TotalOrders DESC;

-- 10. Correlated Subquery (İlişkili Alt Sorgu)
-- Dış sorgudaki her satır için alt sorgu çalışır
-- Her kategoride ortalamadan pahalı ürünleri bulma
SELECT p1.ProductName, p1.UnitPrice, c.CategoryName
FROM Products p1
INNER JOIN Categories c ON p1.CategoryID = c.CategoryID
WHERE p1.UnitPrice > (
    SELECT AVG(p2.UnitPrice)
    FROM Products p2
    WHERE p2.CategoryID = p1.CategoryID
)
ORDER BY c.CategoryName, p1.UnitPrice DESC;

-- 11. HAVING Clause'da Subquery
-- Grup bazında filtreleme için alt sorgu
-- Ortalama sipariş sayısından fazla sipariş veren müşteriler
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > (
    SELECT AVG(OrderCount)
    FROM (
        SELECT COUNT(*) AS OrderCount
        FROM Orders
        GROUP BY CustomerID
    ) AS AvgOrders
)
ORDER BY OrderCount DESC;

-- 12. Nested Subquery (İç İçe Alt Sorgu)
-- Birden fazla seviye alt sorgu
-- En pahalı ürünü satan tedarikçiyi bulma
SELECT SupplierID, CompanyName
FROM Suppliers
WHERE SupplierID = (
    SELECT SupplierID
    FROM Products
    WHERE ProductID = (
        SELECT TOP 1 ProductID
        FROM Products
        ORDER BY UnitPrice DESC
    )
);

-- 13. Subquery ile UPDATE
-- Alt sorgu kullanarak güncelleme
-- Kategorinin ortalama fiyatına göre ürün fiyatlarını güncelleme
UPDATE Products
SET UnitPrice = (
    SELECT AVG(UnitPrice)
    FROM Products p2
    WHERE p2.CategoryID = Products.CategoryID
)
WHERE UnitsInStock = 0;

-- 14. Subquery ile DELETE
-- Alt sorgu kullanarak silme
-- Hiç sipariş detayı olmayan siparişleri silme (örnek - çalıştırmayın!)
-- DELETE FROM Orders
-- WHERE OrderID NOT IN (
--     SELECT DISTINCT OrderID
--     FROM [Order Details]
-- );
SELECT OrderID FROM Orders
WHERE OrderID NOT IN (
    SELECT DISTINCT OrderID
    FROM [Order Details]
);

-- 15. Multiple Column Subquery
-- Birden fazla sütun döndüren alt sorgu
-- Her kategoriden en pahalı ürünü bulma
SELECT p.ProductID, p.ProductName, p.UnitPrice, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE (p.CategoryID, p.UnitPrice) IN (
    SELECT CategoryID, MAX(UnitPrice)
    FROM Products
    GROUP BY CategoryID
)
ORDER BY c.CategoryName;

-- 16. Subquery ile TOP Kullanımı
-- İlk 5 müşterinin sipariş detayları
SELECT o.OrderID, o.CustomerID, o.OrderDate
FROM Orders o
WHERE o.CustomerID IN (
    SELECT TOP 5 CustomerID
    FROM Orders
    GROUP BY CustomerID
    ORDER BY COUNT(*) DESC
)
ORDER BY o.OrderDate DESC;

-- 17. Subquery ile Date Filtering
-- Son 6 ayda sipariş veren müşteriler
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE OrderDate >= DATEADD(MONTH, -6, (SELECT MAX(OrderDate) FROM Orders))
)
ORDER BY CompanyName;

-- 18. Subquery ile String Matching
-- Belirli ürünleri sipariş eden müşteriler
SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Customers c
WHERE c.CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE p.ProductName LIKE '%Chai%'
)
ORDER BY c.CompanyName;

-- 19. Subquery ile Aggregation Comparison
-- Her ülkeden en fazla sipariş veren müşteriyi bulma
SELECT c.Country, c.CompanyName, OrderCount
FROM Customers c
INNER JOIN (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
) AS CustomerOrders ON c.CustomerID = CustomerOrders.CustomerID
WHERE CustomerOrders.OrderCount = (
    SELECT MAX(OrderCount)
    FROM (
        SELECT c2.Country, COUNT(*) AS OrderCount
        FROM Orders o2
        INNER JOIN Customers c2 ON o2.CustomerID = c2.CustomerID
        WHERE c2.Country = c.Country
        GROUP BY c2.Country, c2.CustomerID
    ) AS CountryMax
)
ORDER BY c.Country;

-- 20. Subquery Performance: EXISTS vs IN
-- EXISTS genellikle IN'den daha performanslıdır
-- Özellikle büyük veri setlerinde EXISTS tercih edilmelidir

-- IN kullanımı
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE c.CustomerID IN (
    SELECT CustomerID FROM Orders WHERE YEAR(OrderDate) = 1997
);

-- EXISTS kullanımı (daha performanslı)
SELECT c.CustomerID, c.CompanyName
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o
    WHERE o.CustomerID = c.CustomerID AND YEAR(o.OrderDate) = 1997
);


-- Özet
-- Subquery, bir sorgu içinde çalıştırılan başka bir sorgudur
-- WHERE, FROM, SELECT, HAVING clause'larında kullanılabilir
-- Scalar subquery tek bir değer, liste subquery birden fazla değer döndürür
-- Correlated subquery, dış sorgunun her satırı için çalışır
-- EXISTS genellikle IN'den daha performanslıdır
-- NOT EXISTS, LEFT JOIN ile NULL kontrolüne alternatiftir
-- ANY ve ALL operatörleri liste karşılaştırması yapar
-- Subquery'ler okunabilirlik için CTE ile değiştirilebilir

PRINT 'Subquery örnekleri tamamlandı!'
