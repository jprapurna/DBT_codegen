{% macro mplt_CDM_ROW_WID(TGT_TABLE_NAME) %}
WITH max_row_wid AS (
  SELECT 
    COALESCE(MAX(ROW_WID), 0) AS ROW_WID,
    {{ var('tgt_table_name') }} AS TABLE_NAME
  FROM {{ var('schema_cdm') }}.{{ var('tgt_table_name') }}
)
SELECT 
  ROW_WID,
  TABLE_NAME
FROM max_row_wid
{% endmacro %}