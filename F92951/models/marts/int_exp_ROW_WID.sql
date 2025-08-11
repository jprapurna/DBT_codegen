-- Purpose: Calculate ROW_WID using variables V1 and V2
WITH calculated_row_wid AS (
  SELECT 
    V1, 
    V2, 
    V2 + 1 AS ROW_WID 
  FROM (
    SELECT 
      IIF(V2 = 0, (SELECT ROW_WID FROM {{ ref('int_mplt_CDM_ROW_WID') }}), V2) AS V1, 
      V1 + 1 AS V2 
    FROM {{ ref('int_mplt_CDM_ROW_WID') }}
  )
)
SELECT 
  V1, 
  V2, 
  ROW_WID 
FROM calculated_row_wid