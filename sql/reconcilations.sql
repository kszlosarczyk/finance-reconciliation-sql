WITH reconciliation AS (
    SELECT
        fo.trade_id,
        fo.instrument,
        fo.quantity AS fo_quantity,
        bo.quantity AS bo_quantity,
        fo.quantity - bo.quantity AS quantity_diff
    FROM positions_front_office fo
    LEFT JOIN cash_back_office bo
        ON fo.trade_id = bo.trade_id
)
SELECT
    *,
    CASE
        WHEN bo_quantity IS NULL THEN 'Missing in BO'
        WHEN quantity_diff <> 0 THEN 'Quantity mismatch'
        ELSE 'Matched'
    END AS reconciliation_status
FROM reconciliation;
