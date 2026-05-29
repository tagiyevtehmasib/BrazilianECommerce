



USE BrazilianECommerce


-- \      
 --  \
  --   Most Popular Products by Region
 --  /
-- /

-- Question : For each region, identify the most sold product.


WITH Per_Region AS
(
	SELECT c.customer_state,
	oi.product_id,
	COUNT(oi.product_id) AS product_count
	FROM order_items oi
	JOIN orders o
		ON o.order_id = oi.order_id
	JOIN customers c
		ON c.customer_id = o.customer_id
	WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL 
	GROUP BY oi.product_id, c.customer_state
),
Region_Rank AS
(
	SELECT customer_state,
	product_id,
	product_count,
	RANK() OVER(PARTITION BY customer_state ORDER BY product_count DESC) AS _row_per_regionRank
	FROM Per_Region
)
SELECT customer_state,
product_id
FROM Region_Rank
WHERE _row_per_regionRank = 1
ORDER BY 1



--========================================================================================================
--========================================================================================================

