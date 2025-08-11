-- Purpose: Retrieve maximum ROW_WID from a dynamic table using custom SQL query.
WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS row_wid,
    '$$TGT_TABLE_NAME' AS table_name
  FROM $$SCHEMA_CDM.$$TGT_TABLE_NAME
)
SELECT 
  row_wid,
  table_name
FROM max_row_wid