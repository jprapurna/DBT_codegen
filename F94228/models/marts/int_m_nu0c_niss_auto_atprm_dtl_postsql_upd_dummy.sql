{{
  config(
    materialized='ephemeral'
  )
}}

WITH source_data AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    BI_LMT,
    PRD_GRP_CD,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    CVG_TYP_CD
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),

-- Node: EXPTRANS
exptrans_step AS (
  SELECT
    NISS_APRM_DETL_SK,
    ST_ABBR,
    ACCTNG_LOB,
    BI_LMT,
    PRD_GRP_CD,
    NJ_NO_LWST_LMT_IND,
    NJ_NMD_DRVR_EXCL_IND,
    CVG_TYP_CD
  FROM source_data
)

SELECT *
FROM exptrans_step;