SELECT 
  TGT_TABLE_NAME,
  ROW_WID
FROM {{ ref('int_lkp_max_row_wid') }}