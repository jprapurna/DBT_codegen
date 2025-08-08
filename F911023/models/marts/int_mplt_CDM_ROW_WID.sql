-- Purpose: Generate ROW_WID based on input TGT_TABLE_NAME.

WITH generated_row_wid AS (
    SELECT 
        tgt_table_name, 
        ROW_WID
    FROM {{ ref('int_CDH_GW_BUR') }}
)

SELECT 
    tgt_table_name, 
    ROW_WID
FROM generated_row_wid