-- Purpose: Write data to the target table
WITH output_data AS (
    SELECT 
        TGT_TABLE_NAME, 
        V1, 
        V2, 
        ROW_WID
    FROM {{ ref('int_exp_ROW_WID') }}
)
SELECT 
    TGT_TABLE_NAME, 
    V1, 
    V2, 
    ROW_WID 
FROM output_data