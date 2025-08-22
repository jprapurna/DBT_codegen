-- Purpose: Generates ROW_WID based on input fields and variable bindings.
WITH row_wid_data AS (
  SELECT 
    TGT_TABLE_NAME,
    ROW_NUMBER() OVER (ORDER BY TGT_TABLE_NAME) AS ROW_WID
  FROM {{ ref('int_rtr_clm_insert_upd') }}
)
SELECT * FROM row_wid_data