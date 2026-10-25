# E-commerce Platform — database design

My case study records customers, products, orders, order_items.

## Users

- Customers placing orders
- Shop staff reviewing orders and stock

## Main operations

- Browse products and stock
- Place orders with one or more product lines
- Review customer order history and sales totals

## Entities

| Entity | Information stored |
| --- | --- |
| customers | Stores customer identity and contact details. |
| products | Stores the catalog, current price, and available stock. |
| orders | Stores each customer's order and its checkout status. |
| order_items | Stores product quantities and purchase-time prices for each order. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## products

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
| stock_quantity | INTEGER |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## orders

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| placed_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| total_amount | NUMERIC(18,2) |  | Yes |
- customer_id → customers.customer_id

## order_items

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_item_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → orders.order_id
- product_id → products.product_id
- Unique key: (order_id, product_id).

## Relationships and business rules

- A normalized customer email identifies at most one customer.
- Each catalog SKU identifies at most one product.
- Available stock must never be negative.
- Every order references an existing customer through customer_id.
- Every order line references an existing order through order_id.
- Every order line references an existing product through product_id.
- Every order line has a quantity greater than zero.

## Assumptions

- All prices and order totals use USD.
- Each product has an integer stock quantity; checkout rejects orders that would make stock negative.
- Order lines retain the unit price at purchase time, even if the product price later changes.
- Customer emails are stored in normalized lowercase form and are unique; product SKUs are unique.
- All names, addresses, prices, timestamps, and identifiers in exercise data are synthetic.

