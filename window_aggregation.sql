==============================================================================
   SQL Window Aggregate Functions
-------------------------------------------------------------------------------
   These functions allow you to perform aggregate calculations over a set 
   of rows without the need for complex subqueries. They enable you to compute 
   counts, sums, averages, minimums, and maximums while still retaining access 
   to individual row details.

   Table of Contents:
    1. COUNT
    2. SUM
    3. AVG
    4. MAX / MIN
    5. ROLLING SUM & AVERAGE Use Case
===============================================================================


============================================================
   SQL WINDOW AGGREGATION | COUNT
============================================================

TASK 1:
   Find the Total Number of Orders and the Total Number of Orders for Each Customer
   
select
	orderid,
    productid,
    customerid,
    sales,
	count(sales) over() as totalorders,
    count(sales) over(partition by customerid)
from orders



TASK 2:
   - Find the Total Number of Customers
   - Find the Total Number of Scores for Customers
   - Find the Total Number of Countries

select
-- 	   count(customerid),
--     count(score),
--     count(country),
    count(*) over() as totalcustomers,
    count(1) over() as totalcustomers,
    count(score) over() as totalnoofscore,
    count(score) over(partition by customerid) as totalnoofscore,
    count(country) over() as totalnoofcountry
from customers
    


TASK 3:
   Check whether the table 'OrdersArchive' contains any duplicate rows

select
	*
from (
	select
		orderid,
        productid,
		-- count(*) over(),
		-- count(orderid) over(),
		count(*) over(partition by orderid) as duplicaterow
	from orders_archive
)t where duplicaterow > 1

 ============================================================
   SQL WINDOW AGGREGATION | SUM
============================================================ 

TASK 4:
   - Find the Total Sales Across All Orders 
   - Find the Total Sales for Each Product

select * from orders

select
	orderid,
    productid,
    sales,
    sum(sales) over() as totalsales,
    sum(sales) over(partition by productid) as totalsalesforeachproduct
from orders



TASK 5:
   Find the Percentage Contribution of Each Products Sales to the Total Sales

select
	orderid,
    productid,
    sales,
    sum(sales) over() as totalsales,
    round((sales / sum(sales) over() * 100),2) as productsalesttotalsales
from orders


============================================================
   SQL WINDOW AGGREGATION | AVG
============================================================ 

TASK 6:
   - Find the Average Sales Across All Orders 
   - Find the Average Sales for Each Product

select
	productid,
    orderid,
    sales,
    avg(sales) over() as avgsales,
    avg(sales) over(partition by productid) as avgsaleseachproduct
from orders



TASK 7:
   Find the Average Scores of Customers

select * from customers

select
	customerid,
    firstname,
    lastname,
    score,
    avg(score) over(),
    avg(coalesce(score,0)) over()
from customers



TASK 8:
   Find all orders where Sales exceed the average Sales across all orders

select
	*
from(
	select
		orderid,
		productid,
		sales,
		avg(sales) over() as avgsale
	from orders
) t where sales > avgsale



============================================================
   SQL WINDOW AGGREGATION | MAX / MIN
============================================================ 

TASK 9:
   Find the Highest and Lowest Sales across all orders

select
	orderid,
    productid,
    sales,
    min(sales) over() as lowestsale,
    max(sales) over() as highestsale
from orders



TASK 10:
   Find the Lowest Sales across all orders and by Product

select
	orderid,
    productid,
    sales,
    min(sales) over(partition by productid) as lowestsale,
    max(sales) over(partition by productid) as highestsale
from orders



TASK 11:
   Show the employees who have the highest salaries

select * from employees

select 
	*
from (
	select 
		employeeid,
		firstname,
		department,
		salary,
		max(salary) over() as highestsalary
	from employees
)t where highestsalary = salary



TASK 12:
   Find the deviation of each Sale from the minimum and maximum Sales

select
	orderid,
    productid,
    sales,
    max(sales) over() as maxsales,
    min(sales) over() as minsales,
    max(sales) over() - sales as maxtosalesdeviation,
    sales - min(sales) over() as salestomindeviation
from orders



============================================================
   Use Case | ROLLING SUM & AVERAGE
============================================================ 


TASK 13:
   Calculate the moving average of Sales for each Product over time

select
	orderid,
    productid,
    orderdate,
    sales,
    avg(sales) over(partition by productid) as avgsales,
    avg(sales) over(partition by productid order by orderdate) as movingavg
from orders



TASK 14:
   Calculate the moving average of Sales for each Product over time,
   including only the next order
   
select
	orderid,
    productid,
    orderdate,
    sales,
	avg(sales) over(partition by productid order by orderdate rows between current row and 1 following)  
from orders









