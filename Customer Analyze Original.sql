

USE BrazilianECommerce


-- \      
 --  \
  --   Customer Purchase Behavior Over Time
 --  /
-- /

-- First Analyze : For each customer, determine the date of their first order.


WITH First_Order AS
(
	SELECT c.customer_unique_id,
	c.customer_id,
	o.order_id,
	o.order_purchase_timestamp,
	ROW_NUMBER() OVER(PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp ASC) AS _MinDate
	FROM customers c 
	JOIN orders o
	ON c.customer_id = o.customer_id
	WHERE o.order_status = 'delivered'
)
SELECT * FROM First_Order
WHERE _MinDate = 1



--========================================================================================================
--========================================================================================================

-- Second Analyze : Analyze the subsequent purchase behavior:
--	How many customers placed only 1 order
--	How many placed 2 or more orders

WITH Each_Customer_Order_Count AS
(
	SELECT c.customer_unique_id,
	COUNT(o.order_id) AS total_count
	FROM customers c 
	JOIN orders o
	ON c.customer_id = o.customer_id
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id
),
Order_Segmentation AS
(
	SELECT customer_unique_id,
	total_count,
	CASE 
		WHEN total_count = 1 THEN 'one'
		ELSE 'twoormore'
	END AS 'segmentation'
	FROM Each_Customer_Order_Count
),
Grouping_Of_Segmentation AS
(
	SELECT segmentation,
	COUNT(segmentation) AS end_segmentation
	FROM Order_Segmentation
	GROUP BY segmentation
)
SELECT segmentation,
end_segmentation,
ROUND(CAST(end_segmentation AS FLOAT) / CAST(SUM(end_segmentation) OVER() AS FLOAT), 3) * 100
FROM Grouping_Of_Segmentation