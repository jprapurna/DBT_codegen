-- Purpose: Generates ROW_WID based on input TGT_TABLE_NAME.
SELECT 
  TGT_TABLE_NAME,
  ROW_WID
FROM {{ ref('int_MAX_ROW_WID') }}