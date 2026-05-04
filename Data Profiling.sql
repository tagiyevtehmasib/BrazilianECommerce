


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

SELECT COUNT(*) FROM category_names
WHERE column1 IS NOT NULL OR column1 IS NULL OR  column2 IS NOT NULL OR column2 IS NULL

SELECT * FROM customers
SELECT * FROM geolocations
SELECT * FROM order_items
SELECT * FROM order_payments
SELECT * FROM order_reviews
SELECT * FROM orders
SELECT * FROM products
SELECT * FROM sellers



SELECT * FROM order_items
WHERE order_id = '0008288aa423d2a3f00fcb17cd7d8719'















