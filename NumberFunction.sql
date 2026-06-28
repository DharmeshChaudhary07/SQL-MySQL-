-- ============================================================================== 
--    SQL Number Functions Guide


--    Table of Contents:
--      1. Rounding Functions
--         - ROUND
--      2. Absolute Value Function
--         - ABS

-- ============================================================================== 
--    ROUND() - Rounding Numbers


-- rounding a number to different decimal places

SELECT 
    3.516 AS original_number,
    ROUND(3.516, 2) AS round_2,
    ROUND(3.516, 1) AS round_1,
    ROUND(3.516, 0) AS round_0;

-- ============================================================================== 
--    ABS() - Absolute Value

-- absolute value function

SELECT 
    -10 AS original_number,
    ABS(-10) AS absolute_value_negative,
    ABS(10) AS absolute_value_positive