-- macros/mplt_cdm_batch_id.sql
{% macro mplt_cdm_batch_id(source_cte='exp_bur', column_name='SOURCE_NAME') %}
(
  select
    src.{{ column_name }} as SOURCE_NAME,
    coalesce(max_tbl.BATCH_ID, -999) as o_BATCH_ID
  from {{ source_cte }} src
  left join (
    select
      SOURCE_NAME,
      max(BATCH_ID) as BATCH_ID
    from {{ source('GENAI_POWER_BI_CDM', 'LKP_CDM_BATCH_CTRLID') }}
    where upper(STATUS) = 'RUNNING'
    group by SOURCE_NAME
  ) max_tbl
    on upper(max_tbl.SOURCE_NAME) = upper(src.{{ column_name }})
)
{% endmacro %}
