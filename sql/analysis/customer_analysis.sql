USE ecommerce_analytics_olist;
-- 1. Average Order Value (AOV)
SELECT ROUND(AVG(order_value), 2) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(oi.price + oi.freight_value) AS order_value
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) t;

-- 2. Repeat Customer Rate


-- 3. Customer Lifetime Value (Top Customers)


-- 4. Orders per Customer Distribution
