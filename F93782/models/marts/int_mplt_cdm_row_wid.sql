-- Purpose: Generates ROW_WID based on input TGT_TABLE_NAME.
SELECT 
    ROW_WID
FROM {{ ref('int_lkp_max_row_wid') }}