{{
  config(
    unique_key='NISS_APRM_DETL_SK',
    strategy='timestamp',
    updated_at='last_updated_at'
  )
}}

SELECT
  NISS_APRM_DETL_SK,
  ST_ABBR,
  ACCTNG_LOB,
  BI_LMT,
  PRD_GRP_CD,
  NJ_NO_LWST_LMT_IND,
  NJ_NMD_DRVR_EXCL_IND,
  CVG_TYP_CD,
  last_updated_at
FROM {{ source('source_system', 'historical_table') }}