# Databases security and privacy

Databases often contain the most valuable asset of an organization: its data. Security and privacy are therefore essential. You don’t want stored information — especially *Personally Identifiable Information (PII)* — to be accessible to people who have no legitimate reason to use it. Beyond the direct risks, organizations must also comply with regulations such as the GDPR. Failing to do so can result not only in legal consequences but also in serious damage to public trust and reputation.

Another important aspect is the prevention of internal misuse. Databases should be designed and managed in a way that minimizes opportunities for fraud or abuse by employees with access rights.

In software development, this is often described with the principle of *defense in depth*. This means that security is not based on a single protective layer, but on multiple safeguards at different levels. If one measure fails, the next one is in place to limit the damage. Database configuration and schema design are among these critical layers of protection.

Examples of database security measures include:

- *Access control*: ensuring only authorized users and applications can access certain data.
- *Encryption*: protecting sensitive information both “at rest” (in the database files) and “in transit” (when sent over the network).
- *Auditing and monitoring*: keeping logs of database activity to detect unusual behavior or suspicious access patterns.
- *Data minimization and anonymization*: storing only what is necessary, and anonymizing data where possible to reduce exposure risks.

By combining these techniques, organizations strengthen their resilience against both external attacks and internal misuse.

**PII**\
In this workshop the term **PII** is used. This abbreviation stands for *Personally Identifiable Information* — data that can be used to identify an individual, either directly (e.g., name, social security number) or indirectly (e.g., date of birth, address, IP address).

**Schema**\
The word “schema” has two meanings:

- In data modeling, “schema” often refers to the entire structure of the database.
- In PostgreSQL, Oracle, and MS SQL, a “schema” is a namespace inside a database, used to organize objects and control privileges.

Regarding security and privacy the word "schema" can have either meaning, depending on whether we are discussing the overall database design or the namespace boundaries inside a DBMS.
