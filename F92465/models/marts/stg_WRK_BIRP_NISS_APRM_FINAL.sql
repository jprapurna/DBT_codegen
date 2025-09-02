{{ config(materialized='view') }}

WITH wrk_birp_niss_aprm_final AS (
    SELECT
        "NISS_APRM_FINAL_SK" AS niss_aprm_final_sk, -- Primary key for NISS APRM final
        "CLNDR_YR" AS calendar_year, -- Calendar year
        "CALL_YR" AS call_year, -- Call year
        "NISS_CMPNY_CD" AS niss_company_code, -- NISS company code
        "ST_NM" AS state_name, -- State name
        "ST_CD" AS state_code, -- State code
        "ST_ABBR" AS state_abbreviation, -- State abbreviation
        "NISS_ST_CD" AS niss_state_code -- NISS state code
    FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_FINAL') }}
)
SELECT
    niss_aprm_final_sk,
    calendar_year,
    call_year,
    niss_company_code,
    state_name,
    state_code,
    state_abbreviation,
    niss_state_code
FROM wrk_birp_niss_aprm_final