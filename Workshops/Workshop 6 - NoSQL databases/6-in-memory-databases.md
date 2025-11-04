# In-Memory Databases and Data Persistence

Redis is an **in-memory database**, meaning that all data is stored in **RAM (Random Access Memory)** instead of on disk.  
This makes Redis extremely fast — ideal for caching, session management, and other use cases where speed is critical.

However, because data is stored in memory, it is **not persistent by default**.  
Let’s explore what that means and how Redis handles it.

---

## What does "in-memory" mean?

Traditional databases like PostgreSQL or MySQL write every change to disk immediately.  
Redis, on the other hand, keeps all data in memory and only writes to disk if you configure it to do so.

| Characteristic | In-Memory Database | Disk-Based Database |
|----------------|--------------------|---------------------|
| Storage location | RAM | Disk / SSD |
| Access speed | Very fast (microseconds) | Slower (milliseconds) |
| Persistence | Optional | Always persistent |
| Typical use cases | Caching, sessions, temporary data | Transactions, long-term storage |

---

## Default Behavior

By default, Redis stores everything in memory.  
When the server restarts, all data is lost.

Example:
```bash
SET user:1001 "Alice"
# Restart Redis server
GET user:1001
```
→ Result: `(nil)` — the key no longer exists.

Redis behaves like a **temporary data store** unless persistence is enabled.

---

## Making Data Persistent

Redis provides two mechanisms for saving data to disk:

| Method | File | Description |
|--------|------|-------------|
| **RDB (Redis Database Backup)** | `dump.rdb` | Takes periodic snapshots of the entire dataset (e.g. every 5 minutes or after N changes). Fast to load, but data since the last snapshot may be lost. |
| **AOF (Append Only File)** | `appendonly.aof` | Logs every write operation. More durable, slightly slower. Can replay all operations to restore data. |

You can configure these in `redis.conf`, for example:

```
save 900 1
appendonly yes
appendfsync everysec
```

This setup means:
- Take a snapshot every 900 seconds (15 minutes) if at least 1 key changed.
- Keep an append-only log and sync it to disk every second.

---

## When Memory Becomes Full

Redis has a configurable **maxmemory limit**.  
When that limit is reached, it applies an **eviction policy** — old keys are removed to free up space.

### Common eviction policies

| Policy | Behavior |
|--------|-----------|
| `noeviction` | Returns an error on writes (no keys are removed). |
| `allkeys-lru` | Removes least recently used (LRU) keys from all keys. |
| `volatile-lru` | Removes LRU keys only among keys with an expiration time (TTL). |
| `allkeys-random` | Removes random keys. |
| `volatile-ttl` | Removes keys that are closest to expiration. |

To set a policy:

```bash
CONFIG SET maxmemory-policy allkeys-lru
```

---

## Example: LRU in action

```bash
SET user:1 "Alice"
SET user:2 "Bob"
SET user:3 "Charlie"
# Assume maxmemory is very small
# Redis will remove the least recently used key automatically
```

Redis keeps track of which keys were accessed most recently.  
Keys that haven’t been used for a while are removed first when memory is low.

---

## Advantages and Trade-offs

| Advantage | Trade-off |
|------------|------------|
| Extremely fast read/write performance | Data may be lost after restart if persistence is not enabled |
| Ideal for caching or temporary data | Limited by available memory |
| Supports eviction policies | Requires careful configuration for persistence |
| Optional hybrid storage (RDB + AOF) | More disk usage when persistence is enabled |

---

## When to Use an In-Memory Database

| Use case | Why Redis fits |
|-----------|----------------|
| **Caching API responses** | Very low latency and automatic expiration |
| **Session storage** | Fast read/write, can expire old sessions automatically |
| **Rate limiting / counters** | Atomic operations (`INCR`, `DECR`) in memory |
| **Message queues or pub/sub** | Real-time communication between services |

Redis can also be configured as a *hybrid system* — keeping data in memory but writing snapshots or logs to disk for recovery.

---

## Practice Questions

🧠 1. What happens to your Redis data if persistence is not enabled and the server restarts?

<details><summary>Click to reveal answer</summary>
All data is lost because Redis keeps everything in memory by default.
</details>

---

🧠 2. What is the main difference between RDB and AOF persistence?

<details><summary>Click to reveal answer</summary>
- **RDB** stores periodic snapshots of the dataset.  
- **AOF** logs every write operation for higher durability.
</details>

---

🧠 3. When memory is full, which policy removes the least recently used keys?

<details><summary>Click to reveal answer</summary>
`allkeys-lru`
</details>

---

🧠 4. Suppose Redis is used as a cache for product pages.  
Which eviction policy would be most appropriate?

<details><summary>Click to reveal answer</summary>
`allkeys-lru` — it keeps recently accessed pages and removes old ones automatically.
</details>

---

🧠 5. Enable AOF persistence and explain what happens during a crash recovery.

<details><summary>Click to reveal answer</summary>
When Redis restarts, it replays the commands from the `appendonly.aof` file in order, restoring the dataset to its last consistent state.
</details>

---

## Summary

Redis is fast because it stores data entirely in memory. By default, it is **non-persistent** — data disappears after a restart. You can enable **RDB snapshots** or **AOF logging** to persist data on disk. When memory fills up, Redis automatically evicts keys based on the configured policy (e.g. *Least Recently Used*).

This design makes Redis ideal for caching, session management, and temporary data — where **speed matters more than permanent storage**.

