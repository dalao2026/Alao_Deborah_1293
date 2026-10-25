-- Fictional sample records for E-commerce Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("customer_id", "email", "full_name", "created_at") VALUES (1001, 'alex@example.test', 'Alex Rivera', '2026-01-10T09:15:00Z');
INSERT INTO portfolio."customers" ("customer_id", "email", "full_name", "created_at") VALUES (1002, 'sam@example.test', 'Sam Chen', '2026-01-12T14:30:00Z');
INSERT INTO portfolio."products" ("product_id", "sku", "name", "unit_price", "stock_quantity", "active") VALUES (2001, 'MUG-001', 'Ceramic Mug', 12.5, 20, TRUE);
INSERT INTO portfolio."products" ("product_id", "sku", "name", "unit_price", "stock_quantity", "active") VALUES (2002, 'TEA-001', 'Herbal Tea', 5.5, 35, TRUE);
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status", "total_amount") VALUES (3001, 1001, '2026-02-01T10:00:00Z', 'placed', 23.5);
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status", "total_amount") VALUES (3002, 1002, '2026-02-02T11:30:00Z', 'placed', 12.5);
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price") VALUES (4001, 3001, 2001, 1, 12.5);
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price") VALUES (4002, 3001, 2002, 2, 5.5);
INSERT INTO portfolio."order_items" ("order_item_id", "order_id", "product_id", "quantity", "unit_price") VALUES (4003, 3002, 2001, 1, 12.5);
COMMIT;
