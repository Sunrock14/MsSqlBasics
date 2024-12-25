Use Northwind

-- 1. Basit Koşul ile Filtreleme  
-- Şehir değeri 'London' olan müşterileri listele  
SELECT CustomerID, CompanyName, City   
FROM Customers  
WHERE City = 'London';  

-- 2. Birden Fazla Koşul (AND Kullanımı)  
-- Şehir değeri 'London' olan ve şirket adı 'Around the Horn' olan müşterileri listele  
SELECT CustomerID, CompanyName, City   
FROM Customers  
WHERE City = 'London' AND CompanyName = 'Around the Horn';

-- 3. Alternatif Koşullar (OR Kullanımı)  
-- Şehir değeri 'London' veya 'Berlin' olan müşterileri listele  
SELECT CustomerID, CompanyName, City   
FROM Customers  
WHERE City = 'London' OR City = 'Berlin';

-- 4. NOT ile Koşulları Tersine Çevirme  
-- Şehir değeri 'London' olmayan müşterileri listele  
SELECT CustomerID, CompanyName, City   
FROM Customers  
WHERE NOT City = 'London';

-- 5. LIKE ile Pattern Arama  
-- Şirket adı 'A' harfiyle başlayan müşterileri listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE CompanyName LIKE 'A%';  

-- Şirket adı 's' harfiyle biten müşterileri listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE CompanyName LIKE '%s';  

-- Şirket adında 'ar' geçen müşterileri listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE CompanyName LIKE '%ar%';


-- 6. BETWEEN ile Aralık Belirlemek  
-- 1997 yılına ait siparişleri listele  
SELECT OrderID, CustomerID, OrderDate   
FROM Orders  
WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31';  

-- Fiyatı 10 ile 20 arasında olan ürünleri listele  
SELECT ProductID, ProductName, UnitPrice   
FROM Products  
WHERE UnitPrice BETWEEN 10 AND 20;


-- 7. IN ile Belirli Değerleri Seçmek  
-- Şehir değeri 'London', 'Berlin' veya 'Madrid' olan müşterileri listele  
SELECT CustomerID, CompanyName, City   
FROM Customers  
WHERE City IN ('London', 'Berlin', 'Madrid');


-- 8. NULL Değerleri Kontrol Etmek  
-- Telefon numarası olmayan müşterileri listele  
SELECT CustomerID, CompanyName, Phone   
FROM Customers  
WHERE Phone IS NULL;  

-- Telefon numarası olan müşterileri listele  
SELECT CustomerID, CompanyName, Phone   
FROM Customers  
WHERE Phone IS NOT NULL;

-- 9. Matematiksel Koşullar  
-- Fiyatı 50'den büyük olan ürünleri listele  
SELECT ProductID, ProductName, UnitPrice   
FROM Products  
WHERE UnitPrice > 50;  

-- Stok miktarı 10 ile 50 arasında olan ürünleri listele  
SELECT ProductID, ProductName, UnitsInStock   
FROM Products  
WHERE UnitsInStock >= 10 AND UnitsInStock <= 50;


-- 10. String Fonksiyonları ile Koşullar  
-- Şirket adı 10 karakterden uzun olan müşterileri listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE LEN(CompanyName) > 10;  

-- Şirket adında 'a' harfi geçen müşterileri listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE CHARINDEX('a', CompanyName) > 0;

-- 11. CASE ile Koşullu Filtreleme  
-- Siparişlerin durumuna göre filtreleme: 1997'den önceki siparişleri listele  
SELECT OrderID, CustomerID, OrderDate   
FROM Orders  
WHERE   
    CASE   
        WHEN YEAR(OrderDate) < 1997 THEN 1  
        ELSE 0  
    END = 1;

-- 12. ALT SORGULAR (Subqueries) ile Koşullar  
-- En pahalı ürünün fiyatına eşit olan ürünleri listele  
SELECT ProductID, ProductName, UnitPrice   
FROM Products  
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products);  

-- En fazla sipariş veren müşteriyi listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE CustomerID = (  
    SELECT TOP 1 CustomerID   
    FROM Orders   
    GROUP BY CustomerID   
    ORDER BY COUNT(OrderID) DESC  
);

-- 13. NOT IN ile Koşullar  
-- Sipariş vermeyen müşterileri listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 14. EXISTS ile Koşullar  
-- Sipariş vermiş müşterileri listele  
SELECT CustomerID, CompanyName   
FROM Customers  
WHERE EXISTS (  
    SELECT 1   
    FROM Orders   
    WHERE Orders.CustomerID = Customers.CustomerID  
);

-- 15. Boolean Mantığı ile Karmaşık Koşullar  
-- Şehir değeri 'London' olan veya fiyatı 50'den büyük olan ürünleri listele  
SELECT ProductID, ProductName, UnitPrice   
FROM Products  
WHERE (UnitPrice > 50) OR (ProductID IN (SELECT ProductID FROM Orders WHERE ShipCity = 'London'));