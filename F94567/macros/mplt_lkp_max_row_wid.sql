{% macro mplt_lkp_max_row_wid(tgt_table_name) %}
WITH max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ tgt_table_name }}' AS TABLE_NAME
  FROM {{ source('custom_table', tgt_table_name) }}
)
SELECT ROW_WID, TABLE_NAME
FROM max_row_wid
{% endmacro %}