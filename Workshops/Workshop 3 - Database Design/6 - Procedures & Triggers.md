# Stored Procedures & Triggers

Databases are the backbone of modern applications, and managing them efficiently is crucial. **Stored procedures** and **triggers** are powerful tools that help automate tasks, enforce business rules, and optimize performance.

## Why use them?

Imagine a scenario where a banking system needs to transfer funds between accounts. Without stored procedures, the application would need to send multiple queries to the database, increasing network traffic and reducing efficiency. With a stored procedure, the entire transaction can be handled within the database, ensuring atomicity and reducing errors.

Similarly, triggers can automatically log changes to a table, ensuring that every modification is recorded without requiring manual intervention.

- **Performance Optimization:**
  - Stored procedures reduce network traffic by executing logic on the server rather than sending multiple queries from the client.
  - Triggers automate tasks, reducing manual intervention and improving efficiency.

- **Code Reusability & Maintainability:**
  - Encapsulating logic in stored procedures makes code easier to manage and reuse across applications.
  - Triggers ensure consistency by enforcing rules automatically.

- **Security & Data Integrity:**
  - Stored procedures can restrict direct access to tables, enhancing security.
  - Triggers prevent invalid data modifications and enforce business rules.

&nbsp;

## Stored Procedures

Stored procedures offer a structured and reusable way to execute multiple SQL statements. They enable advanced control structures and complex calculations, facilitating the development of intricate applications directly within the database. By default, PostgreSQL supports three primary procedural languages: `SQL`, `PL/pgSQL`, and `C`. Stored procedures in PostgreSQL are created using the `CREATE PROCEDURE` statement.

```sql
CREATE PROCEDURE procedure_name (param1 datatype, param2 datatype)
LANGUAGE plpgsql
AS $$
BEGIN
    -- SQL statements
END;
$$;
```

### Simple

Imagine a company wants to automate employee registration. Instead of manually inserting records, a stored procedure can handle the process efficiently.

```sql
CREATE PROCEDURE add_employee(IN emp_name TEXT, IN emp_salary NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employees (name, salary) VALUES (emp_name, emp_salary);
END;
$$;
```

### Calling a stored procedure

```sql
CALL add_employee('John Doe', 50000);
```

### Advanced

Consider a fund transfer system where money is moved between accounts. This stored procedure ensures that both debit and credit operations occur **within a single transaction**.

```sql
CREATE PROCEDURE transfer_funds(IN sender_id INT, IN receiver_id INT, IN amount NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN TRANSACTION;
    UPDATE accounts SET balance = balance - amount WHERE id = sender_id;
    UPDATE accounts SET balance = balance + amount WHERE id = receiver_id;
    COMMIT;
END;
$$;
```

#### Conditionals

A balance check procedure ensures that users are notified when their balance is low.

```sql
CREATE PROCEDURE check_balance(IN user_id INT, OUT balance NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT account_balance INTO balance FROM accounts WHERE id = user_id;
    IF balance < 100 THEN
        RAISE NOTICE 'Low balance warning!';
    END IF;
END;
$$;
```

#### Loops & Cursors

A procedure to list all employees can iterate through records using a loop.

```sql
CREATE PROCEDURE list_employees()
LANGUAGE plpgsql
AS $$
DECLARE
    emp RECORD;
BEGIN
    FOR emp IN SELECT * FROM employees LOOP
        RAISE NOTICE 'Employee: %, Salary: %', emp.name, emp.salary;
    END LOOP;
END;
$$;
```

&nbsp;

## Triggers

A PostgreSQL trigger is a robust mechanism that automatically executes a function in response to specific events on a table, such as `INSERT`, `UPDATE`, `DELETE`, or `TRUNCATE`. By enforcing data integrity and streamlining complex database operations, triggers enhance efficiency and reliability. Triggers are created using the `CREATE TRIGGER` statement.

```sql
CREATE TRIGGER trigger_name
AFTER INSERT OR UPDATE OR DELETE
ON table_name
FOR EACH ROW
EXECUTE FUNCTION function_name();
```

A trigger is a specialized user-defined function linked to a table. To create one, you first define a trigger function and then associate it with the table. Unlike regular user-defined functions, triggers activate automatically in response to specific events.

### Types

A trigger can be set on a **row-level** and a **statement-level**:

- **Row-level** triggers are executed **once per effected row**.
- **Statement-level** triggers are execetued **once per SQL statement**.

### Timings

Triggers come in three different timings:

- `BEFORE` triggers: execute before the event occurs;
- `AFTER` triggers: execute after the evnent occurs;
- `INSTEAD OF` triggers: Used for views to override default behavior.

&nbsp;

Imagine a company wants to track changes to employee records. A trigger can automatically log modifications.

```sql
CREATE FUNCTION log_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, timestamp)
    VALUES (TG_TABLE_NAME, TG_OP, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON employees
FOR EACH ROW
EXECUTE FUNCTION log_changes();
```

&nbsp;

### Advanced examples

In many situations you want to audit what an employee does. A trigger is an excellent tool for this. 

```sql
CREATE FUNCTION audit_employee_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employee_audit (emp_id, change_type, change_time)
    VALUES (NEW.id, TG_OP, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER employee_audit_trigger
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION audit_employee_changes();
```

The above trigger will fire on every `UPDATE` event on the `employees` table. It will then store audit information (`emp_id`, `change_type`, `change_time`) into the `employee_audit` table. This can help to pinpoint who changed data on who in a later moment. 

&nbsp;

We can also create a trigger to prevent something from happening. For example, we do not want any employee to have a negative salary. To make sure this is not possible we can create the following trigger:

```sql
CREATE FUNCTION prevent_negative_salary()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary < 0 THEN
        RAISE EXCEPTION 'Salary cannot be negative!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER salary_check_trigger
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_salary();
```

This trigger will check if the `salary` on the `NEW` record (`NEW.salary`) is not below `0`. If it is, we `RAISE` an `EXCEPTION`, if not we just return the `NEW` record. This trigger is listening `BEFORE INSERT OR UPDATE` on the `employees` table and is triggered `FOR EACH ROW`.

&nbsp;

## Best practices

- Avoid unnecessary triggers that slow down operations.
- Optimize stored procedures by minimizing redundant queries.
- Restrict privileges to prevent unauthorized execution.
- Use logging and debugging techniques to track errors.
- Avoid recursive triggers that cause inifite loops.
- Ensure stored procedures handle executions properly.

&nbsp;
&nbsp;