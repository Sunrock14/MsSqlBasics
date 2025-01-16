USE Northwind

-- 1. Basit UNION Kullan�m�  
-- �ki farkl� tablodan veri �ekerek birle�tirme, tekrar eden kay�tlar� kald�rma.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName al�nmaktad�r.  
SELECT ProductName FROM Products  
UNION  
SELECT ContactName FROM Suppliers;  

-- 2. Basit UNION ALL Kullan�m�  
-- �ki farkl� tablodan veri �ekerek birle�tirme, tekrar eden kay�tlar� da g�sterme.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName al�nmaktad�r.  
SELECT ProductName FROM Products  
UNION ALL  
SELECT ContactName FROM Suppliers;  

-- 3. Farkl� S�tun Say�lar� ile UNION  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName al�nmaktad�r.  
-- Suppliers tablosundaki Country s�tunu NULL olarak atanm��t�r.  
SELECT ProductName, NULL AS Country FROM Products  
UNION  
SELECT ContactName, Country FROM Suppliers;

-- 4. UNION ALL ile S�ralama  
-- Birle�tirilen sonu� k�mesini s�ralama.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName al�nmaktad�r.  
SELECT ProductName FROM Products  
UNION ALL  
SELECT ContactName FROM Suppliers  
ORDER BY 1 ASC;  -- S�ralama ProductName ve ContactName'e g�re yap�lmaktad�r.

-- 5. UNION ile Filtreleme  
-- Belirli ko�ullara uyan kay�tlar� d�nd�rmek i�in kullan�l�r.  
-- Products tablosundan yaln�zca fiyat� 20'den b�y�k olan �r�nler ve Suppliers tablosundan 'USA' �lkesindeki tedarik�iler al�nmaktad�r.  
SELECT ProductName FROM Products WHERE UnitPrice > 20  
UNION  
SELECT ContactName FROM Suppliers WHERE Country = 'USA';

-- 6. UNION ALL ile NULL De�er Kullan�m�  
-- NULL de�erleri birle�tirilen sonu� k�mesinde kullanma.  
-- Products tablosundan ProductName ve Suppliers tablosundan ContactName al�nmaktad�r.  
SELECT ProductName FROM Products  
UNION ALL  
SELECT NULL AS ContactName FROM Suppliers;