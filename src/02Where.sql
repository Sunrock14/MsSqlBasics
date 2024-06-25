Use Northwind

SELECT * FROM Personeller p WHERE  Sehir = 'London'

SELECT * FROM Personeller p WHERE  Sehir = 'London' and Adi = 'Steven'

SELECT * FROM Personeller p WHERE  Adi = 'Steven' or Bolge ='WA'

SELECT * FROM Personeller p WHERE  PersonelID >= 7

SELECT * FROM Personeller p WHERE  PersonelID <>  7 -- Idsi 7 olmayan

SELECT * FROM Personeller p WHERE YEAR(IseBaslamaTarihi) = 1993

SELECT * FROM Personeller p WHERE MONTH(IseBaslamaTarihi) = 05

SELECT * FROM Personeller p WHERE DAY(IseBaslamaTarihi) = 05

--Between
--Belirli bir değer aralığı olacaksa between kullanılır
SELECT * FROM Personeller p  WHERE  YEAR (DogumTarihi) BETWEEN 1950 and 1965
SELECT * FROM Personeller p  WHERE YEAr(DogumTarihi) > 1950 and YEAR(DogumTarihi) < 1965

--In
--or ile aynı mantıkta çalışır

SELECT *FROM Personeller p WHERE  Sehir IN ('London', 'Tacoma')
SELECT * FROM Personeller p WHERE  Sehir = 'London' or Adi = 'Steven'

