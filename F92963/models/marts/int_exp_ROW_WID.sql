-- Purpose: Calculate ROW_WID using variables V1 and V2
WITH row_wid_calculation AS (
    SELECT 
        TGT_TABLE_NAME,
        IIF(v2 = 0, :LKP.lkp_MAX_ROW_WID(TGT_TABLE_NAME), V2) AS v1,
        v1 + 1 AS v2
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
)
SELECT 
    TGT_TABLE_NAME, 
    v1, 
    v2
FROM row_wid_calculation