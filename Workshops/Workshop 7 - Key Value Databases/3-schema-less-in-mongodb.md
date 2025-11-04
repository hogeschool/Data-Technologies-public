# Schema-less in MongoDB

Although MongoDB does not enforce a complete schema, it is not entirely schema-free. You can define validation rules to enforce a minimal structure on the documents within a collection.

This is useful when you want flexibility, but also need to ensure that certain fields always exist or follow specific data types.

## JSON Schema Validation

MongoDB supports schema validation using the ```$jsonSchema``` keyword. This allows you to describe the expected structure of documents in a way that is very similar to the [JSON Schema Standard](https://json-schema.org).

When you create a collection, you can attach a validator that checks each document being inserted or updated. The following example shows how to create a products collection in MongoDB with a JSON Schema validator.

```javascript
db.createCollection("products", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "price"],
      properties: {
        name: {
          bsonType: "string",
          description: "Product name must be a string and is required."
        },
        price: {
          bsonType: "number",
          minimum: 0,
          description: "Price must be a positive number."
        },
        specs: {
          bsonType: "object",
          properties: {
            wireless: {
              bsonType: "bool",
              description: "Indicates whether the product is wireless."
            }
          }
        }
      }
    }
  },
  validationAction: "error", // reject invalid documents
  validationLevel: "strict"  // Validate all inserts and updates
})
```
With the above JSON Schema definition a document must include the ```name``` and ```price``` properties as they are listed in the ```required``` array. The ```specs``` property is optional.
- The  ```name``` property must be a string;
- The ```price``` property must be a number with a minimum value of zero;
- If present, the ```specs``` property must be an object;
- If the ```specs``` object contains the ```wireless``` property it must be a boolean.  

After creating the collection above:

- The following document will be accepted:

```javascript
db.products.insertOne({
  name: "Headphones",
  price: 199,
  specs: { wireless: true }
})
```
- The following document will be rejected (missing price):

```javascript
db.products.insertOne({
  name: "Keyboard",
  specs: { wireless: false }
})
```
### Validation Options
MongoDB allows you to define validation behaviour for documents using two options:

**validationAction**

- "error" → Invalid documents are rejected and not written to the collection (default).
- "warn" → invalid documents are still written, but a warning is logged.

**validationLevel**
- "strict" → All inserts and updates are validated against the schema (default).
- "moderate" → Inserts are always validated. Updates are only validated if the existing document already meets the validation rules.

### Adding a Validator to an Existing Collection

If the collection already exists, you can still apply a JSON Schema validator afterwards. This is done with the collMod (collection modify) command.

```javascript
db.runCommand({
  collMod: "products",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "price"],
      properties: {
        name: {
          bsonType: "string",
          description: "Product name must be a string and is required."
        },
        price: {
          bsonType: "number",
          minimum: 0,
          description: "Price must be a positive number."
        },
        specs: {
          bsonType: "object",
          properties: {
            wireless: {
              bsonType: "bool",
              description: "Indicates whether the product is wireless."
            }
          }
        }
      }
    }
  },
  validationAction: "error",
  validationLevel: "strict"  // Validate all inserts and updates
})
```
This command updates the existing products collection and applies the same validation rules as if they had been defined at creation time.

#### Validation of existing Documents

When you add a validator to a collection that already contains documents, MongoDB does not check the existing documents immediately. Validation is only enforced when documents are inserted or updated.

## Questions

🧠 1) What is the purpose of using $jsonSchema in MongoDB?
- A) To encrypt documents
- B) To automatically generate indexes
- C) To describe the expected structure of documents
- D) To back up the collection

<details> <summary>Click to reveal the correct answer</summary>
Correct Answer: C

\
$jsonSchema allows you to define validation rules that describe the expected structure of documents, including required fields and data types. This helps enforce consistency even in a flexible schema-less environment.
</details>

\
🧠 2) Consider the following JSON Schema validator for a userProfiles collection:
```javascript

{
  $jsonSchema: {
    bsonType: "object",
    required: ["username", "email"],
    properties: {
      username: {
        bsonType: "string",
        description: "Username must be a string and is required."
      },
      email: {
        bsonType: "string",
        pattern: "^.+@.+$",
        description: "Email must be a valid email address."
      },
      age: {
        bsonType: "int",
        minimum: 13,
        description: "Age must be an integer of at least 13."
      }
    }
  }
}
```
Which of the following fields is optional according to this schema?
- A) username
- B) email
- C) age
- D) None of the above


<details> <summary>Click to reveal the correct answer</summary>
Correct Answer: C

\
The required array lists username and email as mandatory fields. The age field is defined in the schema but is not listed as required, meaning it is optional. If present, it must be an integer of at least 13.
</details>

\
🧠 3) What happens when a document violates the validation rules and validationAction is set to "error"?

- A) The document is automatically corrected
- B) The document is rejected
- C) The document is inserted with a warning
- D) The document is ignored

<details> <summary>Click to reveal the correct answer</summary>
Correct Answer: B

\
 When validationAction is set to "error", MongoDB rejects any document that does not meet the schema requirements. This ensures strict enforcement of validation rules.
</details>

\
🧠 4) What is the difference between "strict" and "moderate" in validationLevel?

- A) "strict" validates only inserts, "moderate" validates everything
- B) "strict" validates all operations, "moderate" validates inserts and updates only if the document already meets the schema
- C) "strict" disables validation, "moderate" enables it
- D) "strict" is slower than "moderate"

<details> <summary>Click to reveal the correct answer</summary>
Correct Answer: B

\
 "strict" applies validation to all inserts and updates. "moderate" always validates inserts, but only validates updates if the existing document already complies with the schema.
</details>

\
🧠 5) What happens to existing documents when a validator is added to an already populated collection?

- A) They are immediately validated and deleted if invalid
- B) They are automatically updated
- C) They remain unchanged until updated
- D) They are flagged as invalid

<details> <summary>Click to reveal the correct answer</summary>
Correct Answer: C

\
 MongoDB does not retroactively validate existing documents when a validator is added. Validation only occurs during insert or update operations after the validator is in place.
</details>