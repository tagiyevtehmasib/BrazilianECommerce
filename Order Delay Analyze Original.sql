

USE CopyBrazilianECommerce



-- \      
 --  \
  --   Delivery Delay Analysis
 --  /
-- /

-- First and Second Analyze in together : Calculate the difference between the real delivery date and the estimated delivery date for each order.

WITH Determine_Status_Delivered AS
(
	SELECT order_id,
	DATEDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date) AS _differences
	FROM orders
	WHERE order_status = 'delivered' 
),
Determine_Delay AS
(
	SELECT order_id,
	CASE 
		WHEN _differences >= 0 THEN 'nodelay'
		ELSE 'delay'
	END AS date_group
	FROM Determine_Status_Delivered
)
SELECT date_group,
COUNT(date_group)
FROM Determine_Delay
GROUP BY date_group

--========================================================================================================
--========================================================================================================

-- First and Second Analyze in together : For each seller, calculate the percentage of delayed orders.

WITH Delay_Order AS
(
	SELECT s.seller_id,
	CASE WHEN s._differences >= 0 THEN 'nodelay'
		 WHEN s._differences < 0 THEN 'delay' 
	END AS _Delays
	FROM 
	(
		SELECT i.seller_id,
		o.order_delivered_customer_date,
		o.order_estimated_delivery_date,
		DATEDIFF(DAY, o.order_delivered_customer_date, o.order_estimated_delivery_date) AS _differences 
		FROM order_items i
		JOIN orders o 
		ON i.order_id = o.order_id
		WHERE o.order_status = 'delivered' 
			  AND o.order_estimated_delivery_date IS NOT NULL 
			  AND o.order_delivered_customer_date IS NOT NULL
	) AS s
),
Total_Count_Deay AS
(
	SELECT seller_id,
	_Delays,
	COUNT(_Delays) AS seller_delay_count
	FROM Delay_Order
	GROUP BY seller_id, _Delays
),
Sel_TotalOrder AS
(
	SELECT seller_id,
	_Delays,
	seller_delay_count,
	SUM(seller_delay_count) OVER(PARTITION BY seller_id) AS whole_delay
	FROM Total_Count_Deay
)
SELECT seller_id,
_Delays,
seller_delay_count,
whole_delay,
ROUND(CAST(seller_delay_count AS FLOAT) / CAST(whole_delay AS FLOAT), 4) * 100 AS percentage_delay
FROM Sel_TotalOrder 
WHERE _Delays = 'delay'


















