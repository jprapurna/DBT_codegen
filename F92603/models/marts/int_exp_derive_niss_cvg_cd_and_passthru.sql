-- Purpose: This model derives the NISS coverage code based on various input fields and conditions, and passes the data to the next transformation.

SELECT
  NISS_APRM_DETL_SK,
  ST_NM,
  ST_ABBR,
  ACCTNG_LOB,
  -- Derive NISS_CVG_CD logic here
  CASE
    WHEN ST_NM = 'New York' THEN 'NY_CVG'
    WHEN ST_NM = 'New Jersey' THEN 'NJ_CVG'
    ELSE 'OTHER_CVG'
  END AS niss_cvg_cd
FROM {{ ref('stg_wrk_birp_niss_aprm_detl') }}