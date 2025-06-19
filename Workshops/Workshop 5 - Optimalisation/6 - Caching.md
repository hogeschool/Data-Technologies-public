# Caching & Connection Pooling

## Caching (TBD)
Met caching hebben we het dan over de caches in PostgreSQL:

| Cache-type         | Niveau        | Voorbeeld                              |
| ------------------ | ------------- | -------------------------------------- |
| OS page cache      | OS            | Filesystem houdt blokken in RAM        |
| shared\_buffers    | PostgreSQL    | Veelgebruikte tabellen/indexen         |
| work\_mem          | PostgreSQL    | Sorts, joins zonder tempfiles          |
| query result cache | Niet aanwezig | Alternatief: materialized view / Redis / memcached / pgpool |
| plan cache         | PostgreSQL    | Via prepared statements/functions      |


Datawarehousing. Tijdeijke data voorbewerken en opslaan in data. (ETL).



## Connection pooling (TBD)
PgPool or PgBouncer ?

PgPool heeft wel een query result cache




