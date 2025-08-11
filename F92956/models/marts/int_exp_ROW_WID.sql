-- Purpose: Calculate ROW_WID using variables V1 and V2.

WITH source_data AS (
    SELECT 
        TGT_TABLE_NAME
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
)

SELECT 
    TGT_TABLE_NAME,
    IIF(V2 = 0, :LKP.lkp_MAX_ROW_WID(TGT_TABLE_NAME), V2) AS V1,
    V1 + 1 AS V2,
    V2 AS ROW_WID
FROM source_data