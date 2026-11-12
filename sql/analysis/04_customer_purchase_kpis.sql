WITH customer_orders AS (
    SELECT customer_unique_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM analytics.order_sales
    WHERE order_status = 'delivered'
        AND customer_unique_id IS NOT NULL
    GROUP BY customer_unique_id
)
SELECT COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE total_orders = 1
    ) AS one_time_customers,
    COUNT(*) FILTER (
        WHERE total_orders >= 2
    ) AS repeat_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE total_orders >= 2
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM customer_orders;