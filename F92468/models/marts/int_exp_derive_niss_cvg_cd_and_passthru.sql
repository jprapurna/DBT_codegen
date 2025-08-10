-- Purpose: This model derives the NISS coverage code based on various input fields and conditions, and passes the data to the next transformation.

SELECT
  NISS_APRM_DETL_SK,
  ST_NM,
  ST_ABBR,
  ACCTNG_LOB,
  CASE
    WHEN CVG_TYP_CD = 'A' THEN 'NISS_A'
    WHEN CVG_TYP_CD = 'B' THEN 'NISS_B'
    ELSE 'NISS_OTHER'
  END AS niss_cvg_cd
FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}