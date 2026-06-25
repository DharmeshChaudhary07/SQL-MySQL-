-- ==============================================================================
--    SQL Joins 

--   This document provides an overview of SQL joins, which allow combining data from multiple tables to retrieve meaningful insights.

--    Table of Contents:
--      1. Basic Joins
--         - INNER JOIN
--         - LEFT JOIN
--         - RIGHT JOIN
--         - FULL JOIN
--      2. Advanced Joins
--         - LEFT ANTI JOIN
--         - RIGHT ANTI JOIN
--         - ALTERNATIVE INNER JOIN
--         - FULL ANTI JOIN
--         - CROSS JOIN
--      3. Multiple Table Joins (4 Tables)


-- ============================================================================== 
--    BASIC JOINS 


-- No Join
-- Retrieve all data from customers and orders as separate results 

SELECT * FROM customers;
SELECT * FROM orders;

-- INNER JOIN
-- Get all customers along with their orders, but only for customers who have placed an order 

select 
	id,
    first_name,
    order_id,
    customer_id
from customers
inner join orders
on id = customer_id;



-- LEFT JOIN
-- Get all customers along with their orders, including those without orders

select 
	id,
    first_name,
    order_id,
    customer_id
from customers
left join orders
on id = customer_id;

-- RIGHT JOIN
-- Get all customers along with their orders, including orders without matching customers

select 
	id,
    first_name,
    order_id,
    customer_id
from customers
right join orders
on id = customer_id;


-- Alternative to RIGHT JOIN using LEFT JOIN
-- Get all customers along with their orders, including orders without matching customers 

select 
	id,
    first_name,
    order_id,
    customer_id
from orders
left join customers
on id = customer_id;



-- FULL JOIN
-- Get all customers and all orders, even if there’s no match 

select 
	id,
    first_name,
    order_id,
    customer_id
from customers
full join orders
on id = customer_id;

######

# In MySQL, writing the keyword FULL JOIN or FULL OUTER JOIN actually defaults to an INNER JOIN syntax equivalent 
# because MySQL does not natively support FULL OUTER JOIN.
# If your query successfully runs but acts like an INNER JOIN, MySQL is interpreting your standalone JOIN or FULL JOIN keyword directly as a standard, 
# inner-matching JOIN. Additionally, if you simulated a full join using other methods, a poorly placed WHERE clause might be filtering out the null row.

######

-- alternate 
-- use union to stimulate full join

select 
	id,
    first_name,
    order_id,
    customer_id
from customers
left join orders
on id = customer_id

union

select 
	id,
    first_name,
    order_id,
    customer_id
from customers
right join orders
on id = customer_id;