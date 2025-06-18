# Altering tables

Databases are dynamic systems that evolve over time as organizations expand, technology advances, and business requirements shift. As applications grow, they often require schema modifications—such as adding new data attributes, removing obsolete columns, or restructuring relationships between tables.

Over time, databases must adapt to new business requirements, updated regulations, or technological advancements. Whether it's adding fields for additional customer data or restructuring relationships, schema modifications ensure a database remains scalable, efficient, and relevant.

- **E-commerce Systems**: Online stores may initially track only product names and prices, but later need to store inventory levels, customer reviews, and supplier details.
- **Healthcare Databases**: As medical practices integrate new health regulations, they may need to modify patient records, adding fields for updated insurance policies or lab results.
- **Social Media Platforms**: When introducing new features (e.g., Stories or Reactions), databases must adapt to store additional user-generated data.
- **Finance Systems**: Banks must update their database structures to comply with new legal regulations and security standards.

&nbsp;

```sql
ALTER TABLE table_name <modification_option>;
```

To make these changes efficiently and safely, PostgreSQL provides `ALTER TABLE`, enabling structured schema modifications while preserving data integrity.

&nbsp;

## Adding columns to a table

When new business requirements emerge, you may need to expand a table structure to include additional attributes.

```sql
ALTER TABLE table_name ADD COLUMN column_name datatype [constraint];
```

The above query adds a new column.

Let's assume we have a HR System, after a while we want to see the Job Title of our `employees`, we can fix this by adding a `job_title` column to our `employees` table.

```sql
ALTER TABLE employees ADD COLUMN job_title VARCHAR(100) DEFAULT 'Unknown';
```

The above query adds a `job_title` column with type `VARCHAR(100)` to the `employees` table and makes sure that a default value of `Unknown` is provided for existing records.

You can alter a table in one go, by adding multiple columns to a table.

```sql
ALTER TABLE employees ADD (salary INT, department VARCHAR(50));
```

When altering tables make sure to proper handle `NULL` values. Default values could help **auto-fill** historical data.

&nbsp;

## Modifying existing tables

Changing column names, updating data types, or restructuring constraints ensures database consistency while adapting to new workflows.

```sql
ALTER TABLE table_name ALTER COLUMN column_name TYPE new_datatype; -- Modify column datatype

ALTER TABLE table_name RENAME COLUMN old_name TO new_name; -- Rename a column
```

### Modifying

Changing columns can be very handy if we made a mistake in our initial database design. For example we might have a table `accounts` that has a column `interest_rate`. In our initial design we thought this needed to be an `INT` value, but after sharpening the requirements it should have been a higher precision `DECIMAL`.

```sql
ALTER TABLE accounts ALTER COLUMN interest_rate TYPE DECIMAL(5,2);
```

> [!NOTE]
> When changing the type of a table you have make sure the new type is compatible with the old type.

### Renaming

We also have a table called `users` where we currently use the column `username` for displaying the name of the user. Since we changed our application from using the `username` for logging in to using their `email` instead, we can convert the `username` column to be a more suitable name: `display_name` so it covers their use better.

```sql
ALTER TABLE users RENAME COLUMN username TO display_name;
```

> [!NOTE]
> Renaming columns impacts depdent queries and foreign keys!

&nbsp;

## Deleting columns

Removing outdated fields helps streamline storage, prevent redundancy, and optimize performance.

```sql
ALTER TABLE table_name DROP COLUMN column_name;
```

In our HR System we currently have a column called `fax_number`, even though non of our `employees` has a fax number. This column could be deleted without losing any important data. To do this, we can use the following query:

```sql
ALTER TABLE employees DROP COLUMN fax_number;
```

> [!NOTE]
> Ensure dependencies are resolved before deletion.
> Consider archiving old records before removing data permanently.

Just like adding multiple columns to a table, you can also drop multiple tables in one go.

```sql
ALTER TABLE employees DROP COLUMN salary, DROP COLUMN department;
```

&nbsp;

## Constraints

Constraints are essential for maintaining data integrity and consistency in a database. They enforce rules that ensure only valid and meaningful data is stored. PostgreSQL supports various constraints, which can be added, modified, renamed, or dropped as needed.

### Adding constraints

Adding constraints ensures that new rules are applied to maintain the integrity of data. When constraints are introduced, PostgreSQL validates existing records and enforces them for new ones. This process is crucial for preventing invalid entries that could lead to inconsistent data.s

```sql
ALTER TABLE employees ADD CONSTRAINT unique_email UNIQUE (email);
```

### Dropping constraints

Dropping a constraint removes a previously defined integrity rule. This operation should be performed cautiously, as removing constraints can allow invalid data to enter the table, potentially affecting relationships and business logic.

```sql
ALTER TABLE employees DROP CONSTRAINT unique_email;
```

### Renaming constraints

Renaming constraints helps maintain a clear and organized schema as database structures evolve. While renaming does not alter the function of a constraint, it ensures better readability and consistency in complex projects.

```sql
ALTER TABLE employees RENAME CONSTRAINT unique_email TO email_unique;
```

### Modifying constraints

Altering constraints usually involves modifying column properties, such as changing whether a column must always have a value (`NOT NULL`). Instead of dropping and re-adding a constraint, altering can refine the rules without fully removing them.

```sql
ALTER TABLE employees ALTER COLUMN email SET NOT NULL;
```

Some constraints require it to drop the constraint first and add a new one to modify it.

```sql
ALTER TABLE employees DROP CONSTRAINT salary_check;

ALTER TABLE employees ADD CONSTRAINT salary_check CHECK (salary > 25000);
```

### Considerations

- Since PostgreSQL does not allow direct modification, you must temporarily remove the constraint, which may pose a risk to data integrity during the change.
- Dropping and re-adding constraints in large tables can impact performance, especially if constraints require revalidation.
- Always ensure proper indexing and dependency handling when modifying foreign key constraints.

&nbsp;

## Indexes

Indexes enhance database performance by speeding up query execution. They allow PostgreSQL to quickly locate records rather than scanning entire tables. Various types of indexes can be used based on query needs.

> [!NOTE]
> You will learn more about indexes in another workshop.

While indexes are managed separately from constraints, they are closely related (e.g., a primary key automatically creates an index). To modify indexes:

### Adding an index

Creating indexes improves search efficiency by organizing data in a structured way. Proper indexing speeds up retrieval operations but should be used wisely, as unnecessary indexes can slow down insert and update processes.

```sql
ALTER TABLE products ADD INDEX idx_product_name (product_name);
```

### Dropping an index

Removing an index is sometimes necessary when it no longer benefits query performance. Over-indexing can lead to unnecessary storage consumption and slow down insertions and updates.

```sql
ALTER TABLE products DROP INDEX idx_product_name;
```

### Renaming an index

Renaming indexes helps maintain consistency in database structures, especially when schema modifications require clear identification of indexed fields.

```sql
ALTER INDEX idx_employee_name RENAME TO idx_emp_name;
```

### Altering an index

Indexes themselves cannot be directly altered with ALTER TABLE, but PostgreSQL provides options to recreate them for optimization. Adjusting index strategies—such as changing index types—helps improve efficiency as data grows.

```sql
DROP INDEX idx_employee_name;
CREATE INDEX idx_employee_name ON employees USING GIN (name);
```

### Keep in mind

- Over-indexing may slow down writes (inserts/updates) since indexes need maintenance.
- Choosing the right index type based on query needs is crucial for performance.
- PostgreSQL automatically uses indexes for query optimization when beneficial.

&nbsp;
