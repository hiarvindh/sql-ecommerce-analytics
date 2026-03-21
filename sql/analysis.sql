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


-- =========================================
-- 3. Revenue by Product Category
-- =========================================
-- Question:
-- Which product categories generate the most revenue?


-- =========================================
-- 4. Top Sellers by Revenue
-- =========================================
-- Question:
-- Which sellers generate the most revenue?


-- =========================================
-- 5. Orders by Customer State
-- =========================================
-- Question:
-- Which customer states place the most orders?



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
