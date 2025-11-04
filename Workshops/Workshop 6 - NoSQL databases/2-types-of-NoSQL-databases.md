# Types of NoSQL databases

NoSQL databases come in different types, each optimized for specific kinds of data and access patterns:

- *Key–value stores* are the basic type of NoSQL database. Data is stored as key–value pairs, similar to a Python dictionary or a hash map. They are extremely fast and often used for caching or session storage. Most key-value databases support different data-types for the values (string, integer, lists, etc). \
Examples: Redis, Amazon DynamoDB.

- *Document databases* store data as JSON-like documents, where each document can have its own structure. This is ideal for web applications and APIs where the data structure can vary. \
Examples: MongoDB, CouchDB.

- *Graph databases* are built to represent and query relationships between entities. They are used for social networks, recommendation systems, and network analysis. \
Examples: Neo4j, ArangoDB.

In summary, NoSQL databases provide more flexibility and scalability than traditional relational databases, especially when dealing with large volumes of semi-structured or unstructured data.

# Combining SQL and NoSQL in real systems
In real-world applications, different types of databases are often used side by side — a practice known as **polyglot persistence**.

For example, a webshop like Coolblue might use a document database for its flexible product catalog, a relational SQL database for customer data and orders (where transactions and data integrity are important), and a key–value store like Redis for caching shopping carts or user sessions.

Each database type is chosen for what it does best: relational databases provide consistency and structure, while NoSQL databases offer flexibility and scalability.
