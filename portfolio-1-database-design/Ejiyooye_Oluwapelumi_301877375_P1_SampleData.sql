-- Fictional sample records for E-commerce Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "created_at") VALUES (1, 'alex@example.test', 'Alex Customer', '2026-01-10T09:30:00Z');
INSERT INTO portfolio."product" ("product_id", "sku", "name", "unit_price", "active") VALUES (2, 'SKU-100', 'Blue Mug', 12.5, TRUE);
INSERT INTO portfolio."order_header" ("order_id", "customer_id", "ordered_at", "status") VALUES (3, 1, '2026-02-15T14:00:00Z', 'paid');
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "product_id", "quantity", "unit_price") VALUES (4, 3, 2, 2, 11.5);
COMMIT;
