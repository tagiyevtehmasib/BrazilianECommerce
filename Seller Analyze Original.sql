

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




 


