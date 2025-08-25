{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "MINI_PLCY_SK" AS mini_plcy_sk, -- Surrogate key for mini policy
        "PAY_PLAN_CD" AS pay_plan_cd, -- Payment plan code
        "PAY_PLAN_DESC" AS pay_plan_desc -- Payment plan description
    FROM {{ source('AGDM', 'DIM_AG_MINI_PLCY') }}
)
SELECT
    mini_plcy_sk,
    pay_plan_cd,
    pay_plan_desc
FROM source_data
