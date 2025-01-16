USE Northwind


--CASE WHEN THEN ELSE END yapýsý, SQL'de koþullu mantýk uygulamak için kullanýlan bir ifadedir. 
--Bu yapý, belirli koþullara baðlý olarak farklý sonuçlar döndürmek için kullanýlýr. 

--CASE: Koþullu ifadeyi baþlatýr.
--WHEN: Belirli bir koþulu tanýmlar. Eðer bu koþul doðruysa, ardýndan gelen THEN ifadesi çalýþtýrýlýr.
--THEN: WHEN koþulu doðruysa döndürülecek deðeri belirtir.
--ELSE: (isteðe baðlý) Eðer hiçbir WHEN koþulu doðru deðilse döndürülecek deðeri belirtir.
--END: CASE ifadesinin sonunu belirtir.

--Koþullu Mantýk: Veritabanýndaki verileri belirli koþullara göre sýnýflandýrmak veya dönüþtürmek için kullanýlýr. 
--Örneðin, bir ürünün fiyatýna göre "düþük", "orta" veya "yüksek" olarak sýnýflandýrýlmasý.

--Veri Dönüþümü: Veritabanýndaki verileri daha anlamlý hale getirmek için kullanýlabilir. 
--Örneðin, bir ürünün stok durumuna göre "stokta yok", "düþük stok" veya "stokta var" gibi durumlar döndürülebilir.

--Hesaplamalar: Farklý koþullara göre hesaplamalar yapmak için kullanýlabilir.
--Örneðin, ürün fiyatýna göre indirim hesaplamak.


-- 1. Basit CASE Kullanýmý  
-- Ürünlerin fiyatlarýna göre bir fiyat aralýðý belirlemek için kullanýlýr.  
-- Bu sorgu, her ürün için fiyat aralýðýný döndürür.  
SELECT ProductName, UnitPrice,  
       CASE  
           WHEN UnitPrice < 10 THEN 'Low'  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Medium'  
           ELSE 'High'  
       END AS PriceRange  
FROM Products;  

-- 2. CASE ile Gruplama  
-- Ürünlerin fiyat aralýðýna göre gruplama yapmak için kullanýlýr.  
-- Bu sorgu, her fiyat aralýðý için toplam ürün sayýsýný döndürür.  
SELECT  
       CASE  
           WHEN UnitPrice < 10 THEN 'Low'  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Medium'  
           ELSE 'High'  
       END AS PriceRange,  
       COUNT(*) AS ProductCount  
FROM Products  
GROUP BY  
       CASE  
           WHEN UnitPrice < 10 THEN 'Low'  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Medium'  
           ELSE 'High'  
       END;  

-- 3. CASE ile NULL Deðer Kontrolü  
-- Ürünlerin fiyatý NULL ise 'No Price' olarak döndürmek için kullanýlýr.  
-- Bu sorgu, fiyatý NULL olan ürünleri kontrol eder.  
SELECT ProductName,  
       CASE  
           WHEN UnitPrice IS NULL THEN 'No Price'  
           ELSE CAST(UnitPrice AS nvarchar)  
       END AS Price  
FROM Products;  

-- 4. CASE ile Sýralama  
-- Ürünlerin fiyat aralýðýna göre sýralama yapmak için kullanýlýr.  
-- Bu sorgu, ürünleri fiyat aralýðýna göre sýralar.  
SELECT ProductName, UnitPrice,  
       CASE  
           WHEN UnitPrice < 10 THEN 'Low'  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Medium'  
           ELSE 'High'  
       END AS PriceRange  
FROM Products  
ORDER BY  
       CASE  
           WHEN UnitPrice < 10 THEN 1  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN 2  
           ELSE 3  
       END;  

-- 5. CASE ile Birden Fazla Koþul  
-- Ürünlerin fiyatýna ve stok durumuna göre bir durum belirlemek için kullanýlýr.  
-- Bu sorgu, ürünlerin fiyat ve stok durumuna göre durumunu döndürür.  
SELECT ProductName, UnitPrice, UnitsInStock,  
       CASE  
           WHEN UnitsInStock = 0 THEN 'Out of Stock'  
           WHEN UnitPrice < 10 THEN 'Low Price'  
           ELSE 'Available'  
       END AS Availability  
FROM Products;  

-- 6. CASE ile Hesaplama  
-- Ürünlerin fiyatýna göre indirim hesaplamak için kullanýlýr.  
-- Bu sorgu, ürünlerin fiyatýna göre indirimli fiyatý döndürür.  
SELECT ProductName, UnitPrice,  
       CASE  
           WHEN UnitPrice < 10 THEN UnitPrice * 0.9  -- %10 indirim  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN UnitPrice * 0.85  -- %15 indirim  
           ELSE UnitPrice * 0.8  -- %20 indirim  
       END AS DiscountedPrice  
FROM Products;