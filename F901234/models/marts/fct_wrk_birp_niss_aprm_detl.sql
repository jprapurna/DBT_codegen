-- Purpose: This model represents the final output after applying all transformations and update strategies.

SELECT
  a.NISS_APRM_DETL_SK,
  a.CVG_TYP_CD,
  b.bi_lmt_1_decimal,
  b.bi_lmt_2_decimal,
  b.bi_lmt_3_decimal,
  c.cvg_amt_1_string,
  c.cvg_amt_2_string,
  c.cvg_amt_3_string,
  d.v_cvg_cd_step1,
  d.v_cvg_cd_step1a,
  d.v_cvg_cd_step2,
  d.v_cvg_cd_step3,
  d.v_cvg_cd_step4,
  d.FA2_PLCY_IND,
  d.UM_UMI_STACKING,
  d.PIP_WVR_WL_IND,
  d.PIP_MED_SEC_IND,
  d.PIP_LOSS_INCOME_IND,
  d.MI_PPO_IND,
  d.COMP_DED,
  d.RATNG_CMPY_CD,
  d.COLL_DED,
  d.MIS_LOB,
  d.SOURCE_IND_DERIVED
FROM {{ ref('int_exp_pass_through') }} a
JOIN {{ ref('int_exp_bilimit_split') }} b ON a.NISS_APRM_DETL_SK = b.NISS_APRM_DETL_SK
JOIN {{ ref('int_exp_cvgamount_split') }} c ON a.NISS_APRM_DETL_SK = c.NISS_APRM_DETL_SK
JOIN {{ ref('int_exp_derive_niss_cvg_cd_and_passthru') }} d ON a.NISS_APRM_DETL_SK = d.NISS_APRM_DETL_SK
JOIN {{ ref('int_upd_niss_cvg_cd') }} e ON a.NISS_APRM_DETL_SK = e.NISS_APRM_DETL_SK