{% macro mplt_cdm_batch_id(source_name_sql) %}
(
  select coalesce(max(b.batch_id), -999)
  from {{ ref('stg_LKP_CDM_BATCH_CTRLID') }} b
  where b.source_name = {{ source_name_sql }}
    and upper(b.status) = upper('{{ var("status_running", "RUNNING") }}')
)
{% endmacro %}