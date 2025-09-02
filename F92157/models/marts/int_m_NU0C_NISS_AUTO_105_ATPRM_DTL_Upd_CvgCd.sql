{{
  config(materialized='ephemeral')
}}

WITH EXP_Pass_Through AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_NM,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    BI_LMT,
    GA_ADDED_AT_FAULT_IND,
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
  FROM {{ source('source_system', 'table_name') }}
),

EXP_BILimit_Split AS (
  SELECT
    *,
    REPLACE(LTRIM(RTRIM(BI_LMT)), ',', '') AS v_BI_LMT,
    LENGTH(LTRIM(RTRIM(BI_LMT))) - LENGTH(REPLACE(LTRIM(RTRIM(BI_LMT)), '/', '')) + 1 AS v_BI_LMT_Parts,
    POSITION('/' IN v_BI_LMT) AS v_BI_LMT_Part1_Pos,
    POSITION('/' IN v_BI_LMT FROM v_BI_LMT_Part1_Pos + 1) AS v_BI_LMT_Part2_Pos,
    CASE
      WHEN v_BI_LMT_Parts = 1 THEN v_BI_LMT
      WHEN v_BI_LMT_Parts = 2 THEN SUBSTRING(v_BI_LMT FROM 1 FOR v_BI_LMT_Part1_Pos - 1)
      WHEN v_BI_LMT_Parts = 3 THEN SUBSTRING(v_BI_LMT FROM 1 FOR v_BI_LMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_Limit_FIELD1,
    CASE
      WHEN v_BI_LMT_Parts = 1 THEN '0'
      WHEN v_BI_LMT_Parts = 2 THEN SUBSTRING(v_BI_LMT FROM v_BI_LMT_Part1_Pos + 1)
      WHEN v_BI_LMT_Parts = 3 THEN SUBSTRING(v_BI_LMT FROM v_BI_LMT_Part1_Pos + 1 FOR v_BI_LMT_Part2_Pos - v_BI_LMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_Limit_FIELD2,
    CASE
      WHEN v_BI_LMT_Parts = 1 THEN '0'
      WHEN v_BI_LMT_Parts = 2 THEN '0'
      WHEN v_BI_LMT_Parts = 3 THEN SUBSTRING(v_BI_LMT FROM v_BI_LMT_Part2_Pos + 1)
      ELSE '0'
    END AS v_Limit_FIELD3,
    CAST(v_Limit_FIELD1 AS DECIMAL) AS BI_LMT_1_Decimal,
    CAST(v_Limit_FIELD2 AS DECIMAL) AS BI_LMT_2_Decimal,
    CAST(v_Limit_FIELD3 AS DECIMAL) AS BI_LMT_3_Decimal
  FROM EXP_Pass_Through
),

EXP_CvgAmount_Split AS (
  SELECT
    *,
    REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', '') AS v_CVG_AMT,
    LENGTH(v_CVG_AMT) - LENGTH(REPLACE(v_CVG_AMT, '/', '')) + 1 AS v_CVG_AMT_Parts,
    POSITION('/' IN v_CVG_AMT) AS v_CVG_AMT_Part1_Pos,
    POSITION('/' IN v_CVG_AMT FROM v_CVG_AMT_Part1_Pos + 1) AS v_CVG_AMT_Part2_Pos,
    CASE
      WHEN v_CVG_AMT_Parts = 1 THEN v_CVG_AMT
      WHEN v_CVG_AMT_Parts = 2 THEN SUBSTRING(v_CVG_AMT FROM 1 FOR v_CVG_AMT_Part1_Pos - 1)
      WHEN v_CVG_AMT_Parts = 3 THEN SUBSTRING(v_CVG_AMT FROM 1 FOR v_CVG_AMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD1,
    CASE
      WHEN v_CVG_AMT_Parts = 1 THEN '0'
      WHEN v_CVG_AMT_Parts = 2 THEN SUBSTRING(v_CVG_AMT FROM v_CVG_AMT_Part1_Pos + 1)
      WHEN v_CVG_AMT_Parts = 3 THEN SUBSTRING(v_CVG_AMT FROM v_CVG_AMT_Part1_Pos + 1 FOR v_CVG_AMT_Part2_Pos - v_CVG_AMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD2,
    CASE
      WHEN v_CVG_AMT_Parts = 1 THEN '0'
      WHEN v_CVG_AMT_Parts = 2 THEN '0'
      WHEN v_CVG_AMT_Parts = 3 THEN SUBSTRING(v_CVG_AMT FROM v_CVG_AMT_Part2_Pos + 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD3,
    CAST(v_AMOUNT_FIELD1 AS DECIMAL) AS CVG_AMT_1_Decimal,
    CAST(v_AMOUNT_FIELD2 AS DECIMAL) AS CVG_AMT_2_Decimal,
    CAST(v_AMOUNT_FIELD3 AS DECIMAL) AS CVG_AMT_3_Decimal
  FROM EXP_Pass_Through
),

EXP_Derive_NISS_CVG_CD_And_PassThru AS (
  SELECT
    *,
    CAST(REPLACE(LTRIM(RTRIM(COLL_DED)), ',', '') AS INTEGER) AS v_COLL_DED,
    CASE
      WHEN POSITION('/' IN COMP_DED) = 0 THEN CAST(REPLACE(LTRIM(RTRIM(COMP_DED)), ',', '') AS INTEGER)
      ELSE NULL
    END AS v_COMP_DED,
    CASE
      WHEN PIP_WVR_WL_IND = 1 THEN 'Y'
      WHEN PIP_WVR_WL_IND = 0 THEN 'N'
      ELSE ''
    END AS v_PIP_WVR_WL_IND,
    CASE
      WHEN PIP_MED_SEC_IND = 1 THEN 'Y'
      WHEN PIP_MED_SEC_IND = 0 THEN 'N'
      ELSE ''
    END AS v_PIP_MED_SEC_IND,
    CASE
      WHEN PIP_LOSS_INCOME_IND = 1 THEN 'Y'
      WHEN PIP_LOSS_INCOME_IND = 0 THEN 'N'
      ELSE ''
    END AS v_PIP_LOSS_INCOME_IND,
    CASE
      WHEN MI_PPO_IND = 1 THEN 'Y'
      WHEN MI_PPO_IND = 0 THEN 'N'
      ELSE ''
    END AS v_MI_PPO_IND
  FROM EXP_Pass_Through
),

UPD_NISS_CVG_CD AS (
  SELECT
    *,
    CASE
      WHEN DD_UPDATE THEN 'Updated'
      ELSE 'Not Updated'
    END AS Update_Status
  FROM EXP_Derive_NISS_CVG_CD_And_PassThru
)

SELECT * FROM UPD_NISS_CVG_CD;