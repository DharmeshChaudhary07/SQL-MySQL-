 ==============================================================================
   SQL Common Table Expressions (CTEs)
-------------------------------------------------------------------------------
   This script demonstrates the use of Common Table Expressions (CTEs) in SQL Server.
   It includes examples of non-recursive CTEs for data aggregation and segmentation,
   as well as recursive CTEs for generating sequences and building hierarchical data.

   Table of Contents:
     1. NON-RECURSIVE CTE -> standalone and nested cte
     2. RECURSIVE CTE | GENERATE SEQUENCE
     3. RECURSIVE CTE | BUILD HIERARCHY
===============================================================================

 ==============================================================================
   NON-RECURSIVE CTE
===============================================================================


-- Step1: Find the total Sales Per Customer (Standalone CTE)

with total_sales as(
	select
		customerid,
		sum(sales) as totalsales	
	from orders
	group by customerid
)

-- select 
-- 	*
-- from total_sales as ts
-- join customers as c
-- on ts.customerid = c.customerid

-- Step2: Find the last order date for each customer (Standalone CTE)

, last_order_date as (
	select 
		customerid,
		max(orderdate) as lastorderdate
	from orders
	group by customerid
)

-- select
-- 	*
-- from last_order_date as lod
-- join customers as c
-- on c.customerid = lod.customerid



-- Step3: Rank Customers based on Total Sales Per Customer (Nested CTE)

-- with total_sales as(
-- 	select
-- 		customerid,
-- 		sum(sales) as totalsales
-- 	from orders
-- 	group by customerid
-- )

, rank_total_sales as (
	select 
		customerid,
		totalsales,
		rank() over(order by totalsales) as ranksales
    from total_sales
)

-- select 
-- 	*
-- from rank_total_sales as rts
-- join customers as c
-- on rts.customerid = c.customerid


-- Step4: segment customers based on their total sales (Nested CTE)

-- with total_sales as(
-- 	select
-- 		customerid,
-- 		sum(sales) as totalsales
-- 	from orders
-- 	group by customerid
-- )

, segment_customers as(
	select
		customerid,
		totalsales,
        case 
			when totalsales > 100 then 'High'
            when totalsales> 80 then 'medium'
            else 'low'
            end as segment
	from total_sales
)

-- select *
-- from segment_customers as sc
-- join customers as c
-- on c.customerid = sc.customerid


-- Main Query

select 
	c.customerid,
    c.firstname,
    c.lastname,
    ts.totalsales,
    lod.lastorderdate,
    rts.ranksales,
    sc.segment
from customers as c
left join total_sales as ts
on ts.customerid = c.customerid 	 	
left join last_order_date as lod
on lod.customerid = c.customerid
left join rank_total_sales as rts
on rts.customerid = c.customerid
left join segment_customers as sc
on sc.customerid = c.customerid

 ==============================================================================
   RECURSIVE CTE | GENERATE SEQUENCE
===============================================================================

 TASK 2:
   Generate a sequence of numbers from 1 to 20.

WITH recursive series AS (
    -- Anchor Query
	select 1 as mynum

    union all 
    -- Recursive Query
    select mynum + 1
	from series
    where mynum < 20
 
)
-- Main Query
select *
from series



 TASK 3: Generate a sequence of numbers from 1 to 1000.

SET SESSION cte_max_recursion_depth = 500; 

WITH recursive series AS (
    -- Anchor Query
	select 1 as mynum

    union all 
    -- Recursive Query
    select mynum + 1
	from series
    where mynum < 1000
)
-- Main Query
select *
from series


 ==============================================================================
   RECURSIVE CTE | BUILD HIERARCHY
===============================================================================

 TASK 4:
   Build the employee hierarchy by displaying each employees level within the organization.
   - Anchor Query: Select employees with no manager.
   - Recursive Query: Select subordinates and increment the level.


    -- Anchor Query: Top-level employees (no manager)

    -- Recursive Query: Get subordinate employees and increment level

-- Main Query
