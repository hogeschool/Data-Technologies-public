# Using Redis as a Message Bus

Redis is not only a key–value store — it can also act as a **lightweight message bus** between processes or applications.  
This allows systems to exchange messages asynchronously without a traditional message broker like RabbitMQ or Kafka.

---

## Why use Redis for messaging?

Because Redis keeps everything in memory and provides simple communication commands, it can be used for **real-time notifications**, **background task queues**, or **event broadcasting**.

There are three main patterns for messaging in Redis:

| Mechanism | Description | Typical use |
|------------|--------------|--------------|
| **Pub/Sub** (`PUBLISH`, `SUBSCRIBE`) | Sends real-time messages to all subscribers of a channel. Messages are *not persisted*. | Live notifications, chat systems |
| **Lists as Queues** (`LPUSH`, `BRPOP`) | Push messages onto a list and let consumers pop them. | Simple task or job queues |
| **Streams** (`XADD`, `XREAD`, `XGROUP`) | Persistent message log with message IDs and consumer groups. | Reliable pipelines, event sourcing |

---

## Example 1 – Publish / Subscribe

Redis supports a simple **Pub/Sub** model.

### Step 1 – Subscribe to a channel
Open one terminal and run:

```bash
SUBSCRIBE news:sports
```

### Step 2 – Publish a message
In another terminal, publish a message to the same channel:

```bash
PUBLISH news:sports "New match result: 3–2"
```

### Result
```
1) "message"
2) "news:sports"
3) "New match result: 3–2"
```

Subscribers listening to `news:sports` receive the message instantly.

> ⚠️ Note: If no one is subscribed at the moment of publishing, the message is lost.  
> Pub/Sub in Redis does not store messages — it is purely real-time.

---

## Example 2 – Using a List as a Queue

Redis Lists can be used to build a **work queue**.  
A producer pushes tasks into a list, and workers pop them for processing.

### Producer
```bash
LPUSH job_queue "process image_001.png"
LPUSH job_queue "process image_002.png"
```

### Consumer
```bash
BRPOP job_queue 0
```

The `BRPOP` command waits for a new item if the list is empty.  
This makes it ideal for background processing or worker queues.

---

## Example 3 – Streams for Reliable Messaging

If you need to **store** messages and replay them later, use **Redis Streams**.

### Add messages to a stream
```bash
XADD events * type=order_created order_id=872
XADD events * type=order_shipped order_id=872
```

### Read messages
```bash
XREAD COUNT 2 STREAMS events 0
```

Each message has a unique ID and can be consumed by multiple consumers.  
Streams are persistent until explicitly trimmed.

---

## When to Use Each Pattern

| Pattern | Reliability | Real-time | Typical Use |
|----------|--------------|------------|--------------|
| **Pub/Sub** | ❌ Not stored | ✅ Instant | Notifications, updates |
| **Lists** | ✅ Stored until consumed | ⚙️ Near real-time | Job queues, background tasks |
| **Streams** | ✅ Stored with IDs | ⚙️ Real-time or delayed | Event pipelines, logging |

---

## 🧠 Practice Questions

**1.** What happens if a message is published to a channel but no clients are subscribed?  
<details><summary>Click to reveal answer</summary>
The message is lost. Redis Pub/Sub does not store messages.
</details>

---

**2.** Which Redis data type would you use for a reliable task queue?  
<details><summary>Click to reveal answer</summary>
A **List** using `LPUSH` and `BRPOP`, or a **Stream** for more advanced use cases.
</details>

---

**3.** What is one key difference between Redis Pub/Sub and Streams?  
<details><summary>Click to reveal answer</summary>
Pub/Sub delivers messages in real time and does not store them.  
Streams store messages persistently and allow replay or consumer groups.
</details>

---

## Summary

Redis can act as a **simple message bus** for real-time communication or background processing.  
Depending on your needs, you can choose between:

- **Pub/Sub** for lightweight real-time messages.  
- **Lists** for basic job queues.  
- **Streams** for reliable, persistent event logs.

This flexibility makes Redis a practical choice for both caching and inter-process communication in modern applications.

---
