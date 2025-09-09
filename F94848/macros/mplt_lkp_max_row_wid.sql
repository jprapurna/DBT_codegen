{% macro mplt_lkp_max_row_wid(table_name) %}
WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ table_name }}' AS TABLE_NAME
  FROM {{ source('custom_table', table_name) }}
)
SELECT ROW_WID, TABLE_NAME
FROM max_row_wid
{% endmacro %}