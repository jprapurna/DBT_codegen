{{ config(materialized='view') }}

with source_data as (
  select
    policy_state,
    bur,
    source_name
  from {{ ref('stg_SQ_CDH_GW_BUR') }}
),

exp_bur as (
  select
    policy_state as integration_id,
    bur,
    source_name
  from source_data
),

source_with_batch as (
  select
    e.integration_id,
    e.bur,
    e.source_name,
    coalesce(b.max_batch_id, -999) as o_batch_id
  from exp_bur e
  left join (
    select 
      source_name,
      max(batch_id) as max_batch_id
    from GENAI_POWER_BI.POWER_CENTER.stg_LKP_CDM_BATCH_CTRLID
    where upper(status) = 'RUNNING'
    group by source_name
  ) b
  on e.source_name = b.source_name
),


looked_up as (
  {{ lkp_w_claim_cd_bur_scd3() }}
),

flagged as (
  {{ exp_flag_block() }}
),

insert_update as (
  select *
  from flagged
  where o_flag in ('I','U')
),

row_wid_calc as (
  select
    *,
    {{ mplt_cdm_row_wid() }} as row_wid
  from insert_update i
)

select * from row_wid_calc
