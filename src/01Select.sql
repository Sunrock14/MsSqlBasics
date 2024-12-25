--Yorum satırı

--Sql de harf duyarlılığı yoktur. Küçük harf büyük harf ayrımı olmaz.

--Use komutu çalışacağımız veritabanını seçmek/değiştirmek için kullanılır.

Use Northwind

--1. Tüm Kolonları Seçmek
-- Tablodaki tüm kolonları seçmek için * kullanılır.  
-- Bu yöntem genellikle hızlı bir şekilde tüm verileri görmek için kullanılır.  
SELECT *   
FROM Customers;

--2. Belirli Kolonları Seçmek
-- Sadece ihtiyaç duyulan kolonları seçmek için kolon isimleri belirtilir.  
-- Bu yöntem, performansı artırır ve gereksiz veri taşınmasını önler.  
SELECT CustomerID, CompanyName, City   
FROM Customers;

--3. Kolonlara Takma Ad (Alias) Vermek
-- Kolonlara daha anlamlı veya kısa isimler vermek için AS kullanılır.  
-- Bu, sonuçların okunabilirliğini artırır.  
SELECT CustomerID AS ID,   
       CompanyName AS CustomerName,   
       City AS Location   
FROM Customers;

--4. Sabit Değerler veya Hesaplanmış Kolonlar Eklemek
-- Sabit bir değer veya hesaplanmış bir kolon eklenebilir.  
-- Örneğin, tüm müşterilere varsayılan bir ülke ekleniyor.  
SELECT CustomerID,   
       CompanyName,   
       'Default Country' AS Country   
FROM Customers;  

-- Hesaplanmış bir kolon eklemek: Şirket adının uzunluğunu hesaplıyoruz.  
SELECT CustomerID,   
       CompanyName,   
       LEN(CompanyName) AS NameLength   
FROM Customers;


--5. CONCAT ile Kolonları Birleştirmek
-- Birden fazla kolonu birleştirerek tek bir kolon olarak göstermek için CONCAT kullanılır.  
-- Örneğin, müşteri adı ve şehri birleştiriliyor.  
SELECT CustomerID,   
       CONCAT(CompanyName, ' - ', City) AS CustomerInfo   
FROM Customers;

--6. Sabit Metin ve Dinamik Veriyi Birleştirmek
-- Sabit bir metin ile kolon verilerini birleştirebilirsiniz.  
-- Örneğin, müşteri adlarının başına "Müşteri: " ekleniyor.  
SELECT CustomerID,   
       'Müşteri: ' + CompanyName AS CustomerLabel   
FROM Customers;

--7. DISTINCT ile Tekrarlayan Değerleri Kaldırmak
-- DISTINCT, sonuç kümesindeki tekrarlayan değerleri kaldırır.  
-- Örneğin, farklı şehirleri listelemek için kullanılıyor.  
SELECT DISTINCT City   
FROM Customers;

--8. TOP ile İlk N Satırı Seçmek
-- TOP, sonuç kümesinden yalnızca belirli sayıda satırı döndürür.  
-- Örneğin, ilk 5 müşteriyi listelemek için kullanılıyor.  
SELECT TOP 5 CustomerID, CompanyName   
FROM Customers;  

-- TOP ile birlikte yüzde kullanımı: İlk %10 müşteriyi listele.  
SELECT TOP 10 PERCENT CustomerID, CompanyName   
FROM Customers;

--9. Kolonları Fonksiyonlarla Manipüle Etmek
-- Kolon verilerini manipüle etmek için string fonksiyonları kullanılabilir.  
-- Örneğin, müşteri adlarını büyük harfe çeviriyoruz.  
SELECT CustomerID,   
       UPPER(CompanyName) AS UpperCaseName   
FROM Customers;  

-- Şirket adlarının ilk 5 karakterini almak için LEFT fonksiyonu kullanılıyor.  
SELECT CustomerID,   
       LEFT(CompanyName, 5) AS FirstFiveChars   
FROM Customers;

--10. Kolonları Ters Çevirmek
-- REVERSE fonksiyonu, bir stringi ters çevirmek için kullanılır.  
-- Örneğin, müşteri adlarını ters çeviriyoruz.  
SELECT CustomerID,   
       REVERSE(CompanyName) AS ReversedName   
