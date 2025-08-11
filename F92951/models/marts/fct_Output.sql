-- Purpose: Write data to output target
WITH output_data AS (
  SELECT 
    exp_row_wid.V1, 
    exp_row_wid.V2, 
    exp_row_wid.ROW_WID 
  FROM {{ ref('int_exp_ROW_WID') }} AS exp_row_wid
)
SELECT 
  V1, 
  V2, 
  ROW_WID 
FROM output_data