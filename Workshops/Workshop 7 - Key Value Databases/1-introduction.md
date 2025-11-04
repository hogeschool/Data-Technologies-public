# Document Databases
In the previous workshop, we discussed NoSQL databases and learned that key–value databases allow data to be stored without a fixed schema.
We also saw how a key–value store can manage flexible data structures using simple JSON documents.

In this workshop, we take a closer look at another type of NoSQL database: the document database.

Both models store data as pairs of key and value, but they differ in what the database understands about the value.

**Key-value store**\
A key–value store is the simplest type of NoSQL database: each key is unique, and the database simply stores the value that belongs to it — without knowing its internal structure. You can retrieve the value if you know the key, but you cannot query inside it.
Think of it like a large dictionary where every item has a unique identifier

Example (storing session data in a webshop):
```json
"session_14372": { "cart": ["book_134", "laptop_225"], "user_id": 872 }
``` 

**Document database**\
A document database also stores key–value pairs, but in this case the value has an internal structure that the database can interpret and query.
The document (often JSON) can contain nested objects and arrays, and you can search on those fields directly.

Example (storing product data):

```json
{
  "product_type": "laptop",
  "name": "MacBook Air M3",
  "processor": "Apple M3",
  "RAM": { "value": 16, "unit": "GB" },
  "storage_capacity": { "value": 512, "unit": "GB", "type": "SSD" }
}
```
The ability to query within documents makes document databases more expressive, while key–value stores remain extremely fast and lightweight.

### Typical use cases
| Type                  | Typical use                                  | Examples                                |
| --------------------- | -------------------------------------------- | --------------------------------------- |
| **Key–Value store**   | Caching, session storage, configuration data | Redis, Amazon DynamoDB (Key–Value mode) |
| **Document database** | Web content, user profiles, product catalogs | MongoDB, CouchDB, CosmosDB              |

---
🧠 Question:
Why do you think document databases are often built on top of key–value storage engines?
<details> <summary>Click to reveal the answer</summary>
Because both models are based on key–value pairs.
Document databases use the same idea internally, but they add an extra layer that understands and indexes the structure of the stored documents.
This allows complex queries without losing the performance benefits of a key–value store.
</details>