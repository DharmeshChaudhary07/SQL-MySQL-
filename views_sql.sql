 ==============================================================================
   SQL Views
-------------------------------------------------------------------------------
   This script demonstrates various view use cases in SQL Server.
   It includes examples for creating, dropping, and modifying views, hiding
   query complexity, and implementing data security by controlling data access.

   Table of Contents:
     1. Create, Drop, Modify View
     2. USE CASE - HIDE COMPLEXITY
     3. USE CASE - DATA SECURITY
===============================================================================


 ==============================================================================
   CREATE, DROP, MODIFY VIEW
===============================================================================

 TASK:
   Create a view that summarizes monthly sales by aggregating:
     - OrderMonth (truncated to month)
     - TotalSales, TotalOrders, and TotalQuantities.


-- Create View

CREATE VIEW view_monthly_summary AS
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m-01') AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders,
    SUM(Quantity) AS TotalQuantities
FROM Orders
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m-01')


-- Query the View

select * from view_monthly_summary


-- Drop View if it exists

drop view view_monthly_summary


-- Re-create the view with modified logic

create or replace view view_monthly_summary as
select
	date_format(orderdate, '%Y-%m-01') as ordermonth,
    sum(sales) as totalsales,
    count(orderid) as totalorders
from orders
group by date_format(orderdate, '%Y-%m-01')

select * from view_monthly_summary

 ==============================================================================
   VIEW USE CASE | HIDE COMPLEXITY
===============================================================================

 TASK:
   Create a view that combines details from Orders, Products, Customers, and Employees.
   This view abstracts the complexity of multiple table joins.

create or replace view overall_summary as
select
	o.orderid,
    o.orderdate,
    concat(coalesce(c.firstname,'') , ' ' , coalesce(c.lastname, '')) as name,
    c.country,
    p.product,
    p.category,
    concat(coalesce(e.firstname, ''), ' ' , coalesce(e.lastname, '')) as empname,
    o.sales,
    o.quantity
from orders as o 
left join customers as c
on o.customerid = c.customerid
left join products as p
on o.productid = p.productid
left join employees as e
on o.salespersonid = e.employeeid

select * from overall_summary
 ==============================================================================
   VIEW USE CASE | DATA SECURITY
===============================================================================

 TASK:
   Create a view for the EU Sales Team that combines details from all tables,
   but excludes data related to the USA.

create or replace view overall_summary as
select
	o.orderid,
    o.orderdate,
    concat(coalesce(c.firstname,'') , ' ' , coalesce(c.lastname, '')) as name,
    c.country,
    p.product,
    p.category,
    concat(coalesce(e.firstname, ''), ' ' , coalesce(e.lastname, '')) as empname,
    o.sales,
    o.quantity
from orders as o 
left join customers as c
on o.customerid = c.customerid
left join products as p
on o.productid = p.productid
left join employees as e
on o.salespersonid = e.employeeid
where c.country != 'USA'

select * from overall_summary
