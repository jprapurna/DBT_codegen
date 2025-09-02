{% macro mplt_CDM_ROW_WID(table_name) %}
WITH row_wid_data AS (
  SELECT
    NVL(MAX(ROW_WID), 0) AS max_row_wid,
    table_name
  FROM {{ source('schema_cdm', 'custom_table') }}
  WHERE table_name = {{ table_name }}
)
SELECT max_row_wid
FROM row_wid_data
{% endmacro %}