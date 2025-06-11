# Partitioning – Breaking Large Tables into Smaller Pieces

When dealing with large datasets, partitioning can help improve performance and maintainability. PostgreSQL supports two general types of partitioning:

- Horizontal partitioning: splitting a table by rows
- Vertical partitioning: splitting a table by columns

## Horizontal partitioning

Horizontal partitioning is the process of splitting a large table into smaller pieces, called partitions, where each partition holds a subset of the rows based on the value of one or more columns.
From the user's perspective, it behaves like a single logical table — but under the hood, the data is physically separated.

In the example below, we partition a sales table by sale_date, using yearly ranges.

### Create the logical parent table
````sql
CREATE TABLE sales (
    id SERIAL,
    sale_date DATE,
    amount NUMERIC
) PARTITION BY RANGE (sale_date);
`````

This logically partitions the sales table by sale_date, meaning the data is transparently stored across multiple physical partitions behind the scenes. Queries that filter on sale_date can benefit from improved performance through partition pruning — but only after specific partitions have been created.

- No rows can be inserted into sales directly until partitions are defined.
- The table acts as a logical container; the actual data is stored in child tables (partitions).

### Define physical partitions per year

````sql
-- Partition for 2023
CREATE TABLE sales_2023 PARTITION OF sales
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for 2024
CREATE TABLE sales_2024 PARTITION OF sales
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for 2025
CREATE TABLE sales_2025 PARTITION OF sales
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
`````

- Each partition is a separate physical table behind the scenes.
- The range boundaries (FROM ... TO) define the values of sale_date each partition accepts.
- Any insert with a date outside these ranges will result in an error unless a default partition is defined.

### Optional: Add a default partition

````sql
CREATE TABLE sales_other PARTITION OF sales DEFAULT;
`````
- This catch-all partition handles rows that do not match any of the defined ranges.
- Useful for preventing insert errors when new or unexpected dates are encountered.

### Query the partitioned table

````sql
SELECT SUM(amount)
FROM sales
WHERE sale_date BETWEEN '2024-05-01' AND '2024-05-31';
`````
- PostgreSQL automatically uses partition pruning, scanning only the relevant partition(s).
- This improves query performance, especially on large datasets, by skipping irrelevant partitions.

### Design tip
Horizontal partitioning can be done not only by dates, but also by numeric values, text categories, or even hashed values. As a database designer, you should analyze the most common query patterns before deciding how to partition — the right partitioning strategy depends entirely on how the data is accessed.

### Comparision: Horizontal Partitioning vs Indexes

| Feature                | Horizontal Partitioning                            | Indexes                                       |
| ---------------------- | -------------------------------------------------- | --------------------------------------------- |
| **Main goal**          | Reduce scanned data volume                         | Speed up row lookup                           |
| **How it works**       | Splits table into physical sub-tables (partitions) | Builds a search tree alongside the table      |
| **Best for**           | Filtering on partition key (e.g. date, region)     | Filtering on other columns or point lookups   |
| **Query optimizer**    | Can skip entire partitions (partition pruning)     | Must scan index structure for the whole table |
| **Performance impact** | Reduces I/O and planning time for large datasets   | Improves access speed within a large table    |
| **Can be combined?**   | Yes – with indexes per partition                   | Yes – especially inside partitions          |


## Vertical partitioning (TBD)

No native PostgresSQL support, but the benefits are:

- Prestatie: queries die alleen bepaalde kolommen nodig hebben, lezen minder data.
- Beveiliging: gevoelige gegevens (zoals geboortedatum of voorkeuren) apart houden.
- Cache-efficiëntie: smallere tabellen passen beter in geheugen en cache.
- Soms betere write-prestaties, bij kolommen met verschillende wijzigingsfrequenties.

  It is a design decesion of the Database Administrator (DBA) to do this (or not). 

## Horizontal vs Vertical Partitioning – Summary

| Characteristic       | Horizontal Partitioning                    | Vertical Partitioning                               |
| -------------------- | ------------------------------------------ | --------------------------------------------------- |
| **Split by**         | Row values (e.g. by date)                  | Columns (e.g. rarely used or sensitive fields)      |
| **Primary use case** | Performance with large amounts of row data | Performance or security with wide tables            |
| **Result**           | Multiple tables containing subsets of rows | Multiple tables containing subsets of columns       |
| **Common scenarios** | Time-series data, logging, geographic data | Sensitive data, wide tables, column-specific access |


