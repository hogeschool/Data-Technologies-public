# Introduction to SQL

Structured Query Language (SQL) is the standard language for managing and querying relational databases. It allows users to retrieve, add, update, and delete data, as well as perform advanced operations such as combining data from multiple tables.

To practice SQL, we will use a pre-formed [University dataset](data/university.sql)

<!-- ##### students
| id          | first_name | last_name | date_of_birth | email  | city  | enrolled |
|------------|------------|------------|--------------|--------|------|----------|

##### teachers
| id  | code  | first_name | last_name | email  |
|----|------|------------|------------|------|


##### courses
| id  | name  | department  | credits | active  |
|----|------|-------------|--------|------|


##### course_teachers
| course_id  | teacher_id  | academic_year  |
|-----------|------------|--------------|


##### enrollments
| id  | student_id  | course_id  | academic_year  |
|----|------------|------------|--------------|


##### results
| id  | enrollment_id  | grade  |
|----|--------------|------| -->
---

Just as a reminder, we have the following tables in our database:

- `students`
- `teachers`
- `courses`
- `course_teachers`
- `enrollments`
- `results`

---

In SQL, queries follow a specific execution order, which determines how the database processes different clauses. The logical order of execution is different from the written order in an SQL statement.

**SQL Query Execution Order**

1. **FROM** – Specifies tables and joins data from multiple tables if needed.
2. **WHERE** – Filters rows based on conditions.
3. **GROUP BY** – Groups rows sharing the same values in specified columns.
4. **HAVING** – Filters aggregated/grouped data.
5. **SELECT** – Determines which columns or expressions to retrieve.
6. **DISTINCT** – Removes duplicate rows.
7. **ORDER BY** – Sorts the result set.
8. **LIMIT/OFFSET** – Restricts the number of rows returned.

The writing order of an SQL query is different from its execution order. When writing a SQL statement, you typically follow this structure:

**SQL Writing Order**

1. **SELECT** → Specify the columns to retrieve.
2. **FROM** → Choose the table(s) to query.
3. **JOIN** (if needed) → Define how tables are linked.
4. **WHERE** → Filter specific rows.
5. **GROUP BY** → Aggregate data into groups.
6. **HAVING** → Filter aggregated data.
7. **ORDER BY** → Sort the final result.
8. **LIMIT/OFFSET** → Restrict the number of rows displayed.

&nbsp;

## 1. Basic `SELECT`

The `SELECT` statement is the most commonly used SQL command. It is used to query data from one or more tables. In this guide, we will explore various options and clauses that can be used with `SELECT`, with examples using our [University dataset](data/university.sql).

&nbsp;

Retrieve all columns from the `courses` table:

````sql
SELECT * FROM courses;
````

<details markdown="1">
<summary>View this query result</summary>

| id  | name  | department  | credits | active  |
|----|------|-------------|:------:|:----:|
| 1 | Introduction to Programming | Computer Science | 5 | True |
| 2 | Data Structures and Algorithms | Computer Science | 6 | True |
| 3 | Database Management Systems | Computer Science | 5 | True |
| 4 | Operating Systems | Computer Science | 5 | True |
| 5 | Computer Networks | Computer Science | 5 | True |
| ... | ... | ... | ... | ... |

</details>

&nbsp;

Retrieve specific columns:

````sql
SELECT name, department FROM courses;
````


<details markdown="1">
<summary>View this query result</summary>

| name  | department  |
|------|-------------|
| Introduction to Programming | Computer Science |
| Data Structures and Algorithms | Computer Science |
| Database Management Systems | Computer Science |
| ... | ... |

</details>

&nbsp;
&nbsp;

### 2. SELECT `DISTINCT`

The `DISTINCT` keyword is used to eliminate duplicate rows in the result set. For example, to list all unique departments from the Courses table:

````sql
SELECT DISTINCT department FROM courses;
````

<details markdown="1">
<summary>View this query result</summary>

| department |
| ---------- |
| Education |
| Physics |
| Law |
| Economics |
| Medicine |
| ... |

</details>

&nbsp;
&nbsp;

### 3. Filtering with `WHERE`

The `WHERE` clause allows you to filter records. For example, to select students who enrolled in 2022:

````sql
SELECT * FROM students 
WHERE city = 'Rotterdam';
````

<details markdown="1">
<summary>View this query result</summary>

| id          | first_name | last_name | date_of_birth | email  | city  | enrolled |
|------------|------------|------------|--------------|--------|------|----------|
| 401 | Ashley | de Haan | 2004-08-11 | <ashley.dehaan@example.com> | Rotterdam | 2021-08-24 |
| 736 | Teun | Scholten | 2002-02-09 | <teun.scholten@example.com> | Rotterdam | 2025-05-07 |
| 1225 | Arthur | Wiśniewski | 1997-01-24 | <arthur.wisniewski@example.com> | Rotterdam | 2022-09-18 |
| 1454 | Joep | Vermeulen | 2000-04-23 | <joep.vermeulen83@example.com> | Rotterdam | 2020-08-06 |
| 1599 | Alicja | Kowalski | 1998-07-29 | <alicja.kowalski@example.com> | Rotterdam | 2020-10-04 |
| 1809 | Loïs | Ricci | 2006-04-25 | <lois.ricci@example.com> | Rotterdam | 2024-07-10 |

</details>

&nbsp;

You can also use logical operators like `AND`, `OR` and `NOT`:

````sql
SELECT * FROM students 
WHERE id >= 1000 AND city = 'Rotterdam';
````

<details markdown="1">
<summary>View this query result</summary>

