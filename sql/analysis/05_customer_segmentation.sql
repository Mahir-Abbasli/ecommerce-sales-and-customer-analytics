WITH customer_orders AS (
    SELECT customer_unique_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM analytics.order_sales
    WHERE order_status = 'delivered'
        AND customer_unique_id IS NOT NULL
    GROUP BY customer_unique_id
),
customer_segments AS (
    SELECT CASE
            WHEN total_orders = 1 THEN '1 Purchase'
            WHEN total_orders = 2 THEN '2 Purchases'
            ELSE '3+ Purchases'
        END AS customer_segment,
        CASE
            WHEN total_orders = 1 THEN 1
            WHEN total_orders = 2 THEN 2
            ELSE 3
        END AS segment_order
    FROM customer_orders
)
SELECT customer_segment,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM customer_segments
GROUP BY customer_segment,
    segment_order
ORDER BY segment_order;