WITH state_lookup AS (
    SELECT
        FARMERS_STATE_NAME,
        NISS_STATE_CODE
    FROM {{ ref('ff_NISS_STATE') }}
)
SELECT
    src.ST_NM AS FARMERS_STATE_NAME,
    lookup.NISS_STATE_CODE
FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_TA_NISS_NU0C_APRM_DTL') }} src
LEFT JOIN state_lookup lookup
    ON src.ST_NM = lookup.FARMERS_STATE_NAME;