USE Northwind

-- 1. GETDATE ile Güncel Tarihi ve Zamanı Alma  
-- Şu anki tarih ve zamanı listele  
SELECT GETDATE() AS CurrentDateTime;

-- 2. YEAR, MONTH ve DAY ile Tarih Parçalarını Alma  
-- Sipariş tarihinden yıl, ay ve günü listele  
SELECT OrderID, OrderDate,   
       YEAR(OrderDate) AS OrderYear,   
       MONTH(OrderDate) AS OrderMonth,   
       DAY(OrderDate) AS OrderDay   
FROM Orders;

-- 3. DATEDIFF ile İki Tarih Arasındaki Farkı Hesaplama  
-- Çalışanların işe başlama tarihinden itibaren geçen yıl sayısını listele  
SELECT EmployeeID, FirstName, LastName, HireDate,   
       DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsWorked   
FROM Employees;

-- 4. DATEADD ile Tarihe Belirli Bir Süre Ekleme  
-- Sipariş tarihine 30 gün ekleyerek yeni bir tarih oluştur  
SELECT OrderID, OrderDate,   
       DATEADD(DAY, 30, OrderDate) AS DeliveryDate   
FROM Orders;

-- 5. DATENAME ile Tarih Parçasının Adını Alma  
-- Sipariş tarihinin ay adını listele  
SELECT OrderID, OrderDate,   
       DATENAME(MONTH, OrderDate) AS MonthName   
FROM Orders;

-- 6. FORMAT ile Tarihi Formatlama  
-- Sipariş tarihini 'dd-MM-yyyy' formatında listele  
SELECT OrderID, FORMAT(OrderDate, 'dd-MM-yyyy') AS FormattedDate   
FROM Orders;

-- 7. GETDATE ile Güncel Tarihten Belirli Bir Süre Çıkarma  
-- 1 yıl önceki tarihi listele  
SELECT GETDATE() AS CurrentDate,   
       DATEADD(YEAR, -1, GETDATE()) AS OneYearAgo;

-- 8. İki Tarih Arasındaki Gün Sayısını Hesaplama  
-- Sipariş tarihi ile gönderim tarihi arasındaki gün farkını listele  
SELECT OrderID, OrderDate, ShippedDate,   
       DATEDIFF(DAY, OrderDate, ShippedDate) AS DaysBetween   
FROM Orders;

-- 9. Tarihlerin Haftanın Hangi Gününe Denk Geldiğini Bulma  
-- Sipariş tarihinin haftanın hangi günü olduğunu listele  
SELECT OrderID, OrderDate,   
       DATENAME(WEEKDAY, OrderDate) AS WeekDay   
FROM Orders;

-- 10. Tarih Aralığında Kayıtları Filtreleme  
-- 2023 yılı içinde verilen siparişleri listele  
SELECT OrderID, OrderDate   
FROM Orders  
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';

-- 11. Tarih Formatını Değiştirme  
-- Sipariş tarihini 'yyyy/MM/dd' formatında listele  
SELECT OrderID, CONVERT(VARCHAR, OrderDate, 111) AS FormattedDate   
FROM Orders;

-- 12. Tarih Kolonunu Yalnızca Yıl Olarak Gruplama  
-- Siparişleri yıllara göre gruplayarak toplam sipariş sayısını listele  
SELECT YEAR(OrderDate) AS OrderYear, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY YEAR(OrderDate);

-- 13. Tarih Kolonunu Ay Bazında Gruplama  
-- Siparişleri aylara göre gruplayarak toplam sipariş sayısını listele  
SELECT MONTH(OrderDate) AS OrderMonth, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY MONTH(OrderDate);

-- 14. Tarih Kolonunu Yıl ve Ay Bazında Gruplama  
-- Siparişleri yıl ve aya göre gruplayarak toplam sipariş sayısını listele  
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY YEAR(OrderDate), MONTH(OrderDate)  
ORDER BY OrderYear, OrderMonth;

-- 15. Tarih Kolonunu Haftalara Göre Gruplama  
-- Siparişleri haftalara göre gruplayarak toplam sipariş sayısını listele  
SELECT DATEPART(WEEK, OrderDate) AS OrderWeek, COUNT(*) AS TotalOrders   
FROM Orders  
GROUP BY DATEPART(WEEK, OrderDate)  
ORDER BY OrderWeek;