==============================================================================
   SQL Window Value Functions
-------------------------------------------------------------------------------
   These functions let you reference and compare values from other rows 
   in a result set without complex joins or subqueries, enabling advanced 
   analysis on ordered data.

   Table of Contents:
     1. LEAD
     2. LAG
     3. FIRST_VALUE
     4. LAST_VALUE
=================================================================================



============================================================
   SQL WINDOW VALUE | LEAD, LAG
============================================================ 

TASK 1:
   Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
   Between the Current and Previous Months

select
	*,
    currentmonthsales - previousmonthsales as differncebtwsales,
    round(((currentmonthsales- previousmonthsales) / previousmonthsales) * 100,2) as percentagechange
from(
	select
		month(orderdate) as ordermonth,
		sum(sales) as currentmonthsales,
		lag(sum(sales)) over(order by month(orderdate)) as previousmonthsales
	from orders
	group by month(orderdate)
)t



TASK 2:
   Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders

select
	customerid,
    avg(differncebtw),
    rank() over(order by coalesce(avg(differncebtw),9999999)) as rankcustomers
from(
select 
	orderid,
    customerid,
    orderdate as currentday,
    lead(orderdate) over(partition by customerid order by orderdate) as nextorderdate,
    datediff(
		orderdate,
        lead(orderdate) over(partition by customerid order by orderdate)
        )as differncebtw
from orders
)t
group by customerid



============================================================
   SQL WINDOW VALUE | FIRST & LAST VALUE
  
============================================================ 

TASK 3:
   Find the Lowest and Highest Sales for Each Product,
   and determine the difference between the current Sales and the lowest Sales for each Product.

select
	orderid,
    productid,
    sales,
    first_value(sales) over(partition by productid order by sales) as lowestsales,
    last_value(sales) over(partition by productid order by sales rows between current row and unbounded following) as highestsales,
    sales - first_value(sales) over(partition by productid order by sales) as salesdiff
from orders

