# Comprehensive Guide to MySQL Indexes: Types and Monitoring

This guide provides an in-depth, technical overview of MySQL index structures, performance behaviors, and monitoring strategies.

---

## 1. Index Types

### 1.1 Clustered and Non-Clustered Indexes
In MySQL's InnoDB storage engine, indexes are structured as B+ Trees:
*   **Clustered Index:** Stores the actual table rows in the leaf nodes of the B+ Tree. Every InnoDB table automatically has exactly one clustered index based on the Primary Key. If no Primary Key exists, MySQL uses the first `UNIQUE` index with non-nullable columns, or a hidden 6-byte row ID.
*   **Non-Clustered (Secondary) Index:** Stores index column values along with a reference pointer back to the row's clustered index key. Leaf nodes do not contain raw table data, requiring a secondary lookup (bookmark lookup) if the query selects columns missing from the index.

### 1.2 Leftmost Prefix Rule Explanation
Composite indexes (indexes covering multiple columns like `KEY(col1, col2, col3)`) strictly follow the Leftmost Prefix Rule.
*   The query optimizer can utilize a composite index only if the columns in the `WHERE` clause match the index structure from left to right without gaps.
*   **Valid Usage:** A query filtering by `col1` or `col1 AND col2` uses the index.
*   **Invalid Usage:** A query filtering by `col2` or `col2 AND col3` bypasses the index entirely and triggers a full table scan.

### 1.3 Columnstore Indexes
*   **Native MySQL:** Standard MySQL (Community/Enterprise) does not feature native Columnstore indexes. It relies on row-oriented B+ Trees.
*   **HeatWave & Cloud Variants:** Columnar processing is natively supported in MySQL HeatWave (OCI) and distributed analytical extensions like MariaDB ColumnStore. These engines store data column-by-column rather than row-by-row, optimizing massive aggregation queries and OLAP analytical workloads.

### 1.4 Unique Indexes
A `UNIQUE` index ensures that no two rows within a table share identical values across the indexed columns. Null values are an exception: in MySQL, a `UNIQUE` index permits multiple `NULL` entries unless the column is explicitly defined as `NOT NULL`.

### 1.5 Filtered Indexes (Partial Indexes)
*   **Native MySQL:** MySQL does not support functional Filtered Indexes (e.g., `CREATE INDEX idx ON tbl(col) WHERE status = 'active'`).
*   **Workarounds:** You can simulate partial/filtered indexing using **Generated Columns**. You define a deterministic virtual or stored column based on a conditional expression, then create a standard index on that generated column.

---

## 2. Index Monitoring

### 2.1 Monitor Index Usage
You can evaluate how effectively indexes are leveraged by querying the Performance Schema or inspecting query plans:
```sql
-- View index usage statistics via Performance Schema
SELECT OBJECT_SCHEMA, OBJECT_NAME, INDEX_NAME, COUNT_FETCH, COUNT_INSERT, COUNT_UPDATE, COUNT_DELETE
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA NOT IN ('mysql', 'performance_schema', 'sys', 'information_schema');
```
*   **EXPLAIN Plan:** Prepend `EXPLAIN` or `EXPLAIN ANALYZE` to your query to check the `key` column and determine which index was selected by the optimizer.

### 2.2 Monitor Missing Indexes
MySQL does not possess a single "missing index" DMV. Instead, identify missing indexes by tracking queries that execute full table scans:
```sql
-- Identify tables experiencing frequent full table scans
SELECT OBJECT_SCHEMA, OBJECT_NAME, COUNT_READ, COUNT_FETCH
FROM performance_schema.table_io_waits_summary_by_table
WHERE INDEX_NAME IS NULL 
  AND OBJECT_SCHEMA NOT IN ('mysql', 'performance_schema', 'sys', 'information_schema')
ORDER BY COUNT_READ DESC;
```

### 2.3 Monitor Duplicate Indexes
Duplicate indexes waste storage I/O and slow down `INSERT`/`UPDATE` operations. The MySQL `sys` schema provides a view to catch redundant indexes immediately:
```sql
-- Query the sys schema for redundant or duplicate indexes
SELECT table_schema, table_name, redundant_index_name, redundant_index_columns, dominant_index_name
FROM sys.schema_redundant_indexes;
```

### 2.4 Update Statistics
The optimizer requires accurate index cardinality data to build efficient execution plans. InnoDB automatically updates statistics under configured thresholds, but you can trigger manual refreshes:
```sql
-- Force recalculation of index cardinality statistics
ANALYZE TABLE your_database_name.your_table_name;
```

### 2.5 Fragmentations
Frequent row modifications, page splits, and deletions cause layout gaps within InnoDB tablespaces.
*   **Detection:** Check fragmentation by querying `INFORMATION_SCHEMA.TABLES`. High fragmentation is marked by an elevated `DATA_FREE` value relative to `DATA_LENGTH`.
```sql
-- Check table fragmentation sizes
SELECT TABLE_SCHEMA, TABLE_NAME, DATA_LENGTH, INDEX_LENGTH, DATA_FREE,
       (DATA_FREE / (DATA_LENGTH + INDEX_LENGTH)) * 100 AS fragmentation_percentage
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA NOT IN ('mysql', 'performance_schema', 'sys', 'information_schema')
ORDER BY DATA_FREE DESC;
```
*   **Resolution:** Reclaim space and defragment indexes by rebuilding the table structure:
```sql
ALTER TABLE your_table_name ENGINE=InnoDB;
-- OR
OPTIMIZE TABLE your_table_name;
```
