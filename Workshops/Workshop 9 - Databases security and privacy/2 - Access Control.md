# Access Control

## Vertical Partitioning

In an earlier workshop vertical partitioning was discussed in the context of performance optimization. In this workshop we look at the same concept from a security perspective. By applying vertical partitioning, access for a specific group of people to specific data can be managed at the database level. The method is to isolate sensitive data in a separate table or schema with tighter privileges.

### What is a database schema?
A schema is a logical container inside a database. It groups together related database objects such as tables, views, and functions. You can think of it as a namespace or folder within the database:

- It helps organize data and avoid name conflicts (two tables with the same name can exist in different schemas).
- It provides a security boundary, because you can assign privileges at the schema level.
- It allows you to separate sensitive data (e.g., PII) from non-sensitive data, making access control more transparent.

### Security boundary for PII

Place personally identifiable information (PII) in a **separate schema** with stricter privileges.

```sql
-- Create a dedicated schema for sensitive PII data, separate from the public schema
CREATE SCHEMA pii AUTHORIZATION db_admin;

CREATE TABLE pii.customer_pii (
    customer_id BIGINT PRIMARY KEY
        REFERENCES public.customer_core(customer_id) ON DELETE CASCADE,
    social_security_number         TEXT,
    address     TEXT
);

-- Grant minimal privileges
REVOKE ALL ON SCHEMA pii FROM app_read;
REVOKE ALL ON pii.customer_pii FROM app_read;
GRANT SELECT ON public.customer_core TO app_read;
```
>💡 Note: In this example, ```app_read``` represents an application user with limited privileges. The user can query non-sensitive data in public.customer_core, but not the PII data stored in pii.customer_pii. How to create and configure such users and roles in PostgreSQL will be covered in a separate lesson.

**Benefit:** Clear separation of duties and simplified audits.
