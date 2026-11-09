# E-commerce Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | order_header records (list) |
| --- | --- |
| 1 | [3] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| order_header.order_id | order_header.customer_id | order_header.status | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- |
| 3 | 1 | paid | 1 | alex@example.test |

Key: order_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## order_header_example

| order_header.order_id | order_header.customer_id | order_header.status | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- |
| 3 | 1 | paid | 1 | alex@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | email | display_name | created_at |
| --- | --- | --- | --- |
| 1 | alex@example.test | Alex Customer | 2026-01-10T09:30:00+00:00 |

## product

| product_id | sku | name | unit_price | active |
| --- | --- | --- | --- | --- |
| 2 | SKU-100 | Blue Mug | 12.5 | true |

## order_header

| order_id | customer_id | ordered_at | status |
| --- | --- | --- | --- |
| 3 | 1 | 2026-02-15T14:00:00+00:00 | paid |

## order_item

| order_item_id | order_id | product_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 4 | 3 | 2 | 2 | 11.5 |

## Dependencies

- customer: (customer_id) → email, display_name, created_at
- product: (product_id) → sku, name, unit_price, active
- order_header: (order_id) → customer_id, ordered_at, status
- order_item: (order_item_id) → order_id, product_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
