-- Purpose: Calculate ROW_WID using variables and lookup
WITH row_wid_data AS (
  SELECT 
    IIF(V2 = 0, {{ ref('int_lkp_max_row_wid') }}.ROW_WID, V2) AS V1,
    V1 + 1 AS V2
  FROM {{ ref('int_lkp_max_row_wid') }}
)
SELECT * FROM row_wid_data