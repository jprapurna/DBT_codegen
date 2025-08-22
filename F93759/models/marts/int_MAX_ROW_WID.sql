-- Purpose: Queries maximum ROW_WID and TABLE_NAME dynamically.
SELECT 
  COALESCE(MAX(ROW_WID), 0) AS ROW_WID, 
  '{{ TGT_TABLE_NAME }}' AS TABLE_NAME
FROM {{ source('CDM', 'LKP_MAX_ROW_WID') }}