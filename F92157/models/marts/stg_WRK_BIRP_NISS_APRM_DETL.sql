{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "NISS_APRM_DETL_SK" AS niss_aprm_detl_sk, -- Surrogate key for NISS APRM details
        "CLNDR_YR" AS clndr_yr, -- Calendar year
        "CALL_YR" AS call_yr -- Call year
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT
    niss_aprm_detl_sk,
    clndr_yr,
    call_yr
FROM source_data
