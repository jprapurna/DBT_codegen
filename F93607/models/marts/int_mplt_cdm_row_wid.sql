-- Purpose: Generates ROW_WID based on input fields and variable bindings

WITH row_wid_data AS (
  SELECT 
    tgt_table_name,
    ROW_WID AS row_wid,
    TABLE_NAME AS table_name
  FROM {{ source('CDH_GWODS', 'lkp_MAX_ROW_WID') }}
)

SELECT 
  tgt_table_name,
  CASE 
    WHEN {{ var('v2') }} = 0 THEN row_wid
    ELSE {{ var('v2') }}
  END AS row_wid
FROM row_wid_data
WHERE table_name = tgt_table_name