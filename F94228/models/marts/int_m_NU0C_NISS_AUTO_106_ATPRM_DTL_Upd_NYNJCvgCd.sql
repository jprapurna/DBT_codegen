{{
  config(materialized='ephemeral')
}}

WITH EXP_CvgAmount_Split AS (
  SELECT
    *,
    REPLACE(LTRIM(RTRIM(CVG_AMT)), ',', '') AS v_CVG_AMT,
    LENGTH(REPLACE(LTRIM(RTRIM(CVG_AMT)), '/', '')) - LENGTH(LTRIM(RTRIM(CVG_AMT)))/'/' + 1 AS v_CVG_AMT_Parts,
    POSITION('/' IN v_CVG_AMT) AS v_CVG_AMT_Part1_Pos,
    POSITION('/' IN v_CVG_AMT, POSITION('/' IN v_CVG_AMT) + 1) AS v_CVG_AMT_Part2_Pos,
    CASE 
      WHEN v_CVG_AMT_Parts = 1 THEN v_CVG_AMT
      WHEN v_CVG_AMT_Parts = 2 THEN SUBSTR(v_CVG_AMT, 1, v_CVG_AMT_Part1_Pos - 1)
      WHEN v_CVG_AMT_Parts = 3 THEN SUBSTR(v_CVG_AMT, 1, v_CVG_AMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD1,
    CASE 
      WHEN v_CVG_AMT_Parts = 1 THEN '0'
      WHEN v_CVG_AMT_Parts = 2 THEN SUBSTR(v_CVG_AMT, v_CVG_AMT_Part1_Pos + 1)
      WHEN v_CVG_AMT_Parts = 3 THEN SUBSTR(v_CVG_AMT, v_CVG_AMT_Part1_Pos + 1, v_CVG_AMT_Part2_Pos - v_CVG_AMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD2,
    CASE 
      WHEN v_CVG_AMT_Parts = 1 THEN '0'
      WHEN v_CVG_AMT_Parts = 2 THEN '0'
      WHEN v_CVG_AMT_Parts = 3 THEN SUBSTR(v_CVG_AMT, v_CVG_AMT_Part2_Pos + 1)
      ELSE '0'
    END AS v_AMOUNT_FIELD3,
    CAST(v_AMOUNT_FIELD1 AS DECIMAL) AS CVG_AMT_1_Decimal,
    CAST(v_AMOUNT_FIELD2 AS DECIMAL) AS CVG_AMT_2_Decimal,
    CAST(v_AMOUNT_FIELD3 AS DECIMAL) AS CVG_AMT_3_Decimal,
    v_CVG_AMT_Parts AS CVG_AMT_NO_OF_PARTS,
    v_CVG_AMT AS SRC_CVG_AMT
  FROM {{ source('source_system', 'WRK_BIRP_NISS_APRM_DETL') }}
),

EXP_BILimit_Split AS (
  SELECT
    *,
    REPLACE(LTRIM(RTRIM(BI_LMT)), ',', '') AS v_BI_LMT,
    LENGTH(REPLACE(LTRIM(RTRIM(BI_LMT)), '/', '')) - LENGTH(LTRIM(RTRIM(BI_LMT)))/'/' + 1 AS v_BI_LMT_Parts,
    POSITION('/' IN v_BI_LMT) AS v_BI_LMT_Part1_Pos,
    POSITION('/' IN v_BI_LMT, POSITION('/' IN v_BI_LMT) + 1) AS v_BI_LMT_Part2_Pos,
    CASE 
      WHEN v_BI_LMT_Parts = 1 THEN v_BI_LMT
      WHEN v_BI_LMT_Parts = 2 THEN SUBSTR(v_BI_LMT, 1, v_BI_LMT_Part1_Pos - 1)
      WHEN v_BI_LMT_Parts = 3 THEN SUBSTR(v_BI_LMT, 1, v_BI_LMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_LIMIT_FIELD1,
    CASE 
      WHEN v_BI_LMT_Parts = 1 THEN '0'
      WHEN v_BI_LMT_Parts = 2 THEN SUBSTR(v_BI_LMT, v_BI_LMT_Part1_Pos + 1)
      WHEN v_BI_LMT_Parts = 3 THEN SUBSTR(v_BI_LMT, v_BI_LMT_Part1_Pos + 1, v_BI_LMT_Part2_Pos - v_BI_LMT_Part1_Pos - 1)
      ELSE '0'
    END AS v_LIMIT_FIELD2,
    CASE 
      WHEN v_BI_LMT_Parts = 1 THEN '0'
      WHEN v_BI_LMT_Parts = 2 THEN '0'
      WHEN v_BI_LMT_Parts = 3 THEN SUBSTR(v_BI_LMT, v_BI_LMT_Part2_Pos + 1)
      ELSE '0'
    END AS v_LIMIT_FIELD3,
    CAST(v_LIMIT_FIELD1 AS DECIMAL) AS BI_LMT_1_Decimal,
    CAST(v_LIMIT_FIELD2 AS DECIMAL) AS BI_LMT_2_Decimal,
    CAST(v_LIMIT_FIELD3 AS DECIMAL) AS BI_LMT_3_Decimal,
    v_BI_LMT_Parts AS BI_LMT_NO_OF_PARTS,
    v_BI_LMT AS SRC_BI_LMT
  FROM EXP_CvgAmount_Split
),

EXP_Derive_NISS_CVG_CD_And_PassThru AS (
  SELECT
    *,
    CASE 
      WHEN ST_ABBR = 'NJ' THEN 
        CASE 
          WHEN ACCTNG_LOB = '191' AND NJ_HLTH_INSR_PRIM = 'Y' AND CVG_TYP_CD IN ('35050', '35058', '35102') THEN '691'
          WHEN ACCTNG_LOB = '191' AND NJ_HLTH_INSR_PRIM = 'Y' AND CVG_TYP_CD IN ('35051', '35059', '35103') THEN '693'
          WHEN ACCTNG_LOB = '191' AND NJ_HLTH_INSR_PRIM = 'Y' AND CVG_TYP_CD IN ('35066', '35067', '35106') THEN '699'
          ELSE '???'
        END
      WHEN ST_ABBR = 'NY' THEN 
        CASE 
          WHEN ACCTNG_LOB = '191' AND CVG_TYP_CD IN ('35030', '35007') AND v_PIP_LOSS_INCOME_IND != 'Y' AND v_CVG_AMT = '50000' THEN '0711'
          WHEN ACCTNG_LOB = '191' AND CVG_TYP_CD IN ('35030', '35007') AND v_PIP_LOSS_INCOME_IND != 'Y' AND v_CVG_AMT IN ('50000/100', '50000/200', '0') THEN '0771'
          ELSE ''
        END
      ELSE '???'
    END AS v_NISS_CVG_CD,
    CASE 
      WHEN v_NISS_CVG_CD = '' THEN '???'
      ELSE v_NISS_CVG_CD
    END AS NISS_CVG_CD,
    CASE 
      WHEN v_REC_EXCPN_IND = 'Y' OR i_REC_EXCPN_IND = 'Y' THEN 'Y'
      ELSE ''
    END AS REC_EXCPN_IND
  FROM EXP_BILimit_Split
),

UPD_NISS_CVG_CD AS (
  SELECT
    *,
    'DD_UPDATE' AS NISS_APRM_DETL_SK,
    'DD_UPDATE' AS NISS_CVG_CD,
    'DD_UPDATE' AS NISS_SSL_LIAB_CD,
    'DD_UPDATE' AS NISS_LIAB_OR_NO_FAULT_CD,
    'DD_UPDATE' AS REC_EXCPN_IND
  FROM EXP_Derive_NISS_CVG_CD_And_PassThru
)

SELECT * FROM UPD_NISS_CVG_CD;