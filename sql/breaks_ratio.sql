WITH cte1 AS
(
	SELECT 
		fo.trade_id,
		fo.instrument,
		fo.quantity AS fo_quantity,
		bo.quantity AS bo_quantity,
		fo.quantity - bo.quantity AS quantity_diff
	FROM positions_front_office fo
	LEFT JOIN cash_back_office bo ON fo.trade_id = bo.trade_id
),

cte2 AS
(
	SELECT 
		*,
		CASE
			WHEN quantity_diff > 0 THEN 'Quantity Mismatch'
			WHEN bo_quantity IS NULL THEN 'Missing in back BO'
			ELSE 'Matched'
		END AS reconciliation_status
	FROM cte1
)

SELECT 
	reconciliation_status,
	COUNT(*) AS records_count,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS percentage_of_total
FROM cte2
GROUP BY reconciliation_status;


