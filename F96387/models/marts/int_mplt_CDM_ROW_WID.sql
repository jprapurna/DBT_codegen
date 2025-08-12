-- Purpose: Generate ROW_WID based on input TGT_TABLE_NAME
WITH row_wid_data AS (
    SELECT 
        ROW_WID
    FROM {{ ref('int_lkp_MAX_ROW_WID') }}
)
SELECT 
    ROW_WID
FROM row_wid_data