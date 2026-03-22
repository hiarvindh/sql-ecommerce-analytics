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
SELECT c.customer_state, COUNT(DISTINCT o.order_id) AS total_orders
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
SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days
FROM olist_orders_dataset
WHERE order_status = 'delivered'AND order_delivered_customer_date IS NOT NULL AND order_purchase_timestamp IS NOT NULL;

-- =========================================
-- 7. Late Delivery Rate
-- =========================================
-- Question:
-- What percentage of delivered orders arrived late?
SELECT ROUND(100.0 * SUM(
			CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
                ELSE 0
            END
	) / COUNT(*), 2) AS late_delivery_rate_pct
FROM olist_orders_dataset
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL AND order_estimated_delivery_date IS NOT NULL;

-- =========================================
-- 8. Delivery Time by State
-- =========================================
-- Question:
-- Which customer states have the longest average delivery times?
SELECT c.customer_state, ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL AND o.order_purchase_timestamp IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- =========================================
-- 9. Review Score Distribution
-- =========================================
-- Question:
-- How are review scores distributed?
SELECT review_score, COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

-- =========================================
-- 10. Late Delivery vs Review Score
-- =========================================
-- Question:
-- Do late deliveries receive worse review scores?
SELECT CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
ROUND(AVG(r.review_score), 2) AS avg_review_score, COUNT(*) AS total_reviews
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r
ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status;