{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT
    CVG_ATTR_SK,
    CVG_TYP_CD,
    CVG_TYP_IND,
    CVG_TYP_Priority,
    CVG_EXPS_VAL
  FROM {{ source('FDR', 'WRK_BIRP_NISS_APRM_DETL') }}
),

-- Node: EXP_Passthru
exp_passthru AS (
  SELECT
    CVG_ATTR_SK,
    CVG_TYP_CD,
    CVG_TYP_IND,
    CVG_TYP_Priority,
    CVG_EXPS_VAL
  FROM source_data
),

-- Node: AGG_RetainFirstValueOnly
agg_retain_first_value_only AS (
  SELECT
    CVG_ATTR_SK,
    FIRST_VALUE(CVG_EXPS_VAL) OVER (PARTITION BY CVG_ATTR_SK ORDER BY CVG_ATTR_SK) AS CVG_EXPS_VAL
  FROM exp_passthru
),

-- Node: EXP_PassThrough
exp_pass_through AS (
  SELECT
    CVG_ATTR_SK,
    CVG_EXPS_VAL AS i_CVG_EXPS_VAL,
    ROUND(CVG_EXPS_VAL * 12) AS v_CVG_EXPS_VAL,
    ROUND(CVG_EXPS_VAL * 12) AS EXPS_VAL_ROLLED
  FROM agg_retain_first_value_only
),

-- Node: LKP_FDR_LIB_WRK_BIRP_NISS_APRM_DETL_ByCvgAttrSk
lkp_wrk_birp_niss_aprm_detl_by_cvg_attr_sk AS (
  SELECT
    DETL.NISS_APRM_DETL_SK,
    DETL.CVG_ATTR_SK
  FROM {{ source('FDR', 'WRK_BIRP_NISS_APRM_DETL') }} DETL
  WHERE DETL.CVG_ATTR_SK IN (SELECT CVG_ATTR_SK FROM exp_pass_through)
),

-- Node: EXP_Passthru_Tgt
exp_passthru_tgt AS (
  SELECT
    lkp_wrk_birp_niss_aprm_detl_by_cvg_attr_sk.NISS_APRM_DETL_SK,
    exp_pass_through.EXPS_VAL_ROLLED
  FROM exp_pass_through
  JOIN lkp_wrk_birp_niss_aprm_detl_by_cvg_attr_sk
    ON exp_pass_through.CVG_ATTR_SK = lkp_wrk_birp_niss_aprm_detl_by_cvg_attr_sk.CVG_ATTR_SK
),

-- Node: Upd_CVG_ATTR_SK
upd_cvg_attr_sk AS (
  SELECT
    NISS_APRM_DETL_SK,
    EXPS_VAL_ROLLED
  FROM exp_passthru_tgt
)

SELECT *
FROM upd_cvg_attr_sk;