

USE BrazilianECommerce


-- First Analyze
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


































