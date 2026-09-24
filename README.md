# SQL / MySQL

A collection of MySQL scripts and notes covering SQL fundamentals through advanced topics — written while building a working reference for querying, database design, and performance tuning.

## 📂 Repository Contents

| File | Topics Covered |
|------|-----------------|
| `Introduction.sql` | What SQL is, databases, DBMS concepts |
| `DDL.sql` | Data Definition Language — `CREATE`, `ALTER`, `DROP` for tables |
| `DML.sql` | Data Manipulation Language — `INSERT`, `UPDATE`, `DELETE` |
| `DQL.sql` | Data Query Language — `SELECT` and core querying |
| `Filtering_data.sql` | `WHERE`, comparison conditions, filtering rows |
| `Case_statement.sql` | `CASE WHEN` conditional logic in queries |
| `Joins.sql` | Basic joins — `INNER`, `LEFT`, `RIGHT`, `FULL` |
| `Advance_Join.sql` | Advanced join techniques and multi-table joins |
| `subqueries.sql` | Subqueries — nested and correlated queries |
| `CTE.sql` | Common Table Expressions (`WITH` clause) |
| `CTAS.sql` | `CREATE TABLE AS SELECT` |
| `sets.sql` | Set operations — `UNION`, `INTERSECT`, `EXCEPT`/`MINUS` |
| `aggregate_function.sql` | `SUM`, `COUNT`, `AVG`, `MIN`, `MAX`, `GROUP BY`/`HAVING` |
| `NumberFunction.sql` | Numeric functions (rounding, math operations) |
| `StringFunction.sql` | String functions (concatenation, substrings, formatting) |
| `Null_function.sql` | Handling `NULL` values (`COALESCE`, `IFNULL`, etc.) |
| `DateTime_Function.sql`, `DateTime_Function(1).sql`, `DateTime_Function(2).sql` | Date and time functions |
| `Date_TIme_format_cheatsheet.sql` | Quick-reference cheat sheet for date/time formatting |
| `window_function_basics.sql` | Window function fundamentals — `OVER`, `PARTITION BY`, `ORDER BY`, frames |
| `window_ranking.sql` | Ranking window functions — `RANK`, `DENSE_RANK`, `ROW_NUMBER` |
| `window_aggregation.sql` | Aggregate window functions (running totals, moving averages) |
| `window_value.sql` | Value window functions — `LAG`, `LEAD`, `FIRST_VALUE`, `LAST_VALUE` |
| `views_sql.sql` | Creating and using views |
| `temp_tables.sql` | Temporary tables |
| `stored_procedures.sql` | Writing and using stored procedures |
| `triggers.sql` | Database triggers |
| `indexes.sql` | Creating and using indexes |
| `mysql_indexes_guide.md` | In-depth guide to MySQL index types, performance behavior, and monitoring |
| `partition.sql` | Table partitioning |
| `mysql_advanced_notes.md` | Interview-style notes covering advanced MySQL concepts (window functions and more) |

## 🎯 Purpose

This repository contains core querying fundamentals to advanced topics like window functions, indexing, and performance-oriented database design, with an eye toward interview prep and real-world data engineering work.


**Requirements:** MYSQL workbench

## 📌 Notes

- The `.md` files (`mysql_advanced_notes.md`, `mysql_indexes_guide.md`) are meant as quick-reference study notes alongside the runnable `.sql` scripts.

## 📄 License

No license specified yet — feel free to reach out if you'd like to use this material.
