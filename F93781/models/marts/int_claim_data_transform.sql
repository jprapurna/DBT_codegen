-- Purpose: Intermediate model for claim data transformation.
{{ config(materialized='view') }}
with lookup as (
    select
        lkp_ROW_WID,
        lkp_INTEGRATION_ID,
        lkp_NEW_BUR
    from {{ ref('stg_claim_data') }}
),
transformed as (
    select
        POLICY_STATE,
        BUR,
        {{ flag_evaluation('lkp_NEW_BUR', 'BUR') }} as operation_flag
    from {{ ref('stg_cdh_gw_bur') }}
    left join lookup
    on lookup.lkp_INTEGRATION_ID = stg_cdh_gw_bur.INTEGRATION_ID
)
select * from transformed