{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "MINI_PLCY_SK" AS mini_plcy_sk, -- Surrogate key for mini policy
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "MKT_TIER_FA2" AS mkt_tier_fa2, -- Market tier FA2
        "PAY_PLAN_CD" AS pay_plan_cd, -- Payment plan code
        "PAY_PLAN_DESC" AS pay_plan_desc, -- Payment plan description
        "PERSTNCY_YRS_RNGE" AS perstncy_yrs_rnge -- Persistency years range
    FROM {{ source('AGDM', 'DIM_AG_MINI_PLCY') }}
)
SELECT
    mini_plcy_sk,
    chk_sum_attr,
    mkt_tier_fa2,
    pay_plan_cd,
    pay_plan_desc,
    perstncy_yrs_rnge
FROM source_data