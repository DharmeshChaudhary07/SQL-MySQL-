-- ==============================================================================
--    SQL Date & Time Functions

--    This script demonstrates various date and time functions in SQL.
--    It covers functions such as GETDATE, DATETRUNC, DATENAME, DATEPART,
--    YEAR, MONTH, DAY, EOMONTH, FORMAT, CONVERT, CAST, DATEADD, DATEDIFF,
--    and ISDATE.
--    
--    Table of Contents:
--      1. GETDATE | Date Values
--      2. Date Part Extractions (DATETRUNC, DATENAME, DATEPART, YEAR, MONTH, DAY)
--      3. DATETRUNC
--      4. EOMONTH
--      5. Date Parts
--      6. FORMAT
--      7. CONVERT
--      8. CAST
--      9. DATEADD / DATEDIFF
--     10. ISDATE


--  ==============================================================================
--    GETDATE() | DATE VALUES

-- getdate() doenot work in mysql instead use now()


-- TASK 1:
--    Display OrderID, CreationTime, a hard-coded date, and the current system date.

SELECT
    OrderID,
    CreationTime,
    '2025-08-20' AS HardCoded,
    now() as today # GETDATE() AS Today
FROM Orders;

-- ==============================================================================
--    DATE PART EXTRACTIONS
--    (DATETRUNC, DATENAME, DATEPART, YEAR, MONTH, DAY)


--  TASK 2:

 -- Extract various parts of CreationTime using DATETRUNC, DATENAME, DATEPART, YEAR, MONTH, and DAY. 
 
select * 
from orders;

select 
	creationtime,
	Day(creationtime),
	month(creationtime),
	year(creationtime)
from orders;

# datepart doesnot work in mysql instead use just by name 

select 
	creationtime,
	Day(creationtime),
	month(creationtime),
	year(creationtime),
	hour(creationtime),
	minute(creationtime),
	second(creationtime),
	quarter(creationtime),
	week(creationtime)
from orders;


# datename doesnot work in mqsql instead just use by monthname(), dayname(),
# only datatype -> string will work: only dayname and monthname().

select 
	creationtime,
	day(creationtime),
	dayname(creationtime),
	monthname(creationtime),
	year(creationtime),
	hour(creationtime),
	minute(creationtime),
	second(creationtime),
	quarter(creationtime),
	week(creationtime)
from orders;

# datetrunc doesnt work in mysql atlernate 'date_format'
-- DATE_FORMAT() does double duty for both jobs, because MySQL doesn't have a real truncation function.(truncate and format)

/* '%M'   →  full month name      → January
'%m'   →  month number (2-digit) → 01
'%b'   →  abbreviated month    → Jan
'%c'   →  month number (no leading zero) → 1

'%Y'   →  4-digit year         → 2025
'%y'   →  2-digit year         → 25

'%d'   →  day (2-digit)        → 01
'%e'   →  day (no leading zero)→ 1

'%W'   →  full weekday name    → Wednesday
'%a'   →  abbreviated weekday  → Wed

'%H'   →  hour, 24h            → 12
'%h'   →  hour, 12h            → 12
'%i'   →  minute               → 34
'%s'   →  second                → 56
'%p'   →  pm					→ PM/AM
*/

select
creationtime,
	date_format(creationtime, '%Y') as year,
	date_format(creationtime, '%y') as year2digit,
	date_format(creationtime, '%m') as month,
    date_format(creationtime, '%Y-01-01') as truncateyear,
    date_format(creationtime, '%Y-%m-01') as truncatemonth,
    date_format(creationtime, '%Y-%m-%d %H:00:00') as truncatehours,
    date_format(creationtime, '%Y-%m-%d %H:%i:00') as truncateminute
from orders;

# EOMONTH() doesnot work instead use last_day()

-- TASK 3:
--    Display OrderID, CreationTime, and the end-of-month date for CreationTime.

SELECT
    OrderID,
    CreationTime,
    last_day(CreationTime) AS EndOfMonth
FROM Orders;


