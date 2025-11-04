# Row-Level Security (RLS)

Row-Level Security (RLS) provides **fine-grained access control** at the row level.  
It lets you define which rows of a table a role can `SELECT`, `UPDATE`, `DELETE`, or `INSERT`.  
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

