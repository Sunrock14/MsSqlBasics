USE Northwind

--TOP komutu, bir sorgudan döndürülen sonuçların yalnızca belirli bir sayısını veya yüzdesini almak için kullanılır. 
--Bu komut genellikle büyük veri kümelerinde performansı artırmak veya yalnızca en önemli sonuçları göstermek için kullanılır. 

-- 1. TOP ile İlk N Kaydı Getirme  
-- En pahalı 5 ürünü listele  
SELECT TOP 5 ProductID, ProductName, UnitPrice   
FROM Products  
ORDER BY UnitPrice DESC;

-- 2. TOP ile Yüzde Kullanımı  
-- Siparişlerin en üstteki %10'unu listele  
SELECT TOP 10 PERCENT OrderID, OrderDate, Freight   
FROM Orders  
ORDER BY Freight DESC;

-- 3. TOP ile İlk N Kaydı Tarihe Göre Getirme  
-- En son verilen 3 siparişi listele  
SELECT TOP 3 OrderID, OrderDate, CustomerID   
FROM Orders  
ORDER BY OrderDate DESC;

-- 4. TOP ile İlk N Kaydı Şarta Bağlı Getirme  
-- Stokta olan en ucuz 5 ürünü listele  
SELECT TOP 5 ProductID, ProductName, UnitPrice, UnitsInStock   
FROM Products  
WHERE UnitsInStock > 0  
ORDER BY UnitPrice ASC;

-- 5. TOP ile Tedarikçiye Göre İlk N Kaydı Getirme  
-- Her tedarikçiden en pahalı 1 ürünü listele  
SELECT ProductID, ProductName, SupplierID, UnitPrice   
FROM (  
    SELECT ProductID, ProductName, SupplierID, UnitPrice,   
           ROW_NUMBER() OVER (PARTITION BY SupplierID ORDER BY UnitPrice DESC) AS RowNum  
    FROM Products  
) AS RankedProducts  
WHERE RowNum = 1;

-- 6. TOP ile İlk N Kaydı Gruplandırarak Getirme  
-- Her yıl için en yüksek nakliye ücretine sahip 1 siparişi listele  
SELECT OrderYear, OrderID, Freight   
FROM (  
    SELECT YEAR(OrderDate) AS OrderYear, OrderID, Freight,   
           ROW_NUMBER() OVER (PARTITION BY YEAR(OrderDate) ORDER BY Freight DESC) AS RowNum  
    FROM Orders  
) AS RankedOrders  
WHERE RowNum = 1;

-- 7. TOP ile İlk N Kaydı Müşterilere Göre Getirme  
-- Her müşteriden en son verilen 1 siparişi listele  
SELECT CustomerID, OrderID, OrderDate   
FROM (  
    SELECT CustomerID, OrderID, OrderDate,   
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowNum  
    FROM Orders  
) AS RankedOrders  
WHERE RowNum = 1;

-- 8. TOP ile İlk N Kaydı Tarih ve Fiyat Bazında Getirme  
-- En son eklenen 10 ürünü fiyatlarına göre listele  
SELECT TOP 10 ProductID, ProductName, UnitPrice   
FROM Products  
ORDER BY ProductID DESC, UnitPrice DESC;

-- 9. TOP ile İlk %20'lik kısmı listele  
-- Fiyatı en yüksek olan ürünlerin %20'sini listele  
SELECT TOP 20 PERCENT ProductID, ProductName, UnitPrice   
FROM Products  
ORDER BY UnitPrice DESC;

-- 10. TOP ile İlk %5'lik kısmı listele  
-- Nakliye ücreti 100'den büyük olan siparişlerin en üstteki %5'ini listele  
SELECT TOP 5 PERCENT OrderID, OrderDate, Freight   
FROM Orders  
WHERE Freight > 100  
ORDER BY Freight DESC;

-- 11. TOP ile İlk N Kaydı Gruplandırarak ve Şarta Bağlı Getirme  
-- Her kategoriden stokta olan en pahalı 2 ürünü listele  
SELECT CategoryID, ProductID, ProductName, UnitPrice   
FROM (  
    SELECT CategoryID, ProductID, ProductName, UnitPrice, UnitsInStock,   
           ROW_NUMBER() OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS RowNum  
    FROM Products  
    WHERE UnitsInStock > 0  
) AS RankedProducts  
WHERE RowNum <= 2;

-- 12. TOP ile İlk N Kaydı Tarih ve Şarta Bağlı Getirme  
-- 1997 yılında verilen en pahalı 5 siparişi listele  
SELECT TOP 5 OrderID, OrderDate, Freight   
FROM Orders  
WHERE YEAR(OrderDate) = 1997  
ORDER BY Freight DESC;