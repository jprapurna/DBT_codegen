{% macro mplt_cdm_row_wid(tgt_table_name) %}
WITH row_wid_lookup AS (
  SELECT
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    {{ tgt_table_name }} AS TABLE_NAME
  FROM {{ source('cdm_row_wid') }}
  WHERE TABLE_NAME = {{ tgt_table_name }}
)
SELECT
  ROW_WID
FROM row_wid_lookup
{% endmacro %}