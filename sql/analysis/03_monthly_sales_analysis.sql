WITH monthly_sales AS (
    SELECT DATE_TRUNC(
            'month',
            order_purchase_timestamp
        )::DATE AS sales_month,
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (
            WHERE order_status = 'delivered'
        ) AS delivered_orders,
        COALESCE(
            SUM(product_revenue) FILTER (
                WHERE order_status = 'delivered'
            ),
            0
        ) AS revenue
    FROM analytics.order_sales
    GROUP BY 1
),
calendar_months AS (
    SELECT GENERATE_SERIES(
            (
                SELECT MIN(sales_month)
                FROM monthly_sales
            ),
            (
                SELECT MAX(sales_month)
                FROM monthly_sales
            ),
            INTERVAL '1 month'
        )::DATE AS sales_month
),
monthly_complete AS (
    SELECT c.sales_month,
        COALESCE(m.total_orders, 0) AS total_orders,
        COALESCE(m.delivered_orders, 0) AS delivered_orders,
        COALESCE(m.revenue, 0) AS revenue
    FROM calendar_months c
        LEFT JOIN monthly_sales m ON c.sales_month = m.sales_month
),
monthly_growth AS (
    SELECT *,
        LAG(revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_complete
)
SELECT sales_month,
    total_orders,
    delivered_orders,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100.0 * (revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0),
        2
    ) AS mom_growth_pct
FROM monthly_growth
ORDER BY sales_month;