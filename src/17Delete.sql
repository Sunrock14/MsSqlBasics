USE Northwind

-- 1. Tüm Kayıtları Silme  
-- Customers tablosundaki tüm kayıtları siler.  
-- Dikkatli kullanılmalıdır, çünkü geri alınamaz.  
DELETE FROM Customers;  

-- 2. Belirli Bir Kaydı Silme  
-- Products tablosundaki ProductID'si 5 olan ürünü siler.  
-- WHERE ifadesi, hangi kaydın silineceğini belirtir.  
DELETE FROM Products  
WHERE ProductID = 5;  

-- 3. Birden Fazla Kaydı Silme  
-- Orders tablosundaki toplam tutarı 1000'den fazla olan tüm siparişleri siler.  
-- WHERE ifadesi ile birden fazla kaydı hedefleyebiliriz.  
DELETE FROM Orders  
WHERE TotalAmount > 1000;  

-- 4. Belirli Bir Koşula Göre Kayıt Silme  
-- 2023 yılında verilen tüm siparişleri siler.  
-- YEAR() fonksiyonu ile tarih bazında koşul belirlenir.  
DELETE FROM Orders  
WHERE YEAR(OrderDate) = 2023;  

-- 5. NULL Değerine Sahip Kayıtları Silme  
-- Products tablosundaki fiyatı NULL olan tüm ürünleri siler.  
-- NULL değerleri kontrol etmek için IS NULL kullanılır.  
DELETE FROM Products  
WHERE Price IS NULL;  

-- 6. Alt Sorgu ile Kayıt Silme  
-- Customers tablosundaki CustomerID'si 1 olan müşterinin siparişlerini siler.  
-- Alt sorgu kullanarak belirli bir koşula göre kayıt silinebilir.  
DELETE FROM Orders  
WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE CustomerID = 1);  

-- 7. Belirli Bir Tarih Aralığında Kayıt Silme  
-- 2022 yılına ait tüm siparişleri siler.  
-- BETWEEN ifadesi ile tarih aralığı belirlenir.  
DELETE FROM Orders  
WHERE OrderDate BETWEEN '2022-01-01' AND '2022-12-31';  

-- 8. Birden Fazla Tablodan Kayıt Silme  
-- Products tablosundaki fiyatı 50'den fazla olan ürünleri siler  
-- ve bu ürünlere ait siparişleri Orders tablosundan siler.  
DELETE FROM Orders  
WHERE ProductID IN (SELECT ProductID FROM Products WHERE Price > 50);  

-- 9. JOIN ile Kayıt Silme  
-- Customers tablosundaki belirli bir şehirdeki müşterilerin siparişlerini siler.  
-- INNER JOIN kullanarak iki tabloyu birleştiririz.  
DELETE O  
FROM Orders O  
INNER JOIN Customers C ON O.CustomerID = C.CustomerID  
WHERE C.City = 'New York';  

-- 10. Belirli Bir Müşteri ile İlişkili Kayıtları Silme  
-- Müşteri kimliği 3 olan müşterinin tüm siparişlerini siler.  
DELETE FROM Orders  
WHERE CustomerID = 3;  