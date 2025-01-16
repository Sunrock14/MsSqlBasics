USE Northwind
-- WITH TIES: S�ralama Sonu�lar�nda E�itlik Durumunda Ek Sat�rlar� Dahil Etme  

-- 1. Temel Tan�m ve Ama�  
-- WITH TIES, TOP ifadesiyle birlikte kullan�larak, s�ralama kriterinde e�it olan   
-- t�m sat�rlar�n sonu� k�mesine dahil edilmesini sa�lar. Bu, �zellikle   
-- belirli bir s�ralama kriterine g�re en iyi sonu�lar� almak istedi�inizde   
-- faydal�d�r.  

-- 2. Temel S�zdizimi  
-- SELECT TOP (N) WITH TIES s�tunlar  
-- FROM tablo  
-- ORDER BY s�ralama_s�tunu  

-- 3. Kullan�m Senaryolar�  

-- 3.1 Fiyata G�re En Pahal� �r�nlerin Listelenmesi  
-- �rnek: �lk 3 en pahal� �r�n� listele, fiyatta e�itlik varsa t�m e�it fiyatl� �r�nleri g�ster  
SELECT TOP 3 WITH TIES   
    ProductID,   
    ProductName,   
    UnitPrice  
FROM Products  
ORDER BY UnitPrice DESC;  

-- 3.2 Performans S�ralamas�nda E�itlik Durumu  
-- �rnek: En y�ksek puanl� 5 �al��an� listele, puan e�itli�inde t�m �al��anlar� g�ster  
SELECT TOP 5 WITH TIES   
    EmployeeID,   
    FirstName,   
    LastName,   
    Performance  
FROM Employees  
ORDER BY Performance DESC;  

-- 4. �nemli �zellikleri  
-- - Mutlaka ORDER BY ifadesi ile kullan�lmal�d�r  
-- - E�itlik durumunda, s�ralama kriterindeki e�it de�erlere sahip t�m sat�rlar� d�nd�r�r  
-- - Sonu� k�mesindeki toplam sat�r say�s�, belirtilen TOP de�erinden fazla olabilir  

-- 5. Karma��k Kullan�m �rne�i  
-- Birden fazla s�tuna g�re s�ralama ve e�itlik durumunda t�m sat�rlar� g�sterme  
SELECT TOP 3 WITH TIES   
    CustomerID,   
    CompanyName,   
    Country   
FROM Customers  
ORDER BY   
    CustomerID DESC,   
    Country ASC;  

-- 6. Performans ve Kullan�m �pu�lar�  
-- - B�y�k veri setlerinde dikkatli kullan�lmal�d�r  
-- - Gereksiz yere kullan�lmas� performans� d���rebilir  
-- - Genellikle raporlama ve analiz senaryolar�nda tercih edilir  

-- 7. Alternatif Yakla��mlar  
-- E�er WITH TIES kullan�lmazsa, sadece ilk N sat�r d�nd�r�l�r  
-- E�it de�erler atlan�r  

-- 8. Hata Yakalama ve S�n�rlamalar  
-- - ORDER BY ifadesi olmadan kullan�lamaz  
-- - Genellikle TOP ile birlikte kullan�l�r  
