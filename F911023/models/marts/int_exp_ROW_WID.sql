-- Purpose: Calculate ROW_WID using variables V1 and V2.

WITH row_wid_calculation AS (
    SELECT 
        tgt_table_name, 
        IIF(v2 = 0, :LKP.lkp_MAX_ROW_WID(tgt_table_name), v2) AS v1, 
        v1 + 1 AS v2, 
        v2 AS row_wid
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
)

SELECT 
    tgt_table_name, 
    v1, 
    v2, 
    row_wid
FROM row_wid_calculation