# Advanced `SELECT` functionalities

SQL's `SELECT` statement is incredibly powerful, offering a range of advanced options that allow for complex data retrieval, manipulation, and transformation.

Before diving into advanced features, here’s a small reminder of the standard SELECT structure:

````sql
SELECT column_names
FROM table_name
WHERE conditions
GROUP BY group_columns
HAVING conditions
ORDER BY sort_columns
LIMIT row_count;
````

&nbsp;

## Advanced selection techniques

### Aliases

Using column aliases improves readability and allows computed values.

````sql
SELECT first_name AS "First Name", last_name AS "Surname"
FROM students;
````

&nbsp;

### Conditional Transformation & Sorting

`CASE` allows you to apply conditional logic within SQL statements, for example to transform output, control sorting, or update values based on conditions.

````sql
SELECT id, first_name, last_name, 
       CASE 
           WHEN enrolled IS NOT NULL THEN 'Enrolled'
           ELSE 'Not Enrolled'
       END AS enrollment_status
FROM students;
````
This does not filter rows; it creates a new column based on conditions.

```sql

SELECT first_name, last_name, enrolled
FROM students
ORDER BY CASE WHEN enrolled IS NOT NULL THEN 1 ELSE 2 END;
```
Enrolled students appear first.
&nbsp;

### Expressions

You can perform calculations directly in the SELECT list. 
For example, if you wanted to add a prefix to student names:

````sql
SELECT CONCAT('Student: ', StudentName) AS LabeledName
FROM Students;
````

&nbsp;

### Subqueries

Subqueries allow you to nest queries. 
For example, to select students along with the number of courses they enrolled in:

````sql
SELECT s.StudentName,
       (SELECT COUNT(*) FROM Enrollments e WHERE e.StudentID = s.StudentID) AS CourseCount
FROM Students s;
````

&nbsp;

### `UNION` Operator

Combine results from two queries with the same number of columns using UNION. 
For instance, if you wanted to compile a list of all emails from students and teachers:

````sql
SELECT Email FROM Students
UNION
SELECT Email FROM Teachers;
````

*Note: `UNION` removes duplicates by default. Use `UNION ALL` to include duplicates.*

&nbsp;

### Aggregate functions

Aggregate functions operate on a set of values and return a single value. 
They are commonly used with `GROUP BY` to group records before performing aggregation.
The `GROUP BY` clause groups rows **before** applying an aggregate function.

**Basic syntax**

````sql
SELECT aggregate_function(column_name)
FROM table_name
WHERE conditions
GROUP BY group_column
HAVING filter_condition;
````

&nbsp;

#### Counting rows

To count the number of **non-null** values we can use `COUNT()` in SQL.
For example, let's say we want the total amount of students, we could use:

````sql
SELECT COUNT(*) AS total_students FROM students;
````

But we also might want to know how many students are from each city:

````sql
SELECT city, COUNT(*) AS total_students 
FROM students GROUP BY city;
````

&nbsp;

#### Calculating totals

To compute the sum of a numeric column we can use `SUM()`.
If we want to find the total credits per department we could use:

````sql
SELECT department, SUM(credits) AS total_credits
FROM courses
GROUP BY department;
````

&nbsp;

#### Calculating averages

To find the average value of numeric columns we can use `AVG()`.
For example, let's find the average amount of credits on a course per department:

````sql
SELECT department, AVG(credits) AS avg_credits
FROM courses
GROUP BY department;
````

&nbsp;

#### Minimum and Maximum values

To retrieve the smallest (`MIN()`) or largest (`MAX()`) values we use `MIN()` and `MAX()`.
Let's find the youngest student in our dataset:

````sql
SELECT MIN(date_of_birth) AS youngest_student
FROM students;
````

What was the latest enrolment year in our dataset?

````sql
SELECT MAX(academic_year) AS latest_enrollment_year
FROM enrollments;
````

&nbsp;

#### Filtering

Unlike `WHERE`, which filters individual rows **before** aggregation, `HAVING` filters **after** aggregation.

````sql
SELECT department, SUM(credits) AS total_credits
FROM courses
GROUP BY department
HAVING SUM(credits) > 50;
````

&nbsp;

#### `NULL` handling

By default, aggregate functions **ignore NULL values**, except for `COUNT(*)`.
We can use the `COALESCE()` function to handle NULL values.
For example if we want to ensore no NULL values impact the average calculation:

