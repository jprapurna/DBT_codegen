-- Purpose: Intermediate model for processing data related to NISS_APRM_LND.

WITH source_data AS (
    SELECT
        NISS_APRM_LND_SK,
        REG_PER_YR,
        FISC_PER_YR
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_TA_NISS_NU0C_APRM_LND') }}
)

SELECT *
FROM source_data
