# Access Control

## Vertical Partitioning

In an earlier workshop vertical partitioning was discussed. Then the scope was performance optimization. With vertical partitioning granting access for a specific group of people to specific data can be managed at database level. The method is to isolate senstive data in a separate table/schema with tighter privileges.

### Pattern 2 — Security boundary for PII

Place personally identifiable information (PII) in a **separate schema** with stricter privileges.

```sql
-- Create a dedicated schema for sensitive PII data, separate from the public schema
CREATE SCHEMA pii AUTHORIZATION db_admin;

CREATE TABLE pii.customer_pii (
    customer_id BIGINT PRIMARY KEY
        REFERENCES public.customer_core(customer_id) ON DELETE CASCADE,
    ssn         TEXT,
    address     TEXT
);

-- Grant minimal privileges
REVOKE ALL ON SCHEMA pii FROM app_read;
REVOKE ALL ON pii.customer_pii FROM app_read;
GRANT SELECT ON public.customer_core TO app_read;
```
>💡 Note: In this example, ```app_read``` represents an application user with limited privileges. The user can query non-sensitive data in public.customer_core, but not the PII data stored in pii.customer_pii. How to create and configure such users and roles in PostgreSQL will be covered in a separate lesson.

**Benefit:** Clear separation of duties and simplified audits.
