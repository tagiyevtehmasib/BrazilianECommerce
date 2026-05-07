


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
WHERE category_portugal = 'product_category_name'

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

--=========================================PRODUCTS TABLE=======================================================================
-- We will clean and arrange Product table, because there is Category NAme in here

-- Add category_ID column to Product Table.
ALTER TABLE products ADD category_ID INT

-- Add match data from Category Table.
UPDATE p SET p.category_ID = c.category_ID
FROM products p 
JOIN category_names c 
ON c.category_portugal = p.product_category_name

-- Add FK to category_ID column in the Product Table.
ALTER TABLE products ADD CONSTRAINT
FK_Product_Category FOREIGN KEY (category_ID)
REFERENCES category_names (category_ID)

-- These don't exist at all, but they are in the product table.
SELECT * FROM products WHERE product_category_name IS NOT NULL AND category_ID IS NULL

-- We add them to the category table.
INSERT INTO category_names (category_portugal) VALUES
('pc_gamer'),
('portateis_cozinha_e_preparadores_de_alimentos')


-- And then bring them into the same format as the others.
UPDATE category_names SET category_portugal = LTRIM(category_portugal) 
WHERE category_ID IN(72, 73)
UPDATE category_names SET category_portugal = CONCAT(UPPER(LEFT(category_portugal, 1)), SUBSTRING(category_portugal, 2, LEN(category_portugal))) 
WHERE category_ID IN(72, 73)

-- And finally, we add their IDs to the product table.
UPDATE p SET p.category_ID = c.category_ID
FROM products p 
JOIN category_names c 
ON c.category_portugal = p.product_category_name
WHERE p.product_category_name IS NOT NULL AND p.category_ID IS NULL
--(13 rows affected)

-- Delete product_category_name Column, because there is already category_ID column.
ALTER TABLE products
DROP COLUMN product_category_name

-- Add PK to product_id, because for relation.
ALTER TABLE products ADD CONSTRAINT 
PK_Product_ID PRIMARY KEY (product_id)


--=========================================ORDERS ITEMS TABLE==============================================================
-- Change the false data types.

-- Make the relations with orders table, products table and sellers table.

-- Give the PK to seller_id in the sellers table.
ALTER TABLE sellers ADD CONSTRAINT
PK_Seller_ID PRIMARY KEY (seller_id)

-- Give the PK to order_id in the orders table.
ALTER TABLE orders ADD CONSTRAINT
PK_Order_ID PRIMARY KEY (order_id)

-- Give the PK to product_id in the products table.
ALTER TABLE products ADD CONSTRAINT
PK_Product_ID PRIMARY KEY (product_id)

-- Now, make the many_to_many relation, our middle table is order_items table.
ALTER TABLE order_items ADD CONSTRAINT
FK_Orders_Items FOREIGN KEY (order_id)
REFERENCES orders (order_id)

ALTER TABLE order_items ADD CONSTRAINT
FK_Sellers_Items FOREIGN KEY (seller_id)
REFERENCES sellers (seller_id)

ALTER TABLE order_items ADD CONSTRAINT
FK_Products_Items FOREIGN KEY (product_id)
REFERENCES products (product_id)

-- Convert the data type of "shipping_limit_date", use DATETIME2(0) instead of DATETIME2(7).
SELECT TRY_CAST(shipping_limit_date AS DATETIME2(0)) FROM order_items

ALTER TABLE order_items ALTER COLUMN
shipping_limit_date DATETIME2(0)

SELECT * FROM order_items

--=========================================PAYMENTS TABLE==============================================================
-- First of all, before add the FK to order_id, we must add the not null constraint to order_id.

ALTER TABLE order_payments ALTER COLUMN
order_id NVARCHAR(50) NOT NULL

ALTER TABLE order_payments ADD CONSTRAINT
FK_Order_ID FOREIGN KEY (order_id)
REFERENCES orders (order_id)

--=========================================REVIEWS TABLE==============================================================

























































