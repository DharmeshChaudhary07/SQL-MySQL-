
==============================================================================
   SQL Temporary Tables
-------------------------------------------------------------------------------
   This script provides a generic example of data migration using a temporary
   table. 
=================================================================================


==============================================================================
   Step 1: Create Temporary Table (#Orders)
============================================================================== 

create temporary table temporders as
select
	*
from orders

select * from temporders



==============================================================================
   Step 2: Clean Data in Temporary Table
============================================================================== 

SET SQL_SAFE_UPDATES = 0;

delete from temporders
where orderstatus = 'delivered'

select * from temporders


 ==============================================================================
   Step 3: Load Cleaned Data into Permanent Table (Sales.OrdersTest)
============================================================================== 

create table orderstest as 
select  *
from temporders
