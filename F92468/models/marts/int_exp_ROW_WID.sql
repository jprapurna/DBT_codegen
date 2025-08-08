-- Purpose: Calculate ROW_WID using variables V1 and V2
WITH row_wid_data AS (
    SELECT 
        TGT_TABLE_NAME, 
        IIF(V2 = 0, (SELECT ROW_WID FROM {{ ref('int_lkp_MAX_ROW_WID') }} WHERE TABLE_NAME = TGT_TABLE_NAME), V2) AS V1, 
        V1 + 1 AS V2 
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
)
SELECT 
    TGT_TABLE_NAME, 
    V2 AS ROW_WID 
FROM row_wid_data