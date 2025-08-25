WITH source_data AS (
    SELECT
        {{ safe_cast('NISS_APRM_LND_SK', 'int') }} AS niss_aprm_lnd_sk,
        {{ safe_cast('REG_PER_YR', 'int') }} AS reg_per_yr,
        {{ safe_cast('FISC_PER_YR', 'int') }} AS fisc_per_yr,
        {{ safe_cast('NAIC_CMPNY_CD', 'string') }} AS naic_cmpny_cd,
        {{ safe_cast('NISS_CMPNY_CD', 'string') }} AS niss_cmpny_cd
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_LND') }}
)
SELECT *
FROM source_data