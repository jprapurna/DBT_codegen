{{
  config(materialized='ephemeral')
}}

WITH EXP_PASS_THROUGH AS (
  -- Node: EXP_PASS_THROUGH
  -- Description: Pass-through transformation for fields without modification
  SELECT
    NISS_APRM_DETL_SK,
    ST_CD,
    ST_ABBR,
    ACCTNG_LOB,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    AGE,
    GENDR,
    MRTL_STAT,
    AUTO_USE_CD,
    SOI_TYP,
    NISS_CLASS_CD,
    REC_DROP_IND,
    REC_DROP_RSN_DESC,
    REC_EXCPN_IND,
    REC_EXCPN_RSN_DESC,
    PRINCIPAL_OPRT,
    SOURCE_IND_DERIVED,
    CVG_TYP_CD
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),

EXP_DERV_CLASS_CD AS (
  -- Node: EXP_DERV_CLASS_CD
  -- Description: Derive class code for Toggle Auto data
  SELECT
    NISS_APRM_DETL_SK,
    ST_CD,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    RATNG_CMPY_CD,
    MLT_CAR_IND,
    AGE,
    CASE 
      WHEN AGE IS NULL THEN 0
      ELSE AGE
    END AS IAGE,
    GENDR,
    MRTL_STAT,
    AUTO_USE_CD,
    SOI_TYP,
    CASE 
      WHEN CVG_TYP_CD = 'A' THEN 'CLASS_A'
      WHEN CVG_TYP_CD = 'B' THEN 'CLASS_B'
      ELSE 'CLASS_UNKNOWN'
    END AS NISS_CLASS_CD
  FROM EXP_PASS_THROUGH
),

UPD_NISS_CLASS_CD AS (
  -- Node: UPD_NISS_CLASS_CD
  -- Description: Update strategy to apply DD_UPDATE logic
  SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND,
    CASE 
      WHEN REC_EXCPN_IND = 1 THEN 'Exception Found'
      ELSE 'No Exception'
    END AS REC_EXCP_DESC
  FROM EXP_DERV_CLASS_CD
)

SELECT *
FROM UPD_NISS_CLASS_CD;