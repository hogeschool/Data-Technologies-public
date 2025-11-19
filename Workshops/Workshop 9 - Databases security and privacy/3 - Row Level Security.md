# Row-Level Security (RLS)

Row-Level Security (RLS) provides **fine-grained access control** at the row level.  
It lets you define which rows of a table a role can `SELECT`, `UPDATE`, `DELETE`, or `INSERT`. RLS is often used to refine the coarse-grained access granted by ```GRANT``` and ```REVOKE``` commands. Role-Based Access Control (RBAC) determines if a role can access the table, while RLS determines which rows within that table are visible.\
\
RLS is especially useful in *multi-tenant application* or self-service portals where users should only see or modify *their own* data.

#### What is a multi-tenant application?

A **multi-tenant application** is a software architecture where multiple customers (*tenants*) share the same application and database infrastructure, while their data remains logically separated.

- **Shared resources** → one application instance (and often one database) serves multiple tenants.  
- **Data isolation** → each tenant must only be able to see and manage *their own* data.  
- **Cost-efficient** → cheaper and easier to maintain than running a separate installation per customer.  
- **Challenge** → strict access control is required to prevent tenant A from accessing tenant B’s data.

**Example:**  
In a single-tenant setup, each company has its own database.  
In a multi-tenant setup, all companies share the same database with a column like `tenant_id` in each table.  

- Without RLS: the application must always add `WHERE tenant_id = ...` in queries.  
- With RLS: PostgreSQL policies enforce that a tenant role can only access rows with its own `tenant_id`.

SaaS providers like **Exact Online** (cloud-based accounting software) serve thousands of customers. For such providers, maintaining a separate database per customer would be unmanageable. Instead, SaaS platforms typically adopt a **multi-tenant architecture**, where many customers share the same application and database, with strict access control to ensure data isolation.

---

## Key considerations
- RLS works with a **whitelisting principle**: once enabled, access is denied by default. Only rows explicitly allowed by a policy are visible or updatable.
- RLS requires **careful planning and setup**.  
- RLS policies apply **in addition** to normal table and schema privileges.  
- Be cautious with **connection pooling**: application context (e.g., current user id) must be set correctly for every session or transaction.

---

## Defining a policy

1. **Enable RLS on a table**
```sql
   ALTER TABLE customer_core ENABLE ROW LEVEL SECURITY;
```

2. ***Create a policy***
```sql
CREATE POLICY customer_self_view ON customer_core
    FOR SELECT
    TO app_user
    USING (customer_id = current_setting('app.current_user_id')::BIGINT);
```

3. ***Enforce RLS***
```sql
ALTER TABLE customer_core FORCE ROW LEVEL SECURITY;
```

## Enforcing policies during query execution

When a role queries the table, the defined RLS policy is automatically applied.

```sql
SET app.current_user_id = '55';
SELECT * FROM customer_core;
```
The app_user role only sees the row with customer_id = 55.

### Using 'SET' to pass application context

In PostgreSQL the command `SET` is normally used to change configuration parameters for a session.  
Examples include changing the time zone or enabling/disabling logging.

```sql
SET timezone = 'Europe/Amsterdam';
SET log_statement = 'all';
```
PostgreSQL also allows custom parameters, as long as they have a prefix. This is often used by applications to pass context into the database.

```sql
-- Application-specific parameter
SET app.current_user_id = '55';

-- Later in queries or policies
SELECT current_setting('app.current_user_id');
```

This mechanism makes it possible for the application to tell the database “which user is currently active”.
Row-Level Security (RLS) policies can then use these parameters to decide which rows are visible or updatable.
> Note: By convention a custom prefix like app. is used, to avoid conflicts with built-in PostgreSQL settings.

## RLS and connection pooling

When using connection pooling (e.g., PgBouncer), database sessions are **reused** for different application requests.  
If your application uses `SET app.current_user_id = ...` to pass context, then this context stays active in the database session until it is changed or reset.

⚠️ **Risk:**  
If the application forgets to execute the `SET` statement for a new request, the database may still hold the value from the *previous* request.  
This can lead to a **data leak**: the new user sees rows belonging to another user.

### Mitigations

