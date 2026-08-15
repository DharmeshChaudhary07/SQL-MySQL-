==============================================================================
   SQL Triggers
-------------------------------------------------------------------------------
   This script demonstrates the creation of a logging table, a trigger, and
   an insert operation into the Sales.Employees table that fires the trigger.
   The trigger logs details of newly added employees into the Sales.EmployeeLogs table.
=================================================================================


-- Step 1: Create Log Table


CREATE TABLE EmployeeLog (
    LogID      INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate    DATE
);

-- Step 2: Create Trigger on Employees Table


DROP TRIGGER IF EXISTS trg_AfterInsertEmployee;

DELIMITER $$

CREATE TRIGGER trg_AfterInsertEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLogs (EmployeeID, LogMessage, LogDate)
    VALUES (
        NEW.EmployeeID,
        CONCAT('New Employee Added = ', CAST(NEW.EmployeeID AS CHAR)),
        NOW()
    );
END$$

DELIMITER ;



-- Step 3: Insert New Data Into Employees

INSERT INTO Employees
VALUES (6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);

-- Check the Logs
