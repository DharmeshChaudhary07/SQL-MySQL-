

--    FORMAT()

-- FORMAT() in MySQL is only for numbers. It has nothing to do with dates at all,

-- TASK 9:
--    Format CreationTime into various string representations.

SELECT
    OrderID,
    CreationTime,
    DATE_FORMAT(CreationTime, '%m-%d-%Y') AS USA_Format,
    DATE_FORMAT(CreationTime, '%d-%m-%Y') AS EURO_Format,
    DATE_FORMAT(CreationTime, '%d')       AS dd,
    DATE_FORMAT(CreationTime, '%a')       AS ddd,
    DATE_FORMAT(CreationTime, '%W')       AS dddd,
    DATE_FORMAT(CreationTime, '%m')       AS MM,
    DATE_FORMAT(CreationTime, '%b')       AS MMM,
    DATE_FORMAT(CreationTime, '%M')       AS MMMM
FROM Orders;


-- TASK 10:
--    Display CreationTime using a custom format:
--    Example: Day Wed Jan Q1 2025 12:34:56 PM

select
concat(Date_format(creationtime, '%d %a %b ') , quarter(creationtime) , Date_format(creationtime, ' %Y %h:%i:%s %p')) as task
from orders;



-- TASK 11:
--    How many orders were placed each year, formatted by month and year (e.g., "Jan 25")?

select
count(*),
date_format(orderdate, '%b %y')
from orders
group by date_format(orderdate, '%b %y')



-- ==============================================================================
--    CONVERT()


-- TASK 12:
--    Demonstrate conversion using CONVERT.



-- ==============================================================================
--    CAST()


-- TASK 13:
--    Convert data types using CAST.



-- ==============================================================================
--    DATEADD() / DATEDIFF()


-- TASK 14:
--    Perform date arithmetic on OrderDate.



-- TASK 15:
--    Calculate the age of employees.


-- TASK 16:
--    Find the average shipping duration in days for each month.



-- TASK 17:
--    Time Gap Analysis: Find the number of days between each order and the previous order.



-- ==============================================================================
--    ISDATE()


-- TASK 18:
--    Validate OrderDate using ISDATE and convert valid dates.


