USE ecommerce_analytics_olist;

-- =========================================
-- 1. Orders Over Time
-- =========================================
-- Question:
-- How many orders were placed each month?
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month, COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_month
ORDER BY order_month;

-- =========================================
-- 2. Revenue Over Time
-- =========================================
-- Question:
-- What is the total revenue generated each month?
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month, ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
GROUP BY order_month
ORDER BY order_month;

-- =========================================
-- 3. Revenue by Product Category
-- =========================================
-- Question:
-- Which product categories generate the most revenue?
SELECT pct.product_category_name_english AS product_category, ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pct
ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY total_revenue DESC;

-- =========================================
-- 4. Top Sellers by Revenue
-- =========================================
-- Question:
-- Which sellers generate the most revenue?
SELECT oi.seller_id,ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM olist_order_items_dataset oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- =========================================
-- 5. Orders by Customer State
-- =========================================
-- Question:
-- Which customer states place the most orders?
SELECT c.customer_state, COUNT(*) AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;

-- =========================================
-- 6. Average Delivery Time
-- =========================================
-- Question:
-- What is the average delivery time in days?


-- =========================================
-- 7. Late Delivery Rate
-- =========================================
-- Question:
-- What percentage of delivered orders arrived late?


-- =========================================
-- 8. Delivery Time by State
-- =========================================
-- Question:
-- Which customer states have the longest average delivery times?


-- =========================================
-- 9. Review Score Distribution
-- =========================================
-- Question:
-- How are review scores distributed?


-- =========================================
-- 10. Late Delivery vs Review Score
-- =========================================
-- Question:
-- Do late deliveries receive worse review scores?
