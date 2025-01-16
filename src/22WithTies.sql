USE Northwind
-- WITH TIES: Sýralama Sonuçlarýnda Eþitlik Durumunda Ek Satýrlarý Dahil Etme  

-- 1. Temel Taným ve Amaç  
-- WITH TIES, TOP ifadesiyle birlikte kullanýlarak, sýralama kriterinde eþit olan   
-- tüm satýrlarýn sonuç kümesine dahil edilmesini saðlar. Bu, özellikle   
-- belirli bir sýralama kriterine göre en iyi sonuçlarý almak istediðinizde   
-- faydalýdýr.  

-- 2. Temel Sözdizimi  
-- SELECT TOP (N) WITH TIES sütunlar  
-- FROM tablo  
-- ORDER BY sýralama_sütunu  

-- 3. Kullaným Senaryolarý  

-- 3.1 Fiyata Göre En Pahalý Ürünlerin Listelenmesi  
-- Örnek: Ýlk 3 en pahalý ürünü listele, fiyatta eþitlik varsa tüm eþit fiyatlý ürünleri göster  
SELECT TOP 3 WITH TIES   
    ProductID,   
    ProductName,   
    UnitPrice  
FROM Products  
ORDER BY UnitPrice DESC;  

-- 3.2 Performans Sýralamasýnda Eþitlik Durumu  
-- Örnek: En yüksek puanlý 5 çalýþaný listele, puan eþitliðinde tüm çalýþanlarý göster  
SELECT TOP 5 WITH TIES   
    EmployeeID,   
    FirstName,   
    LastName,   
    Performance  
FROM Employees  
ORDER BY Performance DESC;  

-- 4. Önemli Özellikleri  
-- - Mutlaka ORDER BY ifadesi ile kullanýlmalýdýr  
-- - Eþitlik durumunda, sýralama kriterindeki eþit deðerlere sahip tüm satýrlarý döndürür  
-- - Sonuç kümesindeki toplam satýr sayýsý, belirtilen TOP deðerinden fazla olabilir  

-- 5. Karmaþýk Kullaným Örneði  
-- Birden fazla sütuna göre sýralama ve eþitlik durumunda tüm satýrlarý gösterme  
SELECT TOP 3 WITH TIES   
    CustomerID,   
    CompanyName,   
    Country   
FROM Customers  
ORDER BY   
    CustomerID DESC,   
    Country ASC;  

-- 6. Performans ve Kullaným Ýpuçlarý  
-- - Büyük veri setlerinde dikkatli kullanýlmalýdýr  
-- - Gereksiz yere kullanýlmasý performansý düþürebilir  
-- - Genellikle raporlama ve analiz senaryolarýnda tercih edilir  

-- 7. Alternatif Yaklaþýmlar  
-- Eðer WITH TIES kullanýlmazsa, sadece ilk N satýr döndürülür  
-- Eþit deðerler atlanýr  

-- 8. Hata Yakalama ve Sýnýrlamalar  
-- - ORDER BY ifadesi olmadan kullanýlamaz  
-- - Genellikle TOP ile birlikte kullanýlýr  
