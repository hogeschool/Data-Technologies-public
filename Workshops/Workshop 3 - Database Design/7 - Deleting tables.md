# Deleting Tables

Databases evolve over time, and there are situations where deleting a table becomes necessary. However, removing a table is a **permanent action**, meaning all data stored within it will be lost. Before executing a deletion, it's essential to understand why and when tables should be removed.

- **Obsolete Data Structures**
  When a table is no longer needed due to changes in business requirements.
  Example: A company phases out an old product line, making related tables redundant.
  &nbsp;
- **Database Cleanup & Optimization**
  Removing unused tables helps improve database performance and storage efficiency.
  Example: Temporary tables created for testing purposes should be deleted once testing is complete.
  &nbsp;
- **Schema Redesign**
  When restructuring a database, some tables may need to be dropped and replaced with new ones.
  Example: A table storing customer orders is replaced with a more normalized structure.
  &nbsp;
- **Security & Compliance**
  Sensitive data may need to be permanently removed to comply with regulations.
  Example: GDPR compliance requires deleting user data upon request.

&nbsp;

## Syntax

SQL provides the DROP TABLE statement to remove a table from the database. This command **permanently deletes** the table structure and all its records.

```sql
DROP TABLE table_name;
```

For example if we want to delete our `employees` table:

```sql
DROP TABLE employees;
```

> [!CAUTION]
> Deleting a table is a **permanent action**, data cannot be restored! Make backups and use precaution before running `DROP TABLE`!

### Avoiding errors

If the table does not exist, executing `DROP TABLE` without precautions may result in an error. To prevent this, use `IF EXISTS`.

```sql
DROP TABLE IF EXISTS employees;
```

This ensures the command executes **only if the table exists**, preventing unnecessary errors.


### Temporary tables

Temporary tables are often used for intermediate calculations. They can be deleted using:

```sql
DROP TEMPORARY TABLE temp_sales;
```

This removes only **temporary tables** without affecting permanent ones.

&nbsp;

## Handling dependencies

Before deleting a table, it's crucial to check for dependencies such as:

- **Foreign Key Constraints**: Other tables may reference the table being deleted.
- **Views & Stored Procedures**: The table might be used in queries or functions.
- **Triggers**: Automated actions may depend on the table.

### Checking dependencies

To make sure we do not have any dependencies on a table we are willing to delete we can use:

```sql
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_NAME = 'employees';
```

This query lists all foreign key constraints referencing the `employees` table.

### Removing Foreign Key Constraints

Before dropping a table, foreign keys must be removed:

```sql
ALTER TABLE orders DROP CONSTRAINT fk_employee_id;
```

Once constraints are removed, the table can be safely deleted.

### Handling Views & Stored Procedures

If a table is referenced in a view, the view must be dropped first:

```sql
DROP VIEW employee_summary;
```

Similarly, stored procedures using the table should be updated or removed.

&nbsp;

## Safe deletion

If a table has dependencies, manually removing constraints can be tedious. SQL provides the `CASCADE` option to automatically delete dependent objects.

```sql
DROP TABLE table_name CASCADE;
```

This ensures:

- All dependent foreign keys are removed.
- Views and triggers referencing the table are deleted.

Consider a scenario where the `employees` table is referenced by the orders table:

```sql
DROP TABLE employees CASCADE;
```

This command **automatically removes** all dependencies, ensuring a smooth deletion.

> [!CAUTION]
> Although called *Safe deletion*, deleting a table is a **permanent action** and data cannot be restored! 
> Make backups and use precaution before running `DROP TABLE` (even when using `CASCADE`)!

&nbsp;
&nbsp;