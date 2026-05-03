


USE CopyBrazilianECommerce

-- All tables, their columns and their data types
SELECT Table_Name,
Column_Name,
Data_Type,
Character_Maximum_Length
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'CopyBrazilianECommerce' 
ORDER BY TABLE_NAME, ORDINAL_POSITION


-- The copy of original database created, with .bak file.
-- Is the number of rows the same as in the original table?
USE BrazilianECommerce

SELECT COUNT(*) FROM category_names  -- 72
SELECT COUNT(*) FROM customers       -- 99441
SELECT COUNT(*) FROM geolocations    -- 1000163
SELECT COUNT(*) FROM order_items     -- 112650
SELECT COUNT(*) FROM order_payments  -- 103886
SELECT COUNT(*) FROM order_reviews   -- 99224
SELECT COUNT(*) FROM orders          -- 99441
SELECT COUNT(*) FROM products        -- 32951
SELECT COUNT(*) FROM sellers         -- 3095
--=============================================================================

USE CopyBrazilianECommerce

SELECT COUNT(*) FROM category_names  -- 72
SELECT COUNT(*) FROM customers       -- 99441
SELECT COUNT(*) FROM geolocations    -- 1000163
SELECT COUNT(*) FROM order_items     -- 112650
SELECT COUNT(*) FROM order_payments  -- 103886
SELECT COUNT(*) FROM order_reviews   -- 99224
SELECT COUNT(*) FROM orders          -- 99441
SELECT COUNT(*) FROM products        -- 32951
SELECT COUNT(*) FROM sellers         -- 3095

-- Yes, all the lines came in full.
--=============================================================================

SELECT order_id, 
COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1

SELECT COUNT(DISTINCT order_id) FROM orders

SELECT order_purchase_timestamp
FROM orders
WHERE TRY_CONVERT(DATETIME, order_purchase_timestamp) IS NULL
		AND order_purchase_timestamp IS NOT NULL