
--   SQL String Functions

--    SQL string functions, which allow 
--    manipulation, transformation, and extraction of text data efficiently.

--    Table of Contents:
--      1. Manipulations
--         - CONCAT
--         - LOWER
--         - UPPER
-- 	       - TRIM    
-- 	       - REPLACE
--      2. Calculation
--         - LEN
--      3. Substring Extraction
--         - LEFT
--         - RIGHT
--         - SUBSTRING


-- =================================================================================

 --   CONCAT() - String Concatenation

-- Concatenate first name and country into one column

select 
concat(first_name, country) as name_country
from customers;

-- ============================================================================== 

  --   LOWER() & UPPER() - Case Transformation

-- Convert the first name to lowercase

select 
lower(first_name) as lower
from customers;

-- Convert the first name to uppercase

select 
upper(first_name) as lower
from customers;

-- ============================================================================== 

  -- TRIM() - Remove White Spaces

-- Find customers whose first name contains leading or trailing spaces

select 
length(first_name),
trim(first_name) as trim_name,
length(trim(first_name))
from customers;
# used length just to verify if trim works,


-- ============================================================================== 

  -- REPLACE() - Replace or Remove old value with new one

-- Remove dashes (-) from a phone number

select 
1234-566-789 as phone, #just substracts if '' not used 
replace('1234-566-789', '-', '/') as replace_phone;

SELECT
'1234-566-789' AS phone,
replace('123-456-7890', '-', '/') as replace_phone;

-- Replace File Extence from txt to csv

select
'document.txt' as txt_type,
replace('document.txt', '.txt', '.csv') as csv_type;


-- ============================================================================== 

--    LEN() - String Length & Trimming

-- Calculate the length of each customer's first name

select 
first_name,
length(first_name),
length(trim(first_name)),
length(first_name) - length(trim(first_name)) as flag
from customers;

# or #

select 
first_name,
length(first_name)
from customers
where length(first_name) != length(trim(first_name));

--  ============================================================================== 

--    LEFT() & RIGHT() - Substring Extraction

-- Retrieve the first two characters of each first name

select
first_name,
left(first_name, 2),
trim(first_name),
left(trim(first_name), 2)
from customers;

-- Retrieve the last two characters of each first name

select 
first_name,
right(first_name, 3)
from customers;

	
--  ============================================================================== 

--    SUBSTRING() - Extracting Substrings

-- Retrieve a list of customers' first names after removing the first character


select
substring(first_name, 2, 4),
substring(first_name, 2, 5)
from customers;
# in above case we dont know the actual length of character.

# we need to get all the character after removing first character instead use length of first_name.

select
first_name,
substring(trim(first_name), 2, length(first_name))
from customers;


--  ==============================================================================

--    NESTING FUNCTIONS

-- Nesting

# example of nesting function 
select
first_name,
substring(trim(first_name), 2, length(first_name))
from customers;


select
first_name,
country,
concat(left(trim(first_name), 3), ' ' ,left(country, 5)) as combined
from customers
