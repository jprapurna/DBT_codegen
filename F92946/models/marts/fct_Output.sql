-- Purpose: Map the input field 'ROW_ID' to the output field 'ROW_WID'.
WITH output_mapping AS (
  SELECT 
    ROW_ID,
    ROW_WID
  FROM {{ ref('int_exp_ROW_WID') }}
)
SELECT 
  ROW_ID,
  ROW_WID
FROM output_mapping