{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "NISS_APRM_FINAL_SK" AS niss_aprm_final_sk, -- Surrogate key for NISS APRM final
        "CLNDR_YR" AS clndr_yr, -- Calendar year
        "CALL_YR" AS call_yr, -- Call year
        "NISS_CMPNY_CD" AS niss_cmpny_cd, -- NISS company code
        "ST_NM" AS st_nm -- State name
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_FINAL') }}
)
SELECT
    niss_aprm_final_sk,
    clndr_yr,
    call_yr,
    niss_cmpny_cd,
    st_nm
FROM source_data