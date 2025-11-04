# NoSQL databases

Until now, we worked with databases that use a fixed schema for the data structure. In a relational SQL database, all data must conform to the defined table structure. This works well as long as the structure of the data remains stable. However, when the structure of the data varies a lot, a fixed schema can become problematic.

For example, suppose we operate a webshop that sells many different types of products — such as books, laptops, phones, and vacuum cleaners. Each product type has its own set of attributes that need to be stored in the database. 

- A book might have author, ISBN, and number_of_pages.
- A laptop might have processor, RAM, and storage_capacity.
- A vacuum cleaner might have power, bagless, and noise_level.

In a relational database, we would have to define one large table that contains all possible columns for all product types, like this:

| id | product_type | name                     | author        | ISBN           | number_of_pages | processor | RAM   | storage_capacity | power | bagless | noise_level |
| -- | ------------ | ------------------------ | ------------- | -------------- | --------------- | --------- | ----- | ---------------- | ----- | ------- | ----------- |
| 1  | book         | The Pragmatic Programmer | Hunt & Thomas | 978-0201616224 | 352             | NULL      | NULL  | NULL             | NULL  | NULL    | NULL        |
| 2  | laptop       | Dell XPS 13              | NULL          | NULL           | NULL            | Intel i7  | 16 GB | 512 GB           | NULL  | NULL    | NULL        |

This table quickly becomes hard to maintain, contains many NULL values, and must be changed every time a new product type is added.

NoSQL databases were designed to solve these problems. They allow for flexible schemas, meaning that each item (document) can have its own structure. For example, in a document-based NoSQL database like MongoDB, we could store products like this:

```json
{
  "product_type": "book",
  "name": "The Pragmatic Programmer",
  "author": "Andrew Hunt and David Thomas",
  "ISBN": "978-0201616224",
  "number_of_pages": 352
}
```

```json
{
  "product_type": "laptop",
  "name": "Dell XPS 13",
  "processor": "Intel i7",
  "RAM": { "value": 16, "unit": "GB" },
  "storage_capacity": { "value": 512, "unit": "GB", "type": "SSD" }
}
```
---
🧠 Question: How would you define the JSON structure for the vacuum cleaner?

<details>
<summary>Click to reveal the answer</summary>

```json
{
  "product_type": "vacuumcleaner",
  "name": "Dyson Pro",
  "bagless": true,
  "power": {"value": 600, "unit": "W"},
  "noise_level": {"value": 80, "unit": "dB"}
}

```
</details>

---
🧠 Question: How would you define the JSON structure for another laptop, for example a MacBook Air that includes display information?
<details> 
<summary>Click to reveal the answer</summary>

```json
{
  "product_type": "laptop",
  "name": "MacBook Air M3",
  "processor": "Apple M3",
  "RAM": { "value": 16, "unit": "GB" },
  "storage_capacity": { "value": 512, "unit": "GB", "type": "SSD" },
  "display": {
    "size": { "value": 13.6, "unit": "inch" },
    "resolution": { "width": 2560, "height": 1664 }
  }
}
```

This example shows that documents in a NoSQL database can evolve over time.
Adding a nested field like ```display``` — which contains both size and resolution — does not require changing any existing documents or schema definitions.
Other laptop documents may have different or fewer fields, and that’s perfectly valid in a document-oriented model.
</details>

---
🧠  Question: How would you define the JSON structure for a book that also includes language and edition?
<details> 

<summary>Click to reveal the answer</summary>

```json
{
  "product_type": "book",
  "name": "Clean Code",
  "author": "Robert C. Martin",
  "ISBN": "978-0132350884",
  "number_of_pages": 464,
  "language": "English",
  "edition": 2
}
```

This example shows that new fields such as language or edition can be added whenever needed — other book documents in the same collection don’t have to include them. That’s one of the main strengths of NoSQL databases: flexibility in structure without schema migrations.
</details>

---