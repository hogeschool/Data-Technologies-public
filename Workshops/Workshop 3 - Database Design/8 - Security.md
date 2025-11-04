# Database Security & Access Control

Databases store critical information, including personal data, financial records, and business intelligence. Without proper security measures, organizations risk data breaches, unauthorized access, and compliance violations.


**Common threats**
Below are the most common threats on database systems:

- **Unauthorized Access** – Attackers or insiders gaining access to sensitive data.
- **SQL Injection** – Malicious queries that manipulate database operations.
- **Data Leakage** – Accidental exposure of confidential information.
- **Privilege Abuse** – Users with excessive permissions misusing their access.
- **Denial-of-Service (DoS) Attacks** – Overloading the database to disrupt operations.

PostgreSQL provides robust security mechanisms to mitigate these threats, including role-based access control (RBAC), encryption, and auditing

&nbsp;

## Authentication & Authorization

Authentication and authorization are the first line of defense in database security. They ensure that only verified users can access the database and that they have the appropriate permissions.

### Authentication

Authentication ensures that users prove their identity before accessing the database. Common methods include:

- **Username & Password** – Basic authentication method.
- **Multi-Factor Authentication (MFA)** – Requires additional verification (e.g., SMS code, biometric scan).
- **OAuth & SSO (Single Sign-On)** – Centralized authentication for multiple applications.

&nbsp;

### Authorization

Authorization determines what actions a user can perform. PostgreSQL uses role-based access control (RBAC) to manage permissions.

#### Granting permissions

```sql
GRANT SELECT, INSERT ON employees TO hr_manager;
```

This command allows the hr_manager role to view and add records in the employees table.

#### Revoking permissions

```sql
REVOKE INSERT ON employees FROM hr_manager;
```

This removes the ability to insert records from the hr_manager role.

&nbsp;

## Role-Based Access Control (RABC)

RBAC ensures that users only have access to the data they need. It prevents unauthorized modifications and reduces security risks.

### Creating roles

```sql
CREATE ROLE analyst WITH LOGIN PASSWORD 'securepass';
```

This creates a new role named `analyst` with login access.

### Assigning privileges

```sql
GRANT SELECT ON sales TO analyst;
```

This allows the `analyst` role to **view** the `sales` table but not modify it.

### Default roles

PostgreSQL provides default roles for managing security:

- `pg_read_all_data` – Allows read access to all tables.
- `pg_write_all_data` – Allows write access to all tables.
- `pg_monitor` – Grants monitoring privileges.

&nbsp;

## Encryption & Secure Data Storage

Encryption protects data at rest (stored in the database) and in transit (during communication). PostgreSQL supports various encryption techniques.

### Encrypting data

PostgreSQL provides column-level encryption using the `pgcrypto` extension.

```sql
SELECT pgp_sym_encrypt('Sensitive Data', 'encryption_key');
```

This encrypts the text `"Sensitive Data"` using the key `"encryption_key"`.

### Decrypting data

```sql
SELECT pgp_sym_decrypt(encrypted_column, 'encryption_key');
```

This retrieves the original data from an encrypted column.

### Securing connections

To encrypt data in transit, PostgreSQL supports SSL/TLS:

```sql
ALTER SYSTEM SET ssl = 'on';
```

This enables **secure connections** between clients and the database.

&nbsp;

## Auditing & Monitoring

Auditing helps track who accessed the database, what changes were made, and when. Monitoring ensures real-time security.

### Logging activity

PostgreSQL logs queries, authentication attempts, and errors:

```sql
ALTER SYSTEM SET log_statement = 'all';
```

This logs **all SQL statements** executed in the database.

### Tracking unauthorized accesss

To detect suspicious activity, PostgreSQL provides event triggers:

```sql
CREATE EVENT TRIGGER unauthorized_access
ON ddl_command_end
EXECUTE FUNCTION log_unauthorized_access();
```

This trigger logs unauthorized schema changes.

&nbsp;

## Best practices

Implementing best practices ensures long-term security and compliance.

- **Use Strong Passwords** – Enforce complex passwords for all users.
- **Limit Privileges** – Follow the principle of least privilege (POLP).
- **Enable Encryption** – Protect sensitive data with pgcrypto and SSL.
- **Regularly Audit Access Logs** – Monitor user activity for anomalies.
- **Apply Security Patches** – Keep PostgreSQL updated to prevent vulnerabilities.

&nbsp;
&nbsp;
