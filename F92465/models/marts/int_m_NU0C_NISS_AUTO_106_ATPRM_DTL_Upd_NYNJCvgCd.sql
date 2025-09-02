{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT 
    NISS_APRM_DETL_SK,
    ST_NM,
    ST_ABBR,
    ACCTNG_LOB,
    LTRIM(RTRIM(CVG_TYP_CD)) AS CVG_TYP_CD,
    LTRIM(RTRIM(CVG_AMT)) AS CVG_AMT,
    LTRIM(RTRIM(BI_LMT)) AS BI_LMT,
    PIP_LOSS_INCOME_IND,
    LTRIM(RTRIM(COALESCE(PRD_GRP_CD, ''))) AS PRD_GRP_CD,
    LTRIM(RTRIM(COALESCE(NJ_HLTH_INSR_PRIM, ''))) AS NJ_HLTH_INSR_PRIM,
    LTRIM(RTRIM(COALESCE(NJ_EXTR_PIP_PKG, ''))) AS NJ_EXTR_PIP_PKG,
    NJ_RESDNC_RLTNSHP_PIP_IND,
    NY_FULL_CVG_GLASS_COMP_IND,
    NY_SSL_IND,
    LTRIM(RTRIM(COMP_DED)) AS COMP_DED,
    LTRIM(RTRIM(COLL_DED)) AS COLL_DED,
    REC_EXCPN_IND,
    REC_EXCPN_RSN_DESC
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL_1') }}
  WHERE ST_ABBR IN ('NY', 'NJ')
),

EXP_BILimit_Split AS (
  SELECT
    *,
    REPLACE(TRIM(BI_LMT), ',', '') AS v_BI_LMT,

    -- Count parts by counting slashes + 1
    (LENGTH(REPLACE(BI_LMT, ',', '')) 
     - LENGTH(REPLACE(REPLACE(BI_LMT, ',', ''), '/', '')) + 1) AS v_BI_LMT_Parts,

    -- First slash position
    CHARINDEX('/', REPLACE(BI_LMT, ',', '')) AS v_BI_LMT_Part1_Pos,

    -- Second slash position
    CHARINDEX('/', REPLACE(BI_LMT, ',', ''), CHARINDEX('/', REPLACE(BI_LMT, ',', '')) + 1) AS v_BI_LMT_Part2_Pos,

    -- Extract the first number before the first slash
    CASE 
      WHEN (LENGTH(REPLACE(BI_LMT, ',', '')) 
            - LENGTH(REPLACE(REPLACE(BI_LMT, ',', ''), '/', '')) + 1) = 1 
        THEN REPLACE(BI_LMT, ',', '')

      WHEN (LENGTH(REPLACE(BI_LMT, ',', '')) 
            - LENGTH(REPLACE(REPLACE(BI_LMT, ',', ''), '/', '')) + 1) IN (2,3) 
        THEN SUBSTRING(REPLACE(BI_LMT, ',', ''), 1, CHARINDEX('/', REPLACE(BI_LMT, ',', '')) - 1)

      ELSE '0'
    END AS BI_LMT_1_Decimal
  FROM source_data
),

EXP_CvgAmount_Split AS (
  SELECT
    REPLACE(TRIM(CVG_AMT), ',', '') AS v_CVG_AMT,
    (LENGTH(REPLACE(CVG_AMT, ',', '')) 
     - LENGTH(REPLACE(REPLACE(CVG_AMT, ',', ''), '/', '')) + 1) AS v_CVG_AMT_Parts,
    CHARINDEX('/', REPLACE(CVG_AMT, ',', '')) AS v_CVG_AMT_Part1_Pos,
    CHARINDEX('/', REPLACE(CVG_AMT, ',', ''), CHARINDEX('/', REPLACE(CVG_AMT, ',', '')) + 1) AS v_CVG_AMT_Part2_Pos,
    CASE 
      WHEN (LENGTH(REPLACE(CVG_AMT, ',', '')) 
            - LENGTH(REPLACE(REPLACE(CVG_AMT, ',', ''), '/', '')) + 1) = 1 
        THEN REPLACE(CVG_AMT, ',', '')
      WHEN (LENGTH(REPLACE(CVG_AMT, ',', '')) 
            - LENGTH(REPLACE(REPLACE(CVG_AMT, ',', ''), '/', '')) + 1) IN (2,3) 
        THEN SUBSTRING(REPLACE(CVG_AMT, ',', ''), 1, CHARINDEX('/', REPLACE(CVG_AMT, ',', '')) - 1)
      ELSE '0'
    END AS CVG_AMT_1_Decimal
  FROM EXP_BILimit_Split
),

EXP_Derive_NISS_CVG_CD_And_PassThru AS (
  SELECT
    REPLACE(TRIM(CVG_AMT), ',', '') AS v_CVG_AMT,
    CASE 
      WHEN PIP_LOSS_INCOME_IND = 1 THEN 'Y'
      WHEN PIP_LOSS_INCOME_IND = 0 THEN 'N'
      ELSE ''
    END AS v_PIP_LOSS_INCOME_IND,
    CASE 
      WHEN NJ_RESDNC_RLTNSHP_PIP_IND = 1 THEN 'Y'
      WHEN NJ_RESDNC_RLTNSHP_PIP_IND = 0 THEN 'N'
      ELSE ''
    END AS v_NJ_RESDNC_RLTNSHP_PIP_IND,
    CASE 
      WHEN NY_FULL_CVG_GLASS_COMP_IND = 1 THEN 'Y'
      WHEN NY_FULL_CVG_GLASS_COMP_IND = 0 THEN 'N'
      ELSE ''
    END AS v_NY_FULL_CVG_GLASS_COMP_IND
  FROM EXP_CvgAmount_Split
),

UPD_NISS_CVG_CD AS (
  SELECT
    *,
    'UPDATE' AS update_strategy   -- static since DD_UPDATE was undefined
  FROM EXP_Derive_NISS_CVG_CD_And_PassThru
)

SELECT * FROM UPD_NISS_CVG_CD