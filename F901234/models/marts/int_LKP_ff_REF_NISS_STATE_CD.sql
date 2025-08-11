-- Purpose: Lookup procedure transformation using flat file source with caching enabled
WITH lookup_data AS (
  SELECT 
    FARMERS_STATE_NAME,
    NISS_STATE_CODE
  FROM $LookupFile_ff_NISS_STATE
)
SELECT 
  i_ST_NM,
  FARMERS_STATE_NAME,
  NISS_STATE_CODE
FROM lookup_data
WHERE FARMERS_STATE_NAME = i_ST_NM