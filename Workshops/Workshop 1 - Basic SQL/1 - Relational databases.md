# Relational Databases

### 1. What is a Relational Database?

A relational database is a type of database that stores data in structured tables, where the relationships between the data are explicitly recorded. This model was introduced in the 1970s by Edgar F. Codd and has since formed the basis of many database management systems (DBMS).

In a relational database:

- Data is organized into rows (records) and columns (attributes).
- Tables are linked by keys (primary and foreign).
- Structured Query Language (SQL) is used to query and manipulate data.
- Examples of relational database systems (RDBMS) include:
  - MySQL (open source, widely used in web applications)
  - PostgreSQL (advanced, with strong ACID compliance)
  - Oracle Database (widely used in enterprise environments)
  - Microsoft SQL Server (popular in business applications)

&nbsp;

### 2. Basic Concepts of Relational Databases

Relational databases use a few fundamental concepts to manage data efficiently:

&nbsp;

#### :books: Tables and structure

A table represents a data set. For example, a university database might have the following tables:

```mermaid
erDiagram
    students {
        integer id
        varchar first_name
        varchar last_name
        date date_of_birth
        varchar email
        varchar city
        date enrolled
    }
    
    teachers {
        integer id
        varchar code
        varchar first_name
        varchar last_name
        varchar email
    }
    
    courses {
        integer id
        varchar name
        varchar department
        integer credits
        bool active
    }
    
    course_teachers {
        integer course_id
        integer teacher_id
        integer academic_year
    }
    
    enrollments {
        integer id
        integer student_id
        integer course_id
        integer academic_year
    }
    
    results {
        integer id
        integer enrollment_id
        varchar grade
    }

    teachers ||--o{ course_teachers : "teaches"
    courses ||--o{ enrollments : "includes"
    courses ||--o{ course_teachers : "taught_by"
    students ||--o{ enrollments : "has"
    enrollments ||--o{ results : "produces"
```

The `course_id` in `enrollments` is a foreign key that references the `id` in `courses`, creating a relationship between the two tables.

&nbsp;

#### :key: Keys

Relational databases use keys to uniquely identify records and define relationships between tables.

- Primary Key – A unique identifier for a record (e.g. `id` in `students`, `teachers` and `courses`).
- Foreign Key – A reference to a record in another table (e.g. `course_id` and `student_id` in `enrollments`).

&nbsp;

#### :pencil: Normalization

To avoid redundancy and inconsistent data, relational databases are often normalized:

- 1NF (First Normal Form) – A table is in 1NF if all attributes contain atomic (indivisible) values and there are no repeating groups or arrays in a single column.
- 2NF (Second Normal Form) – A table is in 2NF if it is in 1NF and every non-key attribute is fully functionally dependent on the entire primary key (not just part of it).
- 3NF (Third Normal Form) – A table is in 3NF if it is in 2NF and all non-key attributes depend only on the primary key, not on other non-key attributes.

**1NF Bad example**:
```
students(id, first_name, last_name, emails)
1, John, Smith, "john@mail.com; john.smith@uni.edu"
```
Here, the field emails contains multiple email addresses.

**2NF Bad example**:
```
enrollments(student_id, course_id, academic_year, student_city)
```
Here, student_city depends only on student_id, not on the full composite key (student_id, course_id).

**3NF Bad example**:
```
courses(id, name, department, department_head)
```
Here, department_head depends on department, not directly on id.

&nbsp;
  
*:mortar_board: We will learn more about normalization later on in this course.*

&nbsp;

#### :revolving_hearts: Relationships between tables

Relational databases support several types of relationships:

- One-to-one (1:1) – For example, a table of users and their unique profile information.
- One-to-many (1:N) – For example, customers and their orders (one customer can have multiple orders).
- Many-to-many (N:M) – For example, students and their courses (a student can take multiple courses, and a course has multiple students).

&nbsp;

### 3. Benefits of Relational Databases

Why do many organizations choose relational databases? Here are some key benefits:

- ✔ Data consistency – Relationships and normalization prevent data loss and inconsistent data.
- ✔ Powerful query capabilities – SQL provides advanced ways to retrieve and manipulate data.
- ✔ Data integrity – Primary and foreign keys keep data consistent and accurate. 
- ✔ Transactions & ACID Compliance – Relational databases support secure transactions using ACID principles.

**What is a transaction?**
A transaction is a sequence of one or more SQL operations treated as a single, atomic unit of work. If any part of the transaction fails, the entire transaction is rolled back to maintain data integrity.

**Why are transactions important?**
They ensure that complex operations (such as updating multiple tables) are completed reliably and consistently, even in case of errors or system failures.

**ACID Principles:**
- Atomicity: A transaction is either fully completed or not at all.
- Consistency: The database remains in a valid state before and after the transaction.
- Isolation: Concurrent transactions do not interfere with each other.
- Durability: Data persists even after a system failure.
