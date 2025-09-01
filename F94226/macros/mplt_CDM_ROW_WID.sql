{% macro mplt_CDM_ROW_WID(tgt_table_name) %}
WITH lookup_max_row_wid AS (
  SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID,
    '{{ tgt_table_name }}' AS TABLE_NAME
  FROM {{ source('cdm', 'lkp_max_row_wid') }}
)
SELECT ROW_WID
FROM lookup_max_row_wid
{% endmacro %}