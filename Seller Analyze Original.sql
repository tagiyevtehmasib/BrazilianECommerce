

USE BrazilianECommerce


/* 
	Let's start to Analyze!!!
*/


-- Analyze 1 : Sellers with above-average revenue.

-- First of all, let's find the total_revenue
SELECT SUM(price) FROM order_items
-- Output : 1359164370

-- Now, let's find the count of unique sellers.
SELECT COUNT(DISTINCT seller_id) FROM order_items
-- Output : 3095

-- So, this means that each seller must gain (1359164370 / 3095).
SELECT ROUND(SUM(price) / COUNT(DISTINCT seller_id), 3) FROM order_items
-- That is : 439148,423

WITH Each_Seller_Have_gained AS
(
	SELECT seller_id AS es_ID,
	SUM(price) AS es_have_gained
	FROM order_items
	GROUP BY seller_id
),
Total_Revenue AS
(
	SELECT DISTINCT seller_id AS tr_ID,
	SUM(price) OVER() AS whole_revenue
	FROM order_items
),
Seller_Must_Gane AS 
(
	SELECT tr_ID AS sm_ID,
	ROUND(whole_revenue / (SELECT COUNT(DISTINCT tr_ID) FROM Total_Revenue), 2) AS sm_amount
	FROM Total_Revenue
),
Above_Average_Revenue AS
(
	SELECT es.es_ID,
	es.es_have_gained,
	sm.sm_amount,
	tr.whole_revenue
	FROM Each_Seller_Have_gained es
	JOIN Total_Revenue tr
	ON es.es_ID = tr.tr_ID
	JOIN Seller_Must_Gane sm
	ON sm.sm_ID = tr.tr_ID
	WHERE es.es_have_gained > sm.sm_amount
)
SELECT COUNT(*) FROM Above_Average_Revenue

-- OUTPUT : 628
-- The analyze is in the "README" file.


--==============================================================================================================
--==============================================================================================================


-- Analyze 2 : Top Selling Product Trend.

SELECT i.product_id,
YEAR(o.order_purchase_timestamp) AS order_year,
MONTH(o.order_purchase_timestamp) AS order_month,
SUM(i.price) AS total_revenue
FROM order_items i
JOIN orders o
ON i.order_id = o.order_id
WHERE o.order_status = 'delivered' AND o.order_purchase_timestamp IS NOT NULL AND i.product_id = '00250175f79f584c14ab5cecd80553cd'
GROUP BY i.product_id,
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
ORDER BY 2, 3



WITH Volatility AS
(
	SELECT s.product_id,
	s.order_year,
	s.order_month,
	s.total_revenue,
	LAG(s.total_revenue, 1) OVER(PARTITION BY s.product_id ORDER BY s.product_id, s.order_year)  AS _lag,
	s.total_revenue - LAG(s.total_revenue) OVER(PARTITION BY s.product_id ORDER BY s.product_id, s.order_year) AS _conclusion,
	CASE
		WHEN s.total_revenue - LAG(s.total_revenue) OVER(PARTITION BY s.product_id ORDER BY s.product_id, s.order_year) > 0 THEN 'increasing'
		WHEN s.total_revenue - LAG(s.total_revenue) OVER(PARTITION BY s.product_id ORDER BY s.product_id, s.order_year) < 0 THEN 'decreasing'
		WHEN s.total_revenue - LAG(s.total_revenue) OVER(PARTITION BY s.product_id ORDER BY s.product_id, s.order_year) = 0 THEN 'stable'
		ELSE NULL
	END AS _volatility
	FROM 
	(
		SELECT i.product_id,
		YEAR(o.order_purchase_timestamp) AS order_year,
		MONTH(o.order_purchase_timestamp) AS order_month,
		SUM(i.price) AS total_revenue
		FROM order_items i
		JOIN orders o
		ON i.order_id = o.order_id
		WHERE o.order_status = 'delivered' AND o.order_purchase_timestamp IS NOT NULL 
		GROUP BY i.product_id,
		YEAR(o.order_purchase_timestamp),
		MONTH(o.order_purchase_timestamp)
	) AS s
),
voAnalyze AS
(
	SELECT product_id,
	order_year,
	_volatility,
	COUNT(_volatility) AS total_volatility
	FROM Volatility WHERE _volatility IS NOT NULL
	GROUP BY product_id,
	order_year,
	_volatility
),
Rank_Analyze AS
(
	SELECT product_id,
	order_year,
	_volatility,
	total_volatility,
	ROW_NUMBER() OVER(PARTITION BY product_id, order_year ORDER BY total_volatility DESC) AS _raw
	FROM voAnalyze
)
SELECT product_id,
order_year,
_volatility,
total_volatility
FROM Rank_Analyze WHERE _raw = 1 --AND product_id = '001b72dfd63e9833e8c02742adf472e3'
ORDER BY 1, 2



--==============================================================================================================
--==============================================================================================================



/* 
	Seller Concentration Analysis
*/

-- First Analyze : Identify the top 10 sellers by total revenue.
-- Note : Revenue = price + freight_value.

WITH Perfect_Seller AS
(
	SELECT seller_id,
	SUM(price + freight_value) OVER(PARTITION BY seller_id ORDER BY (price + freight_value) DESC) AS _total_revenue
	FROM order_items
),
Choose_One_Seller AS
(
	SELECT seller_id,
	_total_revenue,
	ROW_NUMBER() OVER(PARTITION BY seller_id ORDER BY _total_revenue DESC) AS _row
	FROM Perfect_Seller
),
Top_Ten AS
(
	SELECT seller_id,
	_total_revenue,
	ROW_NUMBER() OVER(ORDER BY _total_revenue DESC) AS _Last_Choose
	FROM Choose_One_Seller
	WHERE _row = 1
),
General_Revenue AS
(

	SELECT SUM(wr.whole_revenue) AS wr_whole_revenue, 
	(SELECT SUM(_total_revenue) AS total_ten_revenue FROM Top_Ten
	WHERE _Last_Choose BETWEEN 1 AND 10) AS ten_seller
	FROM 
	(
		SELECT SUM(price + freight_value) AS whole_revenue
		FROM order_items
		GROUP BY seller_id
	) AS wr
)
SELECT wr_whole_revenue,
ten_seller,
ROUND(CAST(ten_seller AS FLOAT) / CAST(wr_whole_revenue AS FLOAT), 3) * 100 AS _percentage
FROM General_Revenue
 


