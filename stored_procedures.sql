 ==============================================================================
   SQL Stored Procedures
-------------------------------------------------------------------------------
   This script shows how to work with stored procedures in SQL Server,
   starting from basic implementations and advancing to more sophisticated
   techniques.

   Table of Contents:
     1. Basics (Creation and Execution)
     2. Parameters
     3. Multiple Queries
     4. Variables
     5. Control Flow with IF/ELSE
     6. Error Handling with TRY/CATCH
=================================================================================


 ==============================================================================
   Basic Stored Procedure
============================================================================== 

 TASK 1 For USA customers find the total number of customers and average score.

-- Define the Stored Procedure

DELIMITER $$ 

create procedure uscustomerssummary ()
begin 
	select 
		count(*) as totalcustomer,
		avg(score) as avgscore
	from customers
	where country = 'USA';
end$$
                
DELIMITER ;	

-- Execute Stored Procedure
call uscustomerssummary();

 ==============================================================================
   Parameters in Stored Procedure
============================================================================== 

DROP PROCEDURE IF EXISTS GetCustomerSummary;

DELIMITER $$

CREATE PROCEDURE GetCustomerSummary(IN p_country VARCHAR(50))
BEGIN
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Customers
    WHERE Country = p_country;
END$$

DELIMITER ;


-- Execute Stored Procedure
CALL GetCustomerSummary('Germany');
CALL GetCustomerSummary('USA');
CALL GetCustomerSummary(NULL);   -- uses default 'USA'

 ==============================================================================
   Multiple Queries in Stored Procedure
============================================================================== 

DROP PROCEDURE IF EXISTS GetCustomerSummary;

DELIMITER $$

CREATE PROCEDURE GetCustomerSummary(IN p_country VARCHAR(50))
BEGIN
    IF p_country IS NULL THEN
        SET p_country = 'USA';
    END IF;

    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Customers
    WHERE Country = p_country;

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Orders AS o
    JOIN Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = p_country;
END$$

DELIMITER ;

-- Execute Stored Procedure
CALL GetCustomerSummary('Germany');
CALL GetCustomerSummary('USA');
CALL GetCustomerSummary(NULL);   -- behaves like EXEC GetCustomerSummary; (defaults to 'USA')

 ==============================================================================
   Variables in Stored Procedure
============================================================================== 

DROP PROCEDURE IF EXISTS GetCustomerSummary;

DELIMITER $$

CREATE PROCEDURE GetCustomerSummary(IN p_country VARCHAR(50))
BEGIN
    -- Declare Variables
    DECLARE v_TotalCustomers INT;
    DECLARE v_AvgScore FLOAT;

    IF p_country IS NULL THEN
        SET p_country = 'USA';
    END IF;

    -- Query 1: Find the Total Nr. of Customers and the Average Score
    SELECT
        COUNT(*),
        AVG(Score)
    INTO v_TotalCustomers, v_AvgScore
    FROM Customers
    WHERE Country = p_country;

    SELECT CONCAT('Total Customers from ', p_country, ': ', CAST(v_TotalCustomers AS CHAR)) AS Message1;
    SELECT CONCAT('Average Score from ', p_country, ': ', CAST(v_AvgScore AS CHAR)) AS Message2;

    -- Query 2: Find the Total Nr. of Orders and Total Sales
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Orders AS o
    JOIN Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = p_country;
END$$

DELIMITER ;

-- Execute Stored Procedure

CALL GetCustomerSummary('Germany');
CALL GetCustomerSummary('USA');
CALL GetCustomerSummary(NULL);  


 ==============================================================================
   Control Flow IFELSE in Stored Procedure
============================================================================== 


	-- Declare Variables
   

	 --------------------------------------------------------------------------
	   Prepare & Cleanup Data
	-------------------------------------------------------------------------- 



	 --------------------------------------------------------------------------
	   Generating Reports
	-------------------------------------------------------------------------- 


-- Execute Stored Procedure

 ==============================================================================
   Error Handling TRY CATCH in Stored Procedure
============================================================================== 


    
    

		--------------------------------------------------------------------------
           Prepare & Cleanup Data
        -------------------------------------------------------------------------- 



		--------------------------------------------------------------------------
           Generating Reports
        -------------------------------------------------------------------------- 



		--------------------------------------------------------------------------
           Error Handling
        -------------------------------------------------------------------------- 
