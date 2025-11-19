# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a comprehensive Microsoft SQL Server (T-SQL) educational repository containing 45 numbered tutorial files covering SQL concepts from beginner to advanced level. The repository uses the Northwind sample database for examples and exercises.

## Database Setup

The repository uses Microsoft SQL Server running in Docker:

```bash
# Pull the SQL Server 2022 image
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Run SQL Server container
docker run \
    --name MyMsSql_Container_Name \
    -e 'ACCEPT_EULA=Y' \
    -e 'SA_PASSWORD=MyStringSqlPassword0012' \
    -e 'MSSQL_PID=Developer' \
    -p 1433:1433 \
    -h sqlServer2022 \
    -d mcr.microsoft.com/mssql/server:2022-latest
```

**Important**: The Northwind database must be created first before running the initialization script.

```bash
# Create database and initialize Northwind schema
# Run data/instnwnd.sql in the database you created
# This script does NOT create a database - you must create one first
```

## Repository Structure

### `/src/` - Tutorial SQL Files (01-45)

Tutorial files are numbered sequentially and cover SQL concepts in a progressive learning path from beginner to advanced:

**BEGINNER LEVEL - Basic Query Operations (01-13):**
- `01Select.sql` - SELECT statements, column selection, aliases, and basic functions
- `02Where.sql` - WHERE clause and filtering
- `03Like.sql` - Pattern matching with LIKE
- `04AggregateFunc.sql` - Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- `05StringFuncs.sql` - String manipulation functions
- `06NumericFuncs.sql` - Numeric operations and functions
- `07DateFuncs.sql` - Date and time functions
- `08Group.sql` - GROUP BY operations
- `09TopFunc.sql` - TOP clause and ROW_NUMBER
- `10Distinct.sql` - DISTINCT for unique values
- `11HavingFunc.sql` - HAVING clause for filtered aggregates
- `12OrderByFunc.sql` - ORDER BY for sorting results
- `13TableMerging.sql` - JOINs (INNER, LEFT, RIGHT, FULL OUTER, CROSS)

**INTERMEDIATE LEVEL - Data Manipulation & Advanced Queries (14-28):**
- `14DML&DDL.sql` - DDL (CREATE, ALTER, DROP) and DML (INSERT, UPDATE, DELETE) commands
- `15Insert.sql` - INSERT statements with various techniques
- `16Update.sql` - UPDATE statements with JOINs and cases
- `17Delete.sql` - DELETE statements
- `18Union.sql` - UNION and UNION ALL operations
- `19WithRollup.sql` - WITH ROLLUP for hierarchical subtotals
- `20WithCube.sql` - WITH CUBE for multi-dimensional aggregates
- `21CaseWhenThenElseEnd.sql` - CASE expressions for conditional logic
- `22WithTies.sql` - WITH TIES for handling ties in TOP queries
- `23With.sql` - Common Table Expressions (CTEs) and Recursive CTEs
- `24Subquery.sql` - Subquery operations (scalar, correlated, nested)
- `25BulkInsert.sql` - BULK INSERT for large data imports
- `26TruncateTable.sql` - TRUNCATE TABLE vs DELETE
- `27@@Identity.sql` - @@IDENTITY, SCOPE_IDENTITY(), IDENT_CURRENT()
- `28@@Rowcount.sql` - @@ROWCOUNT for affected rows

**ADVANCED LEVEL - Window Functions & Advanced Topics (29-31):**
- `29.sql` - Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, etc.)
- `30.sql` - PIVOT & UNPIVOT operations
- `31.sql` - Advanced Topics (Temp tables, Table variables, OUTPUT, MERGE, Table hints)

**DATABASE OBJECTS (32-37):**
- `32Views.sql` - Views (CREATE, ALTER, DROP, Indexed views, WITH CHECK OPTION)
- `33StoredProcedures.sql` - Stored Procedures with parameters, OUTPUT, RETURN
- `34Functions.sql` - User-Defined Functions (Scalar, Inline Table-Valued, Multi-Statement)
- `35Triggers.sql` - Triggers (AFTER, INSTEAD OF, inserted/deleted tables)
- `36Constraints.sql` - Constraints (PK, FK, UNIQUE, CHECK, DEFAULT, NOT NULL)
- `37Indexes.sql` - Indexes (Clustered, Non-clustered, Filtered, Covering indexes)

