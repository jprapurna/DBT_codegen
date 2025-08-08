-- Purpose: Fetch maximum ROW_WID from the target table
SELECT 
  NVL(MAX(ROW_WID), 0) AS ROW_WID, 
  '{{ var("TGT_TABLE_NAME") }}' AS TABLE_NAME 
FROM 
  {{ var("SCHEMA_CDM") }}.{{ var("TGT_TABLE_NAME") }}