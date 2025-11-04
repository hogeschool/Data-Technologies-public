# Indexes in MongoDB

Indexes improve query performance by allowing MongoDB to quickly locate documents that match a query condition, rather than scanning every document in the collection.

Think of an index as a “table of contents” for your collection — it lets MongoDB jump directly to the relevant documents.

---

## The Default _id Index

Every collection automatically creates an index on the `_id` field.

```javascript
db.products.getIndexes()
```

Will give an ouput like:

```javascript
[
  { v: 2, key: { _id: 1 }, name: "_id_" }
]
```
This index ensures that every ```_id``` is unique and makes lookups by ```_id``` very fast.

## Creating a Single Field Index

You can create an index on any field to improve read performance for queries using that field.

```javascript
db.products.createIndex({ price: 1 })
```

- ```1``` = ascending order
- ```-1``` = descending order

This index helps queries like:

```javascript
db.products.find({ price: { $lt: 500 } })
```

## Compound Indexes
You can also create indexes on multiple fields. The order of the fields matters.

```javascript
db.products.createIndex({ brand: 1, price: -1 })
```

This index supports queries that use both brand and price, for example:

```javascript
db.products.find({ brand: "Apple" }).sort({ price: -1 })
```
### Why Index Field Order Matters

When you create a compound index, the order of the fields determines how MongoDB can use it for queries.
Example:

```javascript
db.products.createIndex({ brand: 1, price: -1 })
```
This index is sorted first by brand (A–Z) and, within each brand, by price (high → low).

Think of it like a phone book sorted first by last name and then by first name:
you can quickly find all people with the same last name,
but you can’t look up everyone named “John” efficiently without knowing their last name first.

**The Left-Prefix Rule**\
MongoDB follows the left-prefix rule: An index can only be used efficiently starting from its leftmost field.

So for the index ```{ brand: 1, price: -1 }```:

| Query                                                      | Can use the index? | Reason                          |
| ---------------------------------------------------------- | ------------------ | ------------------------------- |
| `db.products.find({ brand: "Apple" })`                     | ✅                  | Uses the first field (`brand`)  |
| `db.products.find({ brand: "Apple" }).sort({ price: -1 })` | ✅                  | Uses both fields                |
| `db.products.find({ price: { $gt: 500 } })`                | ❌                  | Skips the first field (`brand`) |

If you often query by price alone, you should create a separate index:

```javascript
db.products.createIndex({ price: -1 })
```

## Viewing and Dropping Indexes

List all indexes in a collection:

```javascript
db.products.getIndexes()
```

Drop an index by name:

```javascript
db.products.dropIndex("brand_1_price_-1")
```

## The Query Planner

MongoDB automatically decides whether to use an index. To see how a query is executed, use ```explain()```:

```javascript
db.products.find({ price: { $lt: 500 } }).explain("executionStats")
```

If you see ```"IXSCAN"```, the index is being used.
If you see ```"COLLSCAN"```, MongoDB is scanning the whole collection — which is slower.

## Trade-offs
Indexes are powerful, but they have costs:

| Advantage                                  | Disadvantage                                             |
| ------------------------------------------ | -------------------------------------------------------- |
| Much faster read operations                | Slightly slower writes (because indexes must be updated) |
| Enable efficient sorting and range queries | Consume extra disk space                                 |
| Allow unique constraints                   | Require careful design to match query patterns           |


# Practice Questions

🧠 1. What does MongoDB automatically index for each document?
- A) Every string field
- B) The _id field
- C) All numeric fields
- D) The price field

<details><summary>Click to reveal answer</summary> Correct: **B** </details>

\
🧠 2. Which query benefits from the following index?

```javascript
db.products.createIndex({ brand: 1, price: -1 })
```
- A) ```db.products.find({ brand: "Apple" }).sort({ price: -1 })```
- B) ```db.products.find({ price: { $gt: 500 } })```
- C) ```db.products.find({ name: "MacBook" })```
- D) None of the above
<details><summary>Click to reveal answer</summary>Correct: **A** </details>

\
🧠 3. Why can too many indexes slow down writes?

<details><summary>Click to reveal answer</summary> Because MongoDB must update every relevant index whenever a document is inserted or modified. </details>

\
🧠 4. How can you check whether a query uses an index?

<details><summary>Click to reveal answer</summary> Use `explain("executionStats")` and look for `"IXSCAN"` instead of `"COLLSCAN"`. </details>