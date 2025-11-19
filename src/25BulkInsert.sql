USE Northwind

-- BULK INSERT
-- BULK INSERT, büyük miktarda veriyi harici bir dosyadan tabloya hızlı bir şekilde yüklemek için kullanılır.
-- CSV, TXT gibi dosya formatlarından veri aktarımı yapar.

-- 1. Temel BULK INSERT Sözdizimi
-- Syntax: BULK INSERT TabloAdı FROM 'DosyaYolu' WITH (OPTIONS)

-- 2. CSV Dosyasından Veri Yükleme
-- Önce test için bir tablo oluşturalım
CREATE TABLE #BulkTestCustomers (
    CustomerID NCHAR(5),
    CompanyName NVARCHAR(40),
    ContactName NVARCHAR(30),
    City NVARCHAR(15),
    Country NVARCHAR(15)
);

-- CSV dosyasından veri yükleme örneği
-- Not: Dosya yolu mutlak olmalıdır
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Alan ayırıcı (virgül)
    ROWTERMINATOR = '\n',   -- Satır ayırıcı (yeni satır)
    FIRSTROW = 2            -- İlk satır başlık ise 2'den başla
);
*/

-- 3. Tab-Delimited Dosyadan Veri Yükleme
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.txt'
WITH (
    FIELDTERMINATOR = '\t',  -- Tab karakteri
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
);
*/

-- 4. Hata Kontrolü ile BULK INSERT
-- ERRORFILE: Hatalı satırları ayrı bir dosyaya kaydeder
-- MAXERRORS: İzin verilen maksimum hata sayısı
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    ERRORFILE = 'C:\Data\errors.txt',
    MAXERRORS = 10
);
*/

-- 5. BULK INSERT ile Veri Formatı Belirleme
-- DATAFILETYPE: Veri dosyası tipi
-- 'char' : ANSI/OEM karakterler
-- 'native' : SQL Server native format
-- 'widechar' : Unicode karakterler
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    DATAFILETYPE = 'widechar',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
*/

-- 6. BULK INSERT ile Batch Size
-- BATCHSIZE: Bir seferde kaç satır işleneceğini belirler
-- Büyük dosyalarda performans için önemlidir
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    BATCHSIZE = 1000  -- Her batch'te 1000 satır
);
*/

-- 7. BULK INSERT ile CHECK_CONSTRAINTS
-- CHECK_CONSTRAINTS: Kısıtlamaları kontrol eder
-- Varsayılan olarak kısıtlamalar kontrol edilmez
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CHECK_CONSTRAINTS
);
*/

-- 8. BULK INSERT ile FIRE_TRIGGERS
-- FIRE_TRIGGERS: Trigger'ları çalıştırır
-- Varsayılan olarak trigger'lar çalışmaz
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRE_TRIGGERS
);
*/

-- 9. BULK INSERT ile KEEPNULLS
-- KEEPNULLS: Boş değerleri NULL olarak korur
-- Varsayılan olarak default değerler kullanılır
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);
*/

-- 10. BULK INSERT ile TABLOCK
-- TABLOCK: Tablo seviyesinde kilit alır, performansı artırır
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
*/

-- 11. OPENROWSET ile BULK İşlemi
-- OPENROWSET, veriyi bir sonuç kümesi olarak döndürür
/*
SELECT *
FROM OPENROWSET(
    BULK 'C:\Data\customers.csv',
    FORMATFILE = 'C:\Data\format.fmt',
    FIRSTROW = 2
) AS BulkData;
*/

-- 12. Format File Kullanımı
-- Format file, karmaşık veri yapıları için kullanılır
-- XML veya non-XML format desteklenir
/*
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\customers.dat'
WITH (
    FORMATFILE = 'C:\Data\customers.fmt'
);
*/

-- 13. BULK INSERT ile Transaction
-- Transaction içinde BULK INSERT kullanımı
/*
BEGIN TRANSACTION;
BEGIN TRY
    BULK INSERT #BulkTestCustomers
    FROM 'C:\Data\customers.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    PRINT 'BULK INSERT başarılı: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' satır eklendi';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Hata: ' + ERROR_MESSAGE();
END CATCH;
*/

-- 14. BULK INSERT Performance Tips
-- 1. TABLOCK kullanın (minimal logging için)
-- 2. Indexes'leri geçici olarak disable edin
-- 3. BATCHSIZE kullanın
-- 4. Recovery model'i SIMPLE veya BULK_LOGGED yapın
-- 5. CHECK_CONSTRAINTS ve FIRE_TRIGGERS'ı kapatın (gerekmedikçe)

-- 15. BULK INSERT Örnek Workflow
/*
-- Adım 1: Index'leri disable et
ALTER INDEX ALL ON #BulkTestCustomers DISABLE;

-- Adım 2: BULK INSERT yap
BULK INSERT #BulkTestCustomers
FROM 'C:\Data\large_customers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    TABLOCK,
    BATCHSIZE = 10000
);

-- Adım 3: Index'leri rebuild et
ALTER INDEX ALL ON #BulkTestCustomers REBUILD;

-- Adım 4: İstatistikleri güncelle
UPDATE STATISTICS #BulkTestCustomers;
*/

-- Temizlik
DROP TABLE IF EXISTS #BulkTestCustomers;


-- Özet
-- BULK INSERT, büyük veri yüklemeleri için en hızlı yöntemdir
-- CSV, TXT gibi flat file formatlarını destekler
-- FIELDTERMINATOR ve ROWTERMINATOR ile dosya formatı belirlenir
-- TABLOCK ve BATCHSIZE performansı önemli ölçüde artırır
-- ERRORFILE ile hatalı kayıtlar izlenebilir
-- Format file karmaşık veri yapıları için kullanılır
-- Transaction içinde kullanılabilir
-- Production'da index'ler disable edilip sonra rebuild edilmelidir

PRINT 'BULK INSERT örnekleri tamamlandı!'
PRINT 'NOT: Bu örnekler dosya yolları mevcut olmadığı için çalıştırılamaz.'
PRINT 'Gerçek kullanımda dosya yollarını düzenleyin.'
