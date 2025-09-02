{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT 
    NISS_APRM_DETL_SK,
    NISS_CVG_CD,
    NISS_SSL_LIAB_CD,
    NISS_LIAB_OR_NO_FAULT_CD,
    REC_EXCPN_IND,
    BI_LMT,
    REC_EXCPN_RSN_DESC,
    CVG_AMT
  FROM {{ source('source_system', 'table_name') }}
),

-- Node: UPD_NISS_CVG_CD
upd_niss_cvg_cd_step AS (
  SELECT
    *,
    -- Update Strategy logic for DD_UPDATE
    CASE 
      WHEN DD_UPDATE THEN NISS_CVG_CD
      ELSE NULL
    END AS updated_niss_cvg_cd
  FROM source_data
),

-- Node: EXP_BILimit_Split
exp_bilimit_split_step AS (
  SELECT
    *,
    TRIM(REPLACE(BI_LMT, ',', '')) AS v_BI_LMT,
    LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 AS v_BI_LMT_Parts,
    POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) AS v_BI_LMT_Part1_Pos,
    POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', '')), POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) + 1) AS v_BI_LMT_Part2_Pos,
    CASE 
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 1 THEN TRIM(REPLACE(BI_LMT, ',', ''))
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 2 THEN SUBSTRING(TRIM(REPLACE(BI_LMT, ',', '')), 1, POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) - 1)
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 3 THEN SUBSTRING(TRIM(REPLACE(BI_LMT, ',', '')), 1, POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) - 1)
      ELSE '0'
    END AS v_Limit_FIELD1,
    CASE 
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 1 THEN '0'
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 2 THEN SUBSTRING(TRIM(REPLACE(BI_LMT, ',', '')), POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) + 1)
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 3 THEN SUBSTRING(TRIM(REPLACE(BI_LMT, ',', '')), POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) + 1, POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', '')), POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) + 1) - POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) - 1)
      ELSE '0'
    END AS v_Limit_FIELD2,
    CASE 
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 1 THEN '0'
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 2 THEN '0'
      WHEN LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 = 3 THEN SUBSTRING(TRIM(REPLACE(BI_LMT, ',', '')), POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', '')), POSITION('/' IN TRIM(REPLACE(BI_LMT, ',', ''))) + 1) + 1)
      ELSE '0'
    END AS v_Limit_FIELD3,
    CAST(v_Limit_FIELD1 AS INTEGER) AS BI_LMT_1_Decimal,
    CAST(v_Limit_FIELD2 AS INTEGER) AS BI_LMT_2_Decimal,
    CAST(v_Limit_FIELD3 AS INTEGER) AS BI_LMT_3_Decimal,
    LENGTH(TRIM(REPLACE(BI_LMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(BI_LMT, ',', '')), '/', '')) + 1 AS BI_LMT_NO_OF_PARTS,
    TRIM(REPLACE(BI_LMT, ',', '')) AS SRC_BI_LMT
  FROM upd_niss_cvg_cd_step
),

-- Node: EXP_CvgAmount_Split
exp_cvgamount_split_step AS (
  SELECT
    *,
    TRIM(REPLACE(CVG_AMT, ',', '')) AS v_CVG_AMT,
    LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 AS v_CVG_AMT_Parts,
    POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) AS v_CVG_AMT_Part1_Pos,
    POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', '')), POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) + 1) AS v_CVG_AMT_Part2_Pos,
    CASE 
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 1 THEN TRIM(REPLACE(CVG_AMT, ',', ''))
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 2 THEN SUBSTRING(TRIM(REPLACE(CVG_AMT, ',', '')), 1, POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) - 1)
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 3 THEN SUBSTRING(TRIM(REPLACE(CVG_AMT, ',', '')), 1, POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) - 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD1,
    CASE 
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 1 THEN '0'
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 2 THEN SUBSTRING(TRIM(REPLACE(CVG_AMT, ',', '')), POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) + 1)
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 3 THEN SUBSTRING(TRIM(REPLACE(CVG_AMT, ',', '')), POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) + 1, POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', '')), POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) + 1) - POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) - 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD2,
    CASE 
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 1 THEN '0'
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 2 THEN '0'
      WHEN LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 = 3 THEN SUBSTRING(TRIM(REPLACE(CVG_AMT, ',', '')), POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', '')), POSITION('/' IN TRIM(REPLACE(CVG_AMT, ',', ''))) + 1) + 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD3,
    CAST(v_AMOUNT_FIELD1 AS DECIMAL) AS CVG_AMT_1_Decimal,
    CAST(v_AMOUNT_FIELD2 AS DECIMAL) AS CVG_AMT_2_Decimal,
    CAST(v_AMOUNT_FIELD3 AS DECIMAL) AS CVG_AMT_3_Decimal,
    LENGTH(TRIM(REPLACE(CVG_AMT, ',', ''))) - LENGTH(REPLACE(TRIM(REPLACE(CVG_AMT, ',', '')), '/', '')) + 1 AS CVG_AMT_NO_OF_PARTS,
    TRIM(REPLACE(CVG_AMT, ',', '')) AS SRC_CVG_AMT
  FROM exp_bilimit_split_step
),

final AS (
  SELECT
    *
  FROM exp_cvgamount_split_step
)

SELECT * FROM final;