````sql
SELECT department, AVG(COALESCE(credits, 0)) AS avg_credits
FROM courses
GROUP BY department;
````
*What does COALESCE do?*
It returns the first non-null value from the list of arguments. In this example, if credits is NULL, 0 is used instead.
&nbsp;

#### PostgreSQL specific

PostgreSQL provides some extra functions to the default SQL functions above:

- `PERCENTILE_CONT()` - Returns a computed result after doing linear interpolation over a dataset.
- `PERCENTILE_DISC()` - Picks the actual value from a dataset that corresponds to the requested percentile, without interpolation
- `VARIANCE()` - Find the variance on a numeric column
- `STDDEV()` - Find the standard deviation on a numeric column

> See 'Resources' for a explanation of linear interpolation, variance & standard deviation.

## Filtering data

Previously we used the `WHERE` operator to retrieve specific records based on the condition given.
The `WHERE` clause has very powerful extra options that could be used in combination.

### Multiple values

Efficiently filter multiple values with the use of `IN` and a list to match against.

````sql
SELECT * FROM courses WHERE department IN ('Math', 'Physics', 'Computer Science');
````

&nbsp;

### Range filtering

When working with numbers or dates, it is helpful to find records `BETWEEN` a range.
This is where the `BETWEEN` option comes into place, it helps you find every record matching between that range.

````sql
SELECT * FROM students WHERE date_of_birth BETWEEN '2000-01-01' AND '2005-12-31';
````

&nbsp;

### Pattern matching

Pattern matching with `LIKE` in SQL is a powerful way to search for specific text patterns within a column. 
It's commonly used when you want to filter results based on partial matches rather than exact values.

#### Basic syntax

The `LIKE` operator is used in combination with **wildcards** to match patterns in a string column.

````sql
SELECT column_name
FROM table_name
WHERE column_name LIKE 'pattern';
````

The pattern can contain **wildcards**, which allow flexible searching.

#### Wilcards

##### `%` - Any number of characters

The `%` wildcard represents **zero or more** characters and is useful when searching for words that **start**, **end** or **contain** a specific pattern.

**Examples:**
Find all students with first names that **start** with 'J':

````sql
SELECT * FROM students WHERE first_name LIKE 'J%';
````

Find students whose last names **end** with 'son':

````sql
SELECT * FROM students WHERE last_name LIKE '%son';
````

Find students whose email **contains** 'gmail':

````sql
SELECT email FROM students WHERE email LIKE '%gmail%';
````

---

#### `_` - Exactly one character

The `_` wildcard represents **a single** character and is useful when searching for records with specific character length.

**Examples:**
Find all teachers with 5-letter first names:

````sql
SELECT first_name FROM teachers WHERE first_name LIKE '_____';
````

Find teachers whose codes **start with 'A' followed by exactly four characters**:

````sql
SELECT code FROM teachers WHERE code LIKE 'A____';
````

---

#### `[ ]` - Character range

The `[ ]` wildcard matches **any single character** in brackets and will work with **ranges** or **specific sets** of characters.

**Examples:**
Find students whose first name starts with 'A', 'B', or 'C':

````sql
SELECT first_name FROM students WHERE first_name LIKE '[ABC]%';
````

Find students whose last name starts with any **letter from A to M:**

````sql
SELECT last_name FROM students WHERE last_name LIKE '[A-M]%';
````

---

#### `[ˆ]` - Negation

The `[ˆ]` wildcard matches **any single character NOT** in brackets and is useful when filtering out unwanted patterns.

**Example:**
Find students whose first name does **not** start with 'A' or 'B':

````sql
SELECT first_name FROM students WHERE first_name LIKE '[^AB]%';
````

---

#### Case-intensitive matching

By default, **LIKE** is case-sensitive in PostgreSQL. To perform case-insensitive searches:

````sql
SELECT first_name FROM students WHERE LOWER(first_name) LIKE 'j%';
````

PostgreSQL provides **ILIKE**, which automatically performs case-insensitive matching.

````sql
SELECT city FROM students WHERE city ILIKE '%amsterdam%';
````

> [!WARNING]
> Using `LIKE` on large datasets can slow down queries, especially if searching with `%` at the start.

&nbsp;
&nbsp;
