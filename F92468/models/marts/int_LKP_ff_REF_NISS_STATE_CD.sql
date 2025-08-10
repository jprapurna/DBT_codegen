-- Purpose: Lookup procedure transformation using flat file source with caching enabled
WITH lookup_cte AS (
    SELECT 
        FARMERS_STATE_NAME,
        NISS_STATE_CODE
    FROM {{ source('PowerExchange_For_Snowflake', 'WRK_BIRP_NISS_APRM_DETL') }}
    WHERE FARMERS_STATE_NAME = i_ST_NM
)
SELECT 
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
FROM lookup_cte