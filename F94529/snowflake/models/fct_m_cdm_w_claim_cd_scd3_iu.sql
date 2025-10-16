{{ config(
    materialized='table',
    schema='CDM',
    alias='W_CLAIM_CD_BUR_SCD3'
) }}

select *
from {{ ref('int_m_cdm_w_claim_cd_scd3_iu') }}
