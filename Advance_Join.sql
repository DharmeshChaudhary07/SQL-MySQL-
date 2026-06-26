

select * 
from orders;

select * 
from customers;

insert into customers
value (7,null,null,null);



-- ============================================================================== 
-- ADVANCED JOINS


-- LEFT ANTI JOIN
-- Get all customers who haven't placed any order

select *
from customers as c
left join orders as o
on c.id = o.customer_id
where o.customer_id is null;


-- RIGHT ANTI JOIN
 -- Get all orders without matching customers 

select *
from customers as c
right join orders as o
on c.id = o.customer_id
where id is null;  #should use id here but in our table, id cannot be null


-- Alternative to RIGHT ANTI JOIN using LEFT JOIN Get all orders without matching customers 

select *
from orders as o
left join customers as c
on c.id = o.customer_id
where id is null;


-- Alternative to INNER JOIN using LEFT JOIN
--  Get all customers along with their orders, but only for customers who have placed an order 

select *
from customers as c
left join orders as o
on c.id = o.customer_id
where customer_id is not null;


-- FULL ANTI JOIN
-- Find customers without orders and orders without customers 

# full doesnt work in mysql look for alternate like union

SELECT *
FROM orders AS o
# FULL JOIN customers AS c
ON c. id = o.customer_id
WHERE c. id IS NULL OR o. customer_id IS null;


-- CROSS JOIN
-- Generate all possible combinations of customers and orders

select * 
from customers
cross join orders;

-- ============================================================================== 
--  MULTIPLE TABLE JOINS (4 Tables)


-- Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, and employee details. For each order, display:
--    - Order ID
--    - Customer's name
--    - Product name
--    - Sales amount
--    - Product price
--    - Salesperson's name */

select 
o.orderid,
o.sales,
c.firstname as customers_firstname,
c.lastname as customer_lastname,
p.product as product_name,
p.price,
e.firstname as employee_firstname,
e.lastname as employee_lastname
from orders as o
left join customers as c
on o.customerid = c.customerid
left join products as p
on o.productid = p.productid
left join employees as e
on o.salespersonid = e.employeeid

;
select *
from customers;

select *
from employees;

select *
from orders;

select *
from products;

select *
from orders_archive;


