-- Purpose: Calculate ROW_WID using variables V1 and V2
WITH row_wid_data AS (
    SELECT 
        IIF(v2 = 0, lookup(), V2) AS V1, 
        V1 + 1 AS V2, 
        V2 AS ROW_WID 
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
)
SELECT 
    V1, 
    V2, 
    ROW_WID 
FROM row_wid_data