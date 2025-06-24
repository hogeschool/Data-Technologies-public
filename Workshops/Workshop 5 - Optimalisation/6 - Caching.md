# Caching & Connection Pooling

## Caching (TBD)
Caching is a mechanism used to speed up **read operations** between two components of a system, typically when one component (such as a database or disk) is significantly slower than the other (such as a processor or memory).

To accelerate **read operations**, previously fetched or computed data is stored in a temporary, faster storage layer called a cache. When the same data is requested again, it can be served from the cache instead of retrieving it from the slower original source.

In the diagram below, two components are shown: the *Application* and the *Disk*. The running application needs to read data from the disk. To speed up these read operations, a cache layer is placed between the two components. The *Cache Manager* stores previously accessed data in RAM, so that when the application requests the same data again, it can be retrieved from RAM instead of the slower disk.

```mermaid
flowchart TB
  A@{ shape: lin-cyl, label: "Disk" } <--> Cache 
  
  subgraph Cache
    direction LR
    Cache_manager["Cache Manager"] <--> RAM
  end
  
  Cache <--> Application
```
> **Write caching note:**
> Some caching strategies also involve storing writes in the cache. *Write-back caching* improves write performance by temporarily storing data in fast memory before writing it to the slower source at a later time. This strategy will be covered later in this workshop.




## Caching happens at different Levels
In a system caching happens at different levels. In the table below you see typical caching layers used in systems.

| **Level**              | **Example**                                    | **Purpose**                                                      |
| ---------------------- | ---------------------------------------------- | ---------------------------------------------------------------- |
| **Operating System**   | File system cache (e.g., Linux page cache)     | Reduces disk I/O by caching recently accessed file blocks in RAM |
| **Database**           | PostgreSQL shared buffers and query plan cache | Avoids repeated disk reads and parsing of SQL queries            |
| **Application**        | In-memory cache (e.g., Redis, Memcached)       | Caches frequently used query results or user sessions            |
| **Custom aggregation** | Materialized views or precomputed tables       | Stores expensive query results to be reused                      |

In this workshop we focus on caching at the Application and Custom aggregation level. 

## Stale Data and Dirty Data
The concepts **stale data** and **dirty data** are commonly used when discussing caching behavior.
They describe different types of inconsistencies that can occur between the cache and the original data source.

### Stale Data
Cached data can become **stale**, meaning it is outdated, inaccurate, or no longer valid due to changes in the original data source.

> 🔎 **Example:**  
> A customer profile is cached. Later, the customer updates their address.  
> The database is correct, but the cache still returns the old address. 
> This is an example of **stale data**.

There are different strategies to deal with this:

- Time-based invalidation (e.g., "invalidate after 10 minutes")
- Event-based invalidation (e.g., "invalidate if order status changes")
- Manual refresh (e.g., a scheduled job that updates materialized views)

### Dirty Data
Cached data can also be **dirty**, meaning it contains changes that have not yet been written back to the original source. In this case, the original data is outdated and needs to be updated using the cache content.

> 🔎 **Example:**  
> A product’s price is updated in the cache, but not yet written to the database.  
> If another system reads the database directly, it will still see the old price.  
> This is an example of **dirty data**.


## Caching at Application level
There are five caching strategies. The five caching strategies are:
- Cache aside (lazy loading)
- Read through
- Write through
- Write back
- Write around

Each strategy handles the following aspects in a different way:
- Populating the cache
- How to deal with Stale and Dirty Data
- Managing the interaction with the cache
  
### Cache aside (lazy loading)
In this caching strategy, the **application itself controls access to the cache**. When reading data, the application first checks the cache. If the data is not found (a cache miss), it retrieves the data from the database and stores it in the cache for future use. When writing data, the application **writes directly to the database** and may explicitly invalidate or update the corresponding cache entry.

Cache-aside is a flexible strategy, giving the application full control over how and when the cache is used.  
It is also known as *lazy loading*, because the cache is only populated when needed. Cache-aside defines **both a read and a write strategy** — no additional strategy needs to be combined with it.

The name *cache-aside* refers to the fact that the cache sits “off to the side”, and the application decides when to access or update it.

```mermaid
sequenceDiagram
    title Cache-aside strategy (Read)

    participant App as Application
    participant Cache as Cache
    participant DB as Database

    App->>Cache: Read(key)
    alt Cache miss
        App->>DB: Read(key)
        DB-->>App: Value
        App->>Cache: Write(key, value)
    else Cache hit
        Cache-->>App: Value
    end
```
```mermaid
sequenceDiagram
    title Cache-aside strategy (Write)

    participant App as Application
    participant DB as Database
    participant Cache as Cache

    App->>DB: Write(key, value)
    App->>Cache: Invalidate(key)
```


### Read through
In this caching strategy, **the cache itself is responsible for loading data from the original data source** when a cache miss occurs. The application only reads from the cache — it does not need to know whether the data was already cached or not. If a requested key is not found in the cache, the cache transparently fetches it from the backing store and stores the result for future use.

Read-through is a **read strategy only**, and must be combined with a **separate write strategy** to handle how data updates are propagated to the backing store.

The term *read-through* refers to the idea that the cache “reads through” to the underlying data source if it doesn’t already have the data.

```mermaid
sequenceDiagram
    participant App as Application
    participant Cache as Cache
    participant DB as Database

    App->>Cache: Read(key)
    alt Cache miss
        Cache->>DB: Read(key)
        DB-->>Cache: Value
        Cache-->>App: Value
    else Cache hit
        Cache-->>App: Value
    end
```

Only read-strategy. Must be combined with a write strategy (usally write-through or write-back).

### Write through
In this caching strategy, **write operations are sent to both the cache and the original data source simultaneously**. This ensures that the cache always remains consistent with the backing store. Although this approach guarantees strong consistency, it does **not improve write performance**, because the write operation is only considered complete after it has been persisted in the database.

Write-through is a **write strategy only**, and must be combined with a separate **read strategy** (such as read-through or cache-aside) to handle data retrieval.

The name *write-through* indicates that each write operation passes “through” the cache and directly reaches the backing store as well.

```mermaid
sequenceDiagram
    participant App as Application
    participant Cache as Cache
    participant DB as Database

    App->>Cache: Write(key, value)
    Cache->>DB: Write(key, value)
```
### Write back
In this caching strategy, **write operations are optimized** by temporarily storing changes in the cache and deferring writes to the original data source. Multiple write operations can be **bundled into a single write**, reducing the number of write actions to the (slower) backing store.
 
Write-back is a **write strategy only**, and must be combined with a separate **read strategy** to define how data is retrieved from the cache. For example, it is commonly used alongside a cache-aside or read-through read strategy.

In write-back caching, “back” refers to the delayed action of writing data back to the original data source — not to the user or front-end, but to the persistent backing store (e.g., a database or disk). 

```mermaid
sequenceDiagram
    title Write-back strategy with multiple writes

    participant App as Application
    participant Cache as Cache
    participant DB as Database

    App->>Cache: Write(key1, value1)
    Note right of Cache: key1 marked as dirty

    App->>Cache: Write(key2, value2)
    Note right of Cache: key2 marked as dirty

    App->>Cache: Write(key1, value3)
    Note right of Cache: key1 updated again

    Note over Cache, DB: Later (on flush or eviction)
    Cache->>DB: Write(key1, value3), Write(key2, value2)
    Note right of DB: Writes are combined and delayed

```
### Write around

In write-around caching, the write path bypasses the cache entirely, writing only to the database.
However, the read path follows a cache-aside pattern: the application checks the cache first, and on a miss, retrieves data from the database and stores it in the cache. As a result, the cache will eventually be populated — but it may contain stale data if older values remain in the cache after updates. 

The term "write-around" refers to the fact that write operations deliberately bypass the cache and go straight to the database. This prevents infrequently read data from polluting the cache.

```mermaid
sequenceDiagram
    title Write-around strategy (Read)

    participant App as Application
    participant Cache as Cache
    participant DB as Database

    App->>Cache: Read(key)
    alt Cache miss
        App->>DB: Read(key)
        DB-->>App: Value
        App->>Cache: Write(key, value)
    else Cache hit
        Cache-->>App: Value
    end
```

```mermaid
sequenceDiagram
    title Write-around strategy (Write)

    participant App as Application
    participant DB as Database

    App->>DB: Write(key, value)
```



#### TBD Write-through caching 
> **TBD:** Write-through and write-back define how writes are handled between the cache and the backing store. Cache population, on the other hand, is managed through separate strategies like write-allocate and read-allocate.

With write-through caching, every time data is written to the cache, it is also immediately written to the original data source (e.g., disk or database).

Pros:
- The cache and the data source are always consistent.
- No data is lost if the system crashes.
  
Cons:
- Slower write performance, because every write involves the slower backing store.

Analogy: It’s like writing a document and immediately saving it to a USB drive after every single keystroke.
```mermaid
sequenceDiagram
    participant App as Application
    participant Cache as Cache
    participant DB as Disk / Database

    App->>Cache: Write(data)
    Cache->>DB: Write(data)
    Note right of DB: Data is immediately written
```

#### Write-back caching
With write-back caching, data is initially written only to the cache. The write to the original source happens later, either on a schedule or when the cache entry is evicted.

Pros:
- Faster write performance, since writes happen in fast memory (RAM).
- Multiple writes can be combined into a single update to the source.
  
Cons:
- Risk of data loss if the system crashes before changes are written back.
- Cache and source can temporarily be inconsistent (dirty data).

Analogy: It’s like writing in a notebook and only saving the contents to a USB drive when you're done or taking a break.

```mermaid
sequenceDiagram
    participant App as Application
    participant Cache as Cache
    participant DB as Disk / Database

    App->>Cache: Write(data)
    Note right of Cache: Data is now marked as dirty

    Note over Cache, DB: Later...
    Cache->>DB: Write(data)
    Note right of DB: Data is written back from cache
```

## Connection pooling (TBD)
PgPool or PgBouncer ?

PgPool heeft wel een query result cache




