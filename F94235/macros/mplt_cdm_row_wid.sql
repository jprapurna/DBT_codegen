{% macro mplt_cdm_row_wid(target_table_name) %}
WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    {{ target_table_name }} AS TABLE_NAME
  FROM {{ source('cdm', target_table_name) }}
)
SELECT * FROM max_row_wid
{% endmacro %}