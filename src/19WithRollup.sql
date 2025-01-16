USE Northwind

--WITH ROLLUP, gruplama i�lemleri s�ras�nda toplamlar� ve alt toplamlar� hesaplamak i�in kullan�l�r.

-- 1. Basit WITH ROLLUP Kullan�m�  
-- �r�nlerin kategorilerine g�re toplam fiyatlar�n� hesaplamak i�in kullan�l�r.  
-- Bu sorgu, her kategori i�in toplam fiyat� ve genel toplam� d�nd�r�r.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP;  

-- 2. WITH ROLLUP ile Birden Fazla S�tun  
-- Kategorilere ve tedarik�ilere g�re toplam fiyatlar� hesaplamak i�in kullan�l�r.  
-- Bu sorgu, her kategori ve tedarik�i i�in toplam fiyat� ve genel toplam� d�nd�r�r.  
SELECT CategoryID, SupplierID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID, SupplierID  
WITH ROLLUP;  

-- 3. WITH ROLLUP ile S�ralama  
-- Gruplama sonu�lar�n� s�ralamak i�in kullan�l�r.  
-- Bu sorgu, her kategori i�in toplam fiyat� ve genel toplam� d�nd�r�r ve sonu�lar� toplam de�ere g�re s�ralar.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP  
ORDER BY TotalValue DESC;  

-- 4. WITH ROLLUP ile NULL De�er Kullan�m�  
-- ROLLUP sonucu NULL de�erleri kullanarak toplamlar� g�sterir.  
-- NULL de�erler, toplamlar� temsil eder.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP;  
-- Burada NULL, toplam de�erleri temsil eder.  

-- 5. WITH ROLLUP ile Filtreleme  
-- Belirli ko�ullara uyan kay�tlar� d�nd�rmek i�in kullan�l�r.  
-- Bu sorgu, yaln�zca fiyat� 20'den b�y�k olan �r�nlerin toplam de�erlerini hesaplar.  
SELECT CategoryID, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
WHERE UnitPrice > 20  
GROUP BY CategoryID  
WITH ROLLUP;  

-- 6. WITH ROLLUP ile Di�er Fonksiyonlar  
-- ROLLUP ile birlikte di�er toplama fonksiyonlar� kullan�labilir.  
-- Bu sorgu, her kategori i�in toplam fiyat� ve genel toplam� d�nd�r�r.  
SELECT CategoryID, COUNT(*) AS ProductCount, SUM(UnitPrice * UnitsInStock) AS TotalValue  
FROM Products  
GROUP BY CategoryID  
WITH ROLLUP;