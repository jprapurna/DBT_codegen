{{ config(materialized='ephemeral') }}

WITH source_wrk_birp_niss_aprm_dtl AS (
  SELECT 
    *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE ST_ABBR IN ('NY', 'NJ')
),

exp_bilimit_split AS (
  SELECT
    t.*,
    TRIM(BI_LMT) AS v_BI_LMT,
    LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1 AS v_BI_LMT_Parts,
    
    -- First slash position
    POSITION('/' IN TRIM(BI_LMT)) AS v_BI_LMT_Part1_Pos,

    -- Second slash position using regex (Snowflake way)
    LENGTH(REGEXP_SUBSTR(TRIM(BI_LMT), '.*/.*/')) - 
      LENGTH(REGEXP_REPLACE(REGEXP_SUBSTR(TRIM(BI_LMT), '.*/.*/'), '[^/]', '')) + 1 
      AS v_BI_LMT_Part2_Pos,

    CASE 
      WHEN (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) = 1 
        THEN TRIM(BI_LMT)
      WHEN (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) = 2 
        THEN SUBSTRING(TRIM(BI_LMT), 1, POSITION('/' IN TRIM(BI_LMT)) - 1)
      WHEN (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) = 3 
        THEN SUBSTRING(TRIM(BI_LMT), 1, POSITION('/' IN TRIM(BI_LMT)) - 1)
      ELSE '0'
    END AS v_Limit_FIELD1,

    CASE 
      WHEN (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) = 1 
        THEN '0'
      WHEN (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) = 2 
        THEN SPLIT_PART(TRIM(BI_LMT), '/', 2)
      WHEN (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) = 3 
        THEN SPLIT_PART(TRIM(BI_LMT), '/', 2)
      ELSE '0'
    END AS v_Limit_FIELD2,

    CASE 
      WHEN (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) = 3 
        THEN SPLIT_PART(TRIM(BI_LMT), '/', 3)
      ELSE '0'
    END AS v_Limit_FIELD3,

    CAST(NULLIF(SPLIT_PART(TRIM(BI_LMT), '/', 1), '') AS DECIMAL) AS BI_LMT_1_Decimal,
    CAST(NULLIF(SPLIT_PART(TRIM(BI_LMT), '/', 2), '') AS DECIMAL) AS BI_LMT_2_Decimal,
    CAST(NULLIF(SPLIT_PART(TRIM(BI_LMT), '/', 3), '') AS DECIMAL) AS BI_LMT_3_Decimal,

    (LENGTH(TRIM(BI_LMT)) - LENGTH(REPLACE(TRIM(BI_LMT), '/', '')) + 1) AS BI_LMT_NO_OF_PARTS,
    TRIM(BI_LMT) AS SRC_BI_LMT
  FROM source_wrk_birp_niss_aprm_dtl t
),

exp_derive_niss_sublob_cd_and_passthru AS (
  SELECT
    *,
    CASE 
      WHEN NJ_NO_LWST_LMT_IND = 1 THEN 'Y'
      ELSE 'N'
    END AS v_NJ_NO_LWST_LMT_IND,
    CASE 
      WHEN NJ_NMD_DRVR_EXCL_IND = 1 THEN 'Y'
      ELSE 'N'
    END AS v_NJ_NMD_DRVR_EXCL_IND,
    CASE 
      WHEN ST_ABBR = 'NJ' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) IN ('191', '192') AND PRD_GRP_CD != 'BA' AND v_NJ_NO_LWST_LMT_IND = 'Y' THEN '7'
      WHEN ST_ABBR = 'NJ' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) IN ('191', '192') AND PRD_GRP_CD != 'BA' AND v_NJ_NO_LWST_LMT_IND != 'Y' THEN '8'
      WHEN ST_ABBR = 'NJ' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) IN ('191', '192') AND PRD_GRP_CD = 'BA' THEN '9'
      WHEN ST_ABBR = 'NJ' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) = '211' AND PRD_GRP_CD != 'BA' AND v_NJ_NMD_DRVR_EXCL_IND != 'Y' THEN '1'
      WHEN ST_ABBR = 'NJ' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) = '211' AND PRD_GRP_CD != 'BA' AND v_NJ_NMD_DRVR_EXCL_IND = 'Y' THEN '2'
      WHEN ST_ABBR = 'NJ' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) = '211' AND PRD_GRP_CD = 'BA' AND v_NJ_NMD_DRVR_EXCL_IND != 'Y' THEN '3'
      WHEN ST_ABBR = 'NJ' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) = '211' AND PRD_GRP_CD = 'BA' AND v_NJ_NMD_DRVR_EXCL_IND = 'Y' THEN '4'
      WHEN ST_ABBR = 'NJ' THEN '?'
      ELSE '?'
    END AS v_NISS_SUBLOB_CD_NewJersey,
    CASE 
      WHEN ST_ABBR = 'NY' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) IN ('191', '192') AND CVG_TYP_CD NOT IN ('13000', '13006', '13007', '13008') THEN '1'
      WHEN ST_ABBR = 'NY' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) IN ('191', '192') AND CVG_TYP_CD IN ('13000', '13006', '13007', '13008') THEN '2'
      WHEN ST_ABBR = 'NY' AND SUBSTRING(TRIM(ACCTNG_LOB), 1, 3) = '211' THEN '0'
      WHEN ST_ABBR = 'NY' THEN '?'
      ELSE '?'
    END AS v_NISS_SUBLOB_CD_NewYork,
    CASE 
      WHEN ST_ABBR = 'NY' THEN v_NISS_SUBLOB_CD_NewYork
      WHEN ST_ABBR = 'NJ' THEN v_NISS_SUBLOB_CD_NewJersey
      ELSE '?'
    END AS v_NISS_SUBLOB_CD,
    CASE 
      WHEN v_NISS_SUBLOB_CD = '' THEN '?'
      ELSE v_NISS_SUBLOB_CD
    END AS NISS_SUBLOB_CD
  FROM exp_bilimit_split
),

upd_niss_sublob_cd AS (
  SELECT
    *,
    'DD_UPDATE' AS update_strategy
  FROM exp_derive_niss_sublob_cd_and_passthru
)

SELECT * FROM upd_niss_sublob_cd