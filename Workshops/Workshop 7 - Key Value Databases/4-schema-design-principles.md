# Designing Document Structures in MongoDB

Designing a good document structure in MongoDB is often the most challenging part of working with a document database.
Unlike relational databases, MongoDB gives you full freedom to decide how to group or split your data.
This flexibility is powerful, but it also means that you must think carefully about how your application will read and update documents.

## Model Data Around How It’s Used

In a document database like MongoDB, schema design is driven by the queries you run, not by strict normalization rules.
You should combine data that is frequently accessed together, and separate data that changes independently.

*Example combing data:*\
Instead of having two collections, customers and addresses, you can embed the addresses directly in the customer document:

```javascript
{
  name: "Alice",
  email: "alice@example.com",
  addresses: [
    { street: "Main St 12", city: "Rotterdam" },
    { street: "Market Sq 8", city: "Delft" }
  ]
}
```
This makes reads faster and avoids joins, since everything you need is stored in one document.

*Example seperating data:*\
Instead of embedding reviews directly in a product document, you can store them in a separate reviews collection and reference the product by its _id.
```javascript

// products
{
  _id: ObjectId("507f1f77bcf86cd799439011"),
  name: "Noise-Cancelling Headphones",
  brand: "QuietSound"
}

// reviews
{
  _id: ObjectId("507f191e810c19729de860ea"),
  product_id: ObjectId("507f1f77bcf86cd799439011"),
  rating: 5,
  comment: "Excellent sound quality!",
  user: "alice@example.com"
}
```
This approach is useful when:

- Reviews grow independently from the product.
- Reviews need to be queried or analyzed across multiple products.
- You want to avoid bloating the product document with large arrays.



## Embed vs. Reference
A key design decision in MongoDB is whether to embed data or reference it.
| Strategy      | When to use                                                               | Example                                                              |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **Embed**     | The related data is tightly coupled and usually read or written together. | A news-article with embedded comments, a customer with embedded addresses. |
| **Reference** | The related data is shared, reused, or grows independently.               | A product referencing a supplier by `supplier_id`.                   |

Embed what you access together. Reference what you reuse.

## Avoid Deep Nesting
MongoDB supports up to 100 levels of nesting, but deeply nested structures can make queries and updates complex and inefficient.
Keep nesting shallow and meaningful — usually one or two levels is enough.


## Design for Growth and Change
MongoDB’s flexibility allows new fields to be added at any time, but it’s important to design with scalability in mind:

- Be aware that large arrays (e.g., orders: []) can become performance bottlenecks.
- Consider splitting data into separate collections if arrays grow indefinitely.
- Use consistent field names and data types to simplify queries and indexing.

## Pre-Aggregate When Useful
Because documents are stored atomically, it is often efficient to include derived fields that summarize data.
For example, storing a ```total_price``` or ```last_updated``` value in a document can make reads faster.
This is a trade-off between read performance and update complexity — pre-aggregated values must be kept in sync.

# Excercises

🧠 Exercise 1

Use Case\
A garage wants to keep track of cars and their maintenance history.
Each car has a make, model, year, and a list of performed maintenance tasks (e.g., oil change, tire rotation).
The garage usually retrieves the full car record including its maintenance history in one query.

Question\
How would you design a MongoDB document structure for this use case?
Should the maintenance records be embedded or referenced?

<details> <summary>Click to reveal the example solution</summary>
Because the maintenance history always belongs to one car and is retrieved together, embedding is the best approach.

```javascript
{
  _id: ObjectId("..."),
  license_plate: "AB-123-C",
  make: "Toyota",
  model: "Prius",
  year: 2025,
  maintenance: [
    {
      date: ISODate("2024-04-15"),
      type: "Oil change",
      cost: 120
    },
    {
      date: ISODate("2024-10-10"),
      type: "Brake pads replaced",
      cost: 280
    }
  ]
}
```
</details>

\
🧠 Exercise 2

Use Case\
The garage chain has multiple locations.
Each maintenance job can be linked to a mechanic, a garage location, and may include parts that are reused across many jobs.
The company wants to analyze maintenance data across all cars.

Question\
How would you design the schema if maintenance records need to be queried independently from the cars?

