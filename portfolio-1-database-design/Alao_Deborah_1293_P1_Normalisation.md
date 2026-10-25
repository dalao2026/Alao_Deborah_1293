# E-commerce Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | orders records (list) |
| --- | --- |
| 1001 | [3001] |
| 1002 | [3002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| orders.order_id | orders.customer_id | orders.status | customers.customer_id | customers.email |
| --- | --- | --- | --- | --- |
| 3001 | 1001 | placed | 1001 | alex@example.test |
| 3002 | 1002 | placed | 1002 | sam@example.test |

Key: order_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## orders_example

| orders.order_id | orders.customer_id | orders.status | customers.customer_id | customers.email |
| --- | --- | --- | --- | --- |
| 3001 | 1001 | placed | 1001 | alex@example.test |
| 3002 | 1002 | placed | 1002 | sam@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| customer_id | email | full_name | created_at |
| --- | --- | --- | --- |
| 1001 | alex@example.test | Alex Rivera | 2026-01-10T09:15:00+00:00 |
| 1002 | sam@example.test | Sam Chen | 2026-01-12T14:30:00+00:00 |

## products

| product_id | sku | name | unit_price | stock_quantity | active |
| --- | --- | --- | --- | --- | --- |
| 2001 | MUG-001 | Ceramic Mug | 12.5 | 20 | true |
| 2002 | TEA-001 | Herbal Tea | 5.5 | 35 | true |

## orders

| order_id | customer_id | placed_at | status | total_amount |
| --- | --- | --- | --- | --- |
| 3001 | 1001 | 2026-02-01T10:00:00+00:00 | placed | 23.5 |
| 3002 | 1002 | 2026-02-02T11:30:00+00:00 | placed | 12.5 |

## order_items

| order_item_id | order_id | product_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 4001 | 3001 | 2001 | 1 | 12.5 |
| 4002 | 3001 | 2002 | 2 | 5.5 |
| 4003 | 3002 | 2001 | 1 | 12.5 |

## Dependencies

- customers: (customer_id) → email, full_name, created_at
- products: (product_id) → sku, name, unit_price, stock_quantity, active
- orders: (order_id) → customer_id, placed_at, status, total_amount
- order_items: (order_item_id) → order_id, product_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
