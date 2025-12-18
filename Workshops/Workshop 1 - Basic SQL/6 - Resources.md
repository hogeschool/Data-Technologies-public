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
11 + ( ((1.5 − 1) * (12 − 11)) / (2 - 1) ) =>
11 + ( (0.5 *  1) / 1) =>
11 + 0.5 = 11.5
```
# Variance

*What is Variance?*\
Variance is a statistical measure that shows how spread out the numbers in a dataset are. If all numbers are close to each other, the variance is low. If all numbers are very different from each other, the variance is high.\
\
Formula:\
\
![alt text](data/img/variance_formula.svg "Variance")

*Example 1*\
Dataset: 
```
10, 11, 12, 40
```
Calculation of the variance:

- Calculate the average of the dataset:
```
(10 + 11 + 12 + 40) / 4 = 18,25 
```

- Apply the variance formula:
```
( (10-18,25)² + (11-18,25)² + (12-18,25)² + (40-18,25)² ) / 4 =>
(68,0625 + 52,5625 + 39,0625 + 473,0625) / 4 =>
632,75 / 4 = 158,1875 
```

*Example 2*\
Dataset: 
```
10, 11, 12, 14
```
Calculation of the variance:

- Calculate the average of the dataset:
```
(10 + 11 + 12 + 14) / 4 = 11,75 
```

- Apply the variance formula:
```
( (10-11,75)² + (11-11,75)² + (12-11,75)² + (14-11,75)² ) / 4 =>
(3,0625 + 0,5625 + 0,0625 + 5,0625) / 4 =>
8,75 / 4 = 2,1875
```
# Standard deviation

*What is Standard deviation?*\
Standard deviation is a statistical measure that shows how much the numbers in a dataset deviate from the average.\
\
Formula:\
\
![alt text](data/img/standard_deviation_formula.svg "Standard deviation")

*Example 1*\
Dataset: 
```
10, 11, 12, 40
```
- Calculate the variance

```
( (10-18,25)² + (11-18,25)² + (12-18,25)² + (40-18,25)² ) / 4 = 158,1875
```

- Take the square root of the variance

```
√158,1875 => 12,577
```

*Example 2*\
Dataset: 
```
10, 11, 12, 14
```
- Calculate the variance

```
( (10-11,75)² + (11-11,75)² + (12-11,75)² + (40-11,75)² ) / 4 = 2,1875
```

- Take the square root of the variance

```
√2,1875 => 1,479
```

# Further explanation
- [Difference between standard deviation and variance](https://www.investopedia.com/ask/answers/021215/what-difference-between-standard-deviation-and-variance.asp)
- [Coefficient of Variation: Meaning, Formula and Examples](https://www.geeksforgeeks.org/data-science/coefficient-of-variation-meaning-formula-and-examples/)
