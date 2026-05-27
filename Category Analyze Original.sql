

USE BrazilianECommerce

-- \      
 --  \
  --   Top Revenue Generating Product Categories
 --  /
-- /

-- First Analyze : Identify the top 10 product categories that generate the highest revenue.

SELECT TOP(10) c.category_english,
SUM(i.price) AS total_price
FROM order_items i
JOIN orders o
ON i.order_id = o.order_id
JOIN products p
ON p.product_id = i.product_id
JOIN category_names c
ON c.category_ID = p.category_ID
WHERE o.order_status = 'delivered' 
AND p.category_ID IS NOT NULL
GROUP BY c.category_english
ORDER BY 2 DESC

--========================================================================================================
--========================================================================================================


-- Second Analyze : For each category, calculate: Total Revenue and Number of Orders.

WITH Total_Order AS
(
	SELECT a.category_ID,
	COUNT(a.total_order_count) AS total_unique_order
	FROM 
	(
		SELECT p.category_ID,
		t.product_id,
		COUNT(t.order_id) AS total_order_count
		FROM
		(
			SELECT i.order_id,
			i.product_id
			FROM order_items i
			JOIN orders o
			ON i.order_id = o.order_id
			WHERE o.order_status = 'delivered'
			GROUP BY i.order_id,
			i.product_id
		) AS t
		JOIN products p
		ON p.product_id = t.product_id
		JOIN category_names c
		ON c.category_ID = p.category_ID
		GROUP BY p.category_ID,
		t.product_id
	) AS a
	GROUP BY a.category_ID
),
Total_Revenue AS
(
	SELECT c.category_english,
	SUM(i.price) AS total_price
	FROM order_items i
	JOIN orders o
	ON i.order_id = o.order_id
	JOIN products p
	ON p.product_id = i.product_id
	JOIN category_names c
	ON c.category_ID = p.category_ID
	WHERE o.order_status = 'delivered' 
	AND p.category_ID IS NOT NULL
	GROUP BY c.category_english
)
SELECT o.category_ID,
o.total_unique_order,
r.total_price,
c.category_english
FROM Total_Order o
JOIN category_names c
ON c.category_ID = o.category_ID
JOIN Total_Revenue r
ON c.category_english = r.category_english
ORDER BY 1

--========================================================================================
--========================================================================================


-- \      
 --  \
  --   Relationship Between Review Score and Delivery Time
 --  /
-- /

-- First Analyze : Analyze whether there is a relationship between review score and delivery time.
-- The questions of first anaylze \/

-- o Use orders and reviews tables.
-- o Delivery time can be calculated as the difference between order_delivered_customer_date and order_purchase_timestamp.
-- o Join with reviews to get review_score.

WITH Delivered_Date AS 
(
	SELECT o.order_id,
	DATEDIFF(DAY, o.order_purchase_timestamp,o.order_delivered_customer_date) AS _delivered,
	DATEDIFF(DAY, o.order_purchase_timestamp, o.order_estimated_delivery_date) AS _can_have_delivered,
	AVG(r.review_score) AS _AvgScore
	FROM order_reviews r
	JOIN orders o
	ON r.order_id = o.order_id
	WHERE o.order_status = 'delivered' 
	GROUP BY o.order_id,
	DATEDIFF(DAY, o.order_purchase_timestamp,o.order_delivered_customer_date) ,
	DATEDIFF(DAY, o.order_purchase_timestamp, o.order_estimated_delivery_date)

),
Satisfaction AS 
(
	SELECT order_id,
	CASE
		WHEN (_can_have_delivered - _delivered) = 0 THEN 'normal'
		WHEN (_can_have_delivered - _delivered) < 0 THEN 'bad'
		WHEN (_can_have_delivered - _delivered) > 0 THEN 'good'
		ELSE NULL
	END AS _rank
	FROM Delivered_Date
)
SELECT d.order_id,
d._delivered,
d._can_have_delivered,
d._AvgScore,
s._rank
FROM Delivered_Date d 
JOIN Satisfaction s
ON s.order_id = d.order_id


SELECT o.order_id FROM orders o WHERE o.order_status = 'delivered'
AND o.order_id = ANY(SELECT r.order_id FROM order_reviews r)

























