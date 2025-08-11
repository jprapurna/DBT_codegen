-- Purpose: Calculates ROW_WID using variables V1 and V2.
WITH exp_row_wid AS (
    SELECT 
        IIF(v2 = 0, (SELECT MAX(ROW_WID) FROM {{ ref('int_mplt_CDM_ROW_WID') }}), v2) AS v1,
        v1 + 1 AS v2,
        v2 AS row_wid
    FROM 
        {{ ref('int_EXP_Flag') }}
)
SELECT 
    row_wid
FROM 
    exp_row_wid