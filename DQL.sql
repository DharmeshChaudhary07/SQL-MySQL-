/* ==============================================================================

# # DQL(Data query language)

# # SQL SELECT Query

# # SELECT query techniques used for retrieving, filtering, sorting, and aggregating data efficiently.

   Table of Contents:
     1. SELECT ALL COLUMNS
     2. SELECT SPECIFIC COLUMNS
     3. WHERE CLAUSE
     4. ORDER BY
     5. GROUP BY
     6. HAVING
     7. DISTINCT
     8. TOP
     9. Combining Queries
	 10.Additional SQL Features
================================================================================= */

--  WRITE SQL IN THIS ORDER


-- What do I want? → SELECT

-- From where? → FROM

-- Which rows? → WHERE


-- Combine rows into buckets? → GROUP BY

-- Filter those buckets? → HAVING

-- In what order? →ORDER BY

-- How many rows max? → LIMIT

-- =================================================================================

-- SELECT ALL COLUMNS
   

# # Retrieve All Customer Data

SELECT *
FROM customers;


# # Retrieve All Order Data

SELECT *
FROM orders;

-- =================================================================================

-- SELECT FEW COLUMNS


# # Retrieve each customer's name, country, and score.

SELECT 
	firstname,
	country,
	score
FROM customers;


-- ==============================================================================

-- WHERE


# # Retrieve customers with a score not equal to 0

SELECT *
FROM customers
where score != 0;


# # Retrieve customers from Germany

SELECT *
FROM customers
WHERE country = 'germany';


# # Retrieve the name and country of customers from Germany

SELECT 
	firstname,
	country
FROM customers
WHERE country = 'germany';


-- ==============================================================================

-- ORDER BY


# # Retrieve all customers and sort the results by the highest score first.

SELECT *
FROM customers
ORDER BY SCORE DESC;


# # Retrieve all customers and sort the results by the lowest score first.

SELECT *
FROM customers
ORDER BY SCORE ASC;


# # Retrieve all customers and sort the results by the country.

SELECT *
FROM customers
ORDER BY country ASC;


# # Retrieve all customers and sort the results by the country and then by the highest score. 

SELECT *
FROM customers
ORDER BY country ASC, score DESC;

# # Retrieve the name, country, and score of customers whose score is not equal to 0 and sort the results by the highest score first. 

SELECT 
	firstname,
	country,
	score
FROM customers
where score != 0
ORDER BY score DESC;


-- ==============================================================================

-- GROUP BY


# # Find the total score for each country

SELECT 
	country,
	SUM(score)	
FROM customers
GROUP BY country;


/* This will not work because 'first_name' is neither part of the GROUP BY nor wrapped in an aggregate function. 
SQL doesn't know how to handle this column. */

SELECT 
    country,
    first_name,
    SUM(score) AS total_score
FROM customers
GROUP BY country;



# # Find the total score and total number of customers for each country

SELECT 
	country,
	SUM(score),	
    COUNT(customerid)
FROM customers
GROUP BY country;


-- ==============================================================================

-- HAVING 
-- Group by and having work together.


# # Find the average score for each country and return only those countries with an average score greater than 430 */

SELECT
	country,
	AVG(score)
FROM customers
GROUP BY country
HAVING AVG(score) > 430;

# # Find the average score for each country considering only customers with a score not equal to 0 
# # and return only those countries with an average score greater than 430 */

SELECT
	country,
	AVG(score)
FROM customers
where score != 0
GROUP BY country
HAVING AVG(score) > 430;


-- ==============================================================================

-- DISTINCT


# # Return Unique list of all countries

SELECT DISTINCT country
FROM customers;


-- ==============================================================================
--   TOP
# # doesnot work in MYSQl workbench instead use limit 


# # Retrieve only 3 Customers

SELECT *
FROM customers
lIMIT 3;


# # Retrieve the Top 3 Customers with the Highest Scores

SELECT *
FROM customers
ORDER BY score DESC
lIMIT 3;

# # Retrieve the Lowest 2 Customers based on the score

SELECT *
FROM customers
ORDER BY score ASC
lIMIT 2;

# # Get the Two Most Recent Orders

SELECT *
FROM orders
ORDER BY orderdate DESC
lIMIT 2;

-- ==============================================================================
-- combining query


/* Calculate the average score for each country 
   considering only customers with a score not equal to 0
   and return only those countries with an average score greater than 430
   and sort the results by the highest average score first. */

SELECT 
	country,
    AVG(score)
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430
ORDER BY AVG(score) DESC


/* ============================================================================== 
Additional SQL Features
=============================================================================== */

-- Execute multiple queries at once
-- SELECT * FROM customers;
-- SELECT * FROM orders;

/* Selecting Static Data */
-- Select a static or constant value without accessing any table
-- SELECT 123 AS static_number;

-- SELECT 'Hello' AS static_string;

-- Assign a constant value to a column in a query
-- SELECT
--     id,
--     first_name,
--     'New Customer' AS customer_type
-- FROM customers;