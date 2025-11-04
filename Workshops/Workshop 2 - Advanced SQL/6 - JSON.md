# JSON and JSON Functions

PostgreSQL provides extensive support for **JSON** and **JSONB** data types, allowing efficient storage and querying of semi-structured data.

## Reminder of JSON

JSON stands for JavaScript Object Notation. JSON is a lightweight data interchange format that is readable for humans and simple for computers to parse. JSON is based on 2 main structures **Objects** and **Arrays**.

### Objects in JSON

An object is defined as an unordered collection of key-value pairs enclosed in curly braces `{}`. Each pair includes:

- A key which is a string surrounded by double quotes (`“`).
- A colon `:` that separates the key and value.
- A value that can be a string, a number, or even an object.

Let's take a look at the following example illustrating a JSON object representing a student:

```json
{"id": 1, "name": "John Doe", "date_of_birth": "18-04-2002", "city": "Rotterdam"}
```

The student object has 4 keys `id`, `name`, `date_of_birth` and `city` with associated values.

&nbsp;

### Arrays in JSON

An array is an ordered list of values enclosed in square brackets `[]`. The values do not have to be the same type. Additionally, an array may contain values of any valid JSON data type including objects and arrays.

For example, the following shows an array that stores three courses titles as strings:

```json
["Development 101", "Project Alpha", "Skills"]
```

&nbsp;

### Data types in JSON

JSON supports some data types including:

- String: `“Joe”`
- Number: `100, 9.99, …`
- Boolean: `true` and `false`.
- Null: `null`

JSON data can be particularly useful for creating configuration files or exchanging data between a client and a server.

&nbsp;

## JSON data types in PostgreSQL

PostgreSQL offers two data types for storing JSON:

- **JSON** – store an exact copy of the JSON text.
- **JSONB** – store the JSON data in binary format.

&nbsp;

### JSON or JSONB?

The following table shows the key differences between JSON and JSONB types in PostgreSQL.

Type | JSON | JSONB
-----|------|------
Storage|Textual representation (verbatim)|Binary storage format
Size|Typically larger because it retains the whitespace in JSON data|Typically smaller
Indexing|Full-text search indexes|Binary indexes
Performance|Slightly slower|Generally faster
Query performance|Slower due to parsing|Faster due to binary storage
Parsing|Parse each time|Parse once, store in binary format
Data manipulation|Simple and easy|More complex
Ordering of keys|Preserved|Not preserved
Duplicate keys|Allow duplicate key, the last value is retained|Do not allow duplicate keys.
Use cases|Storing configuration data, log data, simple JSON documents|Storing JSON documents where fast querying and indexing are required

> [!TIP]
> In practice, you should use `JSONB` to store JSON data unless you have specialized requirements such as retaining the ordering of keys in the JSON documents.

&nbsp;

### Before we continue

Our current database model `university` has no `JSON` or `JSONB` column in any of the tables, so we need to `ALTER` one of the tables to make sure we can store JSON in it. We are going to alter the `courses` table. *More on altering tables in another workshop.*

```sql
ALTER TABLE courses ADD COLUMN course_details JSONB;
```

Now the table has a JSONB field we can query on via the JSON functions in PostgreSQL.
Let's add some data so we can grab information via the examples:

```sql
UPDATE courses
SET course_details = '{
    "prerequisites": ["Mathematics 101", "Introduction to Programming"],
    "textbooks": [
        {"title": "Database Systems", "author": "Elmasri & Navathe"},
        {"title": "PostgreSQL for Professionals", "author": "Christophe Pettus"}
    ],
    "learning_objectives": [
        "Understand database normalization",
        "Master SQL queries",
        "Optimize database performance"
    ]
}'
WHERE name = 'Advanced SQL';
```

&nbsp;

### Extracting JSON functions

Because JSON is a format on it's own, we need to do use specific functions inside a SELECT query to grab information from the JSON field. &nbsp; The `->` operator extracts a JSON object or array, so we can use it inside the query. 
The `->` operator is used to extract a JSON object or array, keeping the data in its JSON format.

```sql
SELECT course_details->'textbooks' AS textbook_list
FROM courses
WHERE name = 'Advanced SQL';
```

This query retrieves the **entire** `"textbooks"` array from `course_details`.

&nbsp;

