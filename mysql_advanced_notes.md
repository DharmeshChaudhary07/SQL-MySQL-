# MySQL Advanced — Interview Notes

---

## 1. WINDOW FUNCTIONS
**What:** Perform calculation across a set of rows (a "window") related to current row, WITHOUT collapsing rows (unlike GROUP BY).
**Why:** Need row-level detail + aggregate/rank context together.
**When:** Running totals, rankings, comparisons to prev/next row, top-N per group.

```
Syntax:
<func>() OVER (
    [PARTITION BY col]
    [ORDER BY col]
    [ROWS/RANGE BETWEEN ... AND ...]
)
```

Flow:
```
Table rows -> PARTITION BY (split into groups)
           -> ORDER BY (sort within group)
           -> apply function per row -> return same row count
```

### a) Aggregate Window Functions
SUM, AVG, COUNT, MIN, MAX used as window fn (no row collapse).
```sql
SELECT emp_id, dept, salary,
       SUM(salary) OVER (PARTITION BY dept) AS dept_total,
       AVG(salary) OVER (PARTITION BY dept ORDER BY salary
                          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM employees;
```
Use: running totals, dept-wise totals alongside detail rows.

### b) Rank Window Functions
| Function | Behavior |
|---|---|
| ROW_NUMBER() | unique sequential number, no ties |
| RANK() | ties get same rank, gap after tie |
| DENSE_RANK() | ties get same rank, no gap |
| NTILE(n) | splits rows into n buckets |

```sql
SELECT emp_id, dept, salary,
       ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) AS rn,
       RANK()       OVER (PARTITION BY dept ORDER BY salary DESC) AS rnk,
       DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary DESC) AS drnk
FROM employees;
```
Use: Top-N per group (e.g., top 3 earners per department), dedup.

### c) Value Window Functions
LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()
```sql
SELECT emp_id, salary,
       LAG(salary, 1)  OVER (ORDER BY emp_id) AS prev_salary,
       LEAD(salary, 1) OVER (ORDER BY emp_id) AS next_salary,
       FIRST_VALUE(salary) OVER (PARTITION BY dept ORDER BY salary DESC) AS top_sal
FROM employees;
```
Use: month-over-month comparison, churn detection, trend analysis.

---

## 2. CTE (Common Table Expression)
**What:** Named temporary result set, exists only for the query duration.
**Why:** Readability, breaks complex query into steps, allows recursion.
**When:** Multi-step logic, recursive hierarchy (org chart, category tree).

```sql
-- Simple CTE
WITH dept_avg AS (
    SELECT dept, AVG(salary) AS avg_sal
    FROM employees GROUP BY dept
)
SELECT e.emp_id, e.dept, e.salary, d.avg_sal
FROM employees e
JOIN dept_avg d ON e.dept = d.dept;

-- Recursive CTE
WITH RECURSIVE org_chart AS (
    SELECT emp_id, manager_id, 1 AS lvl FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.manager_id, o.lvl + 1
    FROM employees e JOIN org_chart o ON e.manager_id = o.emp_id
)
SELECT * FROM org_chart;
```

---

## 3. SUBQUERY
**What:** Query nested inside another query (SELECT/WHERE/FROM).
**Why:** Filter/compute using result of another query.
**When:** Single value comparison, EXISTS check, correlated row-by-row logic.

```sql
-- Scalar subquery
SELECT emp_id, salary FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Correlated subquery
SELECT e.emp_id FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees e2 WHERE e2.dept = e.dept);

-- EXISTS
SELECT * FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept = d.dept_id);
```
Note: CTE > subquery for readability; subquery can be slower (correlated = row-by-row).

---

## 4. CTAS (Create Table As Select)
**What:** Create a new physical table from query result.
**Why:** Materialize result permanently, snapshot data.
**When:** ETL staging, backup, denormalized reporting table.

```sql
CREATE TABLE high_earners AS
SELECT emp_id, name, salary FROM employees WHERE salary > 100000;
```
Note: Doesn't copy indexes/constraints automatically in MySQL.

---

## 5. VIEWS
**What:** Virtual table = saved SELECT query, no data stored.
**Why:** Reusability, security (restrict columns), abstraction.
**When:** Repeated complex query, expose limited data to users/roles.

```sql
CREATE VIEW active_employees AS
SELECT emp_id, name, dept FROM employees WHERE status = 'active';

SELECT * FROM active_employees;
```
Note: Runs underlying query every time (no storage) → not faster, just convenient.

---

## 6. TEMP TABLES
**What:** Physical table, session-scoped, auto-dropped on session end.
**Why:** Store intermediate results for multi-step processing, real table (can index).
**When:** Complex multi-query pipelines, stored procedures needing scratch space.

```sql
CREATE TEMPORARY TABLE temp_sales (
    id INT, amount DECIMAL(10,2)
);
INSERT INTO temp_sales SELECT id, amount FROM sales WHERE year = 2025;
SELECT * FROM temp_sales;
-- auto dropped when connection closes
```
CTE vs Temp Table: CTE = query-scope, no storage; Temp table = session-scope, actual disk/memory table, can be indexed.

---

## 7. TRIGGERS
**What:** Auto-executed block of SQL on INSERT/UPDATE/DELETE event.
**Why:** Enforce business rules, auditing, auto-updates, without app code.
**When:** Logging changes, cascading updates, validation before write.

```sql
CREATE TRIGGER before_salary_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SET NEW.salary = OLD.salary; -- prevent salary cut
    END IF;
END;
```
Types: BEFORE/AFTER x INSERT/UPDATE/DELETE. Use NEW.col / OLD.col.

---

## 8. INDEXES
**What:** Data structure (B-Tree default) that speeds up row lookup.
**Why:** Avoid full table scan → faster SELECT/JOIN/WHERE.
**When:** Frequently filtered/joined/sorted columns; NOT on low-cardinality or write-heavy small tables.

```sql
CREATE INDEX idx_dept ON employees(dept);
CREATE UNIQUE INDEX idx_email ON employees(email);
CREATE INDEX idx_dept_sal ON employees(dept, salary);  -- composite

EXPLAIN SELECT * FROM employees WHERE dept = 'IT';  -- check index usage
```
Trade-off: faster reads, slower writes (INSERT/UPDATE/DELETE must update index too).

---

## 9. PARTITIONING
**What:** Split one large table into smaller physical chunks internally (table still queried as one).
**Why:** Improve performance on huge tables, easier maintenance (drop old partition fast).
**When:** Very large tables (millions+ rows), time-series data, archiving.

```sql
CREATE TABLE sales (
    id INT, sale_date DATE, amount DECIMAL(10,2)
)
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026)
);
```
Types: RANGE, LIST, HASH, KEY.
Note: Partitioning ≠ Indexing. Partition = physical data split; Index = lookup structure.

---

## 10. STORED PROCEDURE
**What:** Precompiled, reusable block of SQL logic stored in DB, callable by name.
**Why:** Reduce app↔DB round trips, reuse logic, encapsulate business rules.
**When:** Repeated multi-step operations, batch jobs, complex transactions.

```sql
DELIMITER //
CREATE PROCEDURE GetHighEarners(IN min_sal DECIMAL(10,2))
BEGIN
    SELECT emp_id, name, salary
    FROM employees
    WHERE salary > min_sal;
END //
DELIMITER ;

CALL GetHighEarners(100000);
```
Function vs Procedure: Function returns single value, usable in SELECT; Procedure can return multiple result sets/no return, called via CALL.

---

## Quick Comparison Cheat Table

| Concept | Storage | Scope | Speed benefit |
|---|---|---|---|
| CTE | None (virtual) | Single query | Readability only |
| Subquery | None | Single query | Depends, can be slow |
| View | None (query saved) | Persistent (logical) | No |
| CTAS | Physical table | Persistent | Yes (materialized) |
| Temp Table | Physical (session) | Session | Yes |
| Index | Physical (B-Tree) | Persistent | Yes (reads) |
| Partition | Physical (split) | Persistent | Yes (huge tables) |
