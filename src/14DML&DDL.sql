USE Northwind

--DDL (Data Definition Language)
--DDL, veritabanı yapısını tanımlamak ve değiştirmek için kullanılan SQL komutlarını içerir. 
--Bu komutlar, veritabanı nesnelerinin (tablolar, indeksler, görünümler vb.) oluşturulması, 
--değiştirilmesi ve silinmesi gibi işlemleri gerçekleştirir.

--CREATE: Yeni bir veritabanı nesnesi oluşturur.
CREATE TABLE RandomTable (  
    CustomerID INT PRIMARY KEY,  
    CustomerName VARCHAR(100),  
    ContactEmail VARCHAR(100)  
);  
--ALTER: Var olan bir veritabanı nesnesini değiştirir.
ALTER TABLE RandomTable  ADD PhoneNumber VARCHAR(15);  

--DROP: Var olan bir veritabanı nesnesini siler.
DROP TABLE RandomTable;  

--TRUNCATE: Bir tablodaki tüm verileri siler, ancak tablo yapısını korur.
TRUNCATE TABLE RandomTable;  

--DML (Data Manipulation Language)
--DML, veritabanındaki verileri manipüle etmek için kullanılan SQL komutlarını içerir. 
--Bu komutlar, verilerin eklenmesi, güncellenmesi, silinmesi ve sorgulanması gibi işlemleri gerçekleştirir.

--INSERT: Yeni veriler ekler.
INSERT INTO RandomTable (CustomerID, CustomerName, ContactEmail)   
VALUES (1, 'John Doe', 'john.doe@example.com');  

--UPDATE: Var olan verileri günceller.
UPDATE RandomTable   
SET ContactEmail = 'john.newemail@example.com'   
WHERE CustomerID = 1;  

--DELETE: Var olan verileri siler.
DELETE FROM RandomTable   
WHERE CustomerID = 1;  

--SELECT: Verileri sorgular.
SELECT * FROM RandomTable;  


--Özetle
--DDL: Veritabanı yapısını tanımlar ve değiştirir. (Örnek: CREATE, ALTER, DROP)
--DML: Veritabanındaki verileri manipüle eder. (Örnek: INSERT, UPDATE, DELETE, SELECT)

