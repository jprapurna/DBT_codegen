{{
  config(materialized='view')
}}

WITH source_wrk_birp_niss_aprm_detl AS (
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_fdr_lib_wrk_birp_niss_aprm_detl2 AS (
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_fdr_lib_wrk_birp_niss_aprm_detl AS (
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_sq_fdr_lib_wrk_birp_niss_aprm_detl1 AS (
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_sq_fdr_lib_wrk_birp_niss_aprm_detl AS (
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

exp_before_tgt AS (
  SELECT
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT
  FROM source_wrk_birp_niss_aprm_detl
),

upd_exp_upd AS (
  SELECT
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT
  FROM exp_before_tgt
  WHERE 1=1 -- Update Strategy: DD_UPDATE
),

exp_before_tgt1 AS (
  SELECT
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT,
    ROUND(CVG_EXPS_VAL * 12) AS EXP_VAL_ROLLED
  FROM upd_exp_upd
),

upd_exp_upd_cvg_ind_not_b AS (
  SELECT
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT,
    EXP_VAL_ROLLED
  FROM exp_before_tgt1
  WHERE 1=1 -- Update Strategy: DD_UPDATE
)

SELECT *
FROM upd_exp_upd_cvg_ind_not_b