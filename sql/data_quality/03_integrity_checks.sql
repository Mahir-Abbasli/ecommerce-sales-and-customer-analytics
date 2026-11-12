SELECT 'products' AS table_name,
       COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_count
FROM staging.products
UNION ALL SELECT 'sellers', COUNT(*) - COUNT(DISTINCT seller_id)
FROM staging.sellers
UNION ALL SELECT 'order_payments',
       COUNT(*) - COUNT(DISTINCT (order_id, payment_sequential))
FROM staging.order_payments
UNION ALL SELECT 'category_translation',
       COUNT(*) - COUNT(DISTINCT product_category_name)
FROM staging.category_translation;

SELECT 'items_without_orders' AS test_name, COUNT(*) AS issue_count
FROM staging.order_items i
LEFT JOIN staging.orders o ON i.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'items_without_products', COUNT(*)
FROM staging.order_items i
LEFT JOIN staging.products p ON i.product_id = p.product_id
WHERE p.product_id IS NULL
UNION ALL
SELECT 'items_without_sellers', COUNT(*)
FROM staging.order_items i
LEFT JOIN staging.sellers s ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL
UNION ALL
SELECT 'payments_without_orders', COUNT(*)
FROM staging.order_payments p
LEFT JOIN staging.orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'reviews_without_orders', COUNT(*)
FROM staging.order_reviews r
LEFT JOIN staging.orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL;
