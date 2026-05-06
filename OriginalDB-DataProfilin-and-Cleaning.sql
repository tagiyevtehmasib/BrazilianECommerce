


USE BrazilianECommerce

-- All tables, their columns and their data types
SELECT Table_Name,
Column_Name,
Data_Type,
Character_Maximum_Length
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'BrazilianECommerce' 
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


-- DATA CLEANING PROCESS

--=========================================CATEGORY_NAMES TABLE==============================================================
-- Appoint the column names.

SELECT * FROM category_names

EXEC sp_rename 'category_names.column1', 'category_portugal'
EXEC sp_rename 'category_names.column2', 'category_english'

--Delete the first row, because previous column names were there.
DELETE FROM category_names
WHERE category_portuglar = 'product_category_name'

-- Make upper letter the first character of category_names.
UPDATE category_names SET category_portugal = LTRIM(category_portugal)
UPDATE category_names SET category_portugal = CONCAT(UPPER(LEFT(category_portugal, 1)), SUBSTRING(category_portugal, 2, LEN(category_portugal)))

UPDATE category_names SET category_english = LTRIM(category_english)
UPDATE category_names SET category_english = CONCAT(UPPER(LEFT(category_english, 1)), SUBSTRING(category_english, 2, LEN(category_english)))

-- Add ID (with auto-increament) column.
ALTER TABLE category_names 
ADD category_ID INT IDENTITY(1,1)

-- Add PK to category_ID.
ALTER TABLE category_names
ADD CONSTRAINT PK_category_ID PRIMARY KEY (category_ID)

--=========================================PRODUCT==============================================================
-- We will clean and arrange Product table, because there is Category NAme in here













