| id          | first_name | last_name | date_of_birth | email  | city  | enrolled |
|------------|------------|------------|--------------|--------|------|----------|
| 1225 | Arthur | Wiśniewski | 1997-01-24 | <arthur.wisniewski@example.com> | Rotterdam | 2022-09-18 |
| 1454 | Joep | Vermeulen | 2000-04-23 | <joep.vermeulen83@example.com> | Rotterdam | 2020-08-06 |
| 1599 | Alicja | Kowalski | 1998-07-29 | <alicja.kowalski@example.com> | Rotterdam | 2020-10-04 |
| 1809 | Loïs | Ricci | 2006-04-25 | <lois.ricci@example.com> | Rotterdam | 2024-07-10 |

</details>

&nbsp;
&nbsp;

### 4. Sorting with `ORDER BY`

Use `ORDER BY` to sort the results. For example, sorting `courses` by their `department`:

````sql
SELECT * FROM courses 
ORDER BY department ASC;
````

<details markdown="1">
<summary>View this query result</summary>

| id  | name  | department  | credits | active  |
|----|------|-------------|:------:|:----:|
| 60 | Drawing Fundamentals | Arts | 3 | True |
| 104 | Digital Photography | Arts | 3 | True |
| 59 | Art History Survey I | Arts | 4 | True |
| 27 | Ecology | Biology | 4 | True |
| ... | ... | ... | ... | ... |

</details>

&nbsp;

Sort in descending order:

````sql
SELECT * FROM students
ORDER BY enrolled DESC;
````

<details markdown="1">
<summary>View this query result</summary>

| id          | first_name | last_name | date_of_birth | email  | city  | enrolled |
|------------|------------|------------|--------------|--------|------|----------|
| 111 | Deborah | Koning | 2006-10-10 | <deborah.koning63@example.com> | Breda | 2025-05-20 |
| 1142 | Mohammed | Kuipers | 2007-04-03 | <mohammed.kuipers66@example.com> | Sluis | 2025-05-20 |
| 801 | Mats | van der Wal | 2004-01-03 | <mats.vanderwal87@example.com> | Ermelo | 2025-05-20 |
| 402 | Scott | Durand | 2006-12-26 | <scott.durand74@example.com> | Zaanstad | 2025-05-18 |
| 442 | Willem | Durand | 2006-05-17 | <willem.durand@example.com> | Ommen | 2025-05-17 |
| ... | ... | ... | ... | ... | ... | ...

</details>

&nbsp;
&nbsp;

### 5. Aggregation with `GROUP BY` and `HAVING`

Aggregate functions like `COUNT`, `AVG`, `SUM`, `MIN`, and `MAX` can be used to perform calculations on a set of rows. 
Use `GROUP BY` to group results. For example, count the number of enrollments per academic year:

````sql
SELECT academic_year, COUNT(*) AS enrollment_count
FROM enrollments
GROUP BY academic_year;
````

<details markdown="1">
<summary>View this query result</summary>

| academic_year  | enrollment_count |
|----|------------|
| 2021 | 4921 |
| 2020 | 2305 |
| 2023 | 12102 |
| 2022 | 7816 |
| 2024 | 16743 |

</details>

&nbsp;

You can further filter aggregated data with `HAVING`. For instance, to list years with more than 5000 enrollments:

````sql
SELECT academic_year, COUNT(*) AS enrollment_count
FROM enrollments
GROUP BY academic_year
HAVING COUNT(*) > 5000;
````

<details markdown="1">
<summary>View this query result</summary>

| academic_year  | enrollment_count |
|----|------------|
| 2023 | 12102 |
| 2022 | 7816 |
| 2024 | 16743 |

</details>

&nbsp;
&nbsp;

### 6. Limiting Results with `LIMIT` and `OFFSET`

To retrieve a subset of records, use `LIMIT` and, optionally, `OFFSET`.

For example, to get the first 5 students:

````sql
SELECT * FROM Students
LIMIT 5;
````

<details markdown="1">
<summary>View this query result</summary>

| id          | first_name | last_name | date_of_birth | email  | city  | enrolled |
|------------|------------|------------|--------------|--------|------|----------|
| 1 | Luuk | Wagner | 2006-09-20 | <luuk.wagner62@example.com> | Pijnacker-Nootdorp | 2025-01-07 |
| 2 | Sandra | Durand | 1995-08-11 | <sandra.durand@example.com> | Smallingerland | 2024-02-16 |
| 3 | Rosalie | Verbeek | 2004-09-30 | <rosalie.verbeek@example.com> | Hoofddorp | 2021-11-02 |
| 4 | Luis | Dekkers | 2005-05-08 | <luis.dekkers@example.com> | Steenbergen | 2022-07-23 |
| 5 | Olivier | Martin | 1999-06-10 | <olivier.martin@example.com> | Cranendonck | 2022-09-13 |

</details>

&nbsp;
&nbsp;

Skip the first 3 records and show the next 5:

````sql
SELECT * FROM Students
LIMIT 5 OFFSET 3;
````

<details markdown="1">
<summary>View this query result</summary>

| id          | first_name | last_name | date_of_birth | email  | city  | enrolled |
|------------|------------|------------|--------------|--------|------|----------|
| 4 | Luis | Dekkers | 2005-05-08 | <luis.dekkers@example.com> | Steenbergen | 2022-07-23 |
| 5 | Olivier | Martin | 1999-06-10 | <olivier.martin@example.com> | Cranendonck | 2022-09-13 |
| 6 | Cynthia | Klein | 1998-05-26 | <cynthia.klein59@example.com> | IJmuiden | 2024-02-06 |
| 7 | Laura | Wagner | 2002-12-12 | <laura.wagner@example.com> | Duiven | 2023-03-16 |
| 8 | Rens | Kowalski | 2006-04-28 | <rens.kowalski4@example.com> | Roosendaal | 2025-02-13 |

</details>

&nbsp;
&nbsp;
