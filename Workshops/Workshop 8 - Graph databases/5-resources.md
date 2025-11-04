# Resources

### Official Documentation

- [Cypher Query Language Manual](https://neo4j.com/docs/cypher-manual/current/)  
  The official reference for the Cypher query language — includes syntax, clauses, functions, and best practices.

- [Neo4j Developer Guides](https://neo4j.com/developer/)  
  Step-by-step tutorials for building projects with Neo4j, including examples for Python, JavaScript, and Java.

- [Neo4j Browser User Interface](https://neo4j.com/docs/browser-manual/current/)  
  Official documentation for the Neo4j Browser environment used in the workshop (Sandbox).

- [Neo4j Sandbox](https://sandbox.neo4j.com/)  
  Free online environment to experiment with Neo4j without installing anything locally.

- [Neo4j Graph Academy](https://graphacademy.neo4j.com/)  
  Free online courses from Neo4j, including *Introduction to Cypher*, *Graph Data Modeling Fundamentals*, and *Applied Graph Algorithms*.

---

### Additional References

- [Cypher Style Guide](https://neo4j.com/developer/cypher/style-guide/)  
  Recommended best practices for writing clean and consistent Cypher queries.

- [Neo4j APOC Library](https://neo4j.com/labs/apoc/)  
  “Awesome Procedures On Cypher” — a library of extended procedures for more advanced graph operations.

---

## About Graph Data Modeling Languages

Unlike relational databases, there is no single standardized **ERD equivalent** for graph databases.  
However, several *visual and conceptual tools* exist:

- **Neo4j Graph Data Modeler** (in Neo4j Workspace)  
  A built-in visual tool that lets you draw nodes, relationships, and properties interactively.

- **Arrows.app** ([https://arrows.app](https://arrows.app))  
  A free online diagramming tool maintained by Neo4j engineers. It uses simple node–relationship diagrams that match Cypher syntax — perfect for quickly sketching graph structures.

- **GraphQL Schema for Graph Databases**  
  Some teams model graphs using GraphQL schemas (especially when using Neo4j GraphQL). It can serve as a semi-formal description of the graph’s domain.

In practice, **graph data modeling** is more about **describing relationships and traversal paths** than about strict cardinality and normalization rules.  
You usually start from *questions you want to ask* (“who is connected to whom, through what?”) and model nodes and relationships accordingly.
