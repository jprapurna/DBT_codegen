{{ config(materialized='view') }}

WITH source_data AS (
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_TA_NISS_NU0C_APRM_DTL') }}
),

exptrans AS (
  SELECT
    FISC_PER_YR,
    NAIC_CMPNY_CD,
    NISS_CMPNY_CD,
    ST_NM,
    ST_CD,
    NISS_ST_CD,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    GRNG_ZIP,
    PP_COMMRCL_CD,
    AUTO_USE_CD,
    NISS_TERR_CD
  FROM source_data
),

exp_passthru AS (
  SELECT
    FISC_PER_YR,
    NAIC_CMPNY_CD,
    NISS_CMPNY_CD AS o_NISS_CMPNY_CD,
    ST_NM,
    ST_CD,
    NISS_ST_CD AS o_NISS_ST_CD,
    ST_ABBR,
    ACCTNG_LOB,
    CVG_TYP_CD,
    CVG_AMT,
    GRNG_ZIP,
    PP_COMMRCL_CD,
    AUTO_USE_CD,
    NISS_TERR_CD
  FROM exptrans
),

lkp_fdr_lib_rbi_ref_auto_terr_bystziplob AS (
  SELECT
    r.*
  FROM {{ source('GENAI_POWER_BI', 'RBI_REF_AUTO_TERR') }} r
  JOIN exp_passthru e
    ON r.NISS_ST_CD = e.o_NISS_ST_CD
   AND r.ST_ABBRV = e.ST_ABBR
   AND r.ZIP_CD = e.GRNG_ZIP
   AND r.PP_COMMRCL_CD = e.PP_COMMRCL_CD
),

exp_passthru_tgt AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY FISC_PER_YR) AS v_CNT,
    CONCAT(FISC_PER_YR, NAIC_CMPNY_CD) AS NISS_APRM_DETL_SK,
    EXTRACT(YEAR FROM TRY_TO_DATE(FISC_PER_YR, 'YYYY-MM-DD')) AS CALL_YR,
    AUTO_USE_CD AS o_AUTO_USE_CD,
    NISS_TERR_CD AS o_NISS_TERR_CD
  FROM exp_passthru
)

SELECT *
FROM exp_passthru_tgt