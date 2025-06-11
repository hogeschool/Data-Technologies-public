# Indexing – Speeding Up Data Retrieval

## Introduction to Indexes
Imagine a very large book — perhaps 2,000 pages long — with information scattered throughout. If you want to find all mentions of a certain topic, flipping through every page would take forever. That’s why books have an index at the back: a list of important terms with corresponding page numbers. Instead of reading everything, you can jump directly to what you're looking for.

In a database, the same principle applies. A table is like that big book — it contains a lot of rows (records), and searching without guidance can be slow. An index helps the database locate specific rows much faster, without scanning the entire table.

## What is a Index
An index is a data structure that improves the speed of data retrieval on a table. It provides a mapping from a column’s value to the physical location of rows, similar to how a book’s index maps words to pages.

Without an index, PostgreSQL must perform a sequential scan — checking every row — which is slow for large tables. With an index, PostgreSQL can use a more efficient access path.

### Common Index Types in PostgreSQL

| Index Type | Description                                                                     | Use Cases                                                            |
| ---------- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **B-tree** | The default index type; organizes values in a balanced tree structure.          | Fast for exact matches and range queries (`=`, `<`, `>`, `BETWEEN`)  |
| **BRIN**   | Block Range Index; stores min/max metadata per block instead of row-level data. | Best for very large, **naturally ordered** tables (e.g., timestamps) |
| **Hash**   | Uses a hash table for equality comparisons.                                     | Rarely used; mostly replaced by B-tree                               |
| **GIN**    | Generalized Inverted Index; used for indexing composite or array values.        | Full-text search, JSONB, arrays                                      |
| **GiST**   | Generalized Search Tree; supports complex data types like geometry.             | Spatial data, ranges, custom indexing                                |

```mermaid
flowchart TD
    A[1000&vert;2000&vert;3000] --> B(500&vert;750)
    A --> C(1200&vert;1800)    
    A --> E(2100&vert;2500)        
    A --> G(3100&vert;3800)
    C --> H(1100&vert;1150)    
    C --> I(1250&vert;1400)
    C --> J(1850&vert;1940)
    I --> K(1220 => TID&lpar;5,20&rpar;)
    I --> L(1350 => TID&lpar;3,99&rpar;)
    I --> M(1420 => TID&lpar;8,22&rpar;)                
    
    subgraph leafnodes
    K
    L
    M
    end
```
A illustration of a B-Tree   

### Benefits of Using Indexes
- Faster queries: Especially for SELECTs with filters or joins.
- Enables efficient sorting and searching.
- Supports constraints: e.g., enforcing uniqueness.

### Drawbacks of Indexes
- Insert/Update overhead: Indexes must be updated when the table changes, which adds write cost.
- More storage usage: Indexes take up disk space.
- Too many indexes hurt performance: Each additional index slows down inserts, updates, and deletes.

### Design Tip
Indexing is a powerful optimization tool, but not every column should be indexed.
Before creating an index, ask yourself:

- Will this column be frequently searched or filtered?
- Will the index reduce the need to scan large portions of the table?
- Is the table large enough that indexing brings real value?

Indexing should be based on actual data access patterns. Good index design comes from understanding how your application queries the data.

## Creating a BRIN Index

````sql
CREATE INDEX idx_employee_salary ON employees USING BRIN (salary);
`````

Creates a Block Range Index (BRIN) on the salary column of the employees table, which is efficient for large datasets.

### Full Example for Context and Testing

1. Create the employees table
````sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name TEXT,
    salary NUMERIC
);
````
2. Insert simulated data (100,000 rows)
````sql
INSERT INTO employees (name, salary)
SELECT
    'Employee ' || generate_series(1, 100000),
    generate_series(30000, 130000, 1);  -- salaries from 30k to 130k
````
This creates salaries that are physically ordered, which is ideal for BRIN indexing.

3. Run a query before or after indexing
````sql
EXPLAIN ANALYZE
SELECT * FROM employees WHERE salary BETWEEN 75000 AND 75500;
````

Before indexing, this will likely trigger a Seq Scan.
After indexing, you should see a Bitmap Index Scan or BRIN Index Scan.
