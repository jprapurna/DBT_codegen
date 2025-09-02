{{
  config(materialized='view')
}}

WITH source_fdr_lib_wrk_birp_niss_aprm_detl AS (
  SELECT
    CVG_ATTR_SK,
    CASE WHEN CVG_TYP_IND = 'B' THEN '?-?-?' ELSE CVG_TYP_CD END AS CVG_TYP_CD,
    CVG_TYP_IND,
    CASE WHEN CVG_TYP_IND = 'B' THEN 1 ELSE 99 END AS CVG_TYP_Priority,
    SUM(CVG_EXPS_VAL) AS CVG_EXPS_VAL
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE SOURCE_IND_DERIVED != 'TOGGLE AUTO'
  GROUP BY
    CVG_ATTR_SK,
    CASE WHEN CVG_TYP_IND = 'B' THEN '?-?-?' ELSE CVG_TYP_CD END,
    CVG_TYP_IND,
    CASE WHEN CVG_TYP_IND = 'B' THEN 1 ELSE 99 END
  ORDER BY
    CVG_ATTR_SK, CVG_TYP_Priority, CVG_EXPS_VAL DESC
),

source_wrk_birp_niss_aprm_detl AS (
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

exp_passthru AS (
  SELECT
    CVG_ATTR_SK,
    CVG_TYP_CD,
    CVG_TYP_IND,
    CVG_TYP_Priority,
    CVG_EXPS_VAL
  FROM source_fdr_lib_wrk_birp_niss_aprm_detl
),

agg_retain_first_value_only AS (
  SELECT
    CVG_ATTR_SK,
    FIRST_VALUE(CVG_EXPS_VAL) OVER (PARTITION BY CVG_ATTR_SK ORDER BY CVG_ATTR_SK) AS CVG_EXPS_VAL
  FROM exp_passthru
),

exp_pass_through AS (
  SELECT
    CVG_ATTR_SK,
    CVG_EXPS_VAL AS i_CVG_EXPS_VAL,
    ROUND(CVG_EXPS_VAL * 12) AS v_CVG_EXPS_VAL,
    ROUND(CVG_EXPS_VAL * 12) AS EXPS_VAL_ROLLED
  FROM agg_retain_first_value_only
),

exp_passthru_tgt AS (
  SELECT
    EXPS_VAL_ROLLED
  FROM exp_pass_through
),

upd_cvg_attr_sk AS (
  SELECT
    EXPS_VAL_ROLLED,
    CASE
      WHEN EXPS_VAL_ROLLED IS NOT NULL THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_passthru_tgt
)

SELECT *
FROM upd_cvg_attr_sk