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
SELECT ROUND(100.0 * SUM(CASE 
	WHEN order_count > 1 THEN 1 
    ELSE 0 END) / COUNT(*), 2) 
AS repeat_customer_rate_pct
FROM (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
	ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t;

-- 3. Customer Lifetime Value (Top Customers)


-- 4. Orders per Customer Distribution
