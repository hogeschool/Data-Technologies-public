# Aggregation Framework (Introductie)

## Introduction to the Aggregation Framework

The Aggregation Framework in MongoDB is a powerful tool for transforming and analyzing data within the database.

It allows you to perform operations like filtering, grouping, sorting, and calculating summary statistics — similar to SQL’s `GROUP BY` and aggregate functions.

---

## Aggregation Pipelines

An aggregation pipeline is a sequence of stages, where each stage processes the output of the previous one.

Example: Calculate the average price per brand.

```javascript
db.products.aggregate([
  { $group: { _id: "$brand", avg_price: { $avg: "$price" } } }
])
```
This aggregation pipeline consists of a single stage — the ```$group``` stage.

- The ```$group``` stage groups all documents by the value of the brand field (_id: "$brand").
- For each group, it calculates the average price using the $avg operator.
- The result is one document per brand, containing the brand name (_id) and its corresponding average price.

Example output:

```javascript
[
  { "_id": "Apple", "avg_price": 799 },
  { "_id": "Samsung", "avg_price": 699 },
  { "_id": "Dell", "avg_price": 299 }
]
```

### Common Stages
| Stage      | Description                       | Example                                                    |
| ---------- | --------------------------------- | ---------------------------------------------------------- |
| `$match`   | Filters documents (like `find()`) | `{ $match: { brand: "Apple" } }`                           |
| `$group`   | Groups documents by a field       | `{ $group: { _id: "$brand", total: { $sum: "$price" } } }` |
| `$project` | Selects or reshapes fields        | `{ $project: { name: 1, brand: 1, price: 1 } }`            |
| `$sort`    | Sorts documents                   | `{ $sort: { price: -1 } }`                                 |
| `$limit`   | Limits the number of results      | `{ $limit: 5 }`                                            |

You can chain these stages together to perform complex analyses.

**Example: Top 3 most expensive products per brand**
```javascript
db.products.aggregate([
  { $sort: { brand: 1, price: -1 } },
  { $group: {
      _id: "$brand",
      top_products: { $push: { name: "$name", price: "$price" } }
  }},
  { $project: {
      _id: 1,
      top_3: { $slice: ["$top_products", 3] }
  }}
])
```

This aggregation pipeline consists of three stages:
- ```$sort``` — Sorts all products first by brand in ascending order (A–Z),
and then within each brand by price in descending order (highest first).
- ```$group``` — Groups the sorted documents by brand.
For each brand, it builds an array called top_products that contains
the name and price of every product in that brand, in the sorted order.
- ```$project``` — Reshapes the output from the previous stage.
It creates a new field top_3, which contains only the first three products
from the top_products array using the $slice operator.
As a result, you get one document per brand, each containing its three most expensive products.

## Practice Questions
🧠 1. Which aggregation stage is similar to WHERE in SQL?
- A) $group
- B) $match
- C) $sort
- D) $project
<details><summary>Click to reveal answer</summary> ✅ Correct: **B** </details>

\
🧠 2. What does $group do in an aggregation pipeline?
<details><summary>Click to reveal answer</summary> It groups documents by a field and allows you to calculate aggregated values like `$sum`, `$avg`, or `$count`. </details>

\
🧠 3. Write an aggregation query that counts the number of products per brand.
<details><summary>Click to reveal example solution</summary>
db.products.aggregate([
  { $group: { _id: "$brand", count: { $count: {} } } }
])
</details>