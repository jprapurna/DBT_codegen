-- Purpose: This model updates the NISS_CVG_CD with strategy DD_UPDATE.

WITH cte_update_niss_cvg_cd AS (
  SELECT
    NISS_APRM_DETL_SK,
    niss_cvg_cd
  FROM {{ ref('int_exp_derive_niss_cvg_cd_and_passthru') }}
)

SELECT
  NISS_APRM_DETL_SK,
  niss_cvg_cd
FROM cte_update_niss_cvg_cd