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
| **GIN**    | Generalized Inverted Index; used for indexing composite or array values.        | Full-text search, JSONB, arrays                                      |
| **GiST**   | Generalized Search Tree; supports complex data types like geometry.             | Spatial data, ranges, custom indexing                                |

### Index Variants in PostgreSQL

Besides the core index types, PostgreSQL also supports variants that extend their functionality.  
These are usually based on **B-tree indexes**, but add special behavior.

| Variant              | Description                                                                 | Use Cases                                                            |
| -------------------- | --------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **Partial Index**    | Index only a subset of rows, defined by a `WHERE` condition.                | When queries frequently filter on a specific condition (e.g., active users). |
| **Covering Index**   | A normal index with extra non-key columns included via `INCLUDE`.           | When you want *index-only scans* (queries can be satisfied entirely from the index). |


*Benefits of Using Indexes*
- Faster queries: Especially for SELECTs with filters or joins.
- Enables efficient sorting and searching.
- Supports constraints: e.g., enforcing uniqueness.

*Drawbacks of Indexes*
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

## Creating a Balanced Tree Index (B-Tree)
In the figure below, you see a visual representation of a B-tree index. The blue rectangles represent the nodes of the tree, with the ones at the bottom (inside the yellow box) called leaf nodes.
The leaf nodes contain the actual mapping between indexed values and row pointers, known in PostgreSQL as Tuple Identifiers (`TIDs`). Each `TID` points to the physical location of a row in the table, using a `(page, offset)` format. A page is the smallest storage unit in PostgreSQL, fixed at 8KB.
In a B-tree, a node with N keys always has N+1 child nodes, which ensures that the search space is correctly partitioned.


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

When you create a standard index in PostgreSQL without specifying the index type, PostgreSQL uses a balanced B-Tree by default.

```sql
CREATE INDEX idx_last_name ON customers (last_name);
```
This statement creates an index on the `last_name` column of the `customers` table.
Since no `USING` clause is specified, PostgreSQL uses its default index type: *a B-Tree*.

You don’t need to explicitly write `USING BTREE` unless you want to make it explicit:

```sql
-- Equivalent but more explicit:
CREATE INDEX idx_last_name ON customers USING BTREE (last_name);
```

## Creating a Block Range Index (BRIN)

A BRIN index (Block Range Index) is a compact and efficient index type in PostgreSQL, designed for very large tables where values are physically ordered on disk — such as timestamped logs or sequential IDs.

Unlike B-tree indexes, a BRIN does not store pointers to individual rows. Instead, it stores a summary — typically the minimum and maximum values — for each block of rows (e.g., every 128 pages. A page is the smallest storage unit in PostgreSQL, fixed at 8KB).

The following SQL creates a Block Range Index (BRIN) on the salary column of the employees table.

````sql
CREATE INDEX idx_employee_salary ON employees USING BRIN (salary);
`````


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

### When BRIN works well
BRIN indexes are highly efficient when:
- The data is naturally ordered (e.g., ascending salary or created_at values)
- Each block covers a tight range of values
- You frequently query ranges (e.g., "find all salaries between 70,000 and 75,000")

In this case, PostgreSQL can use the BRIN index to skip entire blocks that are clearly outside the filter range.

### When BRIN becomes ineffective
If the table’s data is not physically clustered (e.g., values are inserted randomly), the value ranges per block become too broad. The BRIN index can no longer help PostgreSQL eliminate irrelevant blocks efficiently — and the query may revert to a full table scan.

### Reorder data physically in the table
If your data is no longer physically ordered, you should consider reordering it to restore index efficiency. The `CLUSTER` command will rearrange the rows in the table based on the order defined by an index. However, `CLUSTER` requires a index that points to every row and defines a strict order - such as a B-Tree index. A BRIN index does not meet this requirement, as it only stores range summaries. In our example of the `employees` table, we can follow these steps:

1. Create a temporay B-Tree index

````sql
CREATE INDEX idx_temp_salary ON employees (salary);
````
2. Reorder the table based upon the indexed column.
````sql
CLUSTER employees USING idx_temp_salary;
````
This rewrites the table on disk, physically ordering the rows by salary. This improves the effectiveness of the existing BRIN index.

3. Drop the temporary B-Tree index
````sql
DROP INDEX idx_temp_salary;
````   

## Creating a Generalized Inverted Index (GIN)

When working with semi-structured data in PostgreSQL, the JSONB data type is commonly used. To improve query performance on JSONB columns — especially for containment checks — a GIN index is highly effective. A GIN index on a JSONB column allows PostgreSQL to index individual keys and values within each JSON object.

This enables fast lookup for containment queries using operators like `@>` — for example:
````sql
SELECT * FROM employees WHERE info @> '{"department": "Engineering"}';
````
Without the index, PostgreSQL would scan every row. With the GIN index, it directly finds relevant rows using internal term-to-row mappings.

In the context of GIN indexes, inversion refers to the idea that the index maps from internal elements (like JSON keys or array items) to the rows that contain them — rather than mapping from a full column value to a row, as B-tree indexes do.

So instead of:
> value → list of rows (B-Tree)

You get:
> element within value → list of rows (GIN)

This "inversion" refers to the focus shifting from entire values to the internal terms or components that make up those values.

### Full Example for Context and Testing

1. Create a table with a JSONB column

````sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    info JSONB
);
````

2. Insert some sample data

````sql
INSERT INTO employees (info) VALUES
  ('{"name": "Alice", "department": "HR", "active": true}'),
  ('{"name": "Bob", "department": "Engineering", "active": true}'),
  ('{"name": "Carol", "department": "Finance", "active": false}');
````
Each row stores a structured JSONB object with different key–value pairs.

3. Create a GIN index on the info column

````sql
CREATE INDEX idx_info_gin ON employees USING GIN (info);
````
This index uses PostgreSQL’s default `jsonb_opsz` operator class, which supports indexing of keys and values in the JSONB structure.

4. Run a query using the `@>` containment operator

````sql
SELECT * FROM employees
WHERE info @> '{"department": "Engineering"}';
````
This query retrieves all rows where the info JSON object contains the key "department" with the value "Engineering".
Thanks to the GIN index, PostgreSQL can quickly locate the matching rows without scanning all rows or parsing every JSONB object.

## Creating a Generalized Search Tree Index (GiST)

TBD

### Full Example for Context and Testing
PostgreSQL supports a special `daterange` data type, which can represent a continuous span of dates (e.g., a vacation, booking, or subscription period).

1. Create table with date ranges

 ````sql
   CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    guest_name TEXT,
    stay_period DATERANGE
);
````
2. Insert some sample data

````sql
INSERT INTO reservations (guest_name, stay_period) VALUES
('Alice',  '[2025-06-10, 2025-06-15)'),
('Bob',    '[2025-06-20, 2025-06-25)'),
('Charlie','[2025-06-15, 2025-06-22)');
````
The range `[2025-06-10, 2025-06-15)` includes the 10th up to but not including the 15th.

3. Create a GiST index to optimize overlap queries

````sql
CREATE INDEX idx_reservations_period ON reservations
USING GiST (stay_period);
````

4. Run a query to find any existing reservations that overlap with a new booking request

````sql
SELECT guest_name
FROM reservations
WHERE stay_period && '[2025-06-14, 2025-06-17)';
````
The && operator means: "overlaps with"

## Partial Indexes

A partial index is an index built only on a subset of rows in a table, defined by a WHERE condition. This can reduce index size and improve performance if queries only need to access a filtered portion of the data.

Example:
Suppose we have a users table, but we only need fast access to active users.

Table creation:
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT true,
    last_login TIMESTAMP
);
```

Partial index creation:
```sql
CREATE INDEX idx_active_users
ON users (last_login)
WHERE active = true;
```
This index only includes rows where active = true.
Queries that filter on this condition can use the smaller, more efficient index.

```sql
SELECT id, last_login
FROM users
WHERE active = true
ORDER BY last_login DESC;
```

## Covering Indexes

A covering index stores extra non-key columns inside the index.
This allows the database to answer queries directly from the index, without looking up the original table (a so-called index-only scan).

Example:
Suppose we often query orders by customer_id, but also need the amount column.

Table creation:
```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);
```

Covering index creation:
```sql
CREATE INDEX idx_orders_customer
ON orders (customer_id)
INCLUDE (amount);
```
The index is ordered by customer_id.
It also stores amount, but not as a key — just as extra data.
This means the query can be satisfied using only the index:

```sql
SELECT customer_id, amount
FROM orders
WHERE customer_id = 123;
```


