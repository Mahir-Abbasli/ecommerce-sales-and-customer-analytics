SELECT i.seller_id,
    s.seller_state,
    COUNT(DISTINCT i.order_id) AS delivered_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(i.price), 2) AS seller_revenue,
    ROUND(AVG(i.price), 2) AS avg_item_price
FROM staging.order_items i
    JOIN staging.orders o ON i.order_id = o.order_id
    LEFT JOIN staging.sellers s ON i.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY i.seller_id,
    s.seller_state
ORDER BY seller_revenue DESC
LIMIT 15;