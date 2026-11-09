-- Show related order_header, customer, order_item, product records (up to 20).
SELECT t0."order_id" AS "order_header_order_id",
       t0."ordered_at" AS "order_header_ordered_at",
       t3."customer_id" AS "customer_customer_id",
       t3."email" AS "customer_email",
       t1."order_item_id" AS "order_item_order_item_id",
       t1."quantity" AS "order_item_quantity",
       t2."product_id" AS "product_product_id",
       t2."sku" AS "product_sku"
FROM portfolio."order_header" t0
JOIN portfolio."order_item" t1 ON t1."order_id" = t0."order_id"
JOIN portfolio."product" t2 ON t1."product_id" = t2."product_id"
JOIN portfolio."customer" t3 ON t0."customer_id" = t3."customer_id"
ORDER BY t0."order_id", t3."customer_id", t1."order_item_id", t2."product_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."order_id" AS "order_header_order_id",
       t0."ordered_at" AS "order_header_ordered_at",
       t3."customer_id" AS "customer_customer_id",
       t3."email" AS "customer_email",
       t1."order_item_id" AS "order_item_order_item_id",
       t1."quantity" AS "order_item_quantity",
       t2."product_id" AS "product_product_id",
       t2."sku" AS "product_sku"
FROM portfolio."order_header" t0
JOIN portfolio."order_item" t1 ON t1."order_id" = t0."order_id"
JOIN portfolio."product" t2 ON t1."product_id" = t2."product_id"
JOIN portfolio."customer" t3 ON t0."customer_id" = t3."customer_id"
ORDER BY t0."order_id", t3."customer_id", t1."order_item_id", t2."product_id"
LIMIT 20;

-- Find customer records where email matches "alex@example.test" (up to 20).
SELECT * FROM portfolio."customer"
WHERE "email" IS NOT DISTINCT FROM 'alex@example.test'
ORDER BY "customer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."customer"
WHERE "email" IS NOT DISTINCT FROM 'alex@example.test'
ORDER BY "customer_id"
LIMIT 20;

-- Count order_item records for each order_id (up to 20 groups).
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_item"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_item"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

-- Find order_header records where ordered_at matches "2026-02-15T14:00:00Z" (up to 20).
SELECT * FROM portfolio."order_header"
WHERE "ordered_at" IS NOT DISTINCT FROM '2026-02-15T14:00:00Z'
ORDER BY "order_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."order_header"
WHERE "ordered_at" IS NOT DISTINCT FROM '2026-02-15T14:00:00Z'
ORDER BY "order_id"
LIMIT 20;
