select * from customers;


SELECT 
    score,
    AVG(score) OVER() AS avg,
    avg(coalesce(score,0)) over() as avgnull
FROM customers;

   
==============================================================================
   SQL NULL Functions
-------------------------------------------------------------------------------
   This script highlights essential SQL functions for managing NULL values. It demonstrates how to handle NULLs in data aggregation, mathematical 
   operations, sorting, and comparisons. These techniques help maintain data integrity and ensure accurate query results.

   Table of Contents:
     1. Handle NULL - Data Aggregation
     2. Handle NULL - Mathematical Operators
     3. Handle NULL - Sorting Data
     4. NULLIF - Division by Zero
     5. IS NULL - IS NOT NULL
     6. LEFT ANTI JOIN
     7. NULLs vs Empty String vs Blank Spaces


==============================================================================
   HANDLE NULL - DATA AGGREGATION
==============================================================================

-- TASK 1: 
--    Find the average scores of the customers.
--    Uses COALESCE to replace NULL Score with 0.

SELECT
    CustomerID,
    Score,
    COALESCE(Score, 0) AS Score2,
    AVG(Score) OVER () AS AvgScores,
    AVG(COALESCE(Score, 0)) OVER () AS AvgScores2
FROM Customers;
 

=============================================================================
   HANDLE NULL - MATHEMATICAL OPERATORS
===============================================================================

-- TASK 2: 
--    Display the full name of customers in a single field by merging their
--    first and last names, and add 10 bonus points to each customer's score.

select * from customers;

select 
	firstname,
    lastname,
    concat(firstname, ' ', lastname) as fullname, #for mary, null -> null , for that we can use concat_ws()
    concat(firstname, ' ' , coalesce(lastname, ' ')) as fullname1,
    concat_ws(' ', firstname, lastname) as fullname2,
    score,
    score + 10 as score,
    coalesce(score, 0) + 10 as score2
from customers  ;


==============================================================================
   HANDLE NULL - SORTING DATA
===============================================================================

-- TASK 3: 
--    Sort the customers from lowest to highest scores,
--    with NULL values appearing last.

select * from customers

select *
from customers
order by case when score is null then 1 else 0 end, score

==============================================================================
   NULLIF - DIVISION BY ZERO
===============================================================================

select *
from orders

-- TASK 4: 
--    Find the sales price for each order by dividing sales by quantity.
--    Uses NULLIF to avoid division by zero.

select		 		
	orderid,
    productid,
    sales,
    quantity,
    sales / quantity
from orders
	 
==============================================================================
   IS NULL - IS NOT NULL
===============================================================================

-- TASK 5: 
--    Identify the customers who have no scores 

select * 
from customers

select *
from customers
where score is null

-- TASK 6: 
--    Identify the customers who have scores 

select *
from customers
where score is not null


==============================================================================
   LEFT ANTI JOIN
===============================================================================

-- TASK 7: 
--    List all details for customers who have not placed any orders 

select *
from customers;

select *
from orders;

select *
from customers as c
left join orders as o 
on c.customerid = o.customerid
where o.customerid is null

==============================================================================
   NULLs vs EMPTY STRING vs BLANK SPACES
==============================================================================

-- TASK 8: 
--    Demonstrate differences between NULL, empty strings, and blank spaces 

-WITH Orders AS (
SELECT 1 Id, 'A' Category 
UNION
SELECT 2, NULL 
UNION 
SELECT 3,
UNION
SELECT 4,
SELECT
DATALENGTH (Category) Categorylen
FROM orders
