CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.customers AS
SELECT
    TRIM(customer_id) AS customer_id,
    TRIM(customer_unique_id) AS customer_unique_id,
    TRIM(customer_zip_code_prefix) AS customer_zip_code_prefix,
    TRIM(customer_city) AS customer_city,
    TRIM(customer_state) AS customer_state
FROM raw.customers;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'staging.customers'::regclass AND contype = 'p'
    ) THEN
        ALTER TABLE staging.customers ADD PRIMARY KEY (customer_id);
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS staging.orders AS
SELECT
    TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,
    TRIM(order_status) AS order_status,
    NULLIF(TRIM(order_purchase_timestamp), '')::TIMESTAMP AS order_purchase_timestamp,
    NULLIF(TRIM(order_approved_at), '')::TIMESTAMP AS order_approved_at,
    NULLIF(TRIM(order_delivered_carrier_date), '')::TIMESTAMP AS order_delivered_carrier_date,
    NULLIF(TRIM(order_delivered_customer_date), '')::TIMESTAMP AS order_delivered_customer_date,
    NULLIF(TRIM(order_estimated_delivery_date), '')::TIMESTAMP AS order_estimated_delivery_date
FROM raw.orders;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'staging.orders'::regclass AND contype = 'p'
    ) THEN
        ALTER TABLE staging.orders ADD PRIMARY KEY (order_id);
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS staging.order_items AS
SELECT
    TRIM(order_id) AS order_id,
    NULLIF(TRIM(order_item_id), '')::INTEGER AS order_item_id,
    TRIM(product_id) AS product_id,
    TRIM(seller_id) AS seller_id,
    NULLIF(TRIM(shipping_limit_date), '')::TIMESTAMP AS shipping_limit_date,
    NULLIF(TRIM(price), '')::NUMERIC(12,2) AS price,
    NULLIF(TRIM(freight_value), '')::NUMERIC(12,2) AS freight_value
FROM raw.order_items;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'staging.order_items'::regclass AND contype = 'p'
    ) THEN
        ALTER TABLE staging.order_items ADD PRIMARY KEY (order_id, order_item_id);
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS staging.products AS
SELECT
    TRIM(product_id) AS product_id,
    TRIM(product_category_name) AS product_category_name,
    NULLIF(TRIM(product_name_lenght), '')::INTEGER AS product_name_length,
    NULLIF(TRIM(product_description_lenght), '')::INTEGER AS product_description_length,
    NULLIF(TRIM(product_photos_qty), '')::INTEGER AS product_photos_qty,
    NULLIF(TRIM(product_weight_g), '')::NUMERIC AS product_weight_g,
    NULLIF(TRIM(product_length_cm), '')::NUMERIC AS product_length_cm,
    NULLIF(TRIM(product_height_cm), '')::NUMERIC AS product_height_cm,
    NULLIF(TRIM(product_width_cm), '')::NUMERIC AS product_width_cm
FROM raw.products;

CREATE TABLE IF NOT EXISTS staging.sellers AS
SELECT
    TRIM(seller_id) AS seller_id,
    TRIM(seller_zip_code_prefix) AS seller_zip_code_prefix,
    TRIM(seller_city) AS seller_city,
    TRIM(seller_state) AS seller_state
FROM raw.sellers;

CREATE TABLE IF NOT EXISTS staging.order_payments AS
SELECT
    TRIM(order_id) AS order_id,
    NULLIF(TRIM(payment_sequential), '')::INTEGER AS payment_sequential,
    TRIM(payment_type) AS payment_type,
    NULLIF(TRIM(payment_installments), '')::INTEGER AS payment_installments,
    NULLIF(TRIM(payment_value), '')::NUMERIC(12,2) AS payment_value
FROM raw.order_payments;

CREATE TABLE IF NOT EXISTS staging.order_reviews AS
SELECT
    TRIM(review_id) AS review_id,
    TRIM(order_id) AS order_id,
    NULLIF(TRIM(review_score), '')::INTEGER AS review_score,
    NULLIF(TRIM(review_comment_title), '') AS review_comment_title,
    NULLIF(TRIM(review_comment_message), '') AS review_comment_message,
    NULLIF(TRIM(review_creation_date), '')::TIMESTAMP AS review_creation_date,
    NULLIF(TRIM(review_answer_timestamp), '')::TIMESTAMP AS review_answer_timestamp
FROM raw.order_reviews;

CREATE TABLE IF NOT EXISTS staging.geolocation AS
SELECT
    TRIM(geolocation_zip_code_prefix) AS geolocation_zip_code_prefix,
    NULLIF(TRIM(geolocation_lat), '')::NUMERIC AS geolocation_lat,
    NULLIF(TRIM(geolocation_lng), '')::NUMERIC AS geolocation_lng,
    TRIM(geolocation_city) AS geolocation_city,
    TRIM(geolocation_state) AS geolocation_state
FROM raw.geolocation;

CREATE TABLE IF NOT EXISTS staging.category_translation AS
SELECT
    TRIM(product_category_name) AS product_category_name,
    TRIM(product_category_name_english) AS product_category_name_english
FROM raw.category_translation;
