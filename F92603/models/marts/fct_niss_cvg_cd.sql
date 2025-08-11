-- Purpose: Final model for reporting or analytics

WITH final_niss_cvg_cd AS (
  SELECT
    a.NISS_APRM_DETL_SK,
    a.NISS_CVG_CD,
    b.bi_lmt_1_decimal,
    b.bi_lmt_2_decimal,
    b.bi_lmt_3_decimal,
    c.cvg_amt_1_decimal,
    c.cvg_amt_2_decimal,
    c.cvg_amt_3_decimal
  FROM {{ ref('int_upd_niss_cvg_cd') }} AS a
  JOIN {{ ref('int_exp_bilimit_split') }} AS b ON a.NISS_APRM_DETL_SK = b.NISS_APRM_DETL_SK
  JOIN {{ ref('int_exp_cvgamount_split') }} AS c ON a.NISS_APRM_DETL_SK = c.NISS_APRM_DETL_SK
)

SELECT
  NISS_APRM_DETL_SK,
  NISS_CVG_CD,
  bi_lmt_1_decimal,
  bi_lmt_2_decimal,
  bi_lmt_3_decimal,
  cvg_amt_1_decimal,
  cvg_amt_2_decimal,
  cvg_amt_3_decimal
FROM final_niss_cvg_cd