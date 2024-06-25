USE Northwind

--Özel karakterler _ , %
-- % Önemli değil
-- _ Özel Önemli değil
-- [] Yada
-- ^ değil 

--Baş harfi j olanları getir
SELECT Adi, SoyAdi  FROM Personeller p WHERE Adi LIKE 'j%'  

--Son harfi y olanları getir
SELECT Adi, SoyAdi  FROM Personeller p WHERE Adi LIKE '%y'  

--isminin İlk harfi r, son harfi t olan personeli getir
SELECT Adi, SoyAdi  FROM Personeller p WHERE Adi LIKE 'r%t'   

--İsminde an geçenleri getir
SELECT Adi, SoyAdi  FROM Personeller p WHERE Adi LIKE '%an%'   

--İkinici harfinin ne olduğpu önemli değiş
--Birinci a olsun ikinci önemli değil üçüncü harfi d olsun gerisi önemli değil
SELECT Adi, SoyAdi From Personeller p WHERE Adi LIKe 'a_d%'

--ilk harfi nmr olabilir
SELECT Adi, SoyAdi From Personeller p WHERE Adi LIKe '[nmr]%'

--İsminde a, i geçenleri getir
SELECT Adi, SoyAdi From Personeller p WHERE Adi LIKe '%[ai]%'

--İsminin baş harfi a olmayanları getir
SELECT Adi, SoyAdi From Personeller p WHERE Adi LIKe '[^a]%'
