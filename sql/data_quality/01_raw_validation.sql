SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL SELECT 'products', COUNT(*) FROM raw.products
UNION ALL SELECT 'sellers', COUNT(*) FROM raw.sellers
UNION ALL SELECT 'order_payments', COUNT(*) FROM raw.order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM raw.order_reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM raw.geolocation
UNION ALL SELECT 'category_translation', COUNT(*) FROM raw.category_translation;

SELECT 'orders' AS table_name,
       COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_count
FROM raw.orders
UNION ALL SELECT 'customers', COUNT(*) - COUNT(DISTINCT customer_id)
FROM raw.customers
UNION ALL SELECT 'products', COUNT(*) - COUNT(DISTINCT product_id)
FROM raw.products
UNION ALL SELECT 'order_items', COUNT(*) - COUNT(DISTINCT (order_id, order_item_id))
FROM raw.order_items;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(order_id), '') IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(customer_id), '') IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(order_purchase_timestamp), '') IS NULL) AS missing_purchase_date,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(order_delivered_customer_date), '') IS NULL) AS missing_delivery_date
FROM raw.orders;

SELECT
    COUNT(*) AS total_items,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(price), '') IS NULL) AS missing_prices,
    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(price), '') IS NOT NULL
          AND TRIM(price) !~ '^[0-9]+(\.[0-9]+)?$'
    ) AS invalid_price_format,
    COUNT(*) FILTER (
        WHERE CASE
              WHEN TRIM(price) ~ '^[0-9]+(\.[0-9]+)?$'
              THEN TRIM(price)::NUMERIC <= 0
              ELSE FALSE
          END
    ) AS non_positive_prices
FROM raw.order_items;

SELECT COUNT(*) AS unmatched_orders
FROM raw.orders o
LEFT JOIN raw.customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
