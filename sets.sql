
--    SQL SET Operations

--    SQL set operations enable you to combine results from multiple queries into a single result set. 
--    This script demonstrates the rules and usage of set operations, including UNION, UNION ALL, EXCEPT, and INTERSECT.
--    
--    Table of Contents:
--      1. SQL Operation Rules
--      2. UNION
--      3. UNION ALL
--      4. EXCEPT
--      5. INTERSECT


-- =================================================================================
-- RULES OF SET OPERATIONS

-- RULE: Data Types
--    The data types of columns in each query should match.

SELECT
    FirstName,
    LastName,
    Country
FROM salesdb.Customers
UNION
SELECT
    FirstName,
    LastName
FROM salesdb.Employees;

-- Error Code: 1222. The used SELECT statements have a different number of columns	



--  RULE: Data Types (Example)
--    The data types of columns in each query should match.


SELECT
    CustomerID,
    LastName
FROM Salesdb.Customers
UNION
SELECT
    FirstName,
    LastName
FROM Salesdb.Employees;

-- RULE: Column Order
--   The order of the columns in each query must be the same.

SELECT
    LastName,
    CustomerID
FROM Salesdb.Customers
UNION
SELECT
    EmployeeID,
    LastName
FROM Salesdb.Employees;

-- RULE: Column Aliases
--    The column names in the result set are determined by the column names specified in the first SELECT statement.

SELECT
    CustomerID AS ID,
    LastName AS Last_Name
FROM Salesdb.Customers
UNION
SELECT
    EmployeeID,
    LastName
FROM Salesdb.Employees;

-- RULE: Correct Columns
--    Ensure that the correct columns are used to maintain data consistency.

SELECT
    FirstName,
    LastName
FROM Salesdb.Customers
UNION
SELECT
    LastName,
    FirstName
FROM Salesdb.Employees;

select * from customers;

-- ==============================================================================
--    SETS: UNION, UNION ALL, EXCEPT, INTERSECT


-- TASK 1: 
--    Combine the data from Employees and Customers into one table using UNION 

SELECT
    FirstName,
    LastName
FROM Customers
UNION
SELECT
    FirstName,
    LastName
FROM Employees;

-- TASK 2: 
--   Combine the data from Employees and Customers into one table, including duplicates, using UNION ALL 

SELECT
    FirstName,
    LastName
FROM Customers
UNION ALL
SELECT
    FirstName,
    LastName
FROM Employees;

-- TASK 3: 
--    Find employees who are NOT customers using EXCEPT 

SELECT
    FirstName,
    LastName
FROM Employees
EXCEPT
SELECT
    FirstName,
    LastName
FROM Customers;

-- TASK 4: 
--    Find employees who are also customers using INTERSECT 

SELECT
    FirstName,
    LastName
FROM Employees
INTERSECT
SELECT
    FirstName,
    LastName
FROM Customers;

-- TASK 5: 
--    Combine order data from Orders and OrdersArchive into one report without duplicates 

SELECT
    'Orders' AS SourceTable,
    OrderID,
    ProductID,
    CustomerID,
    SalesPersonID,
    OrderDate,
    ShipDate,
    OrderStatus,
    ShipAddress,
    BillAddress,
    Quantity,
    Sales,
    CreationTime
FROM Orders
UNION
SELECT
    'OrdersArchive' AS SourceTable,
    OrderID,
    ProductID,
    CustomerID,
    SalesPersonID,
    OrderDate,
    ShipDate,
    OrderStatus,
    ShipAddress,
    BillAddress,
    Quantity,
    Sales,
    CreationTime
FROM Orders_Archive
ORDER BY OrderID;