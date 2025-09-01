{{
  config(materialized='ephemeral')
}}

WITH Exp_before_tgt AS (
  -- Node: Exp_before_tgt
  SELECT
    NISS_APRM_DETL_SK,
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),

Upd_EXP_UPD AS (
  -- Node: Upd_EXP_UPD
  SELECT
    NISS_APRM_DETL_SK,
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT,
    CASE 
      WHEN DD_UPDATE THEN 'DD_UPDATE'
      ELSE NULL
    END AS update_strategy
  FROM Exp_before_tgt
),

Exp_before_tgt1 AS (
  -- Node: Exp_before_tgt1
  SELECT
    NISS_APRM_DETL_SK,
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT,
    ROUND(CVG_EXPS_VAL * 12) AS EXP_VAL_ROLLED
  FROM Upd_EXP_UPD
),

Upd_EXP_UPD_CVG_IND_NOT_B AS (
  -- Node: Upd_EXP_UPD_CVG_IND_NOT_B
  SELECT
    NISS_APRM_DETL_SK,
    CVG_EXPS_VAL,
    PLCY_CNTRCT_NUM,
    UNIT_NUM,
    EFF_DT,
    EXP_VAL_ROLLED,
    CASE 
      WHEN DD_UPDATE THEN 'DD_UPDATE'
      ELSE NULL
    END AS update_strategy
  FROM Exp_before_tgt1
)

SELECT *
FROM Upd_EXP_UPD_CVG_IND_NOT_B;