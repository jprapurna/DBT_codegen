{{ config(materialized='view') }}

WITH source_data AS (
  SELECT
    *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE ST_ABBR IN ('NY', 'NJ')
),

-- Node: EXP_PassThru
exp_passthru AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    PRD_GRP_CD,
    COMP_DED,
    COLL_DED
  FROM source_data
),

-- Node: EXP_CvgAmount_Split
exp_cvgamount_split AS (
  SELECT
    CVG_AMT,
    SPLIT_PART(CVG_AMT, '/', 1) AS CVG_AMT_1_String,
    SPLIT_PART(CVG_AMT, '/', 2) AS CVG_AMT_2_String,
    SPLIT_PART(CVG_AMT, '/', 3) AS CVG_AMT_3_String,
    CAST(SPLIT_PART(CVG_AMT, '/', 1) AS DECIMAL) AS CVG_AMT_1_Decimal,
    CAST(SPLIT_PART(CVG_AMT, '/', 2) AS DECIMAL) AS CVG_AMT_2_Decimal,
    CAST(SPLIT_PART(CVG_AMT, '/', 3) AS DECIMAL) AS CVG_AMT_3_Decimal,
    CASE 
      WHEN POSITION('/' IN CVG_AMT) > 0 THEN ARRAY_SIZE(SPLIT(CVG_AMT, '/'))
      ELSE 1
    END AS CVG_AMT_NO_OF_PARTS,
    CVG_AMT AS SRC_CVG_AMT
  FROM exp_passthru
),

-- Node: EXP_Derive_NISS_PLCY_LMT_CD_And_PassThru
exp_derive_niss_plcy_lmt_cd_and_passthru AS (
  SELECT
    exp_passthru.NISS_APRM_DETL_SK,
    exp_passthru.ST_ABBR,
    exp_passthru.ACCTNG_LOB,
    exp_passthru.CVG_TYP_CD,
    exp_passthru.CVG_AMT,
    exp_passthru.PRD_GRP_CD,
    exp_passthru.COMP_DED,
    exp_passthru.COLL_DED,
    CASE 
      WHEN ST_ABBR = 'NY' THEN 'NY_LMT'
      WHEN ST_ABBR = 'NJ' THEN 'NJ_LMT'
      ELSE NULL
    END AS NISS_PLCY_LMT_CD,
    CASE 
      WHEN COMP_DED IS NOT NULL THEN 'COMP_DED'
      WHEN COLL_DED IS NOT NULL THEN 'COLL_DED'
      ELSE NULL
    END AS NISS_DEDUC_CD
  FROM exp_passthru
),

-- Node: UPD_NISS_PLCY_LMT_CD
upd_niss_plcy_lmt_cd AS (
  SELECT
    NISS_APRM_DETL_SK,
    NISS_PLCY_LMT_CD,
    NISS_DEDUC_CD
  FROM exp_derive_niss_plcy_lmt_cd_and_passthru
)

SELECT *
FROM upd_niss_plcy_lmt_cd