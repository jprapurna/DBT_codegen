SELECT 
  NVL(MAX(ROW_WID), 0) AS ROW_WID,
  '{{ config.get("TGT_TABLE_NAME") }}' AS TABLE_NAME
FROM {{ config.get("SCHEMA_CDM") }}.{{ config.get("TGT_TABLE_NAME") }}