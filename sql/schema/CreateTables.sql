USE ecommerce_analytics_olist;

DROP TABLE IF EXISTS
    olist_order_reviews_dataset,
    olist_order_payments_dataset,
    olist_order_items_dataset,
    olist_orders_dataset,
    olist_products_dataset,
    olist_sellers_dataset,
    product_category_name_translation,
    olist_geolocation_dataset,
    olist_customers_dataset;
CREATE TABLE olist_customers_dataset (
    customer_id VARCHAR(32) NOT NULL,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(5) NOT NULL,
    customer_city VARCHAR(100),
    customer_state CHAR(2),
    CONSTRAINT pk_olist_customers PRIMARY KEY (customer_id)
);
CREATE TABLE olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(5) NOT NULL,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) NOT NULL,
    product_category_name_english VARCHAR(100),
    CONSTRAINT pk_product_category_name_translation PRIMARY KEY (product_category_name)
);
CREATE TABLE olist_products_dataset (
    product_id VARCHAR(32) NOT NULL,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    CONSTRAINT pk_olist_products PRIMARY KEY (product_id)
);
CREATE TABLE olist_sellers_dataset (
    seller_id VARCHAR(32) NOT NULL,
    seller_zip_code_prefix VARCHAR(5) NOT NULL,
    seller_city VARCHAR(100),
    seller_state CHAR(2),
    CONSTRAINT pk_olist_sellers PRIMARY KEY (seller_id)
);
CREATE TABLE olist_orders_dataset (
    order_id VARCHAR(32) NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    CONSTRAINT pk_olist_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id)
);
CREATE TABLE olist_order_items_dataset (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    CONSTRAINT pk_olist_order_items PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES olist_products_dataset(product_id),
    CONSTRAINT fk_order_items_seller
        FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset(seller_id)
);
CREATE TABLE olist_order_payments_dataset (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    CONSTRAINT pk_olist_order_payments PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT fk_order_payments_order
        FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);
CREATE TABLE olist_order_reviews_dataset (
    review_id VARCHAR(32) NOT NULL,
    order_id VARCHAR(32) NOT NULL,
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    CONSTRAINT pk_olist_order_reviews PRIMARY KEY (review_id, order_id),
    CONSTRAINT fk_order_reviews_order
        FOREIGN KEY (order_id) REFERENCES olist_orders_dataset(order_id)
);