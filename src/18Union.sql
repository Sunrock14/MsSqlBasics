USE Northwind

-- 1. Basit UNION Kullanýmý  
-- Ýki farklý tablodan veri çekerek birleþtirme, tekrar eden kayýtlarý kaldýrma.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName alýnmaktadýr.  
SELECT ProductName FROM Products  
UNION  
SELECT ContactName FROM Suppliers;  

-- 2. Basit UNION ALL Kullanýmý  
-- Ýki farklý tablodan veri çekerek birleþtirme, tekrar eden kayýtlarý da gösterme.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName alýnmaktadýr.  
SELECT ProductName FROM Products  
UNION ALL  
SELECT ContactName FROM Suppliers;  

-- 3. Farklý Sütun Sayýlarý ile UNION  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName alýnmaktadýr.  
-- Suppliers tablosundaki Country sütunu NULL olarak atanmýþtýr.  
SELECT ProductName, NULL AS Country FROM Products  
UNION  
SELECT ContactName, Country FROM Suppliers;

-- 4. UNION ALL ile Sýralama  
-- Birleþtirilen sonuç kümesini sýralama.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName alýnmaktadýr.  
SELECT ProductName FROM Products  
UNION ALL  
SELECT ContactName FROM Suppliers  
ORDER BY 1 ASC;  -- Sýralama ProductName ve ContactName'e göre yapýlmaktadýr.

-- 5. UNION ile Filtreleme  
-- Belirli koþullara uyan kayýtlarý döndürmek için kullanýlýr.  
-- Products tablosundan yalnýzca fiyatý 20'den büyük olan ürünler ve Suppliers tablosundan 'USA' ülkesindeki tedarikçiler alýnmaktadýr.  
SELECT ProductName FROM Products WHERE UnitPrice > 20  
UNION  
SELECT ContactName FROM Suppliers WHERE Country = 'USA';

-- 6. UNION ALL ile NULL Deðer Kullanýmý  
-- NULL deðerleri birleþtirilen sonuç kümesinde kullanma.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName alýnmaktadýr.  
SELECT ProductName FROM Products  
UNION ALL  
SELECT NULL AS ContactName FROM Suppliers;