####################### work in my microsoft server only #######################
SELECT
    OrderID,
    CreationTime,
    -- DATETRUNC Examples
    DATETRUNC(year, CreationTime) AS Year_dt,
    DATETRUNC(day, CreationTime) AS Day_dt,
    DATETRUNC(minute, CreationTime) AS Minute_dt,
    -- DATENAME Examples
    DATENAME(month, CreationTime) AS Month_dn,
    DATENAME(weekday, CreationTime) AS Weekday_dn,
    DATENAME(day, CreationTime) AS Day_dn,
    DATENAME(year, CreationTime) AS Year_dn,
    -- DATEPART Examples
    DATEPART(year, CreationTime) AS Year_dp,
    DATEPART(month, CreationTime) AS Month_dp,
    DATEPART(day, CreationTime) AS Day_dp,
    DATEPART(hour, CreationTime) AS Hour_dp,
    DATEPART(quarter, CreationTime) AS Quarter_dp,
    DATEPART(week, CreationTime) AS Week_dp,
    YEAR(CreationTime) AS Year,
    MONTH(CreationTime) AS Month,
    DAY(CreationTime) AS Day
FROM salesdb.Orders;
 ################################################################################
 
 ############################## for postgre ######################################
 SELECT
    OrderID,
    CreationTime,
    -- DATE_TRUNC examples
    DATE_TRUNC('year', CreationTime)   AS Year_dt,
    DATE_TRUNC('day', CreationTime)    AS Day_dt,
    DATE_TRUNC('minute', CreationTime) AS Minute_dt,
    -- "name" equivalents using TO_CHAR
    TO_CHAR(CreationTime, 'Month')     AS Month_dn,
    TO_CHAR(CreationTime, 'Day')       AS Weekday_dn,
    TO_CHAR(CreationTime, 'DD')        AS Day_dn,
    TO_CHAR(CreationTime, 'YYYY')      AS Year_dn,
    -- EXTRACT examples (replaces DATEPART)
    EXTRACT(YEAR FROM CreationTime)    AS Year_dp,
    EXTRACT(MONTH FROM CreationTime)   AS Month_dp,
    EXTRACT(DAY FROM CreationTime)     AS Day_dp,
    EXTRACT(HOUR FROM CreationTime)    AS Hour_dp,
    EXTRACT(QUARTER FROM CreationTime) AS Quarter_dp,
    EXTRACT(WEEK FROM CreationTime)    AS Week_dp,
    EXTRACT(YEAR FROM CreationTime)    AS Year,
    EXTRACT(MONTH FROM CreationTime)   AS Month,
    EXTRACT(DAY FROM CreationTime)     AS Day
FROM salesdb.Orders;

 ################################################################################

--  TASK 4:
--    Aggregate orders by year using DATE_FORMAT on CreationTime.

select
	date_format(creationtime, '%Y') as year,
    count(creationtime) as ordercount
from orders
group by date_format(creationtime, '%Y');
     

--  ==============================================================================
--   DATE PARTS | USE CASES


-- TASK 5:
--    How many orders were placed each year?

SELECT 
    YEAR(OrderDate) AS OrderYear, 
    COUNT(creationtime) AS TotalOrders
FROM Orders
GROUP BY YEAR(OrderDate);



-- TASK 6:
--    How many orders were placed each month?

SELECT 
    MONTH(OrderDate) AS OrderMonth, 
    COUNT(creationtime) AS TotalOrders
FROM Orders
GROUP BY MONTH(OrderDate);


-- TASK 7:
--    How many orders were placed each month (using friendly month names)?

SELECT 
    monthname(OrderDate) AS OrderMonth, 
    COUNT(creationtime) AS TotalOrders
FROM Orders
GROUP BY monthname(OrderDate);


-- TASK 8:
--    Show all orders that were placed during the month of February.

SELECT
    *
FROM Orders
WHERE MONTH(OrderDate) = 2;

-- COUNT(*)
-- Counts every row in the group, no matter what — even if every column in that row is NULL.
-- COUNT(creationtime)   # count(column_name)
-- Counts only rows where that specific column is NOT NULL. Any row where the column is NULL gets skipped.
