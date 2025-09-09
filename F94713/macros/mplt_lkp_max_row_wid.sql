{% macro mplt_lkp_max_row_wid(in_table_name) %}
WITH max_row_wid_lookup AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ in_table_name }}' AS TABLE_NAME
  FROM {{ source('custom_table', 'max_row_wid') }}
  WHERE TABLE_NAME = '{{ in_table_name }}'
)
SELECT ROW_WID, TABLE_NAME
FROM max_row_wid_lookup
{% endmacro %}