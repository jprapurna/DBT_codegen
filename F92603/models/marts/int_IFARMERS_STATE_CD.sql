-- Purpose: Custom calculation for Farmers state code conversion
SELECT 
  TO_INTEGER(v_FARMERS_STATE_CD) AS ifarmers_state_cd
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}