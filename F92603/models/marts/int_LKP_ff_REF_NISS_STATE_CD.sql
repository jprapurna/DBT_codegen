-- Purpose: Lookup procedure transformation using flat file source with caching enabled and case-sensitive string comparison
WITH lookup_ff_niss_state AS (
  SELECT 
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT 
  i_ST_NM,
  FARMERS_STATE_NAME,
  NISS_STATE_CODE
FROM lookup_ff_niss_state
WHERE FARMERS_STATE_NAME = i_ST_NM