SELECT 'customers' AS table_name,
       (SELECT COUNT(*) FROM raw.customers) AS raw_rows,
       (SELECT COUNT(*) FROM staging.customers) AS staging_rows
UNION ALL SELECT 'orders',
       (SELECT COUNT(*) FROM raw.orders),
       (SELECT COUNT(*) FROM staging.orders)
UNION ALL SELECT 'order_items',
       (SELECT COUNT(*) FROM raw.order_items),
       (SELECT COUNT(*) FROM staging.order_items)
UNION ALL SELECT 'products',
       (SELECT COUNT(*) FROM raw.products),
       (SELECT COUNT(*) FROM staging.products)
UNION ALL SELECT 'sellers',
       (SELECT COUNT(*) FROM raw.sellers),
       (SELECT COUNT(*) FROM staging.sellers)
UNION ALL SELECT 'order_payments',
       (SELECT COUNT(*) FROM raw.order_payments),
       (SELECT COUNT(*) FROM staging.order_payments)
UNION ALL SELECT 'order_reviews',
       (SELECT COUNT(*) FROM raw.order_reviews),
       (SELECT COUNT(*) FROM staging.order_reviews)
UNION ALL SELECT 'geolocation',
       (SELECT COUNT(*) FROM raw.geolocation),
       (SELECT COUNT(*) FROM staging.geolocation)
UNION ALL SELECT 'category_translation',
       (SELECT COUNT(*) FROM raw.category_translation),
       (SELECT COUNT(*) FROM staging.category_translation);

SELECT
    order_status,
    COUNT(*) AS missing_delivery_count
FROM staging.orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY missing_delivery_count DESC;
