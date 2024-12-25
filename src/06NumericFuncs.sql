USE Northwind

-- 1. TOPLAM (SUM) ile Sayısal Değerleri Toplama  
-- Tüm siparişlerin toplam nakliye ücretini listele  
SELECT SUM(Freight) AS TotalFreight   
FROM Orders;

-- 2. ORTALAMA (AVG) ile Sayısal Değerlerin Ortalamasını Hesaplama  
-- Ürünlerin ortalama fiyatını listele  
SELECT AVG(UnitPrice) AS AveragePrice   
FROM Products;

-- 3. EN KÜÇÜK (MIN) Değeri Bulma  
-- En düşük fiyatlı ürünü listele  
SELECT MIN(UnitPrice) AS LowestPrice   
FROM Products;

-- 4. EN BÜYÜK (MAX) Değeri Bulma  
-- En yüksek fiyatlı ürünü listele  
SELECT MAX(UnitPrice) AS HighestPrice   
FROM Products;

-- 5. SAYMA (COUNT) ile Kayıt Sayısını Bulma  
-- Toplam sipariş sayısını listele  
SELECT COUNT(*) AS TotalOrders   
FROM Orders;

-- 6. MODÜL (MOD) ile Kalanı Bulma  
-- Stok miktarının 2'ye bölümünden kalan 0 olan ürünleri listele  
SELECT ProductID, ProductName, UnitsInStock   
FROM Products  
WHERE UnitsInStock % 2 = 0;

-- 7. YUVARLAMA (ROUND) ile Sayısal Değerleri Yuvarlama  
-- Ürün fiyatlarını 2 ondalık basamağa yuvarlayarak listele  
SELECT ProductID, ProductName, ROUND(UnitPrice, 2) AS RoundedPrice   
FROM Products;

-- 8. KAREKÖK (SQRT) ile Sayısal Değerlerin Karekökünü Alma  
-- Ürün fiyatlarının karekökünü listele  
SELECT ProductID, ProductName, SQRT(UnitPrice) AS SquareRootPrice   
FROM Products;

-- 9. GÜÇ ALMA (POWER) ile Sayısal Değerlerin Üssünü Hesaplama  
-- Ürün fiyatlarının karesini listele  
SELECT ProductID, ProductName, POWER(UnitPrice, 2) AS PriceSquared   
FROM Products;

-- 10. MUTLAK DEĞER (ABS) ile Negatif Değerleri Pozitife Çevirme  
-- Nakliye ücretlerinin mutlak değerini listele  
SELECT OrderID, Freight, ABS(Freight) AS AbsoluteFreight   
FROM Orders;

-- 11. TAVAN (CEILING) ile Sayıyı Yukarı Yuvarlama  
-- Ürün fiyatlarını yukarı yuvarlayarak listele  
SELECT ProductID, ProductName, CEILING(UnitPrice) AS CeilingPrice   
FROM Products;

-- 12. TABAN (FLOOR) ile Sayıyı Aşağı Yuvarlama  
-- Ürün fiyatlarını aşağı yuvarlayarak listele  
SELECT ProductID, ProductName, FLOOR(UnitPrice) AS FloorPrice   
FROM Products;

-- 13. RASTGELE SAYI ÜRETME (RAND) ile Rastgele Değerler Üretme  
-- Rastgele bir sayı üret ve listele  
SELECT RAND() AS RandomNumber;

-- 14. LOGARİTMA (LOG) ile Sayının Logaritmasını Hesaplama  
-- Ürün fiyatlarının doğal logaritmasını listele  
SELECT ProductID, ProductName, LOG(UnitPrice) AS LogarithmPrice   
FROM Products;

-- 15. FORMAT ile Sayısal Değerleri Formatlama  
-- Nakliye ücretlerini 2 ondalık basamakla formatlayarak listele  
SELECT OrderID, FORMAT(Freight, 'N2') AS FormattedFreight   
FROM Orders;