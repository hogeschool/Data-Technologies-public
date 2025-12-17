# Resources for further learning

For more in depth information about PostgresSql and SQL, the following resources could help.

- [PostgreSQL installation](https://www.postgresql.org/docs/current/tutorial-install.html)
- [Aggregrate functions in SQL](https://www.postgresql.org/docs/9.4/functions-aggregate.html)
- [SELECT in SQL](https://www.postgresql.org/docs/current/sql-select.html)
- [Matching functions in SQL](https://www.postgresql.org/docs/current/functions-matching.html)
- [INSERTing data in SQL](https://www.postgresql.org/docs/current/sql-insert.html)
- [How to UPDATE data in SQL](https://www.postgresql.org/docs/current/sql-update.html)
- [How to DELETE data in SQL](https://www.postgresql.org/docs/current/sql-delete.html)
- [SQL overview in PostgreSQL](https://www.postgresql.org/docs/current/sql-commands.html)
- [PSQL commands for PostgreSQL](https://www.postgresql.org/docs/current/app-psql.html)

# Linear Interpolation

*What is Linear Interpolation?*\
Linear interpolation estimates a value between two known points by assuming a straight-line relationship.
Formula:\
\
![alt text](data/img/linear_interpolation_formula.svg "Linear interpolation")


Example
Dataset: 
```
10, 11, 12, 40
```
The position is as follows:
|Position|Value|
|--------|-----|
|0|10|
|1|11|
|2|12|
|3|40|

We want the 50th percentile (median) using PERCENTILE_CONT(0.5).

Number of elements: 4\
Position of desired percentile: 
```
(4 - 1) * 0.5 = 1.5
```
Calculation of interpolated value:
```
11 + ((1.5 − 1) × (12 − 11)) = 11 + (0.5 × 1) = 11 + 0.5 = 11.5
```
&nbsp;&nbsp;
