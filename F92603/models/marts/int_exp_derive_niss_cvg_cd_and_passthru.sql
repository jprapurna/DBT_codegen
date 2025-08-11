-- Purpose: This model derives the NISS coverage code based on various input fields and conditions, and passes the data to the next transformation.

SELECT
  NISS_APRM_DETL_SK,
  ST_NM,
  ST_ABBR,
  ACCTNG_LOB
FROM {{ ref('stg_wrk_birp_niss_aprm_detl') }}