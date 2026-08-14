
==============================================================================
==============================================================================
		Two types of table 
            
		1. Permanent table -> create/insert table 
						   -> CTAS
		2. Temporary table 
        

Create/insert table -> based on two steps 
1. Create | Define the strucutre of table.
2. Insert | Insert Data into the table.

CTAS -> based on one single step, creates table directly from query using the existing table.
Create a new table based on the result of an SQL query.

==============================================================================
			Differnce between views and ctas 

-- CREATE VIEW view_monthly_summary AS
-- SELECT DATE_FORMAT(orderdate, '%Y-%m-01') AS ordermonth, SUM(sales) AS totalsales
-- FROM orders
-- GROUP BY ordermonth;

view
1. The moment you run this CREATE VIEW statement, MySQL does not touch the orders table or compute any sums. It just saves the query text 
under the name view_monthly_summary. The actual execution only happens later, every single time someone does:

2. slower than ctas
-- CREATE TABLE orderstest AS
-- SELECT * FROM temporders;

CTAs
1. The moment this finishes running, the data is already computed and sitting in orderstest as real rows on disk. When you later do 
SELECT * FROM orderstest, MySQL isn't re-running anything against temporders — it's just reading the stored rows, like any normal table.
2. faster than view

==============================================================================
			CTAS (Create table as select)
==============================================================================

It is a powerful SQL command that allows you to create a brand new table and immediately populate it with data retrieved from an existing 
table using a SELECT query.

If you add, change, or delete rows in the main table later, the table created via CTAS will never update automatically. 

==============================================================================

	Task 1 create a ctas for total number of order for each month 
    
create table ctas_totalorders  as	   
SELECT
date_format(orderdate, '%M') as ordermonth, 
count(OrderID) TotalOrders
FROM orders
GROUP BY date_format(orderdate, '%M')

select * from ctas_totalorders

==============================================================================
	Drop table 
==============================================================================

drop table if exists ctas_totalorders