<details> <summary>Click to reveal the example solution</summary>


```javascript

//cars 
{
  _id: ObjectId(22),
  license_plate: "AB-123-C",
  make: "Toyota",
  model: "Prius",
  year: 2025,
}

// maintenance
{
    car_id: ObjectId(22),
    date: ISODate("2024-04-15"),
    type: "Oil change",
    cost: 120,
    location_id: ObjectId(33),
    mechanic_id: ObjectId(450),
    parts: [ObjectId(2)]
}
{
    car_id: ObjectId(22),  
    date: ISODate("2024-10-10"),
    type: "Brake pads replaced",
    cost: 280,
    location_id: ObjectId(33),
    mechanic_id: ObjectId(453),
    parts: [ObjectId(33), ObjectId(20)]
}
```

Each maintenance document references the car, mechanic, and location by their ObjectIds.
This allows the company to perform cross-collection analytics and reuse part information.

</details>

\
🧠 Exercise 3

Use Case\
The company wants both quick lookups per car and global analytics on all maintenance jobs.

Each car record should include recent maintenance tasks (for quick reads), but older tasks are archived in a separate collection.

Question
How can you combine embedding and referencing for an efficient and scalable schema?

<details> <summary>Click to reveal the example solution</summary>


```javascript

// cars
  _id: ObjectId(22),
  license_plate: "AB-123-C",
  make: "Toyota",
  model: "Prius",
  year: 2025,
  recent_maintenance: [
    {date: ISODate("2025-10-30"),
      type: "Tire change",
      cost: 120,
      location_id: ObjectId(33),
      mechanic_id: ObjectId(450),
      parts: [ObjectId(195), ObjectId(198)]
    }
  ]
}

// maintenance_archive
{
    car_id: ObjectId(22),
    date: ISODate("2024-04-15"),
    type: "Oil change",
    cost: 120,
    location_id: ObjectId(33),
    mechanic_id: ObjectId(450),
    parts: [ObjectId(2)]
}
{
    car_id: ObjectId(22),  
    date: ISODate("2024-10-10"),
    type: "Brake pads replaced",
    cost: 280,
    location_id: ObjectId(33),
    mechanic_id: ObjectId(453),
    parts: [ObjectId(33), ObjectId(20)]
}
```

Recent data is fast to access (embedded); older data is kept lightweight and queryable (separate collection).

This pattern is often called the **Subset Pattern**.
</details>

## Common Schema Design Patterns

There are many best-practice approaches to schema design. These are known as schema design patterns. In the exercises above, we covered the following:

Pattern|Description | When to Use |Example|
|------|------------|-------------|------------------ |
| **1. Embedding Pattern**|Store related data inside a single document as nested objects or arrays.| When related data is always accessed together and updates are atomic.|A customer document with an array of embedded addresses or maintenance jobs.|
| **2. Reference Pattern**|Store related data in separate collections and link them via `_id` references.|When data is shared, reused, or grows independently.|A maintenance record referencing `car_id`, `mechanic_id`, and `location_id`.                |
| **3. Subset Pattern**|Embed only the most recent or most relevant subset of related data; archive the rest elsewhere.|When you want fast reads for recent data and scalability for large histories.|A car document with a few recent maintenance jobs, and older jobs in `maintenance_archive`.|

Besides the patterns listed above, there are also other useful approaches such as:

Pattern|Description | When to Use |Example|
|------|------------|-------------|------------------ |
| **4. Extended Reference Pattern** | Include a few duplicated fields from the referenced document for faster reads.                  | When you want to avoid extra queries but still normalize most of the data.       | A maintenance record that stores `car_make` and `car_model` along with `car_id`.            |
| **5. Bucket Pattern**             | Group multiple smaller, similar records into one document.                                      | When many small events share the same context or time window.                    | Storing all temperature sensor readings for one day in a single “bucket” document.          |

For more schema design patterns and examples, see the official MongoDB documentation:

- [Schema Design Patterns (MongoDB Manual)](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/)
- [Building with Patterns (MongoDB Blog Series)](https://www.mongodb.com/company/blog/building-with-patterns-a-summary)




