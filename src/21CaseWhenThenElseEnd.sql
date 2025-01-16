USE Northwind


--CASE WHEN THEN ELSE END yap�s�, SQL'de ko�ullu mant�k uygulamak i�in kullan�lan bir ifadedir. 
--Bu yap�, belirli ko�ullara ba�l� olarak farkl� sonu�lar d�nd�rmek i�in kullan�l�r. 

--CASE: Ko�ullu ifadeyi ba�lat�r.
--WHEN: Belirli bir ko�ulu tan�mlar. E�er bu ko�ul do�ruysa, ard�ndan gelen THEN ifadesi �al��t�r�l�r.
--THEN: WHEN ko�ulu do�ruysa d�nd�r�lecek de�eri belirtir.
--ELSE: (iste�e ba�l�) E�er hi�bir WHEN ko�ulu do�ru de�ilse d�nd�r�lecek de�eri belirtir.
--END: CASE ifadesinin sonunu belirtir.

--Ko�ullu Mant�k: Veritaban�ndaki verileri belirli ko�ullara g�re s�n�fland�rmak veya d�n��t�rmek i�in kullan�l�r. 
--�rne�in, bir �r�n�n fiyat�na g�re "d���k", "orta" veya "y�ksek" olarak s�n�fland�r�lmas�.

--Veri D�n���m�: Veritaban�ndaki verileri daha anlaml� hale getirmek i�in kullan�labilir. 
--�rne�in, bir �r�n�n stok durumuna g�re "stokta yok", "d���k stok" veya "stokta var" gibi durumlar d�nd�r�lebilir.

--Hesaplamalar: Farkl� ko�ullara g�re hesaplamalar yapmak i�in kullan�labilir.
--�rne�in, �r�n fiyat�na g�re indirim hesaplamak.


-- 1. Basit CASE Kullan�m�  
-- �r�nlerin fiyatlar�na g�re bir fiyat aral��� belirlemek i�in kullan�l�r.  
-- Bu sorgu, her �r�n i�in fiyat aral���n� d�nd�r�r.  
SELECT ProductName, UnitPrice,  
       CASE  
           WHEN UnitPrice < 10 THEN 'Low'  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Medium'  
           ELSE 'High'  
       END AS PriceRange  
FROM Products;  

-- 2. CASE ile Gruplama  
-- �r�nlerin fiyat aral���na g�re gruplama yapmak i�in kullan�l�r.  
-- Bu sorgu, her fiyat aral��� i�in toplam �r�n say�s�n� d�nd�r�r.  
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

-- 3. CASE ile NULL De�er Kontrol�  
-- �r�nlerin fiyat� NULL ise 'No Price' olarak d�nd�rmek i�in kullan�l�r.  
-- Bu sorgu, fiyat� NULL olan �r�nleri kontrol eder.  
SELECT ProductName,  
       CASE  
           WHEN UnitPrice IS NULL THEN 'No Price'  
           ELSE CAST(UnitPrice AS nvarchar)  
       END AS Price  
FROM Products;  

-- 4. CASE ile S�ralama  
-- �r�nlerin fiyat aral���na g�re s�ralama yapmak i�in kullan�l�r.  
-- Bu sorgu, �r�nleri fiyat aral���na g�re s�ralar.  
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

-- 5. CASE ile Birden Fazla Ko�ul  
-- �r�nlerin fiyat�na ve stok durumuna g�re bir durum belirlemek i�in kullan�l�r.  
-- Bu sorgu, �r�nlerin fiyat ve stok durumuna g�re durumunu d�nd�r�r.  
SELECT ProductName, UnitPrice, UnitsInStock,  
       CASE  
           WHEN UnitsInStock = 0 THEN 'Out of Stock'  
           WHEN UnitPrice < 10 THEN 'Low Price'  
           ELSE 'Available'  
       END AS Availability  
FROM Products;  

-- 6. CASE ile Hesaplama  
-- �r�nlerin fiyat�na g�re indirim hesaplamak i�in kullan�l�r.  
-- Bu sorgu, �r�nlerin fiyat�na g�re indirimli fiyat� d�nd�r�r.  
SELECT ProductName, UnitPrice,  
       CASE  
           WHEN UnitPrice < 10 THEN UnitPrice * 0.9  -- %10 indirim  
           WHEN UnitPrice BETWEEN 10 AND 20 THEN UnitPrice * 0.85  -- %15 indirim  
           ELSE UnitPrice * 0.8  -- %20 indirim  
       END AS DiscountedPrice  
FROM Products;