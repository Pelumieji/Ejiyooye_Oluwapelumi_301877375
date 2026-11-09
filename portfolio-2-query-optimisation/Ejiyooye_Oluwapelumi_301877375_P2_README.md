# E-commerce Platform — SQL queries

## 1. Show related order_header, customer, order_item, product records (up to 20).

```sql
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
```

| order_header_order_id | order_header_ordered_at | customer_customer_id | customer_email | order_item_order_item_id | order_item_quantity | product_product_id | product_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3 | 2026-02-15T14:00:00+00:00 | 1 | alex@example.test | 4 | 2 | 2 | SKU-100 |

## 2. Find customer records where email matches "alex@example.test" (up to 20).

```sql
SELECT * FROM portfolio."customer"
WHERE "email" IS NOT DISTINCT FROM 'alex@example.test'
ORDER BY "customer_id"
LIMIT 20;
```

| customer_id | email | display_name | created_at |
| --- | --- | --- | --- |
| 1 | alex@example.test | Alex Customer | 2026-01-10T09:30:00+00:00 |

## 3. Count order_item records for each order_id (up to 20 groups).

```sql
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_item"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
```

| order_id | record_count |
| --- | --- |
| 3 | 1 |

## 4. Find order_header records where ordered_at matches "2026-02-15T14:00:00Z" (up to 20).

```sql
SELECT * FROM portfolio."order_header"
WHERE "ordered_at" IS NOT DISTINCT FROM '2026-02-15T14:00:00Z'
ORDER BY "order_id"
LIMIT 20;
```

| order_id | customer_id | ordered_at | status |
| --- | --- | --- | --- |
| 3 | 1 | 2026-02-15T14:00:00+00:00 | paid |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.041 | 1.031, 2.212, 1.041 | Sort → Seq Scan | 112 |
| After index | 0.185 | 0.18, 0.185, 0.208 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.041 ms to 0.185 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.993..0.995 rows=20 loops=1)
  Seq Scan on order_header (actual time=0.014..0.959 rows=20 loops=1)
Planning Time: 0.336 ms
Execution Time: 1.031 ms
```

### Before index, run 2

```text
Sort (actual time=2.166..2.168 rows=20 loops=1)
  Seq Scan on order_header (actual time=0.025..2.107 rows=20 loops=1)
Planning Time: 0.563 ms
Execution Time: 2.212 ms
```

### Before index, run 3

```text
Sort (actual time=1.01..1.012 rows=20 loops=1)
  Seq Scan on order_header (actual time=0.015..0.974 rows=20 loops=1)
Planning Time: 0.334 ms
Execution Time: 1.041 ms
```

### After index, run 1

```text
Sort (actual time=0.124..0.126 rows=20 loops=1)
  Bitmap Heap Scan on order_header (actual time=0.026..0.089 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.575 ms
Execution Time: 0.18 ms
```

### After index, run 2

```text
Sort (actual time=0.126..0.128 rows=20 loops=1)
  Bitmap Heap Scan on order_header (actual time=0.026..0.091 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.571 ms
Execution Time: 0.185 ms
```

### After index, run 3

```text
Sort (actual time=0.151..0.152 rows=20 loops=1)
  Bitmap Heap Scan on order_header (actual time=0.05..0.114 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.038..0.038 rows=20 loops=1)
Planning Time: 0.544 ms
Execution Time: 0.208 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Ejiyooye_Oluwapelumi_301877375_P2_Queries.sql, then Ejiyooye_Oluwapelumi_301877375_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Ejiyooye_Oluwapelumi_301877375_P2_QueryResults.png) · [Index comparison](screenshots/Ejiyooye_Oluwapelumi_301877375_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

