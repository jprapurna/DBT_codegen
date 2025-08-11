-- Purpose: This model derives the NISS coverage code based on various input fields and conditions, and passes the data to the next transformation.

WITH cte_derive_niss_cvg_cd AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_NM,
    ST_ABBR,
    ACCTNG_LOB,
    -- Add detailed derivation logic for coverage codes using multiple steps
    CASE WHEN <condition> THEN <value> ELSE <default_value> END AS v_cvg_cd_step1,
    CASE WHEN <condition> THEN <value> ELSE <default_value> END AS v_cvg_cd_step1a,
    CASE WHEN <condition> THEN <value> ELSE <default_value> END AS v_cvg_cd_step2,
    CASE WHEN <condition> THEN <value> ELSE <default_value> END AS v_cvg_cd_step3,
    CASE WHEN <condition> THEN <value> ELSE <default_value> END AS v_cvg_cd_step4,
    -- Enhanced pass-through logic for various indicators and amounts
    FA2_PLCY_IND,
    UM_UMI_STACKING,
    PIP_WVR_WL_IND,
    PIP_MED_SEC_IND,
    PIP_LOSS_INCOME_IND,
    MI_PPO_IND,
    COMP_DED,
    RATNG_CMPY_CD,
    COLL_DED,
    MIS_LOB,
    SOURCE_IND_DERIVED
  FROM {{ ref('stg_wrk_birp_niss_aprm_detl') }}
)

SELECT *
FROM cte_derive_niss_cvg_cd