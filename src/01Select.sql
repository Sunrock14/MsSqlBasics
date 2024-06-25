--Yorum satırı

--Sql de harf duyarlılığı yoktur. Küçük harf büyük harf ayrımı olmaz.

--Use komutu çalışacağımız veritabanını seçmek/değiştirmek için kullanılır.

Use Northwind

--Tüm tabloları getir.
Select * from Bolge

--Bir mesaj yazdırmak için kullanılır.
print 'Çalıştı'

-- as ile tabloya takma isim(Alias) verebiliriz
select 'faruk' as ÖrnekTabloAdi

-- as anahtarını kullanmadan alias verilebilir
Select Adi Personelİsmi, SoyAdi, Sehir FROM Personeller p 

Select BolgeTanimi from Bolge 
select * from Bolge b 

-- Eğer tablo adında boşluk varsa [] içerisine yazmamız gerekir.
SELECT * FROM [Satis Detaylari] sd 

--Kolonları nasıl birleştirme [] içinde alias verilir
SELECT Adi + ' ' + SoyAdi [isim soyisim] FROM Personeller p 

