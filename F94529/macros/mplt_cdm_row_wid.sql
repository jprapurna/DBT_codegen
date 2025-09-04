{% macro mplt_cdm_row_wid() %}
(
  select coalesce(max(row_wid), 0) + 1
  from {{ ref('stg_LKP_MAX_ROW_WID') }}
  where upper(table_name) = upper('{{ var("tgt_table_name") }}')
)
{% endmacro %}