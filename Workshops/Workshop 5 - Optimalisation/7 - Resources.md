---
title: "Resources"
parent: "5 - Optimalisation"
nav_order: 7
---
## Resources for further learning
For more in depth information about Indexing, Materialized views, Query optimization and Caching, the following resources could help.

| Source | Vendor / Author | Summary |
|--------|-----------------|---------|
|**Indexing**|||
| [PostgreSQL Documentation – Indexes](https://www.postgresql.org/docs/current/indexes.html) | PostgreSQL Global Development Group | Official documentation covering B-tree, BRIN, GIN, GiST, and index variants (partial, covering). |
|[MySQL Documentation - Indexes](https://dev.mysql.com/doc/refman/9.4/en/mysql-indexes.html)|MySQL / Oracle| Official documentation covering how to use Indexes in MySQL.|
| [Use the Index, Luke!](https://use-the-index-luke.com) | Markus Winand | Practical online guide explaining indexing strategies, access paths, and query optimization in SQL databases. |
|**Materialized Views**|||
| [PostgreSQL Documentation – Materialized Views](https://www.postgresql.org/docs/current/rules-materializedviews.html) | PostgreSQL Global Development Group | Official documentation on creating, refreshing, and managing materialized views. |
| [Oracle Database – CREATE MATERIALIZED VIEW](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/CREATE-MATERIALIZED-VIEW.html) | Oracle | Detailed reference for materialized views in Oracle, including refresh modes (complete, fast, on commit). |
|**Partitioning**|||
| [PostgreSQL Documentation – Table Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html) | PostgreSQL Global Development Group | Official reference on partitioning methods (range, list, hash), setup, and optimizer behavior. |
| [PostgreSQL Documentation – Schemas](https://www.postgresql.org/docs/current/ddl-schemas.html) | PostgreSQL Global Development Group | Explains what schemas are, how they serve as namespaces in a database, how `CREATE SCHEMA` works, and how the search path and authorization work in PostgreSQL. |
|**MVCC**|||
| [PostgreSQL Documentation – Introduction to MVCC](https://www.postgresql.org/docs/current/mvcc-intro.html)                                                  | PostgreSQL Global Development Group | Official introduction: what MVCC is, why PostgreSQL uses it, snapshot isolation, how reads/writes do not block each other.    |
| [DevCenter Heroku – PostgreSQL Concurrency with MVCC](https://devcenter.heroku.com/articles/postgresql-concurrency)                                         | Heroku                              | A more approachable tutorial explaining MVCC in Postgres, with practical examples of how it affects concurrency.              |
| [GeeksforGeeks – MVCC in PostgreSQL](https://www.geeksforgeeks.org/postgresql/multiversion-concurrency-control-mvcc-in-postgresql/)                         | GeeksforGeeks                       | Tutorial style explanation, covers snapshots, tuple versions, visibility rules.                                               |
| [Fast Serializable Multi-Version Concurrency Control for Main-Memory Database Systems](https://15721.courses.cs.cmu.edu/spring2016/papers/p677-neumann.pdf) | Neumann, Mühlbauer, Kemper          | Academic paper: how to achieve serializable isolation with MVCC in main-memory DBs; good for students who want deeper theory. |
| [Memory-Optimized Multi-Version Concurrency Control for Disk-Based Systems](https://www.db.in.tum.de/~freitag/papers/p2797-freitag.pdf)                     | Freitag, Kemper, Neumann            | Evaluates a modern MVCC design optimized for memory/disk trade-offs; gives insight into the costs and design choices.         |
|**Caching**|||
| [Database Caching Strategies Using Redis (AWS Whitepaper)](https://docs.aws.amazon.com/whitepapers/latest/database-caching-strategies-using-redis/caching-patterns.html) | AWS / Redis | Explains cache-aside and write-through with pros/cons. |
| [Redis – Caching Solutions](https://redis.io/solutions/caching/) | Redis | Defines cache-aside, write-through, and write-behind. |
| [Azure Architecture Center – Cache-Aside Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside) | Microsoft Azure | Focuses on cache-aside (lazy loading) pattern. |
| [Amazon ElastiCache – Caching Strategies](https://docs.aws.amazon.com/AmazonElastiCache/latest/dg/Strategies.html) | AWS / ElastiCache | Covers write-through and lazy loading strategies. |
| [A Hitchhiker’s Guide to Caching Patterns](https://hazelcast.com/blog/a-hitchhikers-guide-to-caching-patterns/) | Hazelcast | Overview of cache-aside, read-through, and write-through. |
| [Top 5 Caching Strategies Explained](https://blog.algomaster.io/p/top-5-caching-strategies-explained) | Algomaster (blog) | Explicitly describes write-around strategy. |
| [A Qualitative Study of Application-Level Caching — Mertz & Nunes](https://arxiv.org/abs/2011.00242) | arXiv preprint, 2020 | Empirical study of how developers implement and maintain cache-aside patterns in real-world projects. |

> 💡 **Note:**  
> The terms *cache-aside*, *write-through*, *write-back*, and *write-around* are widely used in practice, but they are **not formally standardized**. Different vendors (AWS, Redis, Azure, Hazelcast) may use slightly different descriptions. Always specify what you mean in your own design or documentation.
