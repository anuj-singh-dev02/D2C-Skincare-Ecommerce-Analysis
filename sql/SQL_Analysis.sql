-- D2C SKINCARE E-COMMERCE DATA ANALYSIS
-- SQL Analysis Script
-- Database: PostgreSQL
-- Tools: PostgreSQL / pgAdmin
--
-- Primary revenue metric:
-- Order_Items.item_total
-- This represents product/order-item revenue and is used consistently
-- for revenue, AOV, monthly sales, acquisition revenue, and profit.



-- ============================================================
-- 01. DATABASE SETUP
-- ============================================================

-- Customers

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    gender VARCHAR(20),
    age_group VARCHAR(20),
    signup_date TEXT,
    acquisition_channel VARCHAR(50)
);

-- Orders

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date TEXT,
    order_status VARCHAR(30),
    payment_method VARCHAR(30),
    sales_channel VARCHAR(30),
    gross_amount NUMERIC(12,2),
    discount_amount NUMERIC(12,2),
    shipping_fee NUMERIC(12,2),
    final_amount NUMERIC(12,2),
    delivered_date TEXT
);

-- Products

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(50),
    concern VARCHAR(100),
    skin_type VARCHAR(100),
    key_ingredient VARCHAR(100),
    size VARCHAR(50),
    mrp NUMERIC(12,2),
    cost_price NUMERIC(12,2),
    stock_qty INTEGER,
    launch_date TEXT
);

-- Order Items

CREATE TABLE order_items (
    order_item_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INTEGER,
    unit_price NUMERIC(12,2),
    discount_pct NUMERIC(5,2),
    item_total NUMERIC(12,2)
);

-- Returns

CREATE TABLE returns (
    return_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    return_date TEXT,
    return_reason VARCHAR(100),
    refund_status VARCHAR(50)
);

-- Reviews

CREATE TABLE reviews (
    review_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    order_id VARCHAR(20),
    rating INTEGER,
    review_date TEXT
);


-- ============================================================
-- 02. DATA PREPARATION & RELATIONSHIPS
-- ============================================================

-- Convert text date columns to DATE

ALTER TABLE customers
ALTER COLUMN signup_date TYPE DATE
USING TO_DATE(signup_date, 'DD-MM-YYYY');

ALTER TABLE orders
ALTER COLUMN order_date TYPE DATE
USING TO_DATE(order_date, 'DD-MM-YYYY');

ALTER TABLE products
ALTER COLUMN launch_date TYPE DATE
USING TO_DATE(launch_date, 'DD-MM-YYYY');

ALTER TABLE returns
ALTER COLUMN return_date TYPE DATE
USING TO_DATE(return_date, 'DD-MM-YYYY');

ALTER TABLE reviews
ALTER COLUMN review_date TYPE DATE
USING TO_DATE(review_date, 'DD-MM-YYYY');

-- Foreign key relationships

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE returns
ADD CONSTRAINT fk_returns_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE returns
ADD CONSTRAINT fk_returns_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- ============================================================
-- 03. DATA OVERVIEW
-- ============================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'returns', COUNT(*) FROM returns
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
ORDER BY table_name;


-- ============================================================
-- 04. CUSTOMER ANALYSIS
-- ============================================================

-- Customers by gender

SELECT
    gender,
    COUNT(*) AS customer_count
FROM customers
GROUP BY gender
ORDER BY customer_count DESC;

-- Customers by acquisition channel

SELECT
    acquisition_channel,
    COUNT(*) AS customer_count
FROM customers
GROUP BY acquisition_channel
ORDER BY customer_count DESC;

-- Customers by age group

SELECT
    age_group,
    COUNT(*) AS customer_count
FROM customers
GROUP BY age_group
ORDER BY customer_count DESC;

-- Customers by state

SELECT
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;


-- ============================================================
-- 05. ORDER & SALES ANALYSIS
-- ============================================================

-- Orders by status

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Orders by payment method

SELECT
    payment_method,
    COUNT(*) AS order_count
FROM orders
GROUP BY payment_method
ORDER BY order_count DESC;

-- Orders by sales channel

SELECT
    sales_channel,
    COUNT(*) AS order_count
FROM orders
GROUP BY sales_channel
ORDER BY order_count DESC;

-- Total orders, customers, product revenue and AOV

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS customers_with_orders,
    ROUND(SUM(oi.item_total), 2) AS product_revenue,
    ROUND(
        SUM(oi.item_total) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;

-- Total units sold

SELECT
    SUM(quantity) AS total_units_sold
FROM order_items;

-- Average selling price

SELECT
    ROUND(AVG(unit_price), 2) AS average_unit_price
FROM order_items;


-- ============================================================
-- 06. CUSTOMER PURCHASE BEHAVIOR
-- ============================================================

-- Number of orders placed by each customer

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC;

-- Customers with no orders

SELECT
    c.customer_id,
    c.customer_name,
    c.acquisition_channel
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- One-time vs repeat customers

SELECT
    customer_id,
    COUNT(order_id) AS order_count,
    CASE
        WHEN COUNT(order_id) = 1 THEN 'One-Time'
        WHEN COUNT(order_id) > 1 THEN 'Repeat'
    END AS customer_type
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC;

-- Count customers by purchase type

SELECT
    customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) = 1 THEN 'One-Time'
            WHEN COUNT(order_id) > 1 THEN 'Repeat'
        END AS customer_type
    FROM orders
    GROUP BY customer_id
) AS customer_segments
GROUP BY customer_type
ORDER BY customer_count DESC;


-- ============================================================
-- 07. PRODUCT ANALYSIS
-- ============================================================

-- Products by category

SELECT
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;

-- Products by skin type

SELECT
    skin_type,
    COUNT(*) AS product_count
FROM products
GROUP BY skin_type
ORDER BY product_count DESC;

-- Products by concern

SELECT
    concern,
    COUNT(*) AS product_count
FROM products
GROUP BY concern
ORDER BY product_count DESC;

-- Product MRP, cost and potential margin

SELECT
    product_id,
    product_name,
    category,
    mrp,
    cost_price,
    ROUND(mrp - cost_price, 2) AS potential_margin
FROM products
ORDER BY potential_margin DESC;

-- Products with low stock

SELECT
    product_id,
    product_name,
    stock_qty
FROM products
WHERE stock_qty < 50
ORDER BY stock_qty ASC;

-- Products sorted by MRP

SELECT
    product_name,
    category,
    mrp
FROM products
ORDER BY mrp DESC;

-- Total quantity sold by product

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;

-- Revenue and units sold by product

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.item_total), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC;

-- Revenue and units sold by category

SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.item_total), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- ============================================================
-- 08. SALES TREND ANALYSIS
-- ============================================================

-- Monthly revenue using Order_Items[item_total]

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.item_total), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;

-- Monthly order count

SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- Monthly AOV using product revenue

SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS revenue,
    ROUND(
        SUM(oi.item_total) / COUNT(DISTINCT o.order_id),
        2
    ) AS aov
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;


-- ============================================================
-- 09. ACQUISITION & MARKETING ANALYSIS
-- ============================================================

-- Customers by acquisition channel

SELECT
    acquisition_channel,
    COUNT(*) AS total_customers
FROM customers
GROUP BY acquisition_channel
ORDER BY total_customers DESC;

-- Customers who actually placed an order

SELECT
    c.acquisition_channel,
    COUNT(DISTINCT c.customer_id) AS customers_with_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.acquisition_channel
ORDER BY customers_with_orders DESC;

-- Acquisition channel conversion rate

SELECT
    c.acquisition_channel,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT o.customer_id) AS customers_with_orders,
    ROUND(
        COUNT(DISTINCT o.customer_id) * 100.0
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS conversion_rate
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.acquisition_channel
ORDER BY conversion_rate DESC;

-- Revenue by acquisition channel

SELECT
    c.acquisition_channel,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.item_total), 2) AS revenue,
    ROUND(
        SUM(oi.item_total) / COUNT(DISTINCT o.order_id),
        2
    ) AS aov
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.acquisition_channel
ORDER BY revenue DESC;


-- ============================================================
-- 10. RETURNS ANALYSIS
-- ============================================================

-- Total returned orders

SELECT
    COUNT(DISTINCT order_id) AS returned_orders
FROM returns;

-- Return reasons

SELECT
    return_reason,
    COUNT(*) AS return_count
FROM returns
GROUP BY return_reason
ORDER BY return_count DESC;

-- Return reasons with percentage

SELECT
    return_reason,
    COUNT(*) AS return_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS return_percentage
FROM returns
GROUP BY return_reason
ORDER BY return_count DESC;

-- Product return count

SELECT
    p.product_id,
    p.product_name,
    COUNT(r.return_id) AS return_count
FROM products p
LEFT JOIN returns r
    ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY return_count DESC;

-- Product units sold vs return count
-- Separate aggregations avoid multiplying units sold by return rows.

WITH product_units AS (
    SELECT
        product_id,
        SUM(quantity) AS units_sold
    FROM order_items
    GROUP BY product_id
),
product_returns AS (
    SELECT
        product_id,
        COUNT(*) AS return_count
    FROM returns
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    COALESCE(pu.units_sold, 0) AS units_sold,
    COALESCE(pr.return_count, 0) AS return_count,
    ROUND(
        COALESCE(pr.return_count, 0) * 100.0
        / NULLIF(pu.units_sold, 0),
        2
    ) AS return_rate
FROM products p
LEFT JOIN product_units pu
    ON p.product_id = pu.product_id
LEFT JOIN product_returns pr
    ON p.product_id = pr.product_id
ORDER BY return_rate DESC NULLS LAST;

-- Overall return rate

SELECT
    COUNT(DISTINCT r.order_id) AS returned_orders,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT r.order_id) * 100.0
        / COUNT(DISTINCT o.order_id),
        2
    ) AS return_rate
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id;

-- Returned order value

SELECT
    ROUND(SUM(o.gross_amount), 2) AS returned_order_value
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM returns r
    WHERE r.order_id = o.order_id
);


-- ============================================================
-- 11. REVIEWS & RATINGS ANALYSIS
-- ============================================================

-- Rating distribution

SELECT
    rating,
    COUNT(*) AS review_count
FROM reviews
GROUP BY rating
ORDER BY rating;

-- Overall average rating

SELECT
    ROUND(AVG(rating), 2) AS average_rating
FROM reviews;

-- Reviews and average rating by product

SELECT
    p.product_id,
    p.product_name,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
LEFT JOIN reviews r
    ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC NULLS LAST;

-- Rating by category

SELECT
    p.category,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
JOIN reviews r
    ON p.product_id = r.product_id
GROUP BY p.category
ORDER BY average_rating DESC;

-- Low-rated products

SELECT
    p.product_id,
    p.product_name,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
JOIN reviews r
    ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) < 3.5
ORDER BY average_rating ASC;


-- ============================================================
-- 12. PROFITABILITY ANALYSIS
-- ============================================================

-- Product-level estimated profit

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.item_total), 2) AS revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2) AS product_cost,
    ROUND(
        SUM(oi.item_total)
        - SUM(oi.quantity * p.cost_price),
        2
    ) AS estimated_profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY estimated_profit DESC;

-- Product-level estimated profit margin

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.item_total), 2) AS revenue,
    ROUND(
        SUM(oi.item_total)
        - SUM(oi.quantity * p.cost_price),
        2
    ) AS estimated_profit,
    ROUND(
        (
            SUM(oi.item_total)
            - SUM(oi.quantity * p.cost_price)
        ) * 100.0
        / NULLIF(SUM(oi.item_total), 0),
        2
    ) AS profit_margin
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY profit_margin DESC;

-- Overall estimated gross profit and margin

SELECT
    ROUND(SUM(oi.item_total), 2) AS revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2) AS product_cost,
    ROUND(
        SUM(oi.item_total)
        - SUM(oi.quantity * p.cost_price),
        2
    ) AS estimated_profit,
    ROUND(
        (
            SUM(oi.item_total)
            - SUM(oi.quantity * p.cost_price)
        ) * 100.0
        / NULLIF(SUM(oi.item_total), 0),
        2
    ) AS gross_margin
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- 13. CTE ANALYSIS
-- ============================================================

-- Customer order and spending summary

WITH customer_orders AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.item_total) AS total_spent
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    customer_id,
    total_orders,
    ROUND(total_spent, 2) AS total_spent
FROM customer_orders
ORDER BY total_spent DESC;

-- High-value customers

WITH customer_orders AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.item_total) AS total_spent
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    customer_id,
    total_orders,
    ROUND(total_spent, 2) AS total_spent
FROM customer_orders
WHERE total_spent > 5000
ORDER BY total_spent DESC;


-- ============================================================
-- 14. WINDOW FUNCTIONS
-- ============================================================

-- Rank products by revenue

SELECT
    p.product_name,
    ROUND(SUM(oi.item_total), 2) AS revenue,
    RANK() OVER (
        ORDER BY SUM(oi.item_total) DESC
    ) AS revenue_rank
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue_rank;

-- Rank products within each category

SELECT
    p.category,
    p.product_name,
    ROUND(SUM(oi.item_total), 2) AS revenue,
    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(oi.item_total) DESC
    ) AS category_rank
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category, p.product_id, p.product_name
ORDER BY p.category, category_rank;

-- Top product in each category

WITH product_ranking AS (
    SELECT
        p.category,
        p.product_name,
        SUM(oi.item_total) AS revenue,
        RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(oi.item_total) DESC
        ) AS category_rank
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY p.category, p.product_id, p.product_name
)
SELECT
    category,
    product_name,
    ROUND(revenue, 2) AS revenue
FROM product_ranking
WHERE category_rank = 1
ORDER BY revenue DESC;


-- ============================================================
-- 15. CUSTOMER SEGMENTATION
-- ============================================================

-- Customer spending segments

WITH customer_spending AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.item_total) AS total_spent
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    customer_id,
    total_orders,
    ROUND(total_spent, 2) AS total_spent,
    CASE
        WHEN total_spent >= 5000 THEN 'High Value'
        WHEN total_spent >= 2500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spent DESC;

-- Count customers in each segment

WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(oi.item_total) AS total_spent
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    CASE
        WHEN total_spent >= 5000 THEN 'High Value'
        WHEN total_spent >= 2500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count
FROM customer_spending
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- ============================================================
-- 16. REVENUE VALIDATION / DATA QUALITY FINDING
-- ============================================================

-- Compare product-level revenue with order gross amount

WITH item_revenue AS (
    SELECT
        order_id,
        SUM(item_total) AS item_revenue
    FROM order_items
    GROUP BY order_id
)
SELECT
    ROUND(SUM(ir.item_revenue), 2) AS item_revenue,
    ROUND(SUM(o.gross_amount), 2) AS gross_amount,
    ROUND(
        SUM(ir.item_revenue) - SUM(o.gross_amount),
        2
    ) AS difference
FROM item_revenue ir
JOIN orders o
    ON ir.order_id = o.order_id;

-- Check whether final_amount follows:
-- gross_amount - discount_amount + shipping_fee

SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE ABS(
            final_amount
            - (gross_amount - discount_amount + shipping_fee)
        ) > 0.01
    ) AS mismatched_orders,
    ROUND(
        COUNT(*) FILTER (
            WHERE ABS(
                final_amount
                - (gross_amount - discount_amount + shipping_fee)
            ) > 0.01
        ) * 100.0 / COUNT(*),
        2
    ) AS mismatch_percentage
FROM orders;

-- Status-wise order value

SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(SUM(gross_amount), 2) AS gross_value,
    ROUND(SUM(final_amount), 2) AS final_value
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;


------------- END ANALYSIS -------------