```sql
SELECT course_details->'textbooks'->0 AS first_textbook
FROM courses
WHERE name = 'Advanced SQL';
```

This query retrieves the **first** textbook object from the textbooks array.

&nbsp;

### Querying nested JSON objects

Because JSON is such a versatile format, it could have objects and arrays nested, for these usecases there is a special operator `#>>` which extracts a nested JSON value. The `#>>` operator extracts a deeply nested JSON value as TEXT (instead of JSON).

```sql
SELECT name, course_details#>>'{textbooks,0,title}' AS first_textbook
FROM courses
WHERE name = 'Advanced SQL';
```

In the above query the `#>>'{textbooks,0,title}'` extracts the title of the first textbook in the textbooks array inside `course_details`.

&nbsp;

Suppose we want to find courses that require "Mathematics 101" as a prerequisite by querying inside the course_details JSONB column.

```sql
SELECT name FROM courses
WHERE 'Mathematics 101' = ANY (
    SELECT jsonb_array_elements_text(course_details->'prerequisites')
);
```

- `jsonb_array_elements_text(course_details->'prerequisites')` extracts each prerequisite as a separate text value.
- The nested query runs inside ANY(), checking if "Mathematics 101" is in the prerequisites list.

&nbsp;

### Expanding JSON arrays

Up until now we had the option to retrieve data from our JSON field as JSON or string. But what if we want to filter on items from a specific JSON field? For this situation there is a built-in function called `json_array_elements_text()` which extracts the data of an JSON array into seperate row values.

```sql
SELECT json_array_elements_text(course_details->'prerequisites') AS prerequisite
FROM courses
WHERE name = 'Advanced SQL';
```

Would result in the following result:

````cli
Mathematics 101
Introduction to Programming
Database Basics
````

*Each value will be in a seperate row, so we can use it for built-in filter functions*

&nbsp;

This is very handy for example for when you want to filter courses based on a prerequisite

```sql
SELECT name FROM courses
WHERE 'Mathematics 101' = ANY (
    SELECT json_array_elements_text(course_details->'prerequisites')
);
```

This query searches for all courses that have `'Mathematics 101'` as an value inside the JSON array `prerequisites`.

&nbsp;

### Building JSON objects

In some situations you might want a JSON object combined from data from several columns when you query the database. For this purpose there is a special function called `json_build_object()` which builds an JSON object dynamically.

```sql
SELECT json_build_object(
    'course_name', name,
    'department', department,
    'credits', credits
) AS course_summary
FROM courses;
```

The above query builds a structured JSON object for each course containing `course_name`, `department` and `credits` as fields.

&nbsp;

### Aggregating JSON data

When you want to group data into a structured JSON format, `json_build_object` isn't enough. For this purpose the function `json_agg()` will give you the correct result. `json_agg()` aggregates multiple rows into a single JSON array.

Aggregating JSON data is mostly used to return JSON-formatted API responses directly from the query and simplifying complex queries.

```sql
SELECT json_agg(email) AS student_emails
FROM students;
```

Would result in the following result:

```json
["alice@example.com", "bob@example.com", "charlie@example.com"]
```

&nbsp;

Let's aggregate the course details and see what happens.

```sql
SELECT department, json_agg(jsonb_build_object('name', name, 'credits', credits, 'active', active)) AS course_list
FROM courses
GROUP BY department;
```

- `jsonb_build_object()` creates a structured JSON representation of each course.
- `json_agg()` aggregates courses within each department into a single JSON array.

&nbsp;

### Counting JSON array elements

Because JSON is a format on it's own, it is a bit harder to do calculations on fields inside the object/array. For example, if we want to count how many `textbooks` each course has listed inside the `course_details` column, we need something to do the calculation for us. `json_array_length()` or for us now `jsonb_array_length()` will count the number of elements in a JSON array.

```sql
SELECT json_array_length('[1, 2, 3, 4, 5]'::json);
```

Will result in `5`

&nbsp;

If we would like to know how many `textbooks` each course has listed, we could use the following query:

```sql
SELECT name, json_array_length(course_details->'textbooks') AS textbook_count
FROM courses;
```

&nbsp;

We could also use this function inside filters, so we can check for courses that have at least `2` textbooks listed inside their `course_details`.

```sql
SELECT name FROM courses
WHERE json_array_length(course_details->'textbooks') > 2;
```

&nbsp;
&nbsp;