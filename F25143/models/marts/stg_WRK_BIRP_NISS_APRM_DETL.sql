{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "NISS_APRM_DETL_SK" AS niss_aprm_detl_sk, -- Surrogate key for NISS APRM details
        "CLNDR_YR" AS clndr_yr, -- Calendar year
        "CALL_YR" AS call_yr, -- Call year
        "NAIC_CMPNY_CD" AS naic_cmpny_cd, -- NAIC company code
        "NISS_CMPNY_CD" AS niss_cmpny_cd -- NISS company code
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT
    niss_aprm_detl_sk,
    clndr_yr,
    call_yr,
    naic_cmpny_cd,
    niss_cmpny_cd
FROM source_data