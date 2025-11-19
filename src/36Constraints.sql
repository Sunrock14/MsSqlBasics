USE Northwind

-- CONSTRAINTS (Kısıtlamalar)
-- Veri bütünlüğünü sağlamak için kullanılan kurallar

-- 1. PRIMARY KEY Constraint
-- Benzersiz ve NULL olamaz
CREATE TABLE #Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

-- Alternatif sözdizimi
CREATE TABLE #Departments (
    DepartmentID INT,
    DepartmentName NVARCHAR(50),
    CONSTRAINT PK_Departments PRIMARY KEY (DepartmentID)
);

-- 2. FOREIGN KEY Constraint
-- Referans bütünlüğünü sağlar
CREATE TABLE #EmployeeDept (
    EmployeeID INT,
    DepartmentID INT,
    CONSTRAINT FK_EmployeeDept_Employees FOREIGN KEY (EmployeeID)
        REFERENCES #Employees(EmployeeID),
    CONSTRAINT FK_EmployeeDept_Departments FOREIGN KEY (DepartmentID)
        REFERENCES #Departments(DepartmentID)
);

-- 3. UNIQUE Constraint
-- Sütun değerlerinin benzersiz olmasını sağlar (NULL kabul eder)
CREATE TABLE #Users (
    UserID INT PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE,
    Email NVARCHAR(100),
    CONSTRAINT UQ_Users_Email UNIQUE (Email)
);

-- 4. CHECK Constraint
-- Belirli bir koşula uygunluğu kontrol eder
CREATE TABLE #Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    UnitPrice MONEY,
    UnitsInStock INT,
    CONSTRAINT CK_Products_Price CHECK (UnitPrice >= 0),
    CONSTRAINT CK_Products_Stock CHECK (UnitsInStock >= 0)
);

-- Kompleks CHECK
CREATE TABLE #Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    ShipDate DATE,
    CONSTRAINT CK_Orders_Dates CHECK (ShipDate >= OrderDate)
);

-- 5. DEFAULT Constraint
-- Varsayılan değer atar
CREATE TABLE #Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(50),
    Country NVARCHAR(50) DEFAULT 'USA',
    CreatedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

INSERT INTO #Customers (CustomerID, CustomerName)
VALUES (1, 'Test Customer');  -- Country, CreatedDate, IsActive otomatik

SELECT * FROM #Customers;

-- 6. Composite PRIMARY KEY
-- Birden fazla sütundan oluşan primary key
CREATE TABLE #OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID)
);

-- 7. Cascade Options
-- Foreign key ile ilişkili kayıtlarda otomatik işlem
CREATE TABLE #ParentTable (
    ParentID INT PRIMARY KEY,
    ParentName NVARCHAR(50)
);

CREATE TABLE #ChildTable (
    ChildID INT PRIMARY KEY,
    ParentID INT,
    ChildName NVARCHAR(50),
    CONSTRAINT FK_Child_Parent FOREIGN KEY (ParentID)
        REFERENCES #ParentTable(ParentID)
        ON DELETE CASCADE  -- Parent silinince child'lar da silinir
        ON UPDATE CASCADE  -- Parent güncellenince child'lar da güncellenir
);

-- 8. Adding Constraint to Existing Table
-- ALTER TABLE ile constraint ekleme
ALTER TABLE #Products
ADD CONSTRAINT CK_Products_Name CHECK (LEN(ProductName) > 2);

-- 9. Dropping Constraint
ALTER TABLE #Products DROP CONSTRAINT CK_Products_Name;

-- 10. Disabling/Enabling Constraints
-- CHECK ve FOREIGN KEY disable edilebilir
ALTER TABLE #Products NOCHECK CONSTRAINT CK_Products_Price;  -- Disable
ALTER TABLE #Products CHECK CONSTRAINT CK_Products_Price;     -- Enable

-- 11. NOT NULL Constraint
CREATE TABLE #TestTable (
    ID INT PRIMARY KEY,
    RequiredField NVARCHAR(50) NOT NULL,
    OptionalField NVARCHAR(50) NULL
);

-- Existing column'a NOT NULL ekleme
-- Önce NULL değerleri temizle
-- UPDATE #TestTable SET OptionalField = 'Default' WHERE OptionalField IS NULL;
-- ALTER TABLE #TestTable ALTER COLUMN OptionalField NVARCHAR(50) NOT NULL;

-- 12. Viewing Constraints
-- Tüm constraints'leri görme
SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
WHERE tc.TABLE_NAME LIKE '#%'
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE;

-- Belirli bir tablonun constraints'leri
EXEC sp_helpconstraint '#Products';

-- Temizlik
DROP TABLE IF EXISTS #ChildTable;
DROP TABLE IF EXISTS #ParentTable;
DROP TABLE IF EXISTS #OrderDetails;
DROP TABLE IF EXISTS #Customers;
DROP TABLE IF EXISTS #Orders;
DROP TABLE IF EXISTS #Products;
DROP TABLE IF EXISTS #Users;
DROP TABLE IF EXISTS #EmployeeDept;
DROP TABLE IF EXISTS #Departments;
DROP TABLE IF EXISTS #Employees;
DROP TABLE IF EXISTS #TestTable;

-- Özet
-- PRIMARY KEY: Benzersiz tanımlayıcı, NULL olamaz
-- FOREIGN KEY: Referans bütünlüğü, ON DELETE/UPDATE CASCADE
-- UNIQUE: Benzersiz değerler, NULL kabul eder
-- CHECK: Koşul kontrolü
-- DEFAULT: Varsayılan değer
-- NOT NULL: NULL değer kabul etmez
-- Constraints veri bütünlüğünü database seviyesinde garanti eder

PRINT 'Constraints örnekleri tamamlandı!'