**ENTERPRISE FEATURES (38-45):**
- `38Transactions.sql` - Transaction Management (BEGIN, COMMIT, ROLLBACK, SAVEPOINT)
- `39ErrorHandling.sql` - Error Handling (TRY-CATCH, THROW, RAISERROR)
- `40IsolationLevels.sql` - Transaction Isolation Levels and concurrency control
- `41Cursors.sql` - Cursors (FORWARD_ONLY, SCROLL, FOR UPDATE)
- `42DynamicSQL.sql` - Dynamic SQL (EXEC, sp_executesql, SQL injection prevention)
- `43XMLHandling.sql` - XML Operations (FOR XML, OPENXML, XML data type)
- `44JSONHandling.sql` - JSON Operations (FOR JSON, OPENJSON, JSON_VALUE, JSON_MODIFY)
- `45ExecutionPlans.sql` - Query Optimization and Execution Plans

### `/data/` - Database Initialization

- `instnwnd.sql` - Northwind database schema and sample data (9350 lines)
  - Microsoft's classic Northwind sample database
  - Creates tables, views, stored procedures, and sample data
  - Must be run in an existing database (does not create database)

## Key Conventions

1. **Database Context**: All SQL files use `USE Northwind` to set the database context
2. **Case Insensitivity**: SQL Server is case-insensitive for keywords and identifiers
3. **Comments**: Turkish language comments explain each concept with detailed examples
4. **Example-Driven**: Each file contains multiple progressive examples (typically 10-20 per file)
5. **Northwind Schema**: Examples use standard Northwind tables (Customers, Orders, Products, Employees, etc.)
6. **File Structure**: Each file ends with a summary section (Özet) and PRINT statement
7. **Practical Focus**: Real-world scenarios and best practices are emphasized

## Working with SQL Files

When modifying or adding SQL tutorial files:

1. All tutorial files should start with `USE Northwind`
2. Include Turkish language comments explaining the concept
3. Provide multiple progressive examples showing different use cases (aim for 10-20 examples)
4. Use meaningful aliases (AS) for readability
5. Follow the numbered naming convention for new files
6. Test queries against the Northwind database schema
7. End with an "Özet" (Summary) section
8. Include a PRINT statement at the end

## Common Northwind Tables

The main tables used throughout the tutorials:
- **Customers** - Customer information (CustomerID, CompanyName, ContactName, City, Country)
- **Orders** - Order records (OrderID, CustomerID, EmployeeID, OrderDate, ShipDate, Freight)
- **Order Details** - Order line items (OrderID, ProductID, Quantity, UnitPrice, Discount)
- **Products** - Product catalog (ProductID, ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
- **Employees** - Employee information (EmployeeID, FirstName, LastName, Title, ReportsTo)
- **Categories** - Product categories (CategoryID, CategoryName, Description)
- **Suppliers** - Supplier information (SupplierID, CompanyName, ContactName, Country)
- **Shippers** - Shipping companies (ShipperID, CompanyName, Phone)

## Learning Path

The repository is structured for progressive learning:

1. **Beginner (Files 01-13)**: Start here if new to SQL
2. **Intermediate (Files 14-28)**: After mastering basics
3. **Advanced (Files 29-31)**: Window functions and advanced query techniques
4. **Database Objects (Files 32-37)**: Views, procedures, functions, triggers, constraints, indexes
5. **Enterprise (Files 38-45)**: Transactions, error handling, optimization, and advanced formats

## Best Practices

Throughout the tutorials, the following best practices are emphasized:
- Use parameterized queries to prevent SQL injection
- Prefer SET-BASED operations over cursors
- Use appropriate isolation levels for transactions
- Create indexes on frequently queried columns
- Use TRY-CATCH for error handling
- Prefer SCOPE_IDENTITY() over @@IDENTITY
- Use covering indexes to avoid key lookups
- Monitor query execution plans for optimization

## Language Note

All documentation and comments are in Turkish (Türkçe). Examples and explanations follow Turkish educational conventions.

## SQL Server Version

Examples are designed for SQL Server 2016+ but most work on SQL Server 2012+. Features requiring newer versions are noted in comments (e.g., JSON support requires SQL Server 2016+, STRING_AGG requires SQL Server 2017+).