- Always execute the `SET` immediately after a connection is checked out from the pool.  
- Use `SET LOCAL` inside a transaction so that the parameter is reset automatically when the transaction ends.  
- Configure the pool to reset session state (e.g., with `DISCARD ALL`) when a connection is returned.

  [PGBouncer Connection Sanity](https://www.pgbouncer.org/config.html#connection-sanity-checks-timeouts) *See: server_reset_query*
  
  [PGPool-II Server Configuration](https://www.pgpool.net/docs/latest/en/html/runtime-config-connection-pooling.html) *See: reset_query_list*

Prefer SET LOCAL within a transaction if your app uses a strict request-per-transaction model:

```sql
BEGIN;
SET LOCAL app.current_user_id = '55';
SELECT * FROM customer_core;
COMMIT;
```
## Case: RLS Implementation on Orders

### Goal
Implement Row-Level Security (RLS) on the orders table so that an individual customer role can only view their own orders, demonstrating the least privilege principle at the row level.

### The Task
1) User Context:
   - Create a customer role (app_customer).
   - The application passes the current ```customer_id``` through the session parameter ```app.current_customer```.
2) Implementation: Enable RLS on the orders table and create a SELECT policy that restricts the app_customer role to rows where ```customer_id``` matches the current session parameter.
3) Testing: Test the RLS implementation by assuming the app_customer role, setting the session parameter, and verifying that the visible rows are correct.

### Setup SQL Script

This script creates the table, populates it, and sets up the required role.

```sql
-- 1. Setup: Role and Table
---------------------------------------------------------------------

-- Create a 'customer' role for testing.
-- This role has no login rights; login is handled by a service account later.
CREATE ROLE app_customer NOLOGIN; 

-- Create a table for the orders
CREATE TABLE orders (
    order_id         BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    customer_id      BIGINT NOT NULL, -- Essential for RLS policies
    order_date       TIMESTAMP NOT NULL DEFAULT now(),
    total_amount     NUMERIC(10, 2)
);

-- Populate the table with sample data (three different customers)
INSERT INTO orders (customer_id, total_amount) VALUES
(101, 45.99),  -- Order by Customer 101
(102, 12.50),  -- Order by Customer 102
(101, 78.00),  -- Order by Customer 101
(103, 200.00), -- Order by Customer 103
(102, 5.00);   -- Order by Customer 102

-- Grant the role SELECT privileges (RBAC) on the entire table.
-- This is the coarse access that RLS will refine.
GRANT SELECT ON orders TO app_customer;

-- 2. Create a custom session parameter
---------------------------------------------------------------------

-- Define a custom GUC (Grand Unified Configuration) parameter with prefix 'app.'
-- This allows the application to pass the customer_id into the database session.
SET app.current_customer TO '0'; -- Set a default value
```

<details>
<summary>Click to reveal a solution</summary>

```sql
-- 1. Enable RLS on the table
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 2. Create the SELECT Policy (whitelisting principle)
-- The policy allows SELECT access to the 'app_customer' role 
-- *only* if the customer_id in the row matches the value in the session parameter.
CREATE POLICY customer_self_view ON orders
    FOR SELECT
    TO app_customer
    USING (customer_id = current_setting('app.current_customer')::BIGINT);

-- 3. Enforce RLS (Optional, but good practice for robustness)
ALTER TABLE orders FORCE ROW LEVEL SECURITY;
```

Testing and verification:

```sql

-- 1. Set the session role to the customer role
SET ROLE app_customer;

-- 2. Set the session context to Customer 101
SET LOCAL app.current_customer = '101';

-- 3. Execute a SELECT query
SELECT * FROM orders;

-- Expected Output: 2 rows (orders belonging to customer 101)
-- order_id | customer_id | order_date | total_amount
-- ---------|-------------|------------|--------------
-- 1        | 101         | ...        | 45.99
-- 3        | 101         | ...        | 78.00

-- 4. Set the session context to Customer 102 (within the same transaction)
SET LOCAL app.current_customer = '102';

-- 5. Execute another SELECT query
SELECT * FROM orders;

-- Expected Output: 2 rows (orders belonging to customer 102)
-- order_id | customer_id | order_date | total_amount
-- ---------|-------------|------------|--------------
-- 2        | 102         | ...        | 12.50
-- 5        | 102         | ...        | 5.00

```

</details>
