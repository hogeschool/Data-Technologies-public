# Views

A view in SQL is a **virtual table** that is based on the result of a query. Unlike physical tables, views do not store data themselves; instead, they dynamically retrieve data from underlying tables whenever queried. Views help simplify complex queries, enhance security, and improve data abstraction.

## Why use views?

- **Simplify complex queries** by storing reusable logic.
- **Enhance security** by restricting access to sensitive data.
- **Improve maintainability** by abstracting database structure.

&nbsp;

## SQL `VIEW` Syntax

Unlike a table, a view does not store data physically. The database system only stores the view’s definition.
When you query data from a view, the database system executes the query to retrieve data from the underlying tables.

### Creating

To create a new view, you use the `CREATE VIEW` statement followed by a query.

```sql
CREATE VIEW [IF NOT EXISTS] view_name AS
--query
SELECT columns FROM table_name WHERE condition;
```

In this syntax we start by setting the `name` of the view after `CREATE VIEW`. By optionally using `IF NOT EXISTS` option we can prevent creating a view that might already exist. After the `AS` we start our `SELECT` query, this is called a view defining query. The query can retrieve data from one or more tables, it acts as a normal query.

> [!NOTE]
> A view always shows up-to-date data! The database engine recreates the view, every time a user queries it.

&nbsp;

Let's create a view for student enrollments

```sql
CREATE VIEW student_enrollments AS
SELECT s.id, s.first_name, s.last_name, c.name AS course_name, e.academic_year
FROM students s
JOIN enrollments e ON s.id = e.student_id
JOIN courses c ON e.course_id = c.id;
```

The above query will create a `VIEW` in our database that we can now access via a regular query:

```sql
SELECT * FROM student_enrollments WHERE academic_year = 2024;
```

&nbsp;

### Updating

To modify the view structure, such as adding new columns to the view or removing columns from a view, you use the `CREATE OR REPLACE VIEW` statement.

```sql
CREATE OR REPLACE view_name AS
--query
SELECT columns FROM table_name WHERE condition;
```

The `CREATE OR REPLACE` statement creates a view if it does not exist or replaces the existing view.

&nbsp;

For example, the following statement changes the `student_enrollments` view by adding the student `email` and `city` columns:

```sql
CREATE OR REPLACE VIEW student_enrollments AS
SELECT s.id, s.first_name, s.last_name, s.email, s.city, c.name AS course_name, e.academic_year
FROM students s
JOIN enrollments e ON s.id = e.student_id
JOIN courses c ON e.course_id = c.id;
```

After the change we can use a query like to include the `city`:

```sql
SELECT * FROM student_enrollments WHERE city = 'Amsterdam';
```

&nbsp;

### Deleting

To remove a view from the database, you use the `DROP VIEW` statement with the following syntax:

```sql
DROP VIEW IF EXISTS view_name;
```

We start by specifying the name of the view (`view_name`) we want to remove after the `DROP VIEW` keywords.
You could also add the `IF EXISTS` option to conditionally drop a view only if it exists. If you don't use the `IF EXISTS` option, and the view does not exists; the databsae system will issue an error. 

> [!NOTE]
> The `DROP VIEW` statement deletes the view only, it does not remove the tables.

The following query uses the `DROP VIEW` statement to drop the `student_enrollments` view from the database:

```sql
DROP VIEW IF EXISTS student_enrollments;
```

&nbsp;

### Recursive views

A recursive view in SQL is a type of view that **calls itself** in a query to process hierarchical or sequential data.

Suppose we want to model course dependencies, where some courses require students to complete prerequisite courses first.
To find all courses and their prerequisite chains, we create a recursive CTE inside a view:

```sql
CREATE VIEW course_hierarchy AS
WITH RECURSIVE course_tree AS (
    -- Base case: Select courses with direct prerequisites
    SELECT c.id, c.name, p.prerequisite_id, 1 AS level
    FROM courses c
    JOIN prerequisites p ON c.id = p.course_id

    UNION ALL

    -- Recursive case: Expand prerequisites further
    SELECT ct.id, ct.name, p.prerequisite_id, ct.level + 1
    FROM course_tree ct
    JOIN prerequisites p ON ct.prerequisite_id = p.course_id
)
SELECT * FROM course_tree;
```

Now, we can retrieve hierarchical prerequisite chains:

```sql
SELECT * FROM course_hierarchy WHERE level > 1;
```

- This helps students see the full course progression.
- Useful for advisors managing degree plans.

&nbsp;

## Example and exercises

Views can contain any form of `SELECT` queries, which means they can also contain complexer queries:

```sql
CREATE VIEW course_statistics AS
SELECT c.name AS course_name, c.department, COUNT(e.id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id;
```

The above `VIEW` can be used to query `course_statistics` based on course enrollment count.

1. Can you come up with a query to get only the `course_statics` data for courses with a `total_enrollments` of 50 or more?
2. Create a view that shows students who enrolled before 2023. Include first name, last name, and enrollment date.
3. Update the view you just created to include the `email` of the student.
4. Run some query's on the new view.
5. Remove the view you created, use `IF EXISTS` on it.

&nbsp;
&nbsp;