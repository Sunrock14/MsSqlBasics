USE Northwind

-- 1. ORDER BY ile Artan Sıralama  
-- Siparişleri tarihe göre artan sırada listele  
-- `ORDER BY` ifadesi, sonuçları belirli bir sütuna göre sıralamak için kullanılır.  
-- `ASC` (artan) sıralama varsayılan olduğu için yazılmasa da okunabilirlik için eklenmiştir.  
SELECT OrderID, OrderDate, CustomerID, Freight  
FROM Orders  
ORDER BY OrderDate ASC;  

-- 2. ORDER BY ile Azalan Sıralama  
-- Siparişleri nakliye ücretine göre azalan sırada listele  
-- `DESC` ifadesi, sıralamanın azalan sırada yapılmasını sağlar.  
SELECT OrderID, Freight, ShipCountry  
FROM Orders  
ORDER BY Freight DESC;  

-- 3. ORDER BY ile Birden Fazla Sütuna Göre Sıralama  
-- Siparişleri önce ülkeye göre artan, ardından şehre göre azalan sırada listele  
-- Birden fazla sütun sıralaması yapılabilir. İlk sütun artan, ikinci sütun azalan sırada sıralanır.  
SELECT OrderID, ShipCountry, ShipCity  
FROM Orders  
ORDER BY ShipCountry ASC, ShipCity DESC;  

-- 4. ORDER BY ile Tarih Sütununda Yıl Bazında Sıralama  
-- Siparişleri sipariş yılını artan sırada listele  
-- Tarih sütunları üzerinde yıl, ay veya gün bazında sıralama yapılabilir.  
SELECT OrderID, YEAR(OrderDate) AS OrderYear, CustomerID  
FROM Orders  
ORDER BY YEAR(OrderDate) ASC;  

-- 5. ORDER BY ile NULL Değerleri En Alta Alma  
-- Siparişleri nakliye ücretine göre artan sırada listele, NULL değerleri en alta al  
-- `NULLS LAST` ifadesi, sıralamada NULL değerlerin en alta alınmasını sağlar.  
SELECT OrderID, Freight, ShipCountry  
FROM Orders  
ORDER BY CASE WHEN Freight IS NULL THEN 1 ELSE 0 END, Freight ASC;

-- 6. ORDER BY ile NULL Değerleri En Üste Alma  
-- Siparişleri nakliye ücretine göre artan sırada listele, NULL değerleri en üste al  
-- `NULLS FIRST` ifadesi, sıralamada NULL değerlerin en üste alınmasını sağlar.  
SELECT OrderID, Freight, ShipCountry  
FROM Orders  
ORDER BY 
    CASE WHEN Freight IS NULL THEN 1 ELSE 0 END,
    Freight;


-- 7. ORDER BY ile İlk Harfe Göre Sıralama  
-- Şehir adına göre artan sırada listele, ancak yalnızca "A" harfiyle başlayan şehirleri göster  
-- `LIKE 'A%'` ifadesi, yalnızca "A" harfiyle başlayan şehirleri filtreler.  
SELECT OrderID, ShipCity, ShipCountry  
FROM Orders  
WHERE ShipCity LIKE 'A%'  
ORDER BY ShipCity ASC;  

-- 8. ORDER BY ile Sabit Değer Kullanımı  
-- Siparişleri sabit bir sütun sırasına göre sıralama  
-- Sütun sırası numarası kullanılarak sıralama yapılabilir. Burada 2. sütun sıralanır.  
SELECT OrderID, OrderDate, CustomerID, Freight  
FROM Orders  
ORDER BY 2 ASC;  

-- 9. ORDER BY ile İlk 10 Kaydı Listeleme  
-- Nakliye ücretine göre en yüksek 10 siparişi listele  
-- `TOP 10` ifadesi, yalnızca en yüksek 10 kaydı döndürür.  
SELECT TOP 10 OrderID, Freight, ShipCountry  
FROM Orders  
ORDER BY Freight DESC;  

-- 10. ORDER BY ile Yıl ve Nakliye Ücretine Göre Sıralama  
-- Siparişleri önce yıla, ardından nakliye ücretine göre azalan sırada listele  
-- Birden fazla sütun sıralaması yapılabilir. İlk sütun artan, ikinci sütun azalan sırada sıralanır.  
SELECT OrderID, YEAR(OrderDate) AS OrderYear, Freight  
FROM Orders  
ORDER BY YEAR(OrderDate) ASC, Freight DESC;  

-- 11. ORDER BY ile Tarih ve Saat Bazında Sıralama  
-- Siparişleri önce tarihe, ardından saate göre sıralama  
-- Tarih ve saat bazında sıralama yapılabilir.  
SELECT OrderID, OrderDate, CustomerID  
FROM Orders  
ORDER BY OrderDate ASC, OrderID ASC;  

-- 12. ORDER BY ile Rastgele Sıralama  
-- Siparişleri rastgele sırada listele  
-- `NEWID()` ifadesi, her çalıştırmada rastgele bir sıralama oluşturur.  
SELECT OrderID, OrderDate, CustomerID  
FROM Orders  
ORDER BY NEWID();  

-- 13. ORDER BY ile Sabit Değer ve Dinamik Sıralama  
-- Siparişleri sabit bir sütun sırasına göre sıralama  
-- Dinamik sıralama için CASE ifadesi kullanılabilir.  
SELECT OrderID, ShipCountry, Freight  
FROM Orders  
ORDER BY  
    CASE  
        WHEN ShipCountry = 'USA' THEN 1  
        WHEN ShipCountry = 'UK' THEN 2  
        ELSE 3  
    END ASC;  