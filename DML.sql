
CREATE TABLE person (
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_person PRIMARY KEY (id)
);
select *
from person;

-- =================================================================================
-- =================================================================================

--    Data Manipulation Language (DML)
--    
--    DML commands used for inserting, updating, and deleting data in database tables.

--    Table of Contents:
--      1. INSERT - Adding Data to Tables
--      2. UPDATE - Modifying Existing Data
--      3. DELETE - Removing Data from Tables
     
-- =================================================================================

--    INSERT

-- #1 Method: Manual INSERT using VALUES */
-- Insert new records into the customers table



-- correct column order if defining column in insert into (col1, col2, col3)


SELECT * FROM customers;

-- Insert a new record with full column values


INSERT INTO person (id, person_name, birth_date, phone)
VALUE(1, 'Raj', NULL , '876543');


-- Insert a new record without specifying column names (not recommended)

INSERT INTO person 
VALUE(4, 'sasy', NULL , '8765623'),
     (3, 'Jam', NULL , '87435423');
    
-- Insert a record with only id and first_name (other columns will be NULL or default values)

INSERT INTO person (id, person_name, phone)
VALUE(5, 'neha', '113454354');

INSERT INTO person 
VALUE(6, 'sasu', '2012-03-14', '8735623');


-- #2 Method: INSERT DATA USING SELECT - Moving Data From One Table to Another 

-- Copy data from the 'customers' table into 'persons'

INSERT INTO person (id, person_name, birth_date, phone)
SELECT 
id,
first_name,
NULL,
'UNKNOWN'
FROM customers;


-- ============================================================================== 
   -- UPDATE

INSERT INTO customers 
VALUE(6, 'SAM', 'AUS', NULL);

-- Change the score of customer with ID 6 to 0

UPDATE customers
SET score = 0
WHERE id = 6;


-- Change the score of customer with ID 4 to 0 and update the country to 'POR'

UPDATE customers
SET score = 0,
	country = 'POR'
WHERE id = 4;


-- Update all customers with a NULL score by setting their score to 0

UPDATE customers
SET score = NULL
WHERE score = 0;



-- Verify the update

SELECT *
FROM customers;



-- ============================================================================== 
--    DELETE




-- Delete all customers with an ID greater than 5

DELETE FROM person
WHERE id > 5;

SELECT *
FROM person;


-- Delete all data from the persons table

DELETE FROM person;



-- Faster method to delete all rows, especially useful for large tables

-- TRUNCATE

-- Clears the whole table at once without checking or logging.
-- is much faster than using delete 

TRUNCATE TABLE person;