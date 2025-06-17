# Common Table Expressions

Common Table Expressions (CTEs), introduced using the `WITH` clause, are a powerful feature in SQL that improve query structure, readability, and performance. CTEs allow temporary result sets to be referenced multiple times within a query, making them useful for **breaking down complex queries**, handling **recursive operations**, and improving **maintainability**.

&nbsp;

A **Common Table Expression (CTE)** is essentially a temporary named result set that exists for the duration of a query.

## Basic syntax

````sql
WITH cte_name AS (
    SELECT column_names FROM table_name WHERE condition
)
SELECT * FROM cte_name;
````

CTEs provide a **cleaner alternative** to subqueries, improving readability and reusability.

&nbsp;

## Benefits of Using CTEs

- **Improves Readability**: Simplifies complex queries by breaking them into logical parts.
- **Enhances Performance**: Reduces redundant calculations by reusing temporary results.
- **Supports Recursion**: Enables hierarchical queries, such as organizational structures.

&nbsp;

### Simple data extraction
Let's learn by example. We will retrieve all students enrolled in courses.

````sql
WITH enrolled_students AS (
    SELECT student_id, course_id, academic_year FROM enrollments
)
SELECT * FROM enrolled_students WHERE academic_year = 2025;
````

&nbsp;

### Using CTEs for Aggregation
Finding the average course credits per department:

```sql
WITH department_credits AS (
    SELECT department, AVG(credits) AS avg_credits
    FROM courses
    GROUP BY department
)
SELECT * FROM department_credits;
```

&nbsp;

### Multiple CTEs in one query
CTEs can also be **stacked**, allowing indepdent calculations.

````sql
WITH active_courses AS (
    SELECT id, name FROM courses WHERE active = true
), 
recent_enrollments AS (
    SELECT student_id, course_id FROM enrollments WHERE academic_year = 2025
)
SELECT * FROM active_courses ac 
JOIN recent_enrollments re ON ac.id = re.course_id;
````

&nbsp;

## Recursive CTEs for hierarchical data

Recursive queries are particularly useful for **organizational hierarchies**, **course prerequisites**, and **nested relationships**.
What if we need to find course prerequisites recursively? We could use:

````sql
WITH RECURSIVE course_tree AS (
    -- Base case: Start with the target course
    SELECT course_id, prerequisite_id FROM course_dependencies WHERE course_id = 3
    
    UNION ALL
    
    -- Recursive case: Find dependencies of prerequisites
    SELECT cd.course_id, cd.prerequisite_id 
    FROM course_dependencies cd
    JOIN course_tree ct ON cd.course_id = ct.prerequisite_id
)
SELECT * FROM course_tree;
````

&nbsp;

## Aggregation & Statistical Computations

What if we want to calculate the average grade per student using CTEs for a cleaner logic, we could use:

````sql
WITH student_grades AS (
    SELECT enrollment_id, AVG(grade) AS avg_grade FROM results GROUP BY enrollment_id
)
SELECT * FROM student_grades WHERE avg_grade > 3.0;
````

&nbsp;
&nbsp;