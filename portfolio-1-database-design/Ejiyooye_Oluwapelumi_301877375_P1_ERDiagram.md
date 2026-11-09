# E-commerce Platform — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text email UK
        text display_name
        timestamptz created_at
    }
    product {
        bigint product_id PK
        text sku UK
        text name
        numeric unit_price
        boolean active
    }
    order_header {
        bigint order_id PK
        bigint customer_id FK
        timestamptz ordered_at
        text status
    }
    order_item {
        bigint order_item_id PK
        bigint order_id FK
        bigint product_id FK
        integer quantity
        numeric unit_price
    }
    customer ||--o{ order_header : "customer_id"
    order_header ||--o{ order_item : "order_id"
    product ||--o{ order_item : "product_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Ejiyooye_Oluwapelumi_301877375_ERDiagram.png)
