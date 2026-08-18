 ==============================================================================
   SQL Indexing
-------------------------------------------------------------------------------
   This script demonstrates various index types in SQL Server including clustered,
   non-clustered, columnstore, unique, and filtered indexes. It provides examples 
   of creating a heap table, applying different index types, and testing their 
   usage with sample queries.

   Table of Contents:
	   Index Types:
			 - Clustered and Non-Clustered Indexes
			 - Leftmost Prefix Rule Explanation
			 - Columnstore Indexes
			 - Unique Indexes
			 - Filtered Indexes
		Index Monitoring:
			 - Monitor Index Usage
			 - Monitor Missing Indexes
			 - Monitor Duplicate Indexes
			 - Update Statistics
			 - Fragmentations
=================================================================================


==============================================================================
==============================================================================
   Clustered and Non-Clustered Indexes
============================================================================== 

-- Create a Heap Table as a copy of Sales.Customer
 
create table dbcustomers (
select * 
from customers
)

drop table dbcustomers


-- Test Query: Select Data and Check the Execution Plan

SELECT *
FROM dbcustomers
WHERE customerid = 1


-- Create a Clustered Index on Sales.DBCustomers using CustomerID

ALTER TABLE dbcustomers
ADD PRIMARY KEY (customerid);


-- Attempt to create a second Clustered Index on the same table (will fail) 

ALTER TABLE dbcustomers
ADD PRIMARY KEY (firstname);

## 04:33:09	ALTER TABLE dbcustomers ADD PRIMARY KEY (firstname)	Error Code: 1068. Multiple primary key defined	0.00080 sec##


-- Drop the Clustered Index 
 
ALTER TABLE dbcustomers
MODIFY customerid INT NOT NULL,
DROP PRIMARY KEY;

-- Test Query: Select Data with a Filter on LastName

select *
from dbcustomers
where lastname = 'brown';


-- Create a Non-Clustered Index on LastName

create index idx_dbcustomers_lastname
on dbcustomers (lastname);

drop index idx_dbcustomers_lastname
ON dbcustomers;


-- Create an additional Non-Clustered Index on FirstName

create index idx_dbcustomers_firstname
on dbcustomers (firstname);


-- Create a Composite (Composed) Index on Country and Score 


create index idx_dbcustomers_countryscores
on dbcustomers (country, score);


-- Query that uses the Composite Index

select *
from dbcustomers
where country = 'USA'
	and score > 500;
    
    
-- Query that likely won't use the Composite Index due to column order

select *
from dbcustomers
where score > 500 and
	country = 'USA'
    
## Both hit the index the same way, both should produce the same EXPLAIN plan, and both should run in essentially the same time 
##(any tiny difference you might see between runs is just system noise — caching, other load, etc. — not caused by the condition order).



==============================================================================
   Leftmost Prefix Rule Explanation
-------------------------------------------------------------------------------
   For a composite index defined on columns (A, B, C, D), the index can be
   utilized by queries that filter on:
     - Column A only,
     - Columns A and B,
     - Columns A, B, and C.
   However, queries that filter on:
     - Column B only,
     - Columns A and C,
     - Columns A, B, and D,
   will not be able to fully utilize the index due to the leftmost prefix rule.
=================================================================================



================================================================================
		Column store indexes is for sql server not for mysql server
================================================================================


-- ==============================================================================
--    Columnstore Indexes
-- ============================================================================== 

-- -- Create a Clustered Columnstore Index on Sales.DBCustomers
-- CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
-- ON Sales.DBCustomers;
-- GO

-- -- Create a Non-Clustered Columnstore Index on the FirstName column
-- CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
-- ON Sales.DBCustomers (FirstName);
-- GO

-- -- Switch context to AdventureWorksDW2022 for FactInternetSales examples 
-- USE AdventureWorksDW2022;

-- -- Create a Heap Table from FactInternetSales
-- SELECT *
-- INTO FactInternetSales_HP
-- FROM FactInternetSales;

-- -- Create a RowStore Table from FactInternetSales
-- SELECT *
-- INTO FactInternetSales_RS
-- FROM FactInternetSales;

-- -- Create a Clustered Index (RowStore) on FactInternetSales_RS
-- CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
-- ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber);

-- -- Create a Columnstore Table from FactInternetSales
-- SELECT *
-- INTO FactInternetSales_CS
-- FROM FactInternetSales;

-- -- Create a Clustered Columnstore Index on FactInternetSales_CS
-- CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
-- ON FactInternetSales_CS;

==============================================================================
   Unique Indexes
============================================================================== 

-- Attempt to create a Unique Index on the Category column in Sales.Products.
   Note: This may fail if duplicate values exist.


CREATE UNIQUE INDEX idx_Products_Category
ON Products (Category);

## CREATE UNIQUE INDEX idx_Products_Category ON Products (Category)Error Code: 1062. Duplicate entry 'Clothing' for key 'products.idx_Products_Category'	0.051 sec


-- Create a Unique Index on the Product column in Sales.Products

CREATE UNIQUE INDEX idx_Products_Product
ON Products (Product);
  
-- Test Insert: Attempt to insert a duplicate value (should fail if the constraint is enforced)

INSERT INTO Products (ProductID, Product)
VALUES (106, 'Caps');

## INSERT INTO Products (ProductID, Product) VALUES (106, 'Caps')	Error Code: 1062. Duplicate entry 'Caps' for key 'products.idx_Products_Product'	0.0022 sec


================================================================================
		filterindex is for sql server not for mysql server
================================================================================

-- ==============================================================================
--    Filtered Indexes
-- ============================================================================== 

-- -- Test Query: Select Customers where Country is 'USA' 

-- SELECT *
-- FROM Sales.Customers
-- WHERE Country = 'USA';
--   
-- -- Create a Non-Clustered Filtered Index on the Country column for rows where Country = 'USA'
-- CREATE NONCLUSTERED INDEX idx_Customers_Country
-- ON Sales.Customers (Country)
-- WHERE Country = 'USA';

================================================================================
							Monitoring index 
================================================================================
 
Here the full runnable MySQL set, using your dbcustomers table as the example throughout.
1. List all indexes on a table

SHOW INDEX FROM dbcustomers;

Shows every index (name, column, uniqueness, cardinality, type) in one go 

================================================================================

2. Monitor index usage

SELECT 
    table_schema,
    table_name,
    index_name,
    rows_selected,
    rows_inserted,
    rows_updated,
    rows_deleted
FROM sys.schema_index_statistics
WHERE table_schema = DATABASE()
  AND table_name = 'dbcustomers';
  
DATABASE() auto-fills your currently selected database — swap in a literal name if you re querying across databases.

================================================================================

3. Find indexes you have but never use

SELECT * 
FROM sys.schema_unused_indexes
WHERE object_schema = DATABASE()
  AND object_name = 'dbcustomers';
  
If this returns nothing, either everything's being used, or MySQL hasn't accumulated enough usage stats yet (stats reset on server restart) — 
run some real queries first, then check again.

================================================================================

4. Find duplicate/redundant indexes
sql
SELECT * 
FROM sys.schema_redundant_indexes
WHERE table_schema = DATABASE()
  AND table_name = 'dbcustomers';
This flags things like having both idx_customerid and a composite idx_customerid_country where the first is now redundant.

================================================================================

5. Update statistics
sql
ANALYZE TABLE dbcustomers;
Run this after large data changes (bulk inserts/deletes) so the optimizers row estimates stay accurate.
 No per-column granularity like SQL Server — its whole-table only.

================================================================================

6. Rebuild table + indexes (defragment)
sql
OPTIMIZE TABLE dbcustomers;
For InnoDB, run this after heavy deletes/updates to reclaim space and rebuild index structures. 
Note: this locks the table for its duration on large tables, so dont run it on a busy production table without checking size/impact first.

================================================================================

7. Check table/index size (bonus — useful for spotting bloat, no SQL Server example was given but this is commonly paired with fragmentation checks)
sql
SELECT 
    table_name,
    index_name,
    ROUND(stat_value * @@innodb_page_size / 1024 / 1024, 2) AS size_mb
FROM mysql.innodb_index_stats
WHERE database_name = DATABASE()
  AND table_name = 'dbcustomers'
  AND stat_name = 'size';

================================================================================

Quick sanity check before you run these: confirm your sys schema exists —
sql
SHOW DATABASES LIKE 'sys';







