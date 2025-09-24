# Row-Level Security (RLS)

Row-Level Security (RLS) provides **fine-grained access control** at the row level.  
It lets you define which rows of a table a role can `SELECT`, `UPDATE`, `DELETE`, or `INSERT`.  
RLS is especially useful in multi-tenant apps or self-service portals where users should only see or modify *their own* data.

---

## Key considerations

- RLS requires **careful planning and setup**.  
- Policies must be defined explicitly; once RLS is enabled, access is denied unless a policy allows it.  
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

