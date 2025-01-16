USE Northwind

--WITH CUBE, �ok boyutlu gruplama i�lemleri yaparak t�m kombinasyonlar� ve toplamlar� hesaplamak i�in kullan�l�r.

-- 1. Basit WITH CUBE Kullan�m�  
-- �r�nlerin kategorilerine ve tedarik�ilere g�re toplam fiyatlar�n� hesaplamak i�in kullan�l�r.  
-- Bu sorgu, her kategori ve tedarik�i i�in toplam fiyat� ve genel toplamlar� d�nd�r�r.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE;  

-- 2. WITH CUBE ile Birden Fazla S�tun  
-- Kategorilere, tedarik�ilere ve fiyat aral�klar�na g�re toplam fiyatlar� hesaplamak i�in kullan�l�r.  
-- Bu sorgu, her kategori ve tedarik�i i�in toplam fiyat� ve genel toplamlar� d�nd�r�r.  
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


-- 3. WITH CUBE ile S�ralama  
-- Gruplama sonu�lar�n� s�ralamak i�in kullan�l�r.  
-- Bu sorgu, her kategori ve tedarik�i i�in toplam fiyat� ve genel toplamlar� d�nd�r�r ve sonu�lar� toplam de�ere g�re s�ralar.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE  
ORDER BY TotalValue DESC;  

-- 4. WITH CUBE ile NULL De�er Kullan�m�  
-- CUBE sonucu NULL de�erleri kullanarak toplamlar� g�sterir.  
-- NULL de�erler, toplamlar� temsil eder.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE;  
-- Burada NULL, toplam de�erleri temsil eder.  

-- 5. WITH CUBE ile Filtreleme  
-- Belirli ko�ullara uyan kay�tlar� d�nd�rmek i�in kullan�l�r.  
-- Bu sorgu, yaln�zca fiyat� 20'den b�y�k olan �r�nlerin toplam de�erlerini hesaplar.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
WHERE UnitPrice > 20  
GROUP BY CategoryID, SupplierID  
WITH CUBE;  

-- 6. WITH CUBE ile Di�er Fonksiyonlar  
-- CUBE ile birlikte di�er toplama fonksiyonlar� kullan�labilir.  
-- Bu sorgu, her kategori ve tedarik�i i�in toplam fiyat� ve genel toplamlar� d�nd�r�r.  
SELECT CategoryID, SupplierID, COUNT(*) AS ProductCount, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH CUBE;