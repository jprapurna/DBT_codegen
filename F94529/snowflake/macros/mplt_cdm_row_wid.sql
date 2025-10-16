{% macro mplt_cdm_row_wid(tgt_table_name_expr, schema_name=None, lookup_model=None) %}

{% set _schema = schema_name or var('SCHEMA_CDM', 'CDM') %}

(
  {% if lookup_model %}
      -- Case 1: A dbt model is provided as lookup_model
      select
          '{{ tgt_table_name_expr }}' as TGT_TABLE_NAME,
          coalesce(max(LKP_ROW_WID), 0) + 1 as ROW_WID
      from {{ ref(lookup_model) }}
      where TABLE_NAME = '{{ tgt_table_name_expr }}'
  
  {% else %}
      -- Case 2: No lookup model provided; use schema + table name directly
      select
          '{{ tgt_table_name_expr }}' as TGT_TABLE_NAME,
          coalesce(max(LKP_ROW_WID), 0) + 1 as ROW_WID
      from {{ _schema }}.{{ tgt_table_name_expr }}
  {% endif %}
)
{% endmacro %}
