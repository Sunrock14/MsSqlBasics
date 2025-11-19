USE Northwind

-- CURSORS
-- Cursor, sonuç kümesindeki satırları tek tek işlemek için kullanılır.
-- Genellikle SET-BASED operasyonlar tercih edilmeli (performans).

-- 1. Basit Cursor
DECLARE @ProductID INT, @ProductName NVARCHAR(40), @Price MONEY;

DECLARE product_cursor CURSOR FOR
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE CategoryID = 1;

OPEN product_cursor;
FETCH NEXT FROM product_cursor INTO @ProductID, @ProductName, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Product: ' + @ProductName + ' - Price: ' + CAST(@Price AS VARCHAR);
    FETCH NEXT FROM product_cursor INTO @ProductID, @ProductName, @Price;
END

CLOSE product_cursor;
DEALLOCATE product_cursor;

-- 2. Cursor ile UPDATE
DECLARE @ProdID INT, @CurrentPrice MONEY;

DECLARE price_cursor CURSOR FOR
SELECT ProductID, UnitPrice
FROM Products
WHERE CategoryID = 1;

OPEN price_cursor;
FETCH NEXT FROM price_cursor INTO @ProdID, @CurrentPrice;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @CurrentPrice < 20
        UPDATE Products SET UnitPrice = @CurrentPrice * 1.10 WHERE ProductID = @ProdID;

    FETCH NEXT FROM price_cursor INTO @ProdID, @CurrentPrice;
END

CLOSE price_cursor;
DEALLOCATE price_cursor;

-- 3. Cursor Types
-- FORWARD_ONLY (default): Sadece ileri, en hızlı
-- SCROLL: İleri-geri hareket

DECLARE scroll_cursor CURSOR SCROLL FOR
SELECT ProductID, ProductName FROM Products;

OPEN scroll_cursor;

FETCH FIRST FROM scroll_cursor;  -- İlk kayıt
FETCH LAST FROM scroll_cursor;   -- Son kayıt
FETCH PRIOR FROM scroll_cursor;  -- Önceki kayıt
FETCH ABSOLUTE 5 FROM scroll_cursor;  -- 5. kayıt
FETCH RELATIVE -2 FROM scroll_cursor;  -- 2 kayıt geri

CLOSE scroll_cursor;
DEALLOCATE scroll_cursor;

-- 4. Cursor Options
-- STATIC: Cursor açıldığında snapshot alır
-- DYNAMIC: Anlık veriyi gösterir
-- KEYSET: Key'ler snapshot, data dynamic

DECLARE static_cursor CURSOR STATIC FOR
SELECT ProductID, ProductName FROM Products;

-- 5. FOR UPDATE Cursor
-- Cursor üzerinden UPDATE/DELETE

DECLARE update_cursor CURSOR FOR
SELECT ProductID, UnitPrice
FROM Products
WHERE CategoryID = 1
FOR UPDATE OF UnitPrice;  -- UPDATE için

OPEN update_cursor;
DECLARE @ID INT, @OldPrice MONEY;
FETCH NEXT FROM update_cursor INTO @ID, @OldPrice;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Products
    SET UnitPrice = @OldPrice * 1.05
    WHERE CURRENT OF update_cursor;  -- Cursor'ın mevcut satırı

    FETCH NEXT FROM update_cursor INTO @ID, @OldPrice;
END

CLOSE update_cursor;
DEALLOCATE update_cursor;

-- 6. @@FETCH_STATUS
-- 0: Başarılı
-- -1: Başarısız veya kayıt yok
-- -2: Fetch edilen kayıt yok (deleted)

-- 7. CURSOR_STATUS
-- 1: Cursor açık
-- 0: Cursor kapalı
-- -1: Cursor deallocate edilmiş

DECLARE test_cursor CURSOR FOR SELECT 1;
SELECT CURSOR_STATUS('global', 'test_cursor');  -- -1 (yok)
OPEN test_cursor;
SELECT CURSOR_STATUS('local', 'test_cursor');  -- 1 (açık)
CLOSE test_cursor;
SELECT CURSOR_STATUS('local', 'test_cursor');  -- 0 (kapalı)
DEALLOCATE test_cursor;

-- 8. Cursor Alternatifi: WHILE Loop
-- Genellikle daha performanslı
CREATE TABLE #TempProducts (ProductID INT, Processed BIT DEFAULT 0);
INSERT INTO #TempProducts (ProductID)
SELECT ProductID FROM Products WHERE CategoryID = 1;

WHILE EXISTS (SELECT 1 FROM #TempProducts WHERE Processed = 0)
BEGIN
    DECLARE @CurrentID INT;
    SELECT TOP 1 @CurrentID = ProductID FROM #TempProducts WHERE Processed = 0;

    -- İşlem yap
    PRINT 'Processing: ' + CAST(@CurrentID AS VARCHAR);

    UPDATE #TempProducts SET Processed = 1 WHERE ProductID = @CurrentID;
END

DROP TABLE #TempProducts;

-- 9. Cursor Performance
-- Cursor'lar yavaştır çünkü:
-- - Row-by-row işlem yapar
-- - Memory overhead
-- - Locking issues

-- SET-BASED alternatif (ÖNER İLEN)
-- Cursor yerine:
UPDATE Products
SET UnitPrice = UnitPrice * 1.10
WHERE CategoryID = 1 AND UnitPrice < 20;

-- 10. Cursor Best Practices
-- - Mümkünse cursor kullanmayın (SET-BASED tercih edin)
-- - FORWARD_ONLY ve READ_ONLY kullanın
-- - LOCAL cursor kullanın
-- - Cursor'ı hemen CLOSE ve DEALLOCATE edin
-- - Cursor içinde başka cursor açmayın

-- Özet
-- Cursor satır satır işlem yapar
-- OPEN, FETCH, CLOSE, DEALLOCATE
-- @@FETCH_STATUS: Fetch durumu
-- SCROLL cursor: İleri-geri hareket
-- FOR UPDATE: Cursor üzerinden güncelleme
-- Performance: SET-BASED >>> CURSOR
-- Cursor son çare olarak kullanılmalı

PRINT 'Cursors örnekleri tamamlandı!'
PRINT 'NOT: Cursor yerine SET-BASED operasyonları tercih edin!'
