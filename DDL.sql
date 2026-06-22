/* ==============================================================================
   SQL Data Definition Language (DDL)

   The essential DDL commands used for defining and managing
   database structures, including creating, modifying, and deleting tables.

   Table of Contents:
     1. CREATE - Creating Tables
     2. ALTER - Modifying Table Structure
     3. DROP - Removing Tables
=================================================================================
*/

-- ============================================================================== 
--    CREATE


/* Create a new table called persons 
   with columns: id, person_name, birth_date, and phone */
   

CREATE TABLE person (
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_person PRIMARY KEY (id)
)
select *
from person;



-- ============================================================================== 
--    ALTER


-- Add a new column called email to the persons table

ALTER TABLE person
ADD email VARCHAR(20) NOT NULL;

SELECT *
FROM person;

ALTER TABLE person
ADD SEX VARCHAR(1) ;

-- TO ADD THE COLUMN IN THE MIDDLE IS NOT POSSIBLE, you will have to delete columns and fit it. (not recommended)


-- ============================================================================== 
--    DROP

-- PRIMARY
-- Delete the table persons from the database

ALTER TABLE person
DROP COLUMN phone;


select *
from person;

ALTER TABLE person
DROP COLUMN SEX;

DROP TABLE person