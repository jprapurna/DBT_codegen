{% macro mplt_cdm_row_wid(tgt_table_name) %}
WITH row_wid_data AS (
  SELECT 
    COALESCE(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ tgt_table_name }}' AS TABLE_NAME
  FROM {{ source('schema_cdm', tgt_table_name) }}
)
SELECT ROW_WID, TABLE_NAME
FROM row_wid_data
{% endmacro %}

---