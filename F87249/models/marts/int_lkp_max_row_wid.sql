-- Purpose: Fetch maximum ROW_WID from the target table
WITH max_row_data AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ var("TGT_TABLE_NAME") }}' AS TABLE_NAME
  FROM {{ source('CDM', var("TGT_TABLE_NAME")) }}
)
SELECT * FROM max_row_data