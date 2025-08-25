{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "FISC_PER_YR" AS fisc_per_yr, -- Fiscal period year
        "NAIC_CMPNY_CD" AS naic_cmpny_cd, -- NAIC company code
        "NISS_CMPNY_CD" AS niss_cmpny_cd -- NISS company code
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_TA_NISS_NU0C_APRM_DTL') }}
)
SELECT
    fisc_per_yr,
    naic_cmpny_cd,
    niss_cmpny_cd
FROM source_data
