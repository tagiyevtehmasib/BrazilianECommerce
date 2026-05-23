

USE BrazilianECommerce

-- Top Revenue Generating Product Categories

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























