{% macro macro_lkp_max_row_wid(in_table_name) %}
WITH lookup_data AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    'TABLE_NAME' AS TABLE_NAME
  FROM {{ var('SCHEMA_CDM') }}.{{ in_table_name }}
)
SELECT ROW_WID, TABLE_NAME
FROM lookup_data
{% endmacro %}