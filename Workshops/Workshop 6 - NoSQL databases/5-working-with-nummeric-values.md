# Working with Numeric Values — Increment and Decrement

Although Redis stores all values as strings, it can treat those strings as numbers when using special commands such as `INCR`, `DECR`, and `HINCRBY`.

These commands are very efficient because Redis performs the arithmetic directly in memory — without needing to fetch, convert, and re-store values on the client side.

Even though Redis treats numbers as strings internally, arithmetic operations like ```INCR``` and ```HINCRBY``` are atomic — they’re safe to use even when multiple clients update the same key at the same time.

---

## Basic Increment and Decrement

Let’s start with a simple counter.

```bash
SET pageviews 0
INCR pageviews
INCR pageviews
GET pageviews
```

Output:

```
"2"
```

Even though the value is stored as a string, Redis interprets it as a number during the INCR operation and updates it accordingly.

\
You can also decrement:

```bash
DECR pageviews
GET pageviews
```

Output:

```
"1"
```

## Increment by a Specific Value

Use ```INCRBY``` or ```DECRBY``` to increase or decrease by a custom amount.

```bash
SET stock:1005 20
INCRBY stock:1005 5
GET stock:1005
```

Output:

```
"25"
```

## Working with Hashes

You can also increment or decrement numeric fields inside a hash using HINCRBY.

```bash
HSET product:1005 price 1299 stock 10
HINCRBY product:1005 stock 3
HGET product:1005 stock
```

Output:

```
"13"
```
If the field doesn’t exist yet, Redis automatically creates it with value 0 before applying the increment.

## Floating-Point Values

For decimal numbers, use ```INCRBYFLOAT``` or ```HINCRBYFLOAT```.

```
SET temperature 19.5
INCRBYFLOAT temperature 0.3
GET temperature
```

Output:

```
"19.8"
```

## Error handling

If a value cannot be interpreted as a number, Redis returns an error.

```
SET counter "ten"
INCR counter
```

Output:

```
(error) ERR value is not an integer or out of range
```

# Practice Questions

🧠 1. Create a counter for website visitors, starting at 0.
Increase it three times and check the value.
<details><summary>Click to reveal answer</summary>

SET visitors 0\
INCR visitors\
INCR visitors\
INCR visitors\
GET visitors

→ "3"
</details>

\
🧠 2. A product has an initial stock of 50.
Decrease the stock by 4 items after a sale.
<details><summary>Click to reveal answer</summary>

SET stock:productA 50\
DECRBY stock:productA 4\
GET stock:productA

→ "46"
</details>

\
🧠 3. Add a views field to a hash called article:1001 and increase it by 10.
<details><summary>Click to reveal answer</summary>

HSET article:1001 title "Redis Introduction"\
HINCRBY article:1001 views 10\
HGET article:1001 views

→ "10"
</details>

\
🧠 4. Create a key temperature:room1 with initial value 20.0.
Increase it by 0.5 degrees and check the result.
<details><summary>Click to reveal answer</summary>

SET temperature:room1 20.0\
INCRBYFLOAT temperature:room1 0.5\
GET temperature:room1

→ "20.5"
</details>