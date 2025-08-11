-- Purpose: Lookup transformation to derive ST_ABBR using FARMERS_STATE_CD as input
WITH lookup_data AS (
  SELECT DISTINCT 
    R.FARMERS_STATE_CD AS farmers_state_cd,
    R.STATE_CODE AS state_code
  FROM {{ source('FDR', 'REF_TFARMERS_STATE') }} R
  WHERE R.END_EFF_DT = '2999-12-31'
  ORDER BY FARMERS_STATE_CD
)
SELECT 
  FARMERS_STATE_CD,
  STATE_CODE
FROM lookup_data
WHERE FARMERS_STATE_CD = i_FARMERS_STATE_CD