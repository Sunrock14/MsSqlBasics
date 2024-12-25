USE Northwind

--DISTINCT, bir sorgudan döndürülen sonuçlarda tekrar eden (duplicate) değerleri kaldırmak için kullanılır. 

-- 1. DISTINCT ile Tekrarlayan Değerleri Kaldırma  
-- Siparişlerin gönderildiği benzersiz ülkeleri listele  
SELECT DISTINCT ShipCountry   
FROM Orders;

-- 2. DISTINCT ile Birden Fazla Kolon Kullanımı  
-- Siparişlerin gönderildiği benzersiz ülke ve şehir çiftlerini listele  
SELECT DISTINCT ShipCountry, ShipCity   
FROM Orders;

-- 3. DISTINCT ile Toplam Kayıt Sayısını Bulma  
-- Benzersiz kategorilerin toplam sayısını listele  
SELECT COUNT(DISTINCT CategoryID) AS UniqueCategoryCount   
FROM Products;

-- 3. DISTINCT ile Toplam Kayıt Sayısını Bulma  
-- Benzersiz kategorilerin toplam sayısını listele  
SELECT COUNT(DISTINCT CategoryID) AS UniqueCategoryCount   
FROM Products;

-- 4. DISTINCT ile Şarta Bağlı Kullanım  
-- Nakliye ücreti 100'den büyük olan siparişlerin gönderildiği benzersiz ülkeleri listele  
SELECT DISTINCT ShipCountry   
FROM Orders  
WHERE Freight > 100;

-- 5. DISTINCT ile Birden Fazla Tablo Kullanımı  
-- Sipariş veren müşterilerin benzersiz kimliklerini listele  
SELECT DISTINCT Customers.CustomerID   
FROM Customers  
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 6. DISTINCT ile Tarih Kolonunda Kullanım  
-- Siparişlerin verildiği benzersiz yılları listele  
SELECT DISTINCT YEAR(OrderDate) AS OrderYear   
FROM Orders;

-- 7. DISTINCT ile Birden Fazla Şarta Bağlı Kullanım  
-- Stokta olan ve fiyatı 50'den büyük olan ürünlerin benzersiz kategorilerini listele  
SELECT DISTINCT CategoryID   
FROM Products  
WHERE UnitsInStock > 0 AND UnitPrice > 50;

-- 8. DISTINCT ile CONCAT Kullanımı  
-- Müşteri ad ve soyadlarını birleştirerek benzersiz tam adları listele  
SELECT DISTINCT CONCAT(FirstName, ' ', LastName) AS FullName   
FROM Employees;

-- 9. DISTINCT ile COUNT ve Şarta Bağlı Kullanım  
-- 2023 yılında verilen siparişlerin gönderildiği benzersiz şehir sayısını listele  
SELECT COUNT(DISTINCT ShipCity) AS UniqueCityCount   
FROM Orders  
WHERE YEAR(OrderDate) = 2023;

-- 10. DISTINCT ile Yüzde Kullanımı  
-- Siparişlerin gönderildiği benzersiz ülkelerin %50'sini listele  
SELECT DISTINCT TOP 50 PERCENT ShipCountry   
FROM Orders  
ORDER BY ShipCountry;

-- 11. DISTINCT ile Gruplama ve Toplama  
-- Her kategorideki benzersiz tedarikçi sayısını listele  
SELECT CategoryID, COUNT(DISTINCT SupplierID) AS UniqueSuppliers   
FROM Products  
GROUP BY CategoryID;

-- 12. DISTINCT ile Tarih ve Saat Kullanımı  
-- Siparişlerin verildiği benzersiz tarih ve saatleri listele  
SELECT DISTINCT OrderDate   
FROM Orders;

-- 13. DISTINCT ile NULL Değerleri Dahil Etme  
-- Ürünlerin benzersiz tedarikçi kimliklerini listele (NULL değerler dahil)  
SELECT DISTINCT SupplierID   
FROM Products;

-- 14. DISTINCT ile Birden Fazla Tablo ve Şarta Bağlı Kullanım  
-- 2023 yılında sipariş veren müşterilerin benzersiz kimliklerini listele  
SELECT DISTINCT Customers.CustomerID   
FROM Customers  
JOIN Orders ON Customers.CustomerID = Orders.CustomerID  
WHERE YEAR(Orders.OrderDate) = 2023;

-- 15. DISTINCT ile Birden Fazla Kolon ve Şarta Bağlı Kullanım  
-- Nakliye ücreti 50'den büyük olan siparişlerin gönderildiği benzersiz ülke ve şehir çiftlerini listele  
SELECT DISTINCT ShipCountry, ShipCity   
FROM Orders  
WHERE Freight > 50;