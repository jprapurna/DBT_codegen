-- Purpose: Lookup transformation to derive ST_ABBR using FARMERS_STATE_CD as input
WITH lookup_tfarmers_state AS (
  SELECT 
    FARMERS_STATE_CD,
    STATE_CODE
  FROM FDR.REF_TFARMERS_STATE
)
SELECT 
  FARMERS_STATE_CD,
  STATE_CODE
FROM lookup_tfarmers_state
WHERE FARMERS_STATE_CD = i_FARMERS_STATE_CD