-- Purpose: Final model for reporting or analytics on NISS_CVG_CD

WITH final_niss_cvg_cd AS (
  SELECT 
    u.NISS_APRM_DETL_SK,
    u.NISS_CVG_CD,
    u.NISS_SSL_LIAB_CD,
    u.NISS_LIAB_OR_NO_FAULT_CD,
    u.REC_EXCPN_IND,
    b.BI_LMT_1_Decimal,
    b.BI_LMT_2_Decimal,
    b.BI_LMT_3_Decimal,
    b.BI_LMT_NO_OF_PARTS,
    b.SRC_BI_LMT,
    c.CVG_AMT_1_Decimal,
    c.CVG_AMT_2_Decimal,
    c.CVG_AMT_3_Decimal,
    c.CVG_AMT_NO_OF_PARTS,
    c.SRC_CVG_AMT
  FROM {{ ref('int_upd_niss_cvg_cd') }} u
  JOIN {{ ref('int_exp_bilimit_split') }} b ON u.NISS_APRM_DETL_SK = b.NISS_APRM_DETL_SK
  JOIN {{ ref('int_exp_cvgamount_split') }} c ON u.NISS_APRM_DETL_SK = c.NISS_APRM_DETL_SK
)

SELECT 
  NISS_APRM_DETL_SK,
  NISS_CVG_CD,
  NISS_SSL_LIAB_CD,
  NISS_LIAB_OR_NO_FAULT_CD,
  REC_EXCPN_IND,
  BI_LMT_1_Decimal,
  BI_LMT_2_Decimal,
  BI_LMT_3_Decimal,
  BI_LMT_NO_OF_PARTS,
  SRC_BI_LMT,
  CVG_AMT_1_Decimal,
  CVG_AMT_2_Decimal,
  CVG_AMT_3_Decimal,
  CVG_AMT_NO_OF_PARTS,
  SRC_CVG_AMT
FROM final_niss_cvg_cd