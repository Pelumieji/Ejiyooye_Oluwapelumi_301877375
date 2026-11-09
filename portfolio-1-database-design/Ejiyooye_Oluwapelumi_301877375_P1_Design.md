# E-commerce Platform — database design

My case study records customer, product, order_header, order_item.

## Users

- Customers browse products and place orders.
- Store staff review orders and product sales.

## Main operations

- Create a product with a unique SKU.
- Place an order containing one or more product items.
- Review order details and summarize product sales.

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A person who places orders. |
| product | A catalog item available for purchase. |
| order_header | An order placed by one customer, with its placement time and current status. |
| order_item | One product line in an order. Worked normalization example: order_item has a foreign key to order_header. Keep the order reference, product reference, quantity, and historical unit price here; do not repeat customer details or product names from referenced records. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## product

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## order_header

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| ordered_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customer.customer_id

## order_item

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_item_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → order_header.order_id
- product_id → product.product_id

## Relationships and business rules

- Each stored canonical customer email identifies at most one customer.
- Each product has a distinct SKU.
- Every order references an existing customer through customer_id.
- Every order item references an existing order through order_id.
- Every order item references an existing product through product_id.
- An order item must have a quantity greater than zero.
- An order item's captured unit price must not be negative.
- An order status must be pending, paid, cancelled, or shipped.

## Assumptions

- All records and benchmark inputs are synthetic.
- Each order belongs to one customer, and each order item refers to one order and one product.
- An order item's unit price is the price captured when the item was ordered; it need not match the product's current price.
- Email addresses are stored in a consistent canonical form, and uniqueness is exact on the stored value.
- The allowed order status values are pending, paid, cancelled, and shipped; this rule checks values, not transition workflows.

