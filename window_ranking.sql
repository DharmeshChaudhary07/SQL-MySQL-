
==============================================================================
   SQL Window Ranking Functions
-------------------------------------------------------------------------------
   These functions allow you to rank and order rows within a result set 
   without the need for complex joins or subqueries. They enable you to assign 
   unique or non-unique rankings, group rows into buckets, and analyze data 
   distributions on ordered data.

   Table of Contents:
     1. ROW_NUMBER
     2. RANK
     3. DENSE_RANK
     4. NTILE
     5. CUME_DIST
=================================================================================


============================================================
   SQL WINDOW RANKING | ROW_NUMBER, RANK, DENSE_RANK
============================================================ 

TASK 1:
   Rank Orders Based on Sales from Highest to Lowest

select 
	orderid,
    productid,
    sales, 
    quantity,
    row_number() over(order by sales desc),
    RANK() OVER (ORDER BY Sales DESC) AS SalesRank_Rank,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS SalesRank_Dense
from orders



TASK 2:
   Use Case | Top-N Analysis: Find the Highest Sale for Each Product

select
	*
from(
	select 
		orderid,
		productid,
		sales, 
		quantity,
		row_number() over(partition by productid order by sales desc) as rankbysale
	from orders
)t where rankbysale = 1



TASK 3:
   Use Case | Bottom-N Analysis: Find the Lowest 2 Customers Based on Their Total Sales
 
select
	*
from(
	select 
		customerid,
		sum(sales) as totalsalebycustomer,
		row_number() over(order by sum(sales)) as orderbysale
	from orders
    group by customerid
)t where orderbysale <= 2	



TASK 4:
   Use Case | Assign Unique IDs to the Rows of the 'Order Archive'

SELECT
	*,
	row_number() over(order by orderid, orderdate) as uniqueid
from orders_archive



TASK 5:
   Use Case | Identify Duplicates:
   Identify Duplicate Rows in 'Order Archive' and return a clean result without any duplicates

select
	*
from(
	select
		*, 
		row_number() over(partition by orderid order by creationtime desc) as rn
	from orders_archive
)t where rn = 1



============================================================
   SQL WINDOW RANKING | NTILE
============================================================ 

TASK 6:
   Divide Orders into Groups Based on Sales

select
	*,
    ntile(1) over(order by sales desc) as groupbysales1,
    ntile(2) over(order by sales desc) as groupbysales2,
    ntile(3) over(order by sales desc) as groupbysales3,
    ntile(4) over(order by sales desc) as groupbysales4,
    ntile(2) over(partition by orderid order by sales desc) as groupbysales
from orders



TASK 7:
   Segment all Orders into 3 Categories: High, Medium, and Low Sales.

select 
	*, 
	case 
		when orderbysales = 1 then 'high'
	    when orderbysales = 2 then 'medium'
        when orderbysales = 3 then 'low'
	end as categories
from(
	select
		orderid,
		productid,
		customerid,
		sales,
		ntile(3) over(order by sales desc) as orderbysales
	from orders
)t



TASK 8:
   Divide Orders into Groups for Processing

select
	*,
    ntile(5) over(order by orderid desc) as ordersingroup
from orders

============================================================
   SQL WINDOW RANKING | CUME_DIST
============================================================ 

Returns the fraction of rows that are less than or equal to the current row


Heres the simplest way to think about it:
CUME_DIST() → "What percent of rows are at or below me (including ties)?"
PERCENT_RANK() → "Where do I fall between the lowest (0%) and highest (100%) value?"


TASK 9:
   Find Products that Fall Within the Highest 40% of the Prices

select * from products

select 
	*
from(
	select
		*,
		cume_dist() over(order by price desc) as rangebtw
	from products
)t where rangebtw <= 0.4



