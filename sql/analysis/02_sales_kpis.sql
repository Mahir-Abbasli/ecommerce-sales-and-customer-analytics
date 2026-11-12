SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE order_status = 'delivered'
    ) AS delivered_orders,
    ROUND(
        SUM(product_revenue) FILTER (
            WHERE order_status = 'delivered'
        ), 2
    ) AS total_revenue,
    ROUND(
        SUM(product_revenue) FILTER (
            WHERE order_status = 'delivered'
        ) /
        NULLIF(
            COUNT(*) FILTER (
                WHERE order_status = 'delivered'
                  AND item_count > 0
            ), 0
        ), 2
    ) AS average_order_value,
    COUNT(*) FILTER (
        WHERE is_late_delivery = TRUE
    ) AS late_deliveries
FROM analytics.order_sales;
