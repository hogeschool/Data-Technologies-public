---
title: "Resources"
parent: "6 - NoSQL databases"
nav_order: 8
---
# Further Learning Resources

This final section provides a list of recommended online resources to deepen your understanding of **Redis** and its common use cases.  
All links point to official documentation or trusted learning platforms.

---

## 🔹 General Redis Overview

| Topic | Resource | Description |
|--------|-----------|-------------|
| Official Redis documentation | [Redis.io – Overview](https://redis.io/docs/latest/) | The main entry point for Redis concepts, data types, and commands. |
| Redis data types explained | [Redis Data Types](https://redis.io/docs/latest/develop/data-types/) | Official guide explaining strings, lists, sets, hashes, and sorted sets. |
| OneCompiler | [OneCompiler for Redis](https://onecompiler.com/redis) | Run Redis commands directly in your browser. |

---

## 🔹 Working with Key–Value Data

| Topic | Resource | Description |
|--------|-----------|-------------|
| Basic key management | [Keys Commands](https://redis.io/docs/latest/commands/keys/) | Lists all commands for managing keys and inspecting data. |
| Strings and simple values | [String Commands](https://redis.io/docs/latest/commands#set) | Overview of `SET`, `GET`, and numeric commands like `INCR`. |
| Hashes | [Hash Commands](https://redis.io/docs/latest/commands#hash) | Learn how to structure JSON-like objects using `HSET`, `HGET`, and `HDEL`. |

---

## 🔹 Working with Sets

| Topic | Resource | Description |
|--------|-----------|-------------|
| Introduction to sets | [Redis Sets Documentation](https://redis.io/docs/latest/develop/data-types/sets/) | How to store and query unique, unordered collections. |
| Set commands | [Set Commands List](https://redis.io/docs/latest/commands#set) | Full command reference, including `SADD`, `SINTER`, `SUNION`, and `SDIFF`. |

---

## 🔹 Numeric and Expiring Keys

| Topic | Resource | Description |
|--------|-----------|-------------|
| Numeric operations | [Redis String Increment/Decrement](https://redis.io/docs/latest/commands/incr/) | Official docs for `INCR`, `DECR`, `INCRBYFLOAT`, and related commands. |
| Expiration and TTL | [Expire Keys](https://redis.io/docs/latest/develop/use/keyspace/expiring/) | How to set key expirations with `EXPIRE` and `TTL`. |

---

## 🔹 In-Memory Storage and Persistence

| Topic | Resource | Description |
|--------|-----------|-------------|
| Persistence overview | [Redis Persistence Options](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/) | Explanation of RDB and AOF mechanisms. |
| Eviction policies | [Memory Management – maxmemory-policy](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/#eviction-policies) | Learn how Redis handles memory limits and LRU eviction. |
| Backups and recovery | [Redis Snapshotting (RDB)](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/rdb/) | How to configure and restore from RDB snapshots. |

---

## 🔹 Redis as a Message Bus

| Topic | Resource | Description |
|--------|-----------|-------------|
| Pub/Sub model | [Redis Pub/Sub (Manual)](https://redis.io/docs/latest/develop/pubsub/) | Introduction to publish–subscribe channels in Redis. |
| Streams | [Redis Streams](https://redis.io/docs/latest/develop/data-types/streams/) | Learn how to build persistent message pipelines. |
| Lists as queues | [Using Redis Lists for Queues](https://redis.io/docs/latest/develop/data-types/lists/) | Implement simple job queues using `LPUSH` and `BRPOP`. |
| Redis University | [RU101: Introduction to Redis Data Structures](https://university.redis.com/courses/ru101/) | Free course covering advanced use cases, including pub/sub and streams. |

---

## 🔹 Tooling and Further Practice

| Topic | Resource | Description |
|--------|-----------|-------------|
| Redis CLI reference | [redis-cli Tool](https://redis.io/docs/latest/develop/reference/cli/) | Command-line tool for interacting with Redis. |
| Docker setup | [Official Redis Docker Image](https://hub.docker.com/_/redis) | Run Redis locally in a Docker container for practice. |
| Visual GUI client | [RedisInsight](https://redis.io/insight/) | Official desktop GUI for browsing data and monitoring Redis. |

---
