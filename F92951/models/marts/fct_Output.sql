-- Purpose: Writes data to output target mapping ROW_ID to ROW_WID.
WITH output AS (
    SELECT 
        ROW_WID AS row_id
    FROM 
        {{ ref('int_exp_ROW_WID') }}
)
SELECT 
    row_id
FROM 
    output