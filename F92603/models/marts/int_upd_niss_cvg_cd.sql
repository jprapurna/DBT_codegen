-- Purpose: Represents the update strategy for NISS_CVG_CD with DD_UPDATE strategy

WITH updated_niss_cvg_cd AS (
  SELECT
    NISS_APRM_DETL_SK,
    NISS_CVG_CD,
    NISS_SSL_LIAB_CD,
    NISS_LIAB_OR_NO_FAULT_CD,
    REC_EXCPN_IND
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE REC_EXCPN_IND = 'Y'
)

SELECT
  NISS_APRM_DETL_SK,
  NISS_CVG_CD,
  NISS_SSL_LIAB_CD,
  NISS_LIAB_OR_NO_FAULT_CD,
  REC_EXCPN_IND
FROM updated_niss_cvg_cd