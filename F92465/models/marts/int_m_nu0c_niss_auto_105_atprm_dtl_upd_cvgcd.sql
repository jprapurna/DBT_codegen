
{{ config(materialized='view') }}

WITH source_data AS (
  SELECT 
    NISS_APRM_DETL_SK,
    ST_NM,
    ST_ABBR,
    TRIM(ACCTNG_LOB) AS ACCTNG_LOB,
    TRIM(CVG_TYP_CD) AS CVG_TYP_CD,
    TRIM(CVG_AMT) AS CVG_AMT,
    TRIM(BI_LMT) AS BI_LMT,
    TRIM(GA_ADDED_AT_FAULT_IND) AS GA_ADDED_AT_FAULT_IND,
    TRIM(FA2_PLCY_IND) AS FA2_PLCY_IND,
    TRIM(UM_UMI_STACKING) AS UM_UMI_STACKING,
    PIP_WVR_WL_IND,
    PIP_MED_SEC_IND,
    PIP_LOSS_INCOME_IND,
    MI_PPO_IND,
    TRIM(RATNG_CMPY_CD) AS RATNG_CMPY_CD,
    TRIM(COMP_DED) AS COMP_DED,
    TRIM(COLL_DED) AS COLL_DED,
    TRIM(LOB) AS MIS_LOB,
    TRIM(SOURCE_IND_DERIVED) AS SOURCE_IND_DERIVED
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE ST_ABBR NOT IN ('NY', 'NJ')
),

exp_pass_through AS (
  SELECT *
  FROM source_data
),

exp_bilimit_split AS (
  SELECT *,
    REPLACE(BI_LMT, ',', '') AS v_BI_LMT,
    ARRAY_SIZE(SPLIT(REPLACE(BI_LMT, ',', ''), '/')) AS BI_LMT_NO_OF_PARTS,
    SPLIT_PART(REPLACE(BI_LMT, ',', ''), '/', 1) AS v_Limit_FIELD1,
    SPLIT_PART(REPLACE(BI_LMT, ',', ''), '/', 2) AS v_Limit_FIELD2,
    SPLIT_PART(REPLACE(BI_LMT, ',', ''), '/', 3) AS v_Limit_FIELD3,
    TRY_CAST(SPLIT_PART(REPLACE(BI_LMT, ',', ''), '/', 1) AS DECIMAL) AS BI_LMT_1_Decimal,
    TRY_CAST(SPLIT_PART(REPLACE(BI_LMT, ',', ''), '/', 2) AS DECIMAL) AS BI_LMT_2_Decimal,
    TRY_CAST(SPLIT_PART(REPLACE(BI_LMT, ',', ''), '/', 3) AS DECIMAL) AS BI_LMT_3_Decimal,
    REPLACE(BI_LMT, ',', '') AS SRC_BI_LMT
  FROM exp_pass_through
),

exp_cvgamount_split AS (
  SELECT *,
    REPLACE(CVG_AMT, ',', '') AS v_CVG_AMT,
    ARRAY_SIZE(SPLIT(REPLACE(CVG_AMT, ',', ''), '/')) AS CVG_AMT_NO_OF_PARTS,
    SPLIT_PART(REPLACE(CVG_AMT, ',', ''), '/', 1) AS v_AMOUNT_FIELD1,
    SPLIT_PART(REPLACE(CVG_AMT, ',', ''), '/', 2) AS v_AMOUNT_FIELD2,
    SPLIT_PART(REPLACE(CVG_AMT, ',', ''), '/', 3) AS v_AMOUNT_FIELD3,
    TRY_CAST(SPLIT_PART(REPLACE(CVG_AMT, ',', ''), '/', 1) AS DECIMAL) AS CVG_AMT_1_Decimal,
    TRY_CAST(SPLIT_PART(REPLACE(CVG_AMT, ',', ''), '/', 2) AS DECIMAL) AS CVG_AMT_2_Decimal,
    TRY_CAST(SPLIT_PART(REPLACE(CVG_AMT, ',', ''), '/', 3) AS DECIMAL) AS CVG_AMT_3_Decimal,
    REPLACE(CVG_AMT, ',', '') AS SRC_CVG_AMT
  FROM exp_pass_through
),

exp_derive_niss_cvg_cd_and_passthru AS (
  SELECT
    e.NISS_APRM_DETL_SK,
    e.MI_PPO_IND,
    e.COMP_DED,
    e.COLL_DED,
    b.BI_LMT_NO_OF_PARTS,
    e.RATNG_CMPY_CD,
    e.MIS_LOB,
    e.SOURCE_IND_DERIVED,
    CASE 
      WHEN POSITION('/' IN e.COMP_DED) = 0 THEN TRY_CAST(REPLACE(e.COMP_DED, ',', '') AS INTEGER)
      ELSE NULL
    END AS v_COMP_DED,
    CASE 
      WHEN e.PIP_WVR_WL_IND = 1 THEN 'Y'
      WHEN e.PIP_WVR_WL_IND = 0 THEN 'N'
      ELSE ''
    END AS v_PIP_WVR_WL_IND,
    CASE 
      WHEN e.PIP_MED_SEC_IND = 1 THEN 'Y'
      WHEN e.PIP_MED_SEC_IND = 0 THEN 'N'
      ELSE ''
    END AS v_PIP_MED_SEC_IND,
    CASE 
      WHEN e.PIP_LOSS_INCOME_IND = 1 THEN 'Y'
      WHEN e.PIP_LOSS_INCOME_IND = 0 THEN 'N'
      ELSE ''
    END AS v_PIP_LOSS_INCOME_IND,
    CASE 
      WHEN e.MI_PPO_IND = 1 THEN 'Y'
      WHEN e.MI_PPO_IND = 0 THEN 'N'
      ELSE ''
    END AS v_MI_PPO_IND,
    -- Placeholder logic for NISS_CVG_CD derivation
    '' AS v_NISS_CVG_CD,
    CASE 
      WHEN '' = '' THEN '???'
      ELSE ''
    END AS o_NISS_CVG_CD
  FROM exp_pass_through e
  LEFT JOIN exp_bilimit_split b ON e.NISS_APRM_DETL_SK = b.NISS_APRM_DETL_SK
)

SELECT *
FROM exp_derive_niss_cvg_cd_and_passthru
