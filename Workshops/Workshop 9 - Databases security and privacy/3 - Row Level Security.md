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

```
SET app.current_user_id = '55';
SELECT * FROM customer_core;
```
The app_user role only sees the row with customer_id = 55.

## RLS and connection pooling

With pooling, connections are reused across users. Always set the correct context when checking out a connection:
```
SET app.current_user_id = '...';
```

Prefer SET LOCAL within a transaction if your app uses a strict request-per-transaction model:

```sql
BEGIN;
SET LOCAL app.current_user_id = '55';
SELECT * FROM customer_core;
COMMIT;
```

