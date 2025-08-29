-- Purpose: Fetches maximum ROW_WID and TABLE_NAME from the target table.
SELECT 
  NVL(MAX(ROW_WID), 0) AS ROW_WID,
  '{{ macro_TGT_TABLE_NAME() }}' AS TABLE_NAME
FROM {{ source('CDM', 'DUMMY_mplt_CDM_ROW_WID_lkp_MAX_ROW_WID') }}