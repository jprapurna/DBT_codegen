-- Purpose: Write data to target table
WITH output_data AS (
    SELECT 
        TGT_TABLE_NAME, 
        v1, 
        v2
    FROM {{ ref('int_exp_ROW_WID') }}
)
SELECT 
    TGT_TABLE_NAME, 
    v1, 
    v2
FROM output_data