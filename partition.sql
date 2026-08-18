 ==============================================================================
   SQL Partitioning
-------------------------------------------------------------------------------
   This script demonstrates SQL Server partitioning features. It covers the creation of partition functions, filegroups, data files, partition schemes,
   partitioned tables, and verification queries. It also shows how to compare execution plans between partitioned and non-partitioned tables.

   Table of Contents:
     1. Create a Partition Function
     2. Create Filegroups
     3. Create Data Files
     4. Create Partition Scheme
     5. Create the Partitioned Table
     6. Insert Data Into the Partitioned Table
     7. Verify Partitioning and Compare Execution Plans
=================================================================================

select * from dbcustomers

select *
from dbcustomers
where score > 500

EXPLAIN SELECT customerid, firstname, score FROM dbcustomers WHERE score > 500;

 ==============================================================================
   Step 1: Create a Partition Function
============================================================================== 

select 
* from orders

create table dborder(
select * from orders)

select 
* from dborder

-- Create Left Range Partition Functions based on Years

## (it start with alter because in mysql it doesnt treat parition function as different object)	
## (MySQL has no such standalone object. There is no "partition function" you create independently in MySQL — partitioning is always 
##  direct property of one specific table, expressed as part of that table's own definition. 
## There's nothing separate being created; you're describing how this table's own storage is organized.)

SHOW CREATE TABLE dborder;

## Foreign key present → partitioning fails, period, regardless of what column you're partitioning on. Only fix: drop the FK.
## Primary key present → partitioning works fine, as long as your partitioning column is part of that primary key. 
## If it already is, or if you adjust it to include the column, partitioning succeeds normally.


ALTER TABLE dborder
PARTITION BY RANGE COLUMNS (orderdate) (
    PARTITION p0 VALUES LESS THAN ('2024-01-01'),
    PARTITION p1 VALUES LESS THAN ('2025-01-01'),
    PARTITION p2 VALUES LESS THAN ('2026-01-01'),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);


## For "list all existing partitions" — as covered earlier, MySQL has no separate "partition function" catalog like 
## SQL Server's sys.partition_functions, since there's no standalone function object. 
## The equivalent here is querying information_schema.partitions, scoped to this table:

-- Query lists all existing Partition Function

select 
	* 
from information_schema.partitions
where table_schema = DATABASE()
		AND table_name = 'dborder'
			AND partition_name IS NOT NULL;

	
==============================================================================
   Step 2: Create Filegroups
============================================================================== 


-- Create Filegroups in SalesDB
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- Optional: Remove a Filegroup if needed
ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023;

-- Query: List All Existing Filegroups (filter by name pattern if needed)
SELECT *
FROM sys.filegroups
WHERE type = 'FG'
    
 ==============================================================================
   Step 3: Create Data Files
============================================================================== 

-- Create Files and map them to Filegroups
ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2023, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2024, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2025, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2026, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

-- Query: List All Existing Files in SalesDB
SELECT 
    fg.name AS FilegroupName,
    mf.name AS LogicalFileName,
    mf.physical_name AS PhysicalFilePath,
    mf.size / 128 AS SizeInMB
FROM 
    sys.filegroups fg
JOIN 
    sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE 
    mf.database_id = DB_ID('SalesDB')

 ==============================================================================
   Step 4: Create Partition Scheme
============================================================================== 

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)

-- Query lists all Partition Scheme
SELECT 
    ps.name AS PartitionSchemeName,
    pf.name AS PartitionFunctionName,
    ds.destination_id AS PartitionNumber,
    fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id

 ==============================================================================
   Step 5: Create the Partitioned Table
============================================================================== 

CREATE TABLE Sales.Orders_Partitioned 
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)

 ==============================================================================
   Step 6: Insert Data Into the Partitioned Table
============================================================================== 

INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2025-12-31', 20);
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-01-01', 100);

 ==============================================================================
   Step 7: Verify Partitioning and Compare Execution Plans
============================================================================== 

-- Query: Verify that data is correctly partitioned and assigned to the appropriate filegroups 
SELECT 
    p.partition_number AS PartitionNumber,
    f.name AS PartitionFilegroup, 
    p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned';

-- Compare Execution Plans by creating a non-partitioned copy
-- Create a table without partitions using SELECT INTO
SELECT *
INTO Sales.Orders_NoPartition
FROM Sales.Orders_Partitioned;
  
-- Query on Partitioned Table
SELECT *
FROM Sales.Orders_Partitioned
WHERE OrderDate IN ('2026-01-01', '2025-12-31');
  
-- Query on Non-Partitioned Table
SELECT *
FROM Sales.Orders_NoPartition
WHERE OrderDate IN ('2026-01-01', '2025-12-31');