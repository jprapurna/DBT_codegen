-- Purpose: Fetch maximum ROW_WID from the target table
WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ var("TGT_TABLE_NAME") }}' AS TABLE_NAME 
  FROM {{ source('W_CLAIM_CD_SCD3_IU', 'LKPK_MAX_ROW_WID') }}
)
SELECT 
  ROW_WID, 
  TABLE_NAME 
FROM max_row_wid