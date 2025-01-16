USE Northwind

--WITH CUBE, çok boyutlu gruplama iþlemleri yaparak tüm kombinasyonlarý ve toplamlarý hesaplamak için kullanýlýr.

-- 1. Basit WITH CUBE Kullanýmý  
-- Ürünlerin kategorilerine ve tedarikçilere göre toplam fiyatlarýný hesaplamak için kullanýlýr.  
-- Bu sorgu, her kategori ve tedarikçi için toplam fiyatý ve genel toplamlarý döndürür.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE;  

-- 2. WITH CUBE ile Birden Fazla Sütun  
-- Kategorilere, tedarikçilere ve fiyat aralýklarýna göre toplam fiyatlarý hesaplamak için kullanýlýr.  
-- Bu sorgu, her kategori ve tedarikçi için toplam fiyatý ve genel toplamlarý döndürür.  
SELECT CategoryID, SupplierID, PriceRange, SUM(UnitPrice * UnitsInStock) AS TotalValue  
	FROM (
		SELECT CategoryID, SupplierID,
			CASE
				WHEN UnitPrice < 10 THEN 'Low'
				WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Medium'
			ELSE 'High'
				END AS PriceRange, UnitPrice, UnitsInStock
		FROM Products ) AS PriceGroups
GROUP BY CategoryID, SupplierID, PriceRange
WITH ROLLUP;


-- 3. WITH CUBE ile Sýralama  
-- Gruplama sonuçlarýný sýralamak için kullanýlýr.  
-- Bu sorgu, her kategori ve tedarikçi için toplam fiyatý ve genel toplamlarý döndürür ve sonuçlarý toplam deðere göre sýralar.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE  
ORDER BY TotalValue DESC;  

-- 4. WITH CUBE ile NULL Deðer Kullanýmý  
-- CUBE sonucu NULL deðerleri kullanarak toplamlarý gösterir.  
-- NULL deðerler, toplamlarý temsil eder.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE;  
-- Burada NULL, toplam deðerleri temsil eder.  

-- 5. WITH CUBE ile Filtreleme  
-- Belirli koþullara uyan kayýtlarý döndürmek için kullanýlýr.  
-- Bu sorgu, yalnýzca fiyatý 20'den büyük olan ürünlerin toplam deðerlerini hesaplar.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
WHERE UnitPrice > 20  
GROUP BY CategoryID, SupplierID  
WITH CUBE;  

-- 6. WITH CUBE ile Diðer Fonksiyonlar  
-- CUBE ile birlikte diðer toplama fonksiyonlarý kullanýlabilir.  
-- Bu sorgu, her kategori ve tedarikçi için toplam fiyatý ve genel toplamlarý döndürür.  
SELECT CategoryID, SupplierID, COUNT(*) AS ProductCount, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE;