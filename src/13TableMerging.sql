USE Northwind

-- 1. INNER JOIN ile İki Tabloyu Birleştirme  
-- Müşteri bilgilerini siparişlerle birleştirerek listele  
-- `INNER JOIN`, her iki tabloda da eşleşen kayıtları döndürür.  
SELECT Customers.CustomerID, Customers.ContactName, Orders.OrderID  
FROM Customers  
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;  

-- 2. LEFT JOIN ile İki Tabloyu Birleştirme  
-- Tüm müşterileri ve varsa siparişlerini listele  
-- `LEFT JOIN`, sol tablodaki tüm kayıtları ve sağ tablodaki eşleşen kayıtları döndürür.  
SELECT Customers.CustomerID, Customers.ContactName, Orders.OrderID  
FROM Customers  
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;  

-- 3. RIGHT JOIN ile İki Tabloyu Birleştirme  
-- Tüm siparişleri ve varsa müşteri bilgilerini listele  
-- `RIGHT JOIN`, sağ tablodaki tüm kayıtları ve sol tablodaki eşleşen kayıtları döndürür.  
SELECT Customers.CustomerID, Customers.ContactName, Orders.OrderID  
FROM Customers  
RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;  

-- 4. FULL OUTER JOIN ile İki Tabloyu Birleştirme  
-- Hem tüm müşterileri hem de tüm siparişleri listele  
-- `FULL OUTER JOIN`, her iki tablodaki tüm kayıtları döndürür, eşleşmeyen kayıtlar için NULL değerler gösterilir.  
SELECT Customers.CustomerID, Customers.ContactName, Orders.OrderID  
FROM Customers  
FULL OUTER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;  

-- 5. CROSS JOIN ile İki Tabloyu Birleştirme  
-- Müşteri ve siparişlerin tüm kombinasyonlarını listele  
-- `CROSS JOIN`, her iki tablodaki tüm kayıtların kombinasyonunu döndürür.  
SELECT Customers.CustomerID, Orders.OrderID  
FROM Customers  
CROSS JOIN Orders;  

-- 6. JOIN ile Birden Fazla Tabloyu Birleştirme  
-- Müşteri, sipariş ve ürün bilgilerini birleştirerek listele  
-- Birden fazla tablo birleştirilirken, her bir tablo için JOIN ifadesi kullanılmalıdır.  
SELECT   
    Customers.CustomerID,   
    Customers.ContactName,   
    Orders.OrderID,   
    [Order Details].OrderID,   
    [Order Details].Quantity
FROM   
    Customers  
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID  
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID;  

-- 7. JOIN ile Aliasing Kullanımı  
-- Müşteri ve sipariş bilgilerini alias kullanarak listele  
-- Alias, tabloların daha okunabilir isimlerle kullanılmasını sağlar.  
SELECT C.CustomerID, C.ContactName, O.OrderID  
FROM Customers AS C  
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID;  

-- 8. JOIN ile Koşullu Birleştirme  
-- Müşteri ve sipariş bilgilerini yalnızca belirli bir şehirdeki müşteriler için listele  
-- `WHERE` ifadesi, birleştirilmiş sonuçlar üzerinde filtreleme yapar.  
SELECT Customers.CustomerID, Customers.ContactName, Orders.OrderID  
FROM Customers  
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID  
WHERE Customers.City = 'London';  

-- 9. JOIN ile NULL Değerleri Kontrol Etme  
-- Müşteri bilgilerini siparişleri olmayanlarla birlikte listele  
-- `IS NULL` ifadesi, NULL değerleri kontrol etmek için kullanılır.  
SELECT Customers.CustomerID, Customers.ContactName, Orders.OrderID  
FROM Customers  
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID  
WHERE Orders.OrderID IS NULL;  

-- 10. JOIN ile Alt Sorgu Kullanımı  
-- Müşteri bilgilerini, en fazla sipariş veren müşterilerle birleştir  
-- Alt sorgular, ana sorguda kullanılabilir.  
SELECT Customers.CustomerID, Customers.ContactName  
FROM Customers  
WHERE Customers.CustomerID IN (  
    SELECT CustomerID  
    FROM Orders  
    GROUP BY CustomerID  
    HAVING COUNT(OrderID) > 5  
);  

-- 11. JOIN ile Gruplama ve Sıralama  
-- Müşteri bilgilerini, sipariş sayısına göre azalan sırada listele  
-- `GROUP BY` ve `ORDER BY` ifadeleri, birleştirilmiş sonuçlar üzerinde kullanılabilir.  
SELECT Customers.CustomerID, COUNT(Orders.OrderID) AS OrderCount  
FROM Customers  
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID  
GROUP BY Customers.CustomerID  
ORDER BY OrderCount DESC;  

-- 12. JOIN ile Dinamik Sıralama  
-- Müşteri bilgilerini, sipariş sayısına göre sıralama  
-- Dinamik sıralama için `CASE` ifadesi kullanılabilir.  
SELECT Customers.CustomerID, COUNT(Orders.OrderID) AS OrderCount  
FROM Customers  
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID  
GROUP BY Customers.CustomerID  
ORDER BY  
    CASE  
        WHEN COUNT(Orders.OrderID) > 5 THEN 1  
        ELSE 2  
    END ASC;  