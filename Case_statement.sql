==============================================================================
   SQL CASE Statement
-------------------------------------------------------------------------------

   Various use cases of the SQL CASE statement, including data categorization, mapping, quick form syntax, handling nulls, and conditional aggregation.
   
   Table of Contents:
     1. Categorize Data
     2. Mapping
     3. Quick Form of Case Statement
     4. Handling Nulls
     5. Conditional Aggregation
     
=================================================================================


==============================================================================
   USE CASE: CATEGORIZE DATA
===============================================================================*/

/* TASK 1: 
   Create a report showing total sales for each category:
	   - High: Sales over 50
	   - Medium: Sales between 20 and 50
	   - Low: Sales 20 or less
   The results are sorted from highest to lowest total sales.
*/

select
	case 
		when sales > 50 then 'high' 
		when sales > 20 then 'medium' 
		else 'low' 
    end as category, 
    sum(sales) as sales
from orders
group by category
order by sales desc


==============================================================================
   USE CASE: MAPPING
===============================================================================*/

/* TASK 2: 
   Retrieve customer details with abbreviated country codes 
*/

select * from customers

select 
	firstname,
    lastname,
    case 
		when country = 'germany' then 'DE'
        when country = 'USA' then 'US'
        else 'no abbe'
        end as ABBE
	from customers
		

==============================================================================
   QUICK FORM SYNTAX
===============================================================================*/

/* TASK 3: 
   Retrieve customer details with abbreviated country codes using quick form 
*/

select 
	firstname,
    lastname,
    case country
		when 'germany' then 'DE'
        when 'USA' then 'US'
        else 'no abbe'
        end as ABBE
	from customers

==============================================================================
   HANDLING NULLS
===============================================================================*/

/* TASK 4: 
   Calculate the average score of customers, treating NULL as 0,
   and provide CustomerID and LastName details.
*/

select
	customerid,
    lastname,
    score,
    case when score is null then 0 else score end as correctedscore,
    avg(
		case 
			when score is null then 0
            else score
		end) over() as avgscore,
	coalesce(score, 0) as usingcoalecse,
    avg(coalesce(score, 0)) over() as usingcoalecse
from customers;


select
	customerid,
    lastname,
    score,
	avg(
		case 
			when score is null then 0
            else score
		end) as avgscore
from customers
group by customerid

==============================================================================
   CONDITIONAL AGGREGATION
===============================================================================

/* TASK 5: 
   Count how many orders each customer made with sales greater than 30 
*/

select * from orders

select 
	customerid,
    sum(s
		case 
			when sales > 30 then 1
			else 0 
		end) as count,
	count(*) as totalcount 
from orders
group by customerid





