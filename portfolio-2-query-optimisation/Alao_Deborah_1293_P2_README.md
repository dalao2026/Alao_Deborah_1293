# E-commerce Platform — SQL queries

## 1. Show related orders, customers, order_items, products records (up to 20).

```sql
SELECT t0."order_id" AS "orders_order_id",
       t0."placed_at" AS "orders_placed_at",
       t3."customer_id" AS "customers_customer_id",
       t3."email" AS "customers_email",
       t1."order_item_id" AS "order_items_order_item_id",
       t1."quantity" AS "order_items_quantity",
       t2."product_id" AS "products_product_id",
       t2."sku" AS "products_sku"
FROM portfolio."orders" t0
JOIN portfolio."order_items" t1 ON t1."order_id" = t0."order_id"
JOIN portfolio."products" t2 ON t1."product_id" = t2."product_id"
JOIN portfolio."customers" t3 ON t0."customer_id" = t3."customer_id"
ORDER BY t0."order_id", t3."customer_id", t1."order_item_id", t2."product_id"
LIMIT 20;
```

| orders_order_id | orders_placed_at | customers_customer_id | customers_email | order_items_order_item_id | order_items_quantity | products_product_id | products_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2026-02-01T10:00:00+00:00 | 1001 | alex@example.test | 4001 | 1 | 2001 | MUG-001 |
| 3001 | 2026-02-01T10:00:00+00:00 | 1001 | alex@example.test | 4002 | 2 | 2002 | TEA-001 |
| 3002 | 2026-02-02T11:30:00+00:00 | 1002 | sam@example.test | 4003 | 1 | 2001 | MUG-001 |

## 2. Find customers records where email matches "alex@example.test" (up to 20).

```sql
SELECT * FROM portfolio."customers"
WHERE "email" IS NOT DISTINCT FROM 'alex@example.test'
ORDER BY "customer_id"
LIMIT 20;
```

| customer_id | email | full_name | created_at |
| --- | --- | --- | --- |
| 1001 | alex@example.test | Alex Rivera | 2026-01-10T09:15:00+00:00 |

## 3. Count orders records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."orders"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 1001 | 1 |
| 1002 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.349 | 2.349, 2.239, 3.13 | Sort → Seq Scan | 274 |
| After index | 0.276 | 0.276, 0.295, 0.268 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.349 ms to 0.276 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.316..2.319 rows=50 loops=1)
  Seq Scan on orders (actual time=0.014..2.28 rows=50 loops=1)
Planning Time: 0.329 ms
Execution Time: 2.349 ms
```

### Before index, run 2

```text
Sort (actual time=2.205..2.208 rows=50 loops=1)
  Seq Scan on orders (actual time=0.015..2.168 rows=50 loops=1)
Planning Time: 0.357 ms
Execution Time: 2.239 ms
```

### Before index, run 3

```text
Sort (actual time=3.088..3.09 rows=50 loops=1)
  Seq Scan on orders (actual time=0.022..3.035 rows=50 loops=1)
Planning Time: 0.445 ms
Execution Time: 3.13 ms
```

### After index, run 1

```text
Sort (actual time=0.218..0.221 rows=50 loops=1)
  Bitmap Heap Scan on orders (actual time=0.029..0.181 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=50 loops=1)
Planning Time: 0.559 ms
Execution Time: 0.276 ms
```

### After index, run 2

```text
Sort (actual time=0.239..0.242 rows=50 loops=1)
  Bitmap Heap Scan on orders (actual time=0.029..0.203 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=50 loops=1)
Planning Time: 0.529 ms
Execution Time: 0.295 ms
```

### After index, run 3

```text
Sort (actual time=0.21..0.213 rows=50 loops=1)
  Bitmap Heap Scan on orders (actual time=0.029..0.176 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=50 loops=1)
Planning Time: 0.547 ms
Execution Time: 0.268 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Alao_Deborah_1293_P2_Queries.sql, then Alao_Deborah_1293_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Alao_Deborah_1293_P2_QueryResults.png) · [Index comparison](screenshots/Alao_Deborah_1293_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

