-- Purpose: Lookup transformation for maximum ROW_WID
WITH max_row_data AS (
  SELECT
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ var("TGT_TABLE_NAME") }}' AS TABLE_NAME
  FROM {{ source('max_row_wid', 'lkp_max_row_wid') }}
)
SELECT *
FROM max_row_data