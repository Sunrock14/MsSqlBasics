USE Northwind

--Özel karakterler _ , %
-- % Önemli değil
-- _ Özel Önemli değil
-- [] Yada
-- ^ değil 

-- 1. LIKE ile Siparişlerin Gönderildiği Şehirleri Filtreleme  
-- Gönderim şehri 'S' harfiyle başlayan siparişleri listele  
SELECT OrderID, ShipCity, ShipCountry   
FROM Orders  
WHERE ShipCity LIKE 'S%';

-- 2. LIKE ile Ürün Adlarını Filtreleme  
-- Ürün adı 'Ch' ile başlayan ürünleri listele  
SELECT ProductID, ProductName, UnitPrice   
FROM Products  
WHERE ProductName LIKE 'Ch%';

-- 3. LIKE ile Çalışanların Adlarını Filtreleme  
-- Çalışan adı 'a' harfiyle biten çalışanları listele  
SELECT EmployeeID, FirstName, LastName, Title   
FROM Employees  
WHERE FirstName LIKE '%a';

-- 4. LIKE ile Tedarikçi Şirket Adlarını Filtreleme  
-- Şirket adında 'Food' kelimesi geçen tedarikçileri listele  
SELECT SupplierID, CompanyName, ContactName, Country   
FROM Suppliers  
WHERE CompanyName LIKE '%Food%';

-- 5. LIKE ile Siparişlerin Gönderildiği Ülkeleri Filtreleme  
-- Gönderim ülkesi 'United' kelimesiyle başlayan siparişleri listele  
SELECT OrderID, ShipCity, ShipCountry   
FROM Orders  
WHERE ShipCountry LIKE 'United%';

-- 6. LIKE ile Ürün Adlarında Belirli Bir Deseni Arama  
-- Ürün adında 'ee' harflerini içeren ürünleri listele  
SELECT ProductID, ProductName, UnitPrice, UnitsInStock   
FROM Products  
WHERE ProductName LIKE '%ee%';

-- 7. LIKE ile Çalışanların Soyadlarını Filtreleme  
-- Soyadı 'son' ile biten çalışanları listele  
SELECT EmployeeID, FirstName, LastName, Title   
FROM Employees  
WHERE LastName LIKE '%son';

-- 8. LIKE ile Tedarikçi Şirket Adlarında Özel Karakter Arama  
-- Şirket adında '&' karakterini içeren tedarikçileri listele  
SELECT SupplierID, CompanyName, ContactName, Country   
FROM Suppliers  
WHERE CompanyName LIKE '%&%';

-- 9. LIKE ile Çalışanların Ünvanlarını Filtreleme  
-- Ünvanı 'Manager' kelimesiyle biten çalışanları listele  
SELECT EmployeeID, FirstName, LastName, Title   
FROM Employees  
WHERE Title LIKE '%Manager';

-- 10. LIKE ile Ürün Adlarında Sayısal Karakter Arama  
-- Ürün adında herhangi bir sayısal karakter içeren ürünleri listele  
SELECT ProductID, ProductName, UnitPrice, UnitsInStock   
FROM Products  
WHERE ProductName LIKE '%[0-9]%';

-- 11. LIKE ile Gönderim Şehirlerinde Belirli Bir Harf Aralığını Filtreleme  
-- Gönderim şehri 'A' ile 'C' arasında bir harfle başlayan siparişleri listele  
SELECT OrderID, ShipCity, ShipCountry   
FROM Orders  
WHERE ShipCity LIKE '[A-C]%';

-- 12. LIKE ile Çalışanların Adlarında Boşluk Arama  
-- Adında boşluk içeren çalışanları listele  
SELECT EmployeeID, FirstName, LastName, Title   
FROM Employees  
WHERE FirstName LIKE '% %';

-- 13. LIKE ile Tedarikçi Şirket Adlarında Büyük/Küçük Harf Duyarlılığı  
-- Şirket adı 'Food' kelimesiyle başlayan tedarikçileri listele (büyük/küçük harf duyarlı)  
SELECT SupplierID, CompanyName, ContactName, Country   
FROM Suppliers  
WHERE CompanyName COLLATE Latin1_General_BIN LIKE 'Food%';