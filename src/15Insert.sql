USE Northwind

-- 1. Basit INSERT Kullanımı  
-- Ürün bilgilerini eklemek için kullanılır.  
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
VALUES ('Chai', 1, 1, '10 boxes x 20 bags', 18.00, 39);  

-- 2. Birden Fazla Kayıt Ekleme  
-- Aynı anda birden fazla ürün eklemek için kullanılır.  
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
VALUES  
    ('Chang', 1, 1, '24 - 12 oz bottles', 19.00, 17),  
    ('Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00, 13);  

-- 3. SELECT ile INSERT Kullanımı  
-- Başka bir tablodan veri alarak ürün eklemek için kullanılır.  
-- Örnek olarak, başka bir ürün tablosundan veri alarak ekleme yapılabilir.  
-- Ancak, Northwind veritabanında başka bir ürün tablosu yoktur. Bu nedenle, bu örneği geçici olarak yorumlayacağız.  
-- INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
-- SELECT ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock  
-- FROM AnotherProductTable;  

-- 4. DEFAULT Değer Kullanımı  
-- Varsayılan değer kullanarak ürün eklemek için kullanılır.  
INSERT INTO Products (ProductName, SupplierID, CategoryID)  
VALUES ('Chef Antons Gumbo Mix', 2, 2);  
-- Burada QuantityPerUnit, UnitPrice ve UnitsInStock sütunları varsayılan değeri alır.  

-- 5. INSERT ile NULL Değer Ekleme  
-- Ürün bilgilerini eklerken NULL değer kullanmak için.  
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
VALUES ('Grandmas Boysenberry Spread', 2, 2, NULL, 25.00, NULL);  

-- 6. INSERT ile Belirli Sütunları Belirtme  
-- Ürün bilgilerini yalnızca belirli sütunlara eklemek için kullanılır.  
INSERT INTO Products (ProductName, SupplierID, UnitPrice)  
VALUES ('Tofu', 3, 23.25);  
-- ProductID, CategoryID, QuantityPerUnit ve UnitsInStock sütunları NULL olarak kalır.  

-- 7. INSERT ile Hata Kontrolü  
-- Hatalı veri eklemeye çalışırken hata kontrolü yapmak için kullanılır.  
BEGIN TRY  
    INSERT INTO Products (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
    VALUES (1, 'Chai', 1, 1, '10 boxes x 20 bags', 18.00, 39);  
END TRY  
BEGIN CATCH  
    PRINT 'Hata: ' + ERROR_MESSAGE();  
END CATCH;  

-- 8. INSERT ile Transaction Kullanımı  
-- Birden fazla INSERT işlemini bir transaction içinde gerçekleştirmek için kullanılır.  
BEGIN TRANSACTION;  
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
VALUES ('Pavlova', 4, 3, '32 oz', 17.45, 29);  
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
VALUES ('Alice Mutton', 5, 6, '20 oz', 39.00, 0);  
COMMIT;  

-- 9. INSERT ile OUTPUT Kullanımı  
-- Eklenen kayıtların bilgilerini döndürmek için kullanılır.  
INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)  
OUTPUT inserted.ProductID, inserted.ProductName  
VALUES ('Cajun Seasoning', 6, 2, '12 oz', 22.00, 15);  


--Özet
--Basit INSERT Kullanımı: Tek bir kayıt eklemek için temel kullanım.
--Birden Fazla Kayıt Ekleme: Aynı anda birden fazla kayıt eklemek için kullanılır.
--SELECT ile INSERT Kullanımı: Başka bir tablodan veri alarak kayıt eklemek için kullanılır.
--DEFAULT Değer Kullanımı: Sütun için varsayılan değer kullanarak kayıt eklemek için kullanılır.
--NULL Değer Ekleme: Sütun için NULL değeri eklemek için kullanılır.
--Belirli Sütunları Belirtme: Tüm sütunları belirtmeden yalnızca belirli sütunlara veri eklemek için kullanılır.
--Hata Kontrolü: Hatalı veri eklemeye çalışırken hata kontrolü yapmak için kullanılır.
--Transaction Kullanımı: Birden fazla INSERT işlemini bir transaction içinde gerçekleştirmek için kullanılır.
--OUTPUT Kullanımı: Eklenen kayıtların bilgilerini döndürmek için kullanılır.