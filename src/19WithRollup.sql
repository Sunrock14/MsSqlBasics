USE Northwind

--WITH ROLLUP, gruplama iþlemleri sýrasýnda toplamlarý ve alt toplamlarý hesaplamak için kullanýlýr.

-- 1. Basit WITH ROLLUP Kullanýmý  
-- Ürünlerin kategorilerine göre toplam fiyatlarýný hesaplamak için kullanýlýr.  
-- Bu sorgu, her kategori için toplam fiyatý ve genel toplamý döndürür.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP;  

-- 2. WITH ROLLUP ile Birden Fazla Sütun  
-- Kategorilere ve tedarikçilere göre toplam fiyatlarý hesaplamak için kullanýlýr.  
-- Bu sorgu, her kategori ve tedarikçi için toplam fiyatý ve genel toplamý döndürür.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH ROLLUP;  

-- 3. WITH ROLLUP ile Sýralama  
-- Gruplama sonuçlarýný sýralamak için kullanýlýr.  
-- Bu sorgu, her kategori için toplam fiyatý ve genel toplamý döndürür ve sonuçlarý toplam deðere göre sýralar.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP  
ORDER BY TotalValue DESC;  

-- 4. WITH ROLLUP ile NULL Deðer Kullanýmý  
-- ROLLUP sonucu NULL deðerleri kullanarak toplamlarý gösterir.  
-- NULL deðerler, toplamlarý temsil eder.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP;  
-- Burada NULL, toplam deðerleri temsil eder.  

-- 5. WITH ROLLUP ile Filtreleme  
-- Belirli koþullara uyan kayýtlarý döndürmek için kullanýlýr.  
-- Bu sorgu, yalnýzca fiyatý 20'den büyük olan ürünlerin toplam deðerlerini hesaplar.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
WHERE UnitPrice > 20  
GROUP BY CategoryID  
WITH ROLLUP;  

-- 6. WITH ROLLUP ile Diðer Fonksiyonlar  
-- ROLLUP ile birlikte diðer toplama fonksiyonlarý kullanýlabilir.  
-- Bu sorgu, her kategori için toplam fiyatý ve genel toplamý döndürür.  
SELECT CategoryID, COUNT(*) AS ProductCount, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP;