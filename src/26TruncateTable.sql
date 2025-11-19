USE Northwind

-- TRUNCATE TABLE
-- TRUNCATE TABLE, bir tablodaki tüm verileri hızlı bir şekilde siler.
-- DELETE'den daha hızlıdır çünkü satır satır loglama yapmaz.

-- 1. TRUNCATE vs DELETE Farkları
-- TRUNCATE TABLE:
--   - Tüm satırları siler, WHERE kullanılamaz
--   - Minimal loglama yapar (çok hızlı)
--   - Identity değerini sıfırlar
--   - Trigger'ları tetiklemez
--   - Transaction içinde kullanılabilir ama rollback daha az esnek
--   - Tablo yapısını korur, sadece veriyi siler
--   - Foreign key constraint varsa kullanılamaz (referans eden tablo)

-- DELETE:
--   - WHERE ile seçici silme yapılabilir
--   - Her satır için loglama yapar (yavaş)
--   - Identity değerini sıfırlamaz
--   - Trigger'ları tetikler
--   - Transaction içinde tam rollback destekler
--   - Foreign key constraint olsa da kullanılabilir

-- 2. Basit TRUNCATE Kullanımı
-- Önce test tablosu oluşturalım
CREATE TABLE #TestEmployees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Salary DECIMAL(10,2)
);

-- Veri ekleyelim
INSERT INTO #TestEmployees (FirstName, LastName, Salary)
VALUES
    ('John', 'Doe', 50000),
    ('Jane', 'Smith', 60000),
    ('Bob', 'Johnson', 55000);

SELECT * FROM #TestEmployees;
PRINT 'Toplam satır: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- TRUNCATE işlemi
TRUNCATE TABLE #TestEmployees;

SELECT * FROM #TestEmployees;  -- Boş tablo
PRINT 'TRUNCATE sonrası satır: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- 3. Identity Reset Kontrolü
-- TRUNCATE sonrası identity değeri 1'den başlar
INSERT INTO #TestEmployees (FirstName, LastName, Salary)
VALUES ('Alice', 'Williams', 65000);

SELECT * FROM #TestEmployees;  -- EmployeeID = 1 olacak

-- 4. DELETE ile Karşılaştırma
-- DELETE ile silme
DELETE FROM #TestEmployees;

-- Identity değeri sıfırlanmaz, kaldığı yerden devam eder
INSERT INTO #TestEmployees (FirstName, LastName, Salary)
VALUES ('Charlie', 'Brown', 70000);

SELECT * FROM #TestEmployees;  -- EmployeeID = 2 olacak (devam ediyor)

-- 5. TRUNCATE ile Transaction
-- TRUNCATE işlemi transaction içinde kullanılabilir
BEGIN TRANSACTION;
    TRUNCATE TABLE #TestEmployees;
    PRINT 'Tablo truncate edildi';

    -- Kontrol edelim
    SELECT COUNT(*) AS RowCount FROM #TestEmployees;

    -- Rollback yapabiliriz
    ROLLBACK TRANSACTION;
    PRINT 'İşlem geri alındı';

-- Rollback sonrası kontrol
SELECT * FROM #TestEmployees;  -- Veri geri geldi

-- 6. TRUNCATE ile Foreign Key Constraint
-- Foreign key referans verdiği bir tablo TRUNCATE edilemez
CREATE TABLE #TestDepartments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

CREATE TABLE #TestEmployees2 (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(50),
    DepartmentID INT FOREIGN KEY REFERENCES #TestDepartments(DepartmentID)
);

-- Veri ekleyelim
INSERT INTO #TestDepartments VALUES (1, 'IT'), (2, 'HR');
INSERT INTO #TestEmployees2 VALUES (1, 'John', 1), (2, 'Jane', 2);

-- Bu çalışmaz - foreign key constraint var
-- TRUNCATE TABLE #TestDepartments;  -- HATA!

-- Önce bağımlı tabloyu truncate etmeliyiz
TRUNCATE TABLE #TestEmployees2;  -- Çalışır
TRUNCATE TABLE #TestDepartments;  -- Şimdi çalışır

-- 7. TRUNCATE Alternatifi: DELETE + DBCC CHECKIDENT
-- TRUNCATE kullan amalgama durumlarda DELETE ile identity reset
DELETE FROM #TestEmployees;
DBCC CHECKIDENT ('#TestEmployees', RESEED, 0);  -- Identity'yi sıfırla

-- 8. TRUNCATE ile Performans Karşılaştırması
-- Büyük test tablosu oluşturalım
CREATE TABLE #LargeTest (
    ID INT IDENTITY(1,1),
    Data NVARCHAR(100)
);

-- 10000 satır ekleyelim
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO #LargeTest (Data) VALUES ('Test Data ' + CAST(@i AS VARCHAR));
    SET @i = @i + 1;
END

-- DELETE ile silme (yavaş)
DECLARE @StartTime DATETIME = GETDATE();
DELETE FROM #LargeTest;
PRINT 'DELETE süresi: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, GETDATE()) AS VARCHAR) + ' ms';

-- Yeniden veri ekleyelim
SET @i = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO #LargeTest (Data) VALUES ('Test Data ' + CAST(@i AS VARCHAR));
    SET @i = @i + 1;
END

-- TRUNCATE ile silme (hızlı)
SET @StartTime = GETDATE();
TRUNCATE TABLE #LargeTest;
PRINT 'TRUNCATE süresi: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, GETDATE()) AS VARCHAR) + ' ms';

-- 9. TRUNCATE ile Partitioned Table
-- Partition belirterek sadece bir partition'ı truncate edebilirsiniz (SQL Server 2016+)
-- TRUNCATE TABLE TableName WITH (PARTITIONS (1, 3, 5));

-- 10. TRUNCATE İzinleri
-- TRUNCATE TABLE için ALTER TABLE izni gerekir
-- DELETE için sadece DELETE izni yeterlidir
-- Bu nedenle TRUNCATE daha kısıtlıdır

-- Temizlik
DROP TABLE IF EXISTS #TestEmployees;
DROP TABLE IF EXISTS #TestEmployees2;
DROP TABLE IF EXISTS #TestDepartments;
DROP TABLE IF EXISTS #LargeTest;


-- Özet
-- TRUNCATE TABLE tüm satırları siler, tablo yapısını korur
-- DELETE'den çok daha hızlıdır (minimal logging)
-- Identity değerini sıfırlar
-- WHERE clause kullanılamaz, tüm tablo silinir
-- Trigger'ları tetiklemez
-- Foreign key referans alan tablolarda kullanılamaz
-- Transaction içinde kullanılabilir
-- ALTER TABLE izni gerektirir
-- Büyük tabloları temizlemek için idealdir

PRINT 'TRUNCATE TABLE örnekleri tamamlandı!'
