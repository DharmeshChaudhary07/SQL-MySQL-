==============================================================================
   SQL Window Functions
-------------------------------------------------------------------------------
   SQL window functions enable advanced calculations across sets of rows 
   related to the current row without resorting to complex subqueries or joins.
   This script demonstrates the fundamentals and key clauses of window functions,
   including the OVER, PARTITION, ORDER, and FRAME clauses, as well as common rules 
   and a GROUP BY use case.

   Table of Contents:
     1. SQL Window Basics
     2. SQL Window OVER Clause
     3. SQL Window PARTITION Clause
     4. SQL Window ORDER Clause
     5. SQL Window FRAME Clause
     6. SQL Window Rules
     7. SQL Window with GROUP BY
=================================================================================


==============================================================================
   SQL WINDOW FUNCTIONS | BASICS
===============================================================================

TASK 1: 
   Calculate the Total Sales Across All Orders 

select 
	sum(sales) as totalsales
from orders


TASK 2: 
   Calculate the Total Sales for Each Product 
   
select *
from orders


select
	productid,
	sum(sales) as totalsales
from orders
group by productid 


==============================================================================
   SQL WINDOW FUNCTIONS | OVER CLAUSE
===============================================================================

SELECT
OrderID, OrderDate, ProductID,
SUM (Sales) Totalsales
FROM Orders
GROUP BY
OrderID, OrderDate, ProductID 



 TASK 3: 
   Find the total sales across all orders,
   additionally providing details such as OrderID and OrderDate 

select
	orderid,
    orderdate,
	sum(sales) over()
from orders

==============================================================================
   SQL WINDOW FUNCTIONS | PARTITION CLAUSE
===============================================================================


TASK 4: 
   Find the total sales across all orders and for each product,
   additionally providing details such as OrderID and OrderDate 

select
	orderid,
    orderdate,
    count(*) over(partition by productid) as totalcount,
	sum(sales) over(partition by productid) as totalsales
from orders


TASK 5: 
   Find the total sales across all orders, for each product,
   and for each combination of product and order status,
   additionally providing details such as OrderID and OrderDate 

select
	orderid,
    productid,
    orderdate,
    orderstatus,
    sales,
    sum(sales) over(partition by productid) as sales_by_product,
    sum(sales) over(partition by productid, orderstatus) as sales_by_productstatus
from orders


==============================================================================
   SQL WINDOW FUNCTIONS | ORDER CLAUSE
===============================================================================


 TASK 6: 
   Rank each order by Sales from highest to lowest 

select
	orderid,
    sales,
    rank() over(order by sales) as ranksales,
    rank() over(order by sales asc) as ranksalesASC,
    rank() over(order by sales desc) as ranksalesDESC
from orders

==============================================================================
   SQL WINDOW FUNCTIONS | FRAME CLAUSE
===============================================================================


TASK 7: 
   Calculate Total Sales by Order Status for current and next two orders 

select
	orderid,
    orderdate,
    orderstatus,
    sales,
    sum(sales) over(partition by orderstatus order by orderdate rows between current row and 2 following) as totalsale
from orders
	

TASK 8: 
   Calculate Total Sales by Order Status for current and previous two orders 

select
	orderid,
    orderdate,
    orderstatus,
    sales,
    sum(sales) over(partition by orderstatus order by orderdate rows between 2 preceding and current row) as totatsales
from orders


TASK 9: 
   Calculate Total Sales by Order Status from previous two orders only 

select
	orderid,
    orderdate,
    orderstatus,
    sales,
    sum(sales) over(partition by orderstatus order by orderdate rows 2 preceding) as totalsales
from orders


TASK 10: 
   Calculate cumulative Total Sales by Order Status up to the current order 

select
	orderid,
    orderdate,
    orderstatus,
    sales,
    sum(sales) over(partition by orderstatus order by orderdate rows between unbounded preceding and current row ) as totalsales
from orders


TASK 11: 
   Calculate cumulative Total Sales by Order Status from the start to the current row 
   
select 
	orderid,
    orderdate,
    orderstatus,
    sales,
    sum(sales) over(partition by orderstatus order by orderdate rows unbounded preceding) as totalsales
from orders




==============================================================================
   SQL WINDOW FUNCTIONS | RULES
===============================================================================

 RULE 1: 
   Window functions can only be used in SELECT or ORDER BY clauses 

SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus) AS Total_Sales
FROM Orders
WHERE SUM(Sales) OVER (PARTITION BY OrderStatus) > 100;  -- Invalid: window function in WHERE clause

 RULE 2: 
Window functions cannot be nested 

SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(SUM(Sales) OVER (PARTITION BY OrderStatus)) OVER (PARTITION BY OrderStatus) AS Total_Sales  -- Invalid nesting
FROM Orders;


==============================================================================

SELECT
	OrderID, 	
    OrderDate, 
    productid,
    OrderStatus, 
    Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus) as TotalSales
FROM Orders
WHERE productid IN (101,102)
	

select version()

==============================================================================

==============================================================================
   SQL WINDOW FUNCTIONS | GROUP BY
===============================================================================

 TASK 12: 
   Rank customers by their total sales 

select
	customerid,
    sum(sales),
    rank() over(order by sum(sales) desc) as totalsales
from orders
group by customerid

    
    
    