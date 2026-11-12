WITH order_seller_counts AS (
    SELECT order_id,
        COUNT(DISTINCT seller_id) AS seller_count
    FROM staging.order_items
    GROUP BY order_id
),
seller_order_sales AS (
    SELECT order_id,
        seller_id,
        SUM(price) AS revenue
    FROM staging.order_items
    GROUP BY order_id,
        seller_id
),
reviews_per_order AS (
    SELECT order_id,
        AVG(review_score::NUMERIC) AS review_score
    FROM staging.order_reviews
    WHERE review_score BETWEEN 1 AND 5
    GROUP BY order_id
),
eligible_orders AS (
    SELECT s.seller_id,
        s.order_id,
        s.revenue,
        o.is_late_delivery,
        r.review_score
    FROM seller_order_sales s
        JOIN order_seller_counts sc ON s.order_id = sc.order_id
        AND sc.seller_count = 1
        JOIN analytics.order_sales o ON s.order_id = o.order_id
        LEFT JOIN reviews_per_order r ON s.order_id = r.order_id
    WHERE o.order_status = 'delivered'
        AND o.is_late_delivery IS NOT NULL
),
seller_summary AS (
    SELECT seller_id,
        COUNT(*) AS orders_analyzed,
        COUNT(review_score) AS reviewed_orders,
        ROUND(SUM(revenue), 2) AS product_revenue,
        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE is_late_delivery = TRUE
            ) / NULLIF(COUNT(*), 0),
            2
        ) AS late_delivery_rate_pct,
        ROUND(AVG(review_score), 2) AS avg_review_score,
        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE review_score <= 2
            ) / NULLIF(COUNT(review_score), 0),
            2
        ) AS low_rating_rate_pct
    FROM eligible_orders
    GROUP BY seller_id
)
SELECT *
FROM seller_summary
WHERE orders_analyzed >= 30
    AND reviewed_orders >= 20
ORDER BY product_revenue DESC
LIMIT 15;