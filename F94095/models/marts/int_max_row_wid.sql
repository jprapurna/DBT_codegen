-- Purpose: Intermediate model for ROW_WID calculation
WITH row_wid_data AS (
    SELECT 
        ROW_WID,
        ROW_WID + 1 AS NEW_ROW_WID
    FROM {{ ref('stg_max_row_wid') }}
)
SELECT * FROM row_wid_data