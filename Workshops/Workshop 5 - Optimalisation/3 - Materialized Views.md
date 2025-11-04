# Materialized Views – Precomputing expensive queries

A materialized view stores the precomputed results of a query physically on disk. This can significantly improve performance, especially for complex queries on large datasets.

**Key characteristics**   
- The result of the query is persisted on disk like a regular table.
- Queries on the materialized view are fast, since the data does not need to be recalculated.
- The view must be refreshed manually or on a schedule to reflect changes in the underlying tables.

Example 1:
````sql
-- Create a materialized view
CREATE MATERIALIZED VIEW top_sellers AS
SELECT name, SUM(sales) FROM employees GROUP BY name;

-- Refresh the view to update the data
REFRESH MATERIALIZED VIEW top_sellers;
````

Example 2:
````sql
-- Create a materialized view
CREATE MATERIALIZED VIEW sales_summary AS
SELECT date_trunc('month', sale_date) AS month,
       SUM(amount) AS total_amount
FROM sales
GROUP BY month;

-- Refresh the view to update the data
REFRESH MATERIALIZED VIEW sales_summary;
````
## Common Methods to Refresh a Materialized View in PostgreSQL
Materialized views do not update automatically when the underlying tables change. They must be refreshed explicitly. Below are the most common methods, with their use cases and trade-offs.

### Manual Refresh
````sql
REFRESH MATERIALIZED VIEW sales_summary;
````
Use when:   
- You need full control over when the data is refreshed.
- The view is updated infrequently (e.g., before generating a report).

Drawback:
- Refreshing must be done manually — easy to forget or overlook.

### Scheduled Refresh (via cron, pg_cron, or pgAgent)
Use the operating system’s cron, the pg_cron extension, or a PostgreSQL job scheduler like pgAgent.
Example using Linux cron (runs daily at 2 AM):

````bash
0 2 * * * /usr/bin/psql -d mydb -c "REFRESH MATERIALIZED VIEW sales_summary;"
````

Use when:
- You want regular updates (e.g., hourly, daily).
- Real-time accuracy is not required, but data should be reasonably fresh.

Drawback:
- Refreshes are time-based, not change-based.
- Requires external configuration and access to the server.

### Application-Level Refresh
Trigger a refresh from your application logic after inserting or updating large amounts of data.

````sql
-- Insert new sales data
INSERT INTO sales (...) VALUES (...);

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW sales_summary;
````

Use when:
- Your application manages data changes and can trigger a refresh at the right time.
- You want more precise control than a fixed schedule allows.

Drawback:
- May lead to unnecessary refreshes.
- Adds complexity to application logic.
  
## Alternative: Using CREATE TABLE AS SELECT

Instead of using a materialized view, you can also use a regular table to store the results of a query. This is useful for one-time snapshots or temporary data processing.

Suppose we want to summarize sales data by month. Instead of creating a materialized view, we could do:

````sql
CREATE TABLE sales_summary AS
SELECT date_trunc('month', sale_date) AS month,
       SUM(amount) AS total_amount
FROM sales
GROUP BY month;
````
This creates a regular table called sales_summary and stores the query results in it.

**Limitations of CREATE TABLE AS SELECT**  
While this works, it lacks some important advantages of a materialized view:

|Limitation|Explanation|
|----------|-----------|
|No built-in refresh|You must manually delete and reinsert data to update it. Updating the table requires custom logic (e.g. TRUNCATE + INSERT).|
|Query definition is lost|The original query is not stored with the table. You must track it yourself.|
|No dependency tracking|PostgreSQL doesn't know which base tables the data came from. You can drop or modify the original table without warning — the derived table will not be affected (but may become outdated or irrelevant).|

**When to Use CREATE TABLE AS SELECT**  
This method is suitable when:

- You only need a one-time result or a snapshot.
- You want full control over the data and do not need automatic refreshing.
- You plan to manipulate the table independently from the source data.



## Regular View vs Materialized View
While both regular views and materialized views allow you to present query results as if they were a table, they work in fundamentally different ways. The table below highlights the key differences between them.

|Feature|	Regular View	|Materialized View|
|-------|---------------|-----------------|
|Data storage	|Not stored; query is executed live|Stored on disk|
|Query performance|Slower for complex or large queries|Faster, since data is precomputed|
|Freshness of data|Always up-to-date|May be outdated until refreshed|
|Needs manual refresh|No|Yes — using REFRESH MATERIALIZED VIEW|
