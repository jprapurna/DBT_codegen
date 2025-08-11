-- Purpose: This model updates the NISS_CVG_CD with strategy DD_UPDATE.

SELECT
  NISS_APRM_DETL_SK,
  ST_NM,
  ST_ABBR,
  ACCTNG_LOB,
  -- Assuming the logic for updating NISS_CVG_CD is defined elsewhere
  NISS_CVG_CD
FROM {{ ref('int_exp_derive_niss_cvg_cd_and_passthru') }}