FROM Customers;

--11. Sabit Değerlerle Matematiksel İşlemler
-- Sabit bir değerle matematiksel işlemler yapılabilir.  
-- Örneğin, ürün fiyatlarına %10 zam ekleniyor.  
SELECT ProductID,   
       ProductName,   
       UnitPrice,   
       UnitPrice * 1.10 AS NewPrice   
FROM Products;

--12. NULL Değerleri Kontrol Etmek ve Varsayılan Değer Atamak
-- ISNULL fonksiyonu, NULL değerleri kontrol eder ve yerine varsayılan bir değer atar.  
-- Örneğin, telefon numarası olmayan müşterilere "Telefon Yok" atanıyor.  
SELECT CustomerID,   
       CompanyName,   
       ISNULL(Phone, 'Telefon Yok') AS PhoneNumber   
FROM Customers;

--13. FORMAT ile Veriyi Formatlamak
-- FORMAT fonksiyonu, tarih veya sayıları belirli bir formatta göstermek için kullanılır.  
-- Örneğin, sipariş tarihlerini 'dd-MM-yyyy' formatında gösteriyoruz.  
SELECT OrderID,   
       FORMAT(OrderDate, 'dd-MM-yyyy') AS FormattedDate   
FROM Orders;  

-- Fiyatları para birimi formatında göstermek  
SELECT ProductID,   
       ProductName,   
       FORMAT(UnitPrice, 'C', 'en-US') AS PriceInUSD   
FROM Products;


--14. QUOTENAME ile Veriyi Özel Karakterlerle Çevrelemek
-- QUOTENAME, bir stringi köşeli parantez veya tırnak içine alır.  
-- Örneğin, müşteri adlarını köşeli parantez içine alıyoruz.  
SELECT CustomerID,   
       QUOTENAME(CompanyName) AS QuotedName   
FROM Customers;

--15. STRING_AGG ile Verileri Birleştirmek (SQL Server 2017+)
-- STRING_AGG, birden fazla satırı birleştirerek tek bir string döndürür.  
-- Örneğin, tüm müşteri adlarını virgülle ayırarak birleştiriyoruz.  
SELECT STRING_AGG(CompanyName, ', ') AS AllCustomerNames   
FROM Customers;

--16. TRIM ile Boşlukları Kaldırmak (SQL Server 2017+)
-- TRIM, bir stringin başındaki ve sonundaki boşlukları kaldırır.  
-- Örneğin, müşteri adlarının başındaki ve sonundaki boşlukları temizliyoruz.  
SELECT CustomerID,   
       TRIM(CompanyName) AS TrimmedName   
FROM Customers;


--17. Sabit Değerlerle Dinamik Kolonlar Eklemek
-- Sabit bir değerle dinamik bir kolon eklenebilir.  
-- Örneğin, tüm müşterilere "VIP" etiketi ekleniyor.  
SELECT CustomerID,   
       CompanyName,   
       'VIP' AS CustomerType   
FROM Customers;

--18. Kolonları Birden Fazla Kez Kullanmak
-- Aynı kolonu birden fazla kez kullanarak farklı işlemler yapabilirsiniz.  
-- Örneğin, şirket adını hem büyük hem de küçük harflerle gösteriyoruz.  
SELECT CustomerID,   
       CompanyName,   
       UPPER(CompanyName) AS UpperCaseName,   
       LOWER(CompanyName) AS LowerCaseName   
FROM Customers;

--19. Sabit Değerlerle Koşullu Kolonlar Eklemek
-- CASE ifadesiyle sabit değerler eklenebilir.  
-- Örneğin, ürün fiyatlarına göre "Ucuz" veya "Pahalı" etiketi ekleniyor.  
SELECT ProductID,   
       ProductName,   
       UnitPrice,   
       CASE   
           WHEN UnitPrice < 20 THEN 'Ucuz'  
           ELSE 'Pahalı'  
       END AS PriceCategory   
FROM Products;


--Bir mesaj yazdırmak için kullanılır.
print 'Çalıştı'
