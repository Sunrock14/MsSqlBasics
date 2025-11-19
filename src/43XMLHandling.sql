USE Northwind

-- XML HANDLING
-- SQL Server'da XML veri tipleri ve işlemleri

-- 1. FOR XML RAW
-- Satırları <row> elementi olarak döndürür
SELECT TOP 3
    ProductID,
    ProductName,
    UnitPrice
FROM Products
FOR XML RAW;

-- 2. FOR XML RAW with Root
SELECT TOP 3 ProductID, ProductName, UnitPrice
FROM Products
FOR XML RAW, ROOT('Products');

-- 3. FOR XML AUTO
-- Tablo isimlerini element adı olarak kullanır
SELECT TOP 3
    ProductID,
    ProductName,
    UnitPrice
FROM Products
FOR XML AUTO;

-- 4. FOR XML PATH
-- Custom XML yapısı oluşturma
SELECT TOP 3
    ProductID AS '@id',
    ProductName AS 'Name',
    UnitPrice AS 'Price'
FROM Products
FOR XML PATH('Product'), ROOT('Products');

-- 5. XML Data Type
CREATE TABLE #XmlTest (
    ID INT,
    XmlData XML
);

INSERT INTO #XmlTest VALUES
(1, '<Product><Name>Chai</Name><Price>18</Price></Product>'),
(2, '<Product><Name>Chang</Name><Price>19</Price></Product>');

SELECT * FROM #XmlTest;

-- 6. XML Query Methods
DECLARE @xml XML =
'<Products>
    <Product id="1">
        <Name>Chai</Name>
        <Price>18.00</Price>
    </Product>
    <Product id="2">
        <Name>Chang</Name>
        <Price>19.00</Price>
    </Product>
</Products>';

-- query(): XQuery expression çalıştırır
SELECT @xml.query('/Products/Product[1]');

-- value(): Tek değer çıkarır
SELECT @xml.value('(/Products/Product[1]/Name)[1]', 'NVARCHAR(50)') AS ProductName;

-- exist(): Element varlığını kontrol eder (1/0)
SELECT @xml.exist('/Products/Product[@id="1"]') AS ProductExists;

-- nodes(): XML'i satırlara böler
SELECT
    T.c.value('@id', 'INT') AS ProductID,
    T.c.value('(Name)[1]', 'NVARCHAR(50)') AS ProductName,
    T.c.value('(Price)[1]', 'MONEY') AS Price
FROM @xml.nodes('/Products/Product') AS T(c);

-- modify(): XML'i değiştir (insert, delete, replace)
SET @xml.modify('insert <Product id="3"><Name>New</Name></Product> into (/Products)[1]');
SELECT @xml;

-- 7. OPENXML
-- XML'i tablo formatına çevirme (eski yöntem)
DECLARE @hdoc INT;
DECLARE @xmlDoc XML = '
<Products>
    <Product ProductID="1" ProductName="Chai" UnitPrice="18"/>
    <Product ProductID="2" ProductName="Chang" UnitPrice="19"/>
</Products>';

EXEC sp_xml_preparedocument @hdoc OUTPUT, @xmlDoc;

SELECT *
FROM OPENXML(@hdoc, '/Products/Product')
WITH (
    ProductID INT '@ProductID',
    ProductName NVARCHAR(50) '@ProductName',
    UnitPrice MONEY '@UnitPrice'
);

EXEC sp_xml_removedocument @hdoc;

-- 8. XML Indexes
-- Primary XML index
-- CREATE PRIMARY XML INDEX idx_xml ON #XmlTest(XmlData);

-- 9. XML Schema Collection
/*
CREATE XML SCHEMA COLLECTION ProductSchema AS '
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <xsd:element name="Product">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element name="Name" type="xsd:string"/>
                <xsd:element name="Price" type="xsd:decimal"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>';
*/

-- 10. XML to Table
-- Modern yöntem: nodes()
SELECT
    Product.value('(ProductID)[1]', 'INT') AS ProductID,
    Product.value('(ProductName)[1]', 'NVARCHAR(50)') AS ProductName
FROM (
    SELECT TOP 5 * FROM Products FOR XML PATH('Product'), ROOT('Products')
) AS XmlSource(XmlData)
CROSS APPLY XmlData.nodes('/Products/Product') AS T(Product);

-- Temizlik
DROP TABLE IF EXISTS #XmlTest;

-- Özet
-- FOR XML: SQL sonucunu XML'e çevirir (RAW, AUTO, PATH)
-- XML data type: XML saklama
-- query(): XQuery çalıştırır
-- value(): Tek değer çıkarır
-- exist(): Varlık kontrolü
-- nodes(): XML'i satırlara böler
-- modify(): XML'i değiştirir
-- OPENXML: XML'den tablo (eski yöntem)
-- XML indexes: Performance için

PRINT 'XML Handling örnekleri tamamlandı!'
