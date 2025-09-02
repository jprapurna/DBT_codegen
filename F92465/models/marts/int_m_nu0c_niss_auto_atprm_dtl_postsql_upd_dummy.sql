{{
  config(
    materialized='view'
  )
}}

WITH source_wrk_birp_niss_aprm_detl_1 AS (
  SELECT
    *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_wrk_birp_niss_aprm_detl_dummy AS (
  -- This is a dummy session that does not read any rows
  SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    BI_LMT,
    PRD_GRP_CD,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    CVG_TYP_CD
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
  WHERE 1=2
),

exptrans AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    BI_LMT,
    PRD_GRP_CD,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    CVG_TYP_CD
  FROM source_wrk_birp_niss_aprm_detl_1
)

SELECT *
FROM exptrans