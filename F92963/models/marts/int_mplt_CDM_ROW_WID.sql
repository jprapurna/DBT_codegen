-- Purpose: Process target table name and row identifier
WITH row_wid_data AS (
    SELECT 
        TGT_TABLE_NAME,
        ROW_WID
    FROM {{ source('genai_power_bi', 'LKP_MAX_ROW_WID') }}
)
SELECT 
    TGT_TABLE_NAME, 
    ROW_WID
FROM row_wid_data