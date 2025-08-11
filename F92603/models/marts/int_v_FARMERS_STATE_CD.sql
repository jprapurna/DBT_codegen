-- Purpose: Custom calculation for Farmers state code
SELECT 
  IIF(ST_CD = '#', '00', ST_CD) AS v_farmers_state_cd
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}