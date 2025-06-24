# Caching & Connection Pooling

## Caching (TBD)
Caching is a mechanism used to speed up read and write operations between two components of a system, typically when one component (such as a database or disk) is significantly slower than the other (such as a processor or memory).

To accelerate **read operations**, previously fetched or computed data is stored in a temporary, faster storage layer called a cache. When the same data is requested again, it can be served from the cache instead of retrieving it from the slower original source.

To accelerate **write operations**, new or updated data is temporarily written to the cache first, and then written back to the original source at a later, more optimal time. This is known as write caching.

In the diagram below, two components are shown: the *Application* and the *Disk*. The running application needs to read data from and write data to the disk. To speed up these operations, a cache layer is placed between the two components. The *Cache Manager* stores previously accessed data in RAM, so that when the application requests the same data again, it can be retrieved from RAM instead of the slower disk.

```mermaid
flowchart TB
  A@{ shape: lin-cyl, label: "Disk" } <--> Cache 
  
  subgraph Cache
    direction LR
    Cache_manager["Cache Manager"] <--> RAM
  end
  
  Cache <--> Application
```



## Caching happens at different Levels
In a system caching happens at different levels. In the table below you see typical caching layers used in systems.

| **Level**              | **Example**                                    | **Purpose**                                                      |
| ---------------------- | ---------------------------------------------- | ---------------------------------------------------------------- |
| **Operating System**   | File system cache (e.g., Linux page cache)     | Reduces disk I/O by caching recently accessed file blocks in RAM |
| **Database**           | PostgreSQL shared buffers and query plan cache | Avoids repeated disk reads and parsing of SQL queries            |
| **Application**        | In-memory cache (e.g., Redis, Memcached)       | Caches frequently used query results or user sessions            |
| **Custom aggregation** | Materialized views or precomputed tables       | Stores expensive query results to be reused                      |

In this workshop we focus on caching at the Application and Custom aggregation level. 

## Caching at Application level
There are five caching strategies. The five caching strategies are:
- Cache aside (lazy loading)
- Read through
- Write through
- Write back
- Write around

Each strategy handles the following aspects in a different way:
- Populating the cache
- Keeping the cache and the database in sync
- Managing the interaction with the cache
  
### Cache aside (lazy loading)

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
```mermaid
sequenceDiagram
    participant App as Application
    participant Cache as Cache
    participant DB as Database

    App->>Cache: Write(key, value)
    Cache->>DB: Write(key, value)
```
### Write back
```mermaid
sequenceDiagram
    participant App as Application
    participant Cache as Cache
    participant DB as Database

    App->>Cache: Write(key, value)
    Note right of Cache: Mark as dirty

    Note over Cache, DB: Later (e.g., on eviction or timer)
    Cache->>DB: Write(key, value)

```
### Write around
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

## Cache Staleness and Dirty Data
### Cache Staleness
Cached data can become **stale**, meaning it is outdated, inaccurate, or no longer valid due to changes in the original data source.

There are different strategies to deal with this:

- Time-based invalidation (e.g., "invalidate after 10 minutes")
- Event-based invalidation (e.g., "invalidate if order status changes")
- Manual refresh (e.g., a scheduled job that updates materialized views)

### Diry Data
Cached data can also be **dirty**, meaning it contains changes that have not yet been written back to the original source. In this case, the original data is outdated and needs to be updated using the cache content. This requires a write-through or write-back policy to ensure consistency.

#### Write-through caching 
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




