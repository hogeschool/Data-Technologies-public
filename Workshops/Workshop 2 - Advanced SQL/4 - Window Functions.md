# Window Functions

Window functions are a powerful feature in SQL that allow calculations across a specific "window" of rows related to the current row—without collapsing them into a single output like traditional aggregation functions. 
They are essential for ranking, running totals, and advanced analytics.

## 1. What are Window Functions?

Unlike standard aggregate functions (`SUM()`, `AVG()`, etc.), which reduce a result set to a single row, window functions operate on a subset of rows while preserving individual row details. 
Window functions are often used for ranking, running totals, moving averages, and cumulative sums.

**Syntax**

````sql
SELECT column_name, 
       window_function() OVER (PARTITION BY column ORDER BY column)
FROM table_name;
````

Each **window function** operates within a defined **window** of rows, determined by:

- **PARTITION BY**: Divides data into subsets.
- **ORDER BY**: Defines row order within each partition.

&nbsp;

## 2. Key Window Functions

### 2.1 Ranking Students by enrollment date

Using `RANK()` to rank students based on when they enrolled:

````sql
SELECT id, first_name, last_name, city, enrolled,
       RANK() OVER (ORDER BY enrolled ASC) AS enrollment_rank
FROM students;
````

*Ranks students by their enrollment date (earliest gets rank 1).*

&nbsp;

### 2.2 Running Total of Students Enrolled Per City

Using `SUM()` to calculate a cumulative count of students in each city:

````sql
SELECT city, enrolled,
       COUNT(id) OVER (PARTITION BY city ORDER BY enrolled ASC) AS running_total
FROM students;
````

*Shows how many students have enrolled in each city over time.*

&nbsp;

### 2.3. First & Last Course Taken Per Student

Using `FIRST_VALUE()` and `LAST_VALUE()` to find a student's first and last courses:

````sql
SELECT e.student_id, e.academic_year, c.name AS course_name,
       FIRST_VALUE(c.name) OVER (PARTITION BY e.student_id ORDER BY e.academic_year ASC) AS first_course,
       LAST_VALUE(c.name) OVER (PARTITION BY e.student_id ORDER BY e.academic_year ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_course
FROM enrollments e
JOIN courses c ON e.course_id = c.id;
````

*Retrieves the first and last course a student enrolled in.*

&nbsp;

### 2.4. Moving Average of Student Grades

Using `AVG()` with rows-based windowing to calculate a moving average of grades:

````sql
SELECT r.enrollment_id, r.grade,
       AVG(grade::numeric) OVER (ORDER BY enrollment_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM results r;
````

*Smooths variations in grades by averaging each student's last three results.*

&nbsp;

### 2.5. Percentile Ranking of Courses by Credit Count

Using `NTILE(4)` to split courses into quartiles based on their credits:

````sql
SELECT id, name, department, credits,
       NTILE(4) OVER (ORDER BY credits DESC) AS credit_quartile
FROM courses;
````

*Divides courses into quartiles, grouping similar ones together.*

&nbsp;

## 3. Performance Considerations

- Indexing `PARTITION BY` columns improves performance.
- Avoid excessive memory usage with large datasets.
- Parallel execution can optimize queries in PostgreSQL.

&nbsp;
&nbsp;
