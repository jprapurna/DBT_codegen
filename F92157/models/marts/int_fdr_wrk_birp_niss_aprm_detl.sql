{{ config(materialized='table') }}

SELECT
  NISS_APRM_DETL_SK AS niss_aprm_detl_sk,
  ST_ABBR AS st_abbr,
  ACCTNG_LOB AS acctng_lob,
  CVG_TYP_CD AS cvg_typ_cd,
  CVG_AMT AS cvg_amt,
  NISS_CVG_CD AS niss_cvg_cd
FROM {{ source('fdr', 'wrk_birp_niss_aprm_detl') }}
WHERE ST_ABBR = 'CT'