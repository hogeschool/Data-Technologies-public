# Physical Design – Creating Tables in SQL

When working with PostgreSQL, physical database design plays a critical role in ensuring optimal performance, efficient storage, and scalability. It involves structuring data storage, indexing, partitioning, and tuning configurations to match workload requirements.

## Data Types

Data types define how values are stored and manipulated in a database. Selecting the right data type enhances efficiency, minimizes storage requirements, and improves query performance. PostgreSQL offers a variety of data types catering to different use cases.

Name | Aliases | Description
:----|:--------|:-----------
boolean | **`bool`** | logical Boolean (true/false)
character [ (n) ] | **`char`** [ (n) ] | fixed-length character string
character varying [ (n) ] | **`varchar`** [ (n) ] | variable-length character string
**`date`** |   | calendar date (year, month, day)
integer | **`int`**, int4 | signed four-byte integer
**`json`** |   | textual JSON data
**`jsonb`** |   | binary JSON data, decomposed
numeric [ (p, s) ] | **`decimal`** [ (p, s) ] | exact numeric of selectable precision
**`real`** | float4 | single precision floating-point number (4 bytes)
**`text`** |   | variable-length character string
**`time`** [ (p) ] [ without time zone ] |   | time of day (no time zone)
**`timestamp`** [ (p) ] [ without time zone ] |   | date and time (no time zone)

*There are more datatypes in PostgreSQL, we are only showing the most common ones for our workshops.*

> [!NOTE]
> Data types might have different names in different database engines. And even if the name is the same, the size and other details may be different! **Always check the documentation!**

&nbsp;

## Creating tables using SQL syntax

Tables are the foundation of any relational database. They consist of rows and columns, where columns represent attributes, and rows contain individual records. Properly structuring tables ensures data consistency and ease of retrieval.

```sql
CREATE TABLE table_name (
    column1 datatype [constraint],
    column2 datatype [constraint],
    column3 datatype [constraint],
    ...
);
```

The `CREATE TABLE` statement defines a new table in a database, specifying its columns and constraints. Here’s the general syntax:

&nbsp;

If we want to have an `employess` table that has 5 fields: `id`, `name`, `age`, `email` and `hire_date` but also includes constraints to maintain data integrity, we can use the following example:

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INTEGER CHECK (age > 18),
    email VARCHAR(255) UNIQUE,
    hire_date DATE DEFAULT CURRENT_DATE
);
```

### Key Features

- `id` is an **auto-incrementing primary key**
- `name` must **always have a value**
- `age` includes a **validation check**
- `email` must be **unique**
- `hire_date` is set to **default to the current date**

This structure ensures that data integrity is maintained from the moment data is inserted.

&nbsp;

## Constraints & Data integrity

Constraints prevent invalid data from being inserted into a database, ensuring consistency and reliability. They operate at the **column level** or **table level**, restricting values based on predefined conditions.

### Primary Key Constraint (`PRIMARY KEY`)

Guarantees uniqueness and prevents null values.

```sql
ALTER TABLE employees ADD PRIMARY KEY (id);
```

&nbsp;

### Foreign Key Constraint (`FOREIGN KEY`)

Maintains relationships between tables.

```sql
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

ALTER TABLE employees ADD COLUMN dept_id INTEGER REFERENCES departments(dept_id);
```

&nbsp;

### Unique Constraint (`UNIQUE`)

Ensures column values remain distinct.

```sql
ALTER TABLE employees ADD CONSTRAINT unique_email UNIQUE (email);
```

&nbsp;

### Not Null Constraint (`NOT NULL`)

Prevents missing values in essential columns.

```sql
ALTER TABLE employees ALTER COLUMN name SET NOT NULL;
```

&nbsp;

### Check Constraint (`CHECK`)

Imposes validation rules on data entry.

```sql
ALTER TABLE employees ADD CONSTRAINT check_age CHECK (age > 18);
```

&nbsp;

### Default Constraint (`DEFAULT`)

Assigns a preset value when no input is provided.

```sql
ALTER TABLE employees ALTER COLUMN hire_date SET DEFAULT CURRENT_DATE;
```

&nbsp;

### Cascade Constraints (`CASCADE`)

In relational databases, maintaining data integrity across multiple tables is crucial. PostgreSQL provides `CASCADE` constraints to automatically propagate changes when a referenced record is updated or deleted. This ensures that dependent data remains consistent without requiring manual intervention.

`CASCADE` constraints are primarily used in **foreign key relationships**, allowing child records to be modified or removed when their parent record changes. This feature is particularly useful in scenarios where data dependencies exist, such as customer orders, employee records, or hierarchical structures.

&nbsp;

#### `ON DELETE CASCADE`

This constraint ensures that when a parent record is deleted, all associated child records are also removed. It prevents orphaned records and maintains referential integrity.

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date DATE DEFAULT CURRENT_DATE
);
```

If a customer is deleted, all their orders are automatically removed.
Useful for scenarios where dependent data should not exist without its parent.

&nbsp;

#### `ON UPDATE CASCADE`

When a parent record's primary key changes, this constraint ensures that all child records referencing it are updated accordingly.

```sql
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id) ON UPDATE CASCADE
);
```

If a department ID changes, all employees linked to that department will have their `dept_id` updated.
This is useful when primary keys need to be modified while preserving relationships.

&nbsp;

#### `ON DELETE SET NULL`

Instead of deleting child records, this constraint sets the foreign key to `NULL` when the parent record is removed.

```sql
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL
);

CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(project_id) ON DELETE SET NULL,
    task_name VARCHAR(100) NOT NULL
);
```

If a project is deleted, its tasks remain but their `project_id` is set to `NULL`.
Useful when child records should persist but lose their association.

&nbsp;

#### `ON DELETE SET DEFAULT`

When a parent record is deleted, the foreign key in child records is reset to a default value.

```sql
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE SET DEFAULT DEFAULT 1,
    product_name VARCHAR(100) NOT NULL
);
```

If a category is deleted, products linked to it will be assigned the default category (`category_id = 1`)
This is useful to maintain a fallback association.

&nbsp;

#### `ON DELETE RESTRICT`

Prevents deletion of a parent record if child records exist. This ensures that dependent data remains intact.

```sql
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors(author_id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL
);
```

&nbsp;

#### `ON DELETE NO ACTION`

Similar to `RESTRICT`, but constraints are enforced at the end of a transaction rather than immediately.

```sql
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES authors(author_id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL
);
```

If a supplier has products, deletion is **prevented** until all constraints are checked.
Useful in complex transactions where constraints should be validated at the end.

&nbsp;

##### Best practices

- Use `CASCADE` cautiously – Ensure automatic deletions or updates align with business logic.
- Prefer `SET NULL` or `SET DEFAULT` when child records should persist.
- Use `RESTRICT` or `NO ACTION` to prevent unintended data loss.
- Test constraints before applying them in production environments.
