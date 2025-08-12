-- Purpose: Calculate ROW_WID using variables V1 and V2
WITH row_wid_calculation AS (
    SELECT 
        CASE 
            WHEN v2 = 0 THEN lookup() 
            ELSE v2 
        END AS v1,
        v1 + 1 AS v2,
        v2 AS row_wid
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
)
SELECT 
    row_wid
FROM row_wid_calculation