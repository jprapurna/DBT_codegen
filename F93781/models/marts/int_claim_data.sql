{{ config(materialized='view') }}
with base_data as (
    select
        POLICY_STATE,
        BUR,
        SOURCE_NAME
    from {{ source('CDH_GWODS', 'SQ_CDH_GW_BUR') }}
),
lookup_data as (
    select
        lkp_ROW_WID,
        lkp_INTEGRATION_ID,
        lkp_NEW_BUR
    from {{ source('CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
)
select
    base_data.POLICY_STATE,
    base_data.BUR,
    base_data.SOURCE_NAME,
    lookup_data.lkp_ROW_WID,
    lookup_data.lkp_INTEGRATION_ID,
    lookup_data.lkp_NEW_BUR
from base_data
left join lookup_data
on base_data.BUR = lookup_data.lkp_NEW_BUR