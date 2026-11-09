-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk reject. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "created_at")
VALUES (1, 'pk-test@example.test', 'PK Test Customer', '2026-03-01T10:00:00Z');

-- 2. customer unique reject. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "created_at")
VALUES (1001, 'alex@example.test', 'Duplicate Email Customer', '2026-03-01T10:00:00Z');

-- 3. customer not null reject. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "created_at")
VALUES (1002, NULL, 'Null Email Customer', '2026-03-01T10:00:00Z');

-- 4. product pk reject. Expected: pk_product, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "name", "unit_price", "active")
VALUES (2, 'SKU-PK-TEST', 'PK Test Product', 9.99, TRUE);

-- 5. product unique reject. Expected: uq_product_0, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "name", "unit_price", "active")
VALUES (1003, 'SKU-100', 'Duplicate SKU Product', 9.99, TRUE);

-- 6. order pk reject. Expected: pk_order_header, SQLSTATE 23505.
INSERT INTO portfolio."order_header" ("order_id", "customer_id", "ordered_at", "status")
VALUES (3, 1, '2026-03-02T10:00:00Z', 'pending');

-- 7. order customer fk reject. Expected: fk_order_header_0, SQLSTATE 23503.
INSERT INTO portfolio."order_header" ("order_id", "customer_id", "ordered_at", "status")
VALUES (1004, 9901, '2026-03-02T10:00:00Z', 'pending');

-- 8. order item pk reject. Expected: pk_order_item, SQLSTATE 23505.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (4, 3, 2, 1, 12.5);

-- 9. item order fk reject. Expected: fk_order_item_0, SQLSTATE 23503.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (1005, 9902, 2, 1, 12.5);

-- 10. item product fk reject. Expected: fk_order_item_1, SQLSTATE 23503.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (1006, 3, 9903, 1, 12.5);

-- 11. item quantity check reject. Expected: item_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (1007, 3, 2, 0, 12.5);

-- 12. item price check reject. Expected: item_price_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (1008, 3, 2, 1, -1);

-- 13. order status check reject. Expected: order_status_allowed, SQLSTATE 23514.
INSERT INTO portfolio."order_header" ("order_id", "customer_id", "ordered_at", "status")
VALUES (1009, 1, '2026-03-02T10:00:00Z', 'refunded');
