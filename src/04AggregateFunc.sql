USE Northwind

-- 1. COUNT ile Toplam Kayıt Sayısını Bulma  
-- Toplam sipariş sayısını listele  
SELECT COUNT(*) AS TotalOrders   
FROM Orders;

-- 2. COUNT ile Belirli Bir Kolonun Boş Olmayan Değerlerini Sayma  
-- Fiyatı belirtilmiş ürünlerin sayısını listele  
SELECT COUNT(UnitPrice) AS PricedProducts   
FROM Products;

-- 3. SUM ile Toplam Değer Hesaplama  
-- Tüm siparişlerin toplam nakliye ücretini listele  
SELECT SUM(Freight) AS TotalFreight   
FROM Orders;

-- 4. AVG ile Ortalama Değer Hesaplama  
-- Ürünlerin ortalama fiyatını listele  
SELECT AVG(UnitPrice) AS AveragePrice   
FROM Products;

-- 5. MIN ile Minimum Değeri Bulma  
-- En düşük fiyatlı ürünü listele  
SELECT MIN(UnitPrice) AS LowestPrice   
FROM Products;

-- 6. MAX ile Maksimum Değeri Bulma  
-- En yüksek fiyatlı ürünü listele  
SELECT MAX(UnitPrice) AS HighestPrice   
FROM Products;

-- 7. COUNT ile Belirli Bir Şartı Sağlayan Kayıtları Sayma  
-- Gönderim ülkesi 'USA' olan siparişlerin sayısını listele  
SELECT COUNT(*) AS OrdersToUSA   
FROM Orders  
WHERE ShipCountry = 'USA';

-- 8. SUM ile Belirli Bir Şartı Sağlayan Değerlerin Toplamını Hesaplama  
-- Stokta 50'den fazla olan ürünlerin toplam stok miktarını listele  
SELECT SUM(UnitsInStock) AS TotalStock   
FROM Products  
WHERE UnitsInStock > 50;

-- 9. AVG ile Belirli Bir Şartı Sağlayan Değerlerin Ortalamasını Hesaplama  
-- Fiyatı 20'den büyük olan ürünlerin ortalama fiyatını listele  
SELECT AVG(UnitPrice) AS AverageExpensiveProducts   
FROM Products  
WHERE UnitPrice > 20;

-- 10. MIN ve MAX ile Tarih Aralığını Bulma  
-- İlk ve son sipariş tarihlerini listele  
SELECT MIN(OrderDate) AS FirstOrderDate,   
       MAX(OrderDate) AS LastOrderDate   
FROM Orders;

-- 11. COUNT ile Çalışanların Ünvanlarını Sayma  
-- Her bir ünvanın kaç çalışan tarafından kullanıldığını listele  
SELECT Title, COUNT(*) AS EmployeeCount   
FROM Employees  
GROUP BY Title;

-- 12. SUM ile Tedarikçilerin Toplam Ürün Stoklarını Hesaplama  
-- Her tedarikçinin toplam stok miktarını listele  
SELECT Suppliers.CompanyName, SUM(Products.UnitsInStock) AS TotalStock   
FROM Suppliers  
JOIN Products ON Suppliers.SupplierID = Products.SupplierID  
GROUP BY Suppliers.CompanyName;

-- 13. AVG ile Çalışanların Ortalama Yaşını Hesaplama  
-- Çalışanların ortalama yaşını listele  
SELECT AVG(DATEDIFF(YEAR, BirthDate, GETDATE())) AS AverageAge   
FROM Employees;

-- 14. MAX ile En Yüksek Sipariş Tutarını Bulma  
-- En yüksek nakliye ücretine sahip siparişi listele  
SELECT MAX(Freight) AS HighestFreight   
FROM Orders;

-- 15. COUNT ile Tedarikçi Sayısını Bulma  
-- Toplam tedarikçi sayısını listele  
SELECT COUNT(*) AS TotalSuppliers   
FROM Suppliers;