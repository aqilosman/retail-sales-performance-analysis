-- =====================================================
-- Retail Sales & Profitability Analysis
-- SQL Portfolio Project
-- =====================================================

USE retail_sales_db;

-- =====================================================
-- 1. DATASET OVERVIEW
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT category) AS total_categories,
    COUNT(DISTINCT region) AS total_regions,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percent
FROM orders;

-- =====================================================
-- 2. SALES PERFORMANCE & YEAR-OVER-YEAR GROWTH
-- =====================================================

WITH yearly_sales AS (
    SELECT
        YEAR(order_date) AS year,
        ROUND(SUM(sales), 2) AS total_sales
    FROM orders
    GROUP BY YEAR(order_date)
)

SELECT
    year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year) AS previous_year_sales,
    ROUND(
        ((total_sales - LAG(total_sales) OVER (ORDER BY year))
        / LAG(total_sales) OVER (ORDER BY year)) * 100,
        2
    ) AS yoy_growth_percent
FROM yearly_sales
ORDER BY year;

-- =====================================================
-- 3. CATEGORY PROFITABILITY
-- =====================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percent
FROM orders
GROUP BY category
ORDER BY profit_margin_percent DESC;

-- =====================================================
-- 4. DISCOUNT IMPACT ON PROFITABILITY
-- =====================================================

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.20 THEN 'Low Discount (1-20%)'
        WHEN discount <= 0.40 THEN 'Medium Discount (21-40%)'
        ELSE 'High Discount (>40%)'
    END AS discount_level,
    COUNT(*) AS transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percent
FROM orders
GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.20 THEN 'Low Discount (1-20%)'
        WHEN discount <= 0.40 THEN 'Medium Discount (21-40%)'
        ELSE 'High Discount (>40%)'
    END
ORDER BY profit_margin_percent DESC;

-- =====================================================
-- 5. REGIONAL PERFORMANCE
-- =====================================================

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percent
FROM orders
GROUP BY region
ORDER BY total_profit DESC;

-- =====================================================
-- 6. LOSS-MAKING SUB-CATEGORIES
-- =====================================================

SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percent
FROM orders
GROUP BY category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- =====================================================
-- 7. CUSTOMER PROFITABILITY
-- =====================================================

SELECT
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percent
FROM orders
GROUP BY customer_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;

-- =====================================================
-- 8. SHIPPING PERFORMANCE
-- =====================================================

SELECT
    ship_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percent,
    ROUND(
        AVG(DATEDIFF(ship_date, order_date)),
        2
    ) AS avg_shipping_days
FROM orders
GROUP BY ship_mode
ORDER BY total_sales DESC;













































































