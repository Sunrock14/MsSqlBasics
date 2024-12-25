USE Northwind

-- 1. LEN ile Karakter Uzunluğunu Bulma  
-- Müşteri adlarının uzunluğunu listele  
SELECT CustomerID, CompanyName, LEN(CompanyName) AS NameLength   
FROM Customers;

-- 2. UPPER ile Metni Büyük Harfe Çevirme  
-- Ürün adlarını büyük harfe çevirerek listele  
SELECT ProductID, ProductName, UPPER(ProductName) AS UpperCaseName   
FROM Products;

-- 3. LOWER ile Metni Küçük Harfe Çevirme  
-- Çalışan soyadlarını küçük harfe çevirerek listele  
SELECT EmployeeID, LastName, LOWER(LastName) AS LowerCaseLastName   
FROM Employees;

-- 4. LEFT ile Belirli Sayıda Karakter Alma  
-- Ürün adlarının ilk 5 karakterini listele  
SELECT ProductID, ProductName, LEFT(ProductName, 5) AS FirstFiveChars   
FROM Products;

-- 5. RIGHT ile Belirli Sayıda Karakter Alma  
-- Müşteri adlarının son 3 karakterini listele  
SELECT CustomerID, CompanyName, RIGHT(CompanyName, 3) AS LastThreeChars   
FROM Customers;

-- 6. CHARINDEX ile Belirli Bir Karakterin Konumunu Bulma  
-- Ürün adlarında 'a' harfinin ilk geçtiği konumu listele  
SELECT ProductID, ProductName, CHARINDEX('a', ProductName) AS PositionOfA   
FROM Products;

-- 7. SUBSTRING ile Belirli Bir Bölümü Alma  
-- Çalışan soyadlarının 2. karakterden başlayarak 4 karakterini listele  
SELECT EmployeeID, LastName, SUBSTRING(LastName, 2, 4) AS SubstringOfLastName   
FROM Employees;

-- 8. REPLACE ile Metin Değiştirme  
-- Gönderim şehir adlarında 'a' harfini 'X' ile değiştirerek listele  
SELECT OrderID, ShipCity, REPLACE(ShipCity, 'a', 'X') AS ModifiedCity   
FROM Orders;

-- 9. TRIM ile Başındaki ve Sonundaki Boşlukları Kaldırma  
-- Tedarikçi adlarının başındaki ve sonundaki boşlukları kaldırarak listele  
SELECT SupplierID, CompanyName, TRIM(CompanyName) AS TrimmedName   
FROM Suppliers;

-- 10. CONCAT ile Stringleri Birleştirme  
-- Çalışanların adını ve soyadını birleştirerek tam ad olarak listele  
SELECT EmployeeID, CONCAT(FirstName, ' ', LastName) AS FullName   
FROM Employees;

-- 11. FORMAT ile Veriyi Formatlama  
-- Sipariş tarihlerini 'dd-MM-yyyy' formatında listele  
SELECT OrderID, FORMAT(OrderDate, 'dd-MM-yyyy') AS FormattedDate   
FROM Orders;

-- 12. REVERSE ile Stringi Ters Çevirme  
-- Müşteri adlarını ters çevirerek listele  
SELECT CustomerID, CompanyName, REVERSE(CompanyName) AS ReversedName   
FROM Customers;

-- 13. STRING_AGG ile Değerleri Birleştirme  
-- Tüm ürün adlarını virgülle ayırarak birleştir  
SELECT STRING_AGG(ProductName, ', ') AS AllProducts   
FROM Products;

-- 14. PATINDEX ile Desen Arama  
-- Ürün adlarında 'Ch%' deseni geçen ürünlerin konumunu listele  
SELECT ProductID, ProductName, PATINDEX('%Ch%', ProductName) AS PatternPosition   
FROM Products;

--15. STUFF (Bir stringin belirli bir kısmını başka bir string ile değiştirir)
-- Müşteri adlarının 2. karakterinden başlayarak 3 karakteri 'XYZ' ile değiştir  
SELECT CustomerID, CompanyName, STUFF(CompanyName, 2, 3, 'XYZ') AS StuffedName  
FROM Customers;

--16. LTRIM (Stringin başındaki boşlukları kaldırır)
-- Müşteri adlarının başındaki boşlukları kaldır  
SELECT CustomerID, CompanyName, LTRIM('   ' + CompanyName) AS TrimmedLeft  
FROM Customers;

--17. RTRIM (Stringin sonundaki boşlukları kaldırır)
-- Müşteri adlarının sonundaki boşlukları kaldır  
SELECT CustomerID, CompanyName, RTRIM(CompanyName + '   ') AS TrimmedRight  
FROM Customers;

--18. QUOTENAME (Bir stringi köşeli parantez veya tırnak içine alır)
-- Müşteri adlarını köşeli parantez içine al  
SELECT CustomerID, QUOTENAME(CompanyName) AS QuotedName  
FROM Customers;

--19. SPACE (Belirli sayıda boşluk döndürür)
-- Müşteri adlarının arasına 5 boşluk ekle  
SELECT CustomerID, CompanyName, CompanyName + SPACE(5) + City AS NameWithSpaces  
FROM Customers;

--20. ASCII (Bir karakterin ASCII değerini döndürür)
-- Müşteri adlarının ilk karakterinin ASCII değerini al  
SELECT CustomerID, CompanyName, ASCII(LEFT(CompanyName, 1)) AS FirstCharASCII  
FROM Customers;

--21. CHAR (Bir ASCII değerine karşılık gelen karakteri döndürür)
-- ASCII değeri 65 olan karakteri döndür (A harfi)  
SELECT CHAR(65) AS CharacterFor65; 
