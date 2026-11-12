WITH reviews_per_order AS (
    SELECT order_id,
        AVG(review_score) AS avg_review_score
    FROM staging.order_reviews
    WHERE review_score BETWEEN 1 AND 5
    GROUP BY order_id
),
delivery_reviews AS (
    SELECT CASE
            WHEN o.is_late_delivery = TRUE THEN 'Late'
            ELSE 'On Time'
        END AS delivery_status,
        r.avg_review_score
    FROM analytics.order_sales o
        LEFT JOIN reviews_per_order r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
        AND o.is_late_delivery IS NOT NULL
)
SELECT delivery_status,
    COUNT(*) AS total_orders,
    COUNT(avg_review_score) AS reviewed_orders,
    ROUND(AVG(avg_review_score), 2) AS average_review_score,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE avg_review_score <= 2
        ) / NULLIF(COUNT(avg_review_score), 0),
        2
    ) AS low_rating_rate_pct
FROM delivery_reviews
GROUP BY delivery_status
ORDER BY delivery_status;