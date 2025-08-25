WITH source_data AS (
    SELECT
        {{ safe_cast('NISS_APRM_DETL_SK', 'int') }} AS niss_aprm_detl_sk,
        {{ safe_cast('CLNDR_YR', 'int') }} AS clndr_yr,
        {{ safe_cast('CALL_YR', 'int') }} AS call_yr,
        {{ safe_cast('NAIC_CMPNY_CD', 'string') }} AS naic_cmpny_cd,
        {{ safe_cast('NISS_CMPNY_CD', 'string') }} AS niss_cmpny_cd
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT *
FROM source_data