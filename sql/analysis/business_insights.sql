
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

-- Revenue + Review Score
SELECT COALESCE(pct.product_category_name_english, 'Unknown') AS category, ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue, ROUND(AVG(r.review_score), 2) AS avg_review
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
ON p.product_category_name = pct.product_category_name
JOIN olist_orders_dataset o
ON oi.order_id = o.order_id
JOIN olist_order_reviews_dataset r
ON o.order_id = r.order_id
GROUP BY category
ORDER BY revenue DESC;

-- Revenue + Customer Satisfaction


-- Delivery Performance
