USE Northwind

-- 1. GROUP BY ile Siparişleri Ülkelere Göre Gruplama  
-- Her ülkeye gönderilen toplam sipariş sayısını listele  
SELECT ShipCountry, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY ShipCountry;

-- 2. GROUP BY ile Ürünleri Kategorilere Göre Gruplama  
-- Her kategoriye ait toplam ürün sayısını listele  
SELECT CategoryID, COUNT(*) AS TotalProducts   
FROM Products  
GROUP BY CategoryID;

-- 3. GROUP BY ile Çalışanları Ünvanlarına Göre Gruplama  
-- Her ünvan için çalışan sayısını listele  
SELECT Title, COUNT(*) AS EmployeeCount   
FROM Employees  
GROUP BY Title;

-- 4. GROUP BY ile Tedarikçileri Ülkelere Göre Gruplama  
-- Her ülkedeki tedarikçi sayısını listele  
SELECT Country, COUNT(*) AS SupplierCount   
FROM Suppliers  
GROUP BY Country;

-- 5. GROUP BY ile Siparişlerin Yıllara Göre Gruplandırılması  
-- Her yıl verilen toplam sipariş sayısını listele  
SELECT YEAR(OrderDate) AS OrderYear, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY YEAR(OrderDate);

-- 6. GROUP BY ile Ürünlerin Ortalama Fiyatlarını Kategorilere Göre Gruplama  
-- Her kategori için ürünlerin ortalama fiyatını listele  
SELECT CategoryID, AVG(UnitPrice) AS AveragePrice   
FROM Products  
GROUP BY CategoryID;

-- 7. GROUP BY ile Çalışanların Yıllara Göre İşe Başlama Sayısı  
-- Her yıl işe başlayan çalışan sayısını listele  
SELECT YEAR(HireDate) AS HireYear, COUNT(*) AS EmployeeCount   
FROM Employees  
GROUP BY YEAR(HireDate);

-- 8. GROUP BY ile Siparişlerin Ülke ve Şehirlere Göre Gruplandırılması  
-- Her ülke ve şehir için toplam sipariş sayısını listele  
SELECT ShipCountry, ShipCity, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY ShipCountry, ShipCity;

-- 9. GROUP BY ile Tedarikçilerin Toplam Ürün Stoklarını Hesaplama  
-- Her tedarikçinin toplam stok miktarını listele  
SELECT Suppliers.CompanyName, SUM(Products.UnitsInStock) AS TotalStock   
FROM Suppliers  
JOIN Products ON Suppliers.SupplierID = Products.SupplierID  
GROUP BY Suppliers.CompanyName;

-- 10. GROUP BY ile Siparişlerin Aylara Göre Gruplandırılması  
-- Her ay verilen toplam sipariş sayısını listele  
SELECT MONTH(OrderDate) AS OrderMonth, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY MONTH(OrderDate);

-- 11. GROUP BY ile Ürünlerin Maksimum Fiyatlarını Kategorilere Göre Gruplama  
-- Her kategori için en yüksek fiyatlı ürünü listele  
SELECT CategoryID, MAX(UnitPrice) AS MaxPrice   
FROM Products  
GROUP BY CategoryID;

-- 12. GROUP BY ile Çalışanların Şehirlere Göre Gruplandırılması  
-- Her şehirde çalışan sayısını listele  
SELECT City, COUNT(*) AS EmployeeCount   
FROM Employees  
GROUP BY City;

-- 13. GROUP BY ile Siparişlerin Yıl ve Ay Bazında Gruplandırılması  
-- Her yıl ve ay için toplam sipariş sayısını listele  
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY YEAR(OrderDate), MONTH(OrderDate)  
ORDER BY OrderYear, OrderMonth;

-- 14. GROUP BY ile Ürünlerin Ortalama Stok Miktarını Kategorilere Göre Gruplama  
-- Her kategori için ürünlerin ortalama stok miktarını listele  
SELECT CategoryID, AVG(UnitsInStock) AS AverageStock   
FROM Products  
GROUP BY CategoryID;

-- 15. GROUP BY ile Siparişlerin Haftalara Göre Gruplandırılması  
-- Her hafta verilen toplam sipariş sayısını listele  
SELECT DATEPART(WEEK, OrderDate) AS OrderWeek, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY DATEPART(WEEK, OrderDate)  
ORDER BY OrderWeek;