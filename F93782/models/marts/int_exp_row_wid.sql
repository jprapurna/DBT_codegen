-- Purpose: Calculates ROW_WID using intermediate variables V1 and V2.
WITH cte AS (
    SELECT 
        ROW_WID, 
        CASE 
            WHEN ROW_WID = 0 THEN lookup() 
            ELSE ROW_WID + 1 
        END AS V1
    FROM {{ ref('int_mplt_cdm_row_wid') }}
)
SELECT 
    V1 AS ROW_WID
FROM cte