{{ config(
    materialized='table'
) }}

with staged as (
  select * from {{ ref('int_claims__w_claim_cd_bur_scd3') }}
)

select
  *,
  {{ md5_hash("bur") }} as bur_md5
from staged