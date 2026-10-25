-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. duplicate customer pk. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "email", "full_name", "created_at")
VALUES (1001, 'new.customer@example.test', 'Taylor Quinn', '2026-03-01T08:00:00Z');

-- 2. duplicate customer email. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "email", "full_name", "created_at")
VALUES (5001, 'alex@example.test', 'Jordan Lee', '2026-03-02T08:00:00Z');

-- 3. null customer email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "email", "full_name", "created_at")
VALUES (5002, NULL, 'Morgan Blake', '2026-03-03T08:00:00Z');

-- 4. duplicate product pk. Expected: pk_products, SQLSTATE 23505.
INSERT INTO portfolio."products" ("product_id", "sku", "name", "unit_price", "stock_quantity", "active")
VALUES (2001, 'MUG-999', 'Travel Mug', 18, 10, TRUE);

-- 5. duplicate product sku. Expected: uq_products_0, SQLSTATE 23505.
INSERT INTO portfolio."products" ("product_id", "sku", "name", "unit_price", "stock_quantity", "active")
VALUES (5003, 'MUG-001', 'Spare Mug', 9, 8, TRUE);

-- 6. negative product stock. Expected: product_stock_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."products" ("product_id", "sku", "name", "unit_price", "stock_quantity", "active")
VALUES (5004, 'BAG-001', 'Canvas Bag', 15, -1, TRUE);

-- 7. duplicate order pk. Expected: pk_orders, SQLSTATE 23505.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status", "total_amount")
VALUES (3001, 1002, '2026-03-04T09:00:00Z', 'placed', 7);

-- 8. unknown order customer. Expected: fk_orders_0, SQLSTATE 23503.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status", "total_amount")
VALUES (5005, 9001, '2026-03-05T09:00:00Z', 'placed', 7);

-- 9. duplicate order item pk. Expected: pk_order_items, SQLSTATE 23505.
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (4001, 3002, 2002, 1, 5.5);

-- 10. duplicate order product pair. Expected: uq_order_items_0, SQLSTATE 23505.
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (5006, 3001, 2001, 3, 12.5);

-- 11. unknown order item order. Expected: fk_order_items_0, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (5007, 9002, 2002, 1, 5.5);

-- 12. unknown order item product. Expected: fk_order_items_1, SQLSTATE 23503.
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (5008, 3002, 9003, 1, 5.5);

-- 13. zero order item quantity. Expected: order_item_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (5009, 3002, 2002, 0, 5.5);
