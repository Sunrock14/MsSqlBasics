USE Northwind

--HAVING, genellikle GROUP BY ile birlikte kullanılır ve gruplandırılmış verilere filtre uygulamak için kullanılır. WHERE ifadesinden farkı, HAVING'in gruplandırılmış (aggregate) verilere uygulanmasıdır.

-- 1. HAVING ile Gruplandırılmış Verilere Koşul Uygulama  
-- Her ülkeye gönderilen siparişlerin toplam sayısını listele, ancak yalnızca 10'dan fazla sipariş olan ülkeleri göster  
SELECT ShipCountry, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY ShipCountry  
HAVING COUNT(*) > 10;

-- 2. HAVING ile Toplam Değer Üzerinde Koşul Uygulama  
-- Her ülkeye gönderilen siparişlerin toplam nakliye ücretini listele, ancak yalnızca toplam nakliye ücreti 1000'den fazla olan ülkeleri göster  
SELECT ShipCountry, SUM(Freight) AS TotalFreight   
FROM Orders  
GROUP BY ShipCountry  
HAVING SUM(Freight) > 1000;

-- 3. HAVING ile Ortalama Değer Üzerinde Koşul Uygulama  
-- Her kategorideki ürünlerin ortalama fiyatını listele, ancak yalnızca ortalama fiyatı 50'den fazla olan kategorileri göster  
SELECT CategoryID, AVG(UnitPrice) AS AveragePrice   
FROM Products  
GROUP BY CategoryID  
HAVING AVG(UnitPrice) > 50;

-- 3. HAVING ile Ortalama Değer Üzerinde Koşul Uygulama  
-- Her kategorideki ürünlerin ortalama fiyatını listele, ancak yalnızca ortalama fiyatı 50'den fazla olan kategorileri göster  
SELECT CategoryID, AVG(UnitPrice) AS AveragePrice   
FROM Products  
GROUP BY CategoryID  
HAVING AVG(UnitPrice) > 50;

-- 4. HAVING ile Minimum Değer Üzerinde Koşul Uygulama  
-- Her tedarikçiden sağlanan ürünlerin minimum fiyatını listele, ancak yalnızca minimum fiyatı 10'dan büyük olan tedarikçileri göster  
SELECT SupplierID, MIN(UnitPrice) AS MinPrice   
FROM Products  
GROUP BY SupplierID  
HAVING MIN(UnitPrice) > 10;

-- 5. HAVING ile Maksimum Değer Üzerinde Koşul Uygulama  
-- Her kategorideki ürünlerin maksimum fiyatını listele, ancak yalnızca maksimum fiyatı 100'den fazla olan kategorileri göster  
SELECT CategoryID, MAX(UnitPrice) AS MaxPrice   
FROM Products  
GROUP BY CategoryID  
HAVING MAX(UnitPrice) > 100;

-- 6. HAVING ile Birden Fazla Koşul Kullanımı  
-- Her ülkeye gönderilen siparişlerin toplam sayısını ve toplam nakliye ücretini listele,  
-- ancak yalnızca toplam sipariş sayısı 10'dan fazla ve toplam nakliye ücreti 2000'den fazla olan ülkeleri göster  
SELECT ShipCountry, COUNT(*) AS TotalOrders, SUM(Freight) AS TotalFreight   
FROM Orders  
GROUP BY ShipCountry  
HAVING COUNT(*) > 10 AND SUM(Freight) > 2000;

-- 7. HAVING ile Tarih Üzerinde Koşul Uygulama  
-- Her yıl verilen siparişlerin toplam sayısını listele, ancak yalnızca 2023 yılında 50'den fazla sipariş verilen yılları göster  
SELECT YEAR(OrderDate) AS OrderYear, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY YEAR(OrderDate)  
HAVING YEAR(OrderDate) = 2023 AND COUNT(*) > 50;

-- 8. HAVING ile Gruplandırılmış Verilerde NULL Değerleri Filtreleme  
-- Her tedarikçinin toplam ürün sayısını listele, ancak yalnızca tedarikçi kimliği NULL olmayanları göster  
SELECT SupplierID, COUNT(*) AS TotalProducts   
FROM Products  
GROUP BY SupplierID  
HAVING SupplierID IS NOT NULL;

-- 9. HAVING ile Ortalama ve Toplam Değer Üzerinde Koşul Uygulama  
-- Her kategorideki ürünlerin toplam stok miktarını ve ortalama fiyatını listele,  
-- ancak yalnızca toplam stok miktarı 100'den fazla ve ortalama fiyatı 20'den büyük olan kategorileri göster  
SELECT CategoryID, SUM(UnitsInStock) AS TotalStock, AVG(UnitPrice) AS AveragePrice   
FROM Products  
GROUP BY CategoryID  
HAVING SUM(UnitsInStock) > 100 AND AVG(UnitPrice) > 20;

-- 10. HAVING ile COUNT ve Şarta Bağlı Kullanım  
-- Her müşterinin verdiği toplam sipariş sayısını listele, ancak yalnızca 5'ten fazla sipariş veren müşterileri göster  
SELECT CustomerID, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY CustomerID  
HAVING COUNT(*) > 5;

-- 11. HAVING ile Birden Fazla Kolon ve Koşul Kullanımı  
-- Her ülke ve şehir için toplam sipariş sayısını listele,  
-- ancak yalnızca toplam sipariş sayısı 20'den fazla ve toplam nakliye ücreti 5000'den fazla olan ülke-şehir çiftlerini göster  
SELECT ShipCountry, ShipCity, COUNT(*) AS TotalOrders, SUM(Freight) AS TotalFreight   
FROM Orders  
GROUP BY ShipCountry, ShipCity  
HAVING COUNT(*) > 20 AND SUM(Freight) > 5000;

-- 12. HAVING ile MAX ve Şarta Bağlı Kullanım  
-- Her kategorideki ürünlerin maksimum fiyatını listele, ancak yalnızca maksimum fiyatı 200'den fazla olan kategorileri göster  
SELECT CategoryID, MAX(UnitPrice) AS MaxPrice   
FROM Products  
GROUP BY CategoryID  
HAVING MAX(UnitPrice) > 200;