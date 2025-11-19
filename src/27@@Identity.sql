USE Northwind

-- @@IDENTITY, SCOPE_IDENTITY(), IDENT_CURRENT()
-- Bu fonksiyonlar son eklenen identity değerini döndürür.

-- 1. @@IDENTITY
-- Session'daki herhangi bir tabloya eklenen son identity değerini döndürür
-- Scope'a bakmaksızın çalışır (trigger'lar dahil)

CREATE TABLE #TestTable1 (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50)
);

INSERT INTO #TestTable1 (Name) VALUES ('Test 1');
SELECT @@IDENTITY AS LastIdentity;  -- 1 döner

INSERT INTO #TestTable1 (Name) VALUES ('Test 2');
SELECT @@IDENTITY AS LastIdentity;  -- 2 döner

-- 2. SCOPE_IDENTITY()
-- Aynı scope içinde eklenen son identity değerini döndürür
-- Trigger'lardan etkilenmez (RECOMMENDED)

INSERT INTO #TestTable1 (Name) VALUES ('Test 3');
SELECT SCOPE_IDENTITY() AS LastIdentityInScope;  -- 3 döner

-- 3. IDENT_CURRENT('table_name')
-- Belirli bir tablonun son identity değerini döndürür
-- Session ve scope'tan bağımsızdır

SELECT IDENT_CURRENT('#TestTable1') AS CurrentIdentity;

-- 4. Farkları Gösterme - Trigger Senaryosu
CREATE TABLE #MainTable (
    MainID INT IDENTITY(100,1) PRIMARY KEY,
    MainData NVARCHAR(50)
);

CREATE TABLE #LogTable (
    LogID INT IDENTITY(1000,1) PRIMARY KEY,
    LogMessage NVARCHAR(100)
);

-- Trigger oluştur
CREATE TRIGGER trg_MainTable_Insert
ON #MainTable
AFTER INSERT
AS
BEGIN
    INSERT INTO #LogTable (LogMessage)
    VALUES ('New record inserted');
END;
GO

-- Test edelim
INSERT INTO #MainTable (MainData) VALUES ('First Record');

-- @@IDENTITY: LogTable'ın ID'sini döndürür (1000)
SELECT @@IDENTITY AS Identity_Value;

-- SCOPE_IDENTITY(): MainTable'ın ID'sini döndürür (100)
SELECT SCOPE_IDENTITY() AS ScopeIdentity_Value;

-- IDENT_CURRENT: Belirtilen tablonun son ID'sini döndürür
SELECT IDENT_CURRENT('#MainTable') AS MainTable_Current;
SELECT IDENT_CURRENT('#LogTable') AS LogTable_Current;

-- 5. Pratik Kullanım Örneği
DECLARE @NewID INT;

INSERT INTO #MainTable (MainData) VALUES ('Second Record');
SET @NewID = SCOPE_IDENTITY();  -- En güvenilir yöntem

PRINT 'Yeni eklenen kayıt ID: ' + CAST(@NewID AS VARCHAR);

-- 6. INSERT ile OUTPUT Clause (Modern Alternatif)
DECLARE @InsertedIDs TABLE (ID INT);

INSERT INTO #MainTable (MainData)
OUTPUT inserted.MainID INTO @InsertedIDs
VALUES ('Third Record');

SELECT * FROM @InsertedIDs;  -- En güvenli yöntem

-- 7. DBCC CHECKIDENT - Identity Değerini Kontrol/Değiştirme
DBCC CHECKIDENT ('#MainTable', NORESEED);  -- Mevcut değeri göster
DBCC CHECKIDENT ('#MainTable', RESEED, 200);  -- 200'den devam et

-- Temizlik
DROP TRIGGER IF EXISTS trg_MainTable_Insert;
DROP TABLE IF EXISTS #MainTable;
DROP TABLE IF EXISTS #LogTable;
DROP TABLE IF EXISTS #TestTable1;

-- Özet
-- @@IDENTITY: Session'daki son identity (trigger dahil)
-- SCOPE_IDENTITY(): Aynı scope'taki son identity (ÖNER İLEN)
-- IDENT_CURRENT(): Belirli tablonun son identity'si
-- OUTPUT clause: Modern ve en güvenli yöntem
-- Trigger kullanıyorsanız SCOPE_IDENTITY() kullanın

PRINT '@@IDENTITY örnekleri tamamlandı!'
