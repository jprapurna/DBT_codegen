-- Purpose: Generate ROW_WID based on input TGT_TABLE_NAME
WITH row_wid_data AS (
    SELECT 
        TGT_TABLE_NAME,
        ROW_WID
    FROM {{ ref('int_EXP_Flag') }}
)
SELECT 
    TGT_TABLE_NAME, 
    ROW_WID 
FROM row_wid_data