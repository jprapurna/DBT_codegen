{% macro exp_flag_block() %}
select
  *,
  case
    when lkp_row_wid is null then 'I'
    when {{ md5_hash("bur") }} = {{ md5_hash("lkp_new_bur") }} then 'NC'
    else 'U'
  end as o_flag,
  current_timestamp as cdm_insert_dt,
  current_timestamp as cdm_update_dt,
  '{{ var("tgt_table_name") }}' as tgt_table_name
from looked_up
{% endmacro %}