-- Purpose: Intermediate model for processing detailed information related to NISS APRM.

WITH source_data AS (
    SELECT
        NISS_APRM_DETL_SK,
        CLNDR_YR,
        CALL_YR
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT *
FROM source_data;