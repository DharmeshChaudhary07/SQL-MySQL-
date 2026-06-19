/* ==============================================================================

                SQL (Structured query langauge)

# Database: A data base is an organised collection of structured data stored on disk.


# DBMS : Database management system is a software that created manages and controls access to database.

what DBMS does:
1. storage (store data on disk efficiently)
2. security (controls the access)
3. concurrency (multiple user at time)
4. Backup and recovery (save and restore data)
5. Data integrity (enforce rules)
6. Query processing (runs sql query)


# Database servers: database server is the machine/process that runs the DBMS software and listens from incoming request.

# Local vs Remote Server:
Type							Meaning								Example
Localhost 				Server runs on your own 			PCLearning/development
Remote Server		 Server runs on another machine			   Production apps
Cloud Server				Hosted online					AWS RDS, Google Cloud SQL


# SQL: Structured query language is language used to communicate with relational database through the DBMS.

# Types of SQL
DDL → Data Definition Language  (CREATE, ALTER, DROP)
DML → Data Manipulation Language (INSERT, UPDATE, DELETE)
DQL → Data Query Language        (SELECT)
DCL → Data Control Language      (GRANT, REVOKE)
TCL → Transaction Control        (COMMIT, ROLLBACK)


# Data types 
-- Text
CHAR(n)        -- fixed length
VARCHAR(n)     -- variable length

-- Numbers
INT            -- whole number
FLOAT          -- decimal
DECIMAL(8,2)   -- precise decimal

-- Date
DATE           -- 2024-01-15
DATETIME       -- 2024-01-15 10:30:00


# Keys & Constraints

PRIMARY KEY   -- uniquely identifies each row
FOREIGN KEY   -- links two tables
NOT NULL      -- cannot be empty
UNIQUE        -- no duplicates
DEFAULT       -- auto fills value
CHECK         -- validates condition

=============================================================================== */