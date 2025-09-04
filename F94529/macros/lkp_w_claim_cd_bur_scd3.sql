{% macro lkp_w_claim_cd_bur_scd3() %}
select
  s.integration_id,
  s.bur,
  s.o_batch_id,
  t.lkp_row_wid,
  t.lkp_integration_id,
  t.lkp_new_bur
from source_with_batch s
left join {{ ref('stg_LKP_W_CLAIM_CD_BUR_SCD3') }} t
  on s.integration_id = t.lkp_integration_id
{% endmacro %}