# Caching & Connection Pooling

## Caching
Met caching hebben we het dan over de caches in PostgreSQL:

| Cache-type         | Niveau        | Voorbeeld                              |
| ------------------ | ------------- | -------------------------------------- |
| OS page cache      | OS            | Filesystem houdt blokken in RAM        |
| shared\_buffers    | PostgreSQL    | Veelgebruikte tabellen/indexen         |
| work\_mem          | PostgreSQL    | Sorts, joins zonder tempfiles          |
| query result cache | Niet aanwezig | Alternatief: materialized view / Redis / memcached / pgpool |
| plan cache         | PostgreSQL    | Via prepared statements/functions      |


## Connection pooling
PgPool or PgBouncer ?

PgPool heeft wel een query result cache




