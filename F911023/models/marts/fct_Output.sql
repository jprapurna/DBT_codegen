-- Purpose: Write data to the target table.

WITH row_wid_calculation AS (
    SELECT 
        tgt_table_name, 
        v1, 
        v2, 
        row_wid
    FROM {{ ref('int_exp_ROW_WID') }}
)

SELECT 
    tgt_table_name, 
    v1, 
    v2, 
    row_wid
FROM row_wid_calculation