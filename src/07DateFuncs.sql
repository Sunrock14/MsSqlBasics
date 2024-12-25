USE Northwind

--Özel karakterler _ , %
-- % Önemli değil
-- _ Özel Önemli değil
-- [] Yada
-- ^ değil 

--Baş harfi j olanları getir
SELECT FirstName, LastName  FROM [Employees] p WHERE FirstName LIKE 'j%'  

--Son harfi y olanları getir
SELECT FirstName, LastName  FROM [Employees] p WHERE FirstName LIKE '%y'  

--isminin İlk harfi r, son harfi t olan personeli getir
SELECT FirstName, LastName  FROM [Employees] p WHERE FirstName LIKE 'r%t'   

--İsminde an geçenleri getir
SELECT FirstName, LastName  FROM [Employees] p WHERE FirstName LIKE '%an%'   

--İkinici harfinin ne olduğpu önemli değiş
--Birinci a olsun ikinci önemli değil üçüncü harfi d olsun gerisi önemli değil
SELECT FirstName, LastName From [Employees] p WHERE FirstName LIKe 'a_d%'

--ilk harfi nmr olabilir
SELECT FirstName, LastName From [Employees] p WHERE FirstName LIKe '[nmr]%'

--İsminde a, i geçenleri getir
SELECT FirstName, LastName From [Employees] p WHERE FirstName LIKe '%[ai]%'

--İsminin baş harfi a olmayanları getir
SELECT FirstName, LastName From [Employees] p WHERE FirstName LIKe '[^a]%'
