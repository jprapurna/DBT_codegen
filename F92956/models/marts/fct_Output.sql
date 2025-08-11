-- Purpose: Write data to target table.

SELECT 
    TGT_TABLE_NAME,
    ROW_WID
FROM {{ ref('int_exp_ROW_WID') }}