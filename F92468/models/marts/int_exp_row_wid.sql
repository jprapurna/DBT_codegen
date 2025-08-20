-- Purpose: Calculates ROW_WID using variables and lookup

WITH row_wid_data AS (
  SELECT 
    IIF(v2 = 0, :LKP.lkp_MAX_ROW_WID(tgt_table_name), v2) AS v1,
    v1 + 1 AS v2,
    v2 AS row_wid
  FROM {{ ref('int_lkp_max_row_wid') }}
)

SELECT 
  row_wid
FROM row_wid_data