 ==============================================================================
   SQL Subquery Functions
-------------------------------------------------------------------------------
   This script demonstrates various subquery techniques in SQL.
   It covers result types, subqueries in the FROM clause, in SELECT, in JOIN clauses,
   with comparison operators, IN, ANY, correlated subqueries, and EXISTS.
   
   Table of Contents:
     1. SUBQUERY - RESULT TYPES
     2. SUBQUERY - FROM CLAUSE
     3. SUBQUERY - SELECT
     4. SUBQUERY - JOIN CLAUSE
     5. SUBQUERY - COMPARISON OPERATORS 
     6. SUBQUERY - IN OPERATOR
     7. SUBQUERY - ANY OPERATOR
     8. SUBQUERY - CORRELATED 
     9. SUBQUERY - EXISTS OPERATOR
===============================================================================


 ==============================================================================
   SUBQUERY | RESULT TYPES
===============================================================================

 Scalar Query 

select 
	avg(sales)
from orders



 Row Query 
 
select
	customerid
from orders


 Table Query 

select
	customerid,
    productid
from orders

 ==============================================================================
   SUBQUERY | FROM CLAUSE
===============================================================================

 TASK 1:
   Find the products that have a price higher than the average price of all products.

select
 *
from(
	select 
		productid,
		product,
        price,
		avg(price) over() as avgprice
	from products
)t 
where price > avgprice



 TASK 2:
   Rank Customers based on their total amount of sales.

select 
	*,
	rank() over(order by totalsales desc) as cusrank
from(
	select
		customerid,
		sum(sales) as totalsales
	from orders
	group by customerid
)t



 ==============================================================================
   SUBQUERY | SELECT
===============================================================================

 TASK 3:
   Show the product IDs, product names, prices, and the total number of orders.

select
	productid,
    product,
    price,
    (select count(*) from orders) as totalorders
from products



 ==============================================================================
   SUBQUERY | JOIN CLAUSE
===============================================================================

 TASK 4:
   Show customer details along with their total sales.

select c.*,
	t.totalsales
from customers as c
left join ( 
	select
		customerid,
		sum(sales) as totalsales
	from orders
	group by customerid
)t
on c.customerid = t.customerid



 TASK 5:
   Show all customer details and the total orders of each customer.

select
	c.*,
    t.totalorders as totalorder
from customers as c
left join( 
	select
		customerid,
		count(*) as totalorders
	from orders
	group by customerid
)t
on c.customerid = t.customerid


 ==============================================================================
   SUBQUERY | COMPARISON OPERATORS
===============================================================================

 TASK 6:
   Find the products that have a price higher than the average price of all products.

select
	*,
    (select avg(price) from products) as avgprice
from products
where price > (select avg(price) from products)



 ==============================================================================
   SUBQUERY | IN OPERATOR
===============================================================================

 TASK 7:
   Show the details of orders made by customers in Germany.

select
	*
from orders
where customerid in (select customerid from customers where country = 'germany')



 TASK 8:
   Show the details of orders made by customers not in Germany.

select
	*
from orders
where customerid not in (select customerid from customers where country = "germany")

 ==============================================================================
   SUBQUERY | ANY OPERATOR
===============================================================================

 TASK 9:
   Find female employees whose salaries are greater than the salaries of any male employees.


select 
	*
from employees 
where gender = 'F' and salary > any(select salary from employees where gender = 'M')



 ==============================================================================
   CORRELATED SUBQUERY
===============================================================================

 TASK 10:
   Show all customer details and the total orders for each customer using a correlated subquery.

select 
	*,
    (select
		count(*) as totalcount
    from orders as o
    where o.customerid = c.customerid) as t
from customers as c


 ==============================================================================
   SUBQUERY | EXISTS OPERATOR
===============================================================================

 TASK 11:
   Show the details of orders made by customers in Germany.

select
	*
from orders as o
where exists(
	select *
	from customers as c
	where country = 'germany' and c.customerid = o.customerid);

 TASK 12:
   Show the details of orders made by customers not in Germany.

select
	*
from orders as o
where not exists(
	select *
	from customers as c
	where country = 'germany' and c.customerid = o.customerid)
