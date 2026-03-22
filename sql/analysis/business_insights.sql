
-- Monthly Growth Revenue
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
           SUM(oi.price + oi.freight_value) AS revenue
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    GROUP BY month
)
SELECT 
    month,
    revenue,
    ROUND(
        100 * (revenue - LAG(revenue) OVER (ORDER BY month)) 
        / LAG(revenue) OVER (ORDER BY month),
        2
    ) AS growth_pct
FROM monthly_revenue;