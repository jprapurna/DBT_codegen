{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "NISS_APRM_LND_SK" AS niss_aprm_lnd_sk, -- Surrogate key for NISS APRM landing details
        "REG_PER_YR" AS reg_per_yr, -- Registration period year
        "FISC_PER_YR" AS fisc_per_yr -- Fiscal period year
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_TA_NISS_NU0C_APRM_LND') }}
)
SELECT
    niss_aprm_lnd_sk,
    reg_per_yr,
    fisc_per_yr
FROM source_data