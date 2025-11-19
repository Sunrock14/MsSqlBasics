USE Northwind

-- 1. Basit UPDATE Kullanımı
-- Tek bir kaydı güncellemek için kullanılır.
-- Örnek: Belirli bir ürünün fiyatını güncelleyelim.
UPDATE Products
SET UnitPrice = 20.00
WHERE ProductID = 1;

-- 2. Birden Fazla Sütunu Güncelleme
-- Aynı anda birden fazla sütunu güncellemek için kullanılır.
-- Örnek: Ürün adı ve fiyatını birlikte güncelleyelim.
UPDATE Products
SET ProductName = 'Chai Special Edition',
    UnitPrice = 22.50,
    UnitsInStock = 50
WHERE ProductID = 2;

-- 3. Tüm Kayıtları Güncelleme
-- WHERE kullanmadan tüm kayıtları güncellemek için kullanılır.
-- DİKKAT: WHERE olmadan kullanıldığında TÜM kayıtlar güncellenir!
-- Örnek: Tüm ürünlere %10 zam yapalım (dikkatli kullanın!)
UPDATE Products
SET UnitPrice = UnitPrice * 1.10;

-- 4. WHERE ile Koşullu Güncelleme
-- Belirli bir koşula uyan kayıtları güncellemek için kullanılır.
-- Örnek: Stok miktarı 10'dan az olan ürünlerin stokunu 20'ye çıkaralım.
UPDATE Products
SET UnitsInStock = 20
WHERE UnitsInStock < 10;

-- 5. JOIN ile Güncelleme
-- Başka bir tablo ile ilişki kurarak güncelleme yapmak için kullanılır.
-- Örnek: Belirli bir kategorideki tüm ürünlerin fiyatını güncelleyelim.
UPDATE Products
SET UnitPrice = UnitPrice * 1.15
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName = 'Beverages';

-- 6. Subquery ile Güncelleme
-- Alt sorgu kullanarak güncelleme yapmak için kullanılır.
-- Örnek: En yüksek fiyatlı ürünün fiyatını ortalama fiyatla güncelleyelim.
UPDATE Products
SET UnitPrice = (SELECT AVG(UnitPrice) FROM Products)
WHERE ProductID = (SELECT TOP 1 ProductID FROM Products ORDER BY UnitPrice DESC);

-- 7. CASE ile Koşullu Güncelleme
-- Farklı koşullara göre farklı değerler atamak için kullanılır.
-- Örnek: Stok durumuna göre fiyat güncellemesi yapalım.
UPDATE Products
SET UnitPrice = CASE
    WHEN UnitsInStock = 0 THEN UnitPrice * 1.20  -- Stokta yok, %20 artır
    WHEN UnitsInStock < 10 THEN UnitPrice * 1.10  -- Az stok, %10 artır
    WHEN UnitsInStock < 50 THEN UnitPrice * 1.05  -- Normal stok, %5 artır
    ELSE UnitPrice  -- Bol stok, değiştirme
END;

-- 8. UPDATE ile NULL Değer Atama
-- Bir sütuna NULL değeri atamak için kullanılır.
-- Örnek: Belirli ürünlerin birim miktarını NULL yapalım.
UPDATE Products
SET QuantityPerUnit = NULL
WHERE ProductID IN (1, 2, 3);

-- 9. UPDATE ile İfade Kullanma
-- Matematiksel veya string ifadeler ile güncelleme yapmak için kullanılır.
-- Örnek: Ürün adının sonuna "(Discontinued)" ekleyelim.
UPDATE Products
SET ProductName = ProductName + ' (Discontinued)'
WHERE Discontinued = 1;

-- 10. TOP ile Sınırlı Güncelleme
-- Sadece belirli sayıda kaydı güncellemek için kullanılır.
-- Örnek: En ucuz 5 ürünün fiyatını %20 artıralım.
UPDATE TOP (5) Products
SET UnitPrice = UnitPrice * 1.20
ORDER BY UnitPrice ASC;

-- 11. UPDATE ile Transaction Kullanımı
-- Birden fazla UPDATE işlemini güvenli bir şekilde gerçekleştirmek için kullanılır.
-- Hata durumunda tüm işlemler geri alınır.
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE Products SET UnitPrice = UnitPrice * 1.10 WHERE CategoryID = 1;
    UPDATE Products SET UnitsInStock = UnitsInStock + 10 WHERE CategoryID = 1;
    COMMIT TRANSACTION;
    PRINT 'Güncelleme başarılı!';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Hata oluştu: ' + ERROR_MESSAGE();
END CATCH;

-- 12. UPDATE ile OUTPUT Kullanımı
-- Güncellenen kayıtların eski ve yeni değerlerini görmek için kullanılır.
-- DELETED: Eski değerler, INSERTED: Yeni değerler
UPDATE Products
SET UnitPrice = UnitPrice * 1.15
OUTPUT
    deleted.ProductID,
    deleted.ProductName,
    deleted.UnitPrice AS OldPrice,
    inserted.UnitPrice AS NewPrice
WHERE CategoryID = 2;

-- 13. UPDATE ile @@ROWCOUNT Kullanımı
-- Kaç satırın güncellendiğini öğrenmek için kullanılır.
UPDATE Products
SET UnitPrice = 25.00
WHERE ProductID = 999;  -- Olmayan bir ID
PRINT 'Güncellenen satır sayısı: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- 14. UPDATE ile EXISTS Kullanımı
-- Başka bir tabloda ilişkili kayıt varsa güncelleme yapmak için kullanılır.
-- Örnek: Sipariş verilmiş ürünlerin fiyatını güncelle.
UPDATE Products
SET UnitPrice = UnitPrice * 1.05
WHERE EXISTS (
    SELECT 1
    FROM [Order Details]
    WHERE [Order Details].ProductID = Products.ProductID
);

-- 15. UPDATE ile String Fonksiyonları
-- String manipülasyonu ile güncelleme yapmak için kullanılır.
-- Örnek: Ürün adlarını büyük harfe çevirelim.
UPDATE Products
SET ProductName = UPPER(ProductName)
WHERE CategoryID = 3;

-- 16. UPDATE ile REPLACE Fonksiyonu
-- Mevcut metni değiştirmek için kullanılır.
-- Örnek: Ürün adlarında 'Chef' kelimesini 'Chief' ile değiştirelim.
UPDATE Products
SET ProductName = REPLACE(ProductName, 'Chef', 'Chief')
WHERE ProductName LIKE '%Chef%';

-- 17. UPDATE ile GETDATE() Kullanımı
-- Tarih/saat güncellemesi yapmak için kullanılır.
-- Not: Northwind'de Products tablosunda tarih sütunu yok, örnek amaçlı gösterilmiştir.
-- Gerçek kullanım örneği:
-- UPDATE Orders
-- SET ShippedDate = GETDATE()
-- WHERE OrderID = 10248 AND ShippedDate IS NULL;

-- 18. UPDATE ile BETWEEN Kullanımı
-- Belirli bir aralıktaki kayıtları güncellemek için kullanılır.
-- Örnek: 10-20 TL arasındaki ürünlerin fiyatını %5 artıralım.
UPDATE Products
SET UnitPrice = UnitPrice * 1.05
WHERE UnitPrice BETWEEN 10 AND 20;

-- 19. UPDATE ile NOT IN Kullanımı
-- Belirli değerler dışındaki kayıtları güncellemek için kullanılır.
-- Örnek: Belirli kategoriler dışındaki ürünlerin fiyatını güncelle.
UPDATE Products
SET UnitPrice = UnitPrice * 0.95  -- %5 indirim
WHERE CategoryID NOT IN (1, 2, 3);

-- 20. UPDATE ile Aggregate Function Sonucu
-- Aggregate fonksiyon sonucuna göre güncelleme yapmak için kullanılır.
-- Örnek: Her kategorideki ürünlerin fiyatını o kategorinin ortalama fiyatına eşitle.
UPDATE p1
SET p1.UnitPrice = (
    SELECT AVG(p2.UnitPrice)
    FROM Products p2
    WHERE p2.CategoryID = p1.CategoryID
)
FROM Products p1;


-- Özet
-- UPDATE komutu veritabanındaki mevcut kayıtları güncellemek için kullanılır.
-- Temel sözdizimi: UPDATE TableName SET Column1 = Value1, Column2 = Value2 WHERE Condition
-- WHERE kullanmadan UPDATE yapmak TÜM kayıtları günceller - dikkatli kullanın!
-- JOIN, CASE, Subquery gibi yapılarla güçlü güncellemeler yapılabilir.
-- OUTPUT clause ile hangi kayıtların nasıl güncellendiğini görebilirsiniz.
-- Transaction kullanarak güvenli güncellemeler yapabilirsiniz.

print 'Update örnekleri tamamlandı!'
