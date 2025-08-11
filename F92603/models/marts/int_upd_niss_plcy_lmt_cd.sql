-- Purpose: Represents the update strategy logic for the NISS_PLCY_LMT_CD field

WITH updated_niss_policy_limit AS (
  SELECT 
    NISS_APRM_DETL_SK,
    NISS_PLCY_LMT_CD
  FROM 
    {{ source('WRK_BIRP_NISS_APRM_DETL', 'WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT 
  NISS_APRM_DETL_SK,
  NISS_PLCY_LMT_CD
FROM 
  updated_niss_policy_limit