
{{ config(materialized='view') }}

WITH source_fdr_lib_wrk_birp_niss_aprm_detl1 AS (
  SELECT * 
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_fdr_lib_wrk_birp_niss_aprm_detl AS (
  SELECT * 
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_wrk_birp_niss_aprm_detl AS (
  SELECT * 
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

exptrans_step AS (
  SELECT 
    CVG_ATTR_CHCKSUM
  FROM source_fdr_lib_wrk_birp_niss_aprm_detl1
),

exptrans1_step AS (
  SELECT 
    NISS_APRM_DETL_SK,
    CVG_ATTR_CHCKSUM,
    CVG_ATTR_SK  -- ✅ Added this column
  FROM source_fdr_lib_wrk_birp_niss_aprm_detl
),

jnrtrans_step AS (
  SELECT 
    exptrans1_step.NISS_APRM_DETL_SK,
    exptrans1_step.CVG_ATTR_SK,  -- ✅ Passed through
    exptrans_step.CVG_ATTR_CHCKSUM AS CVG_ATTR_CHCKSUM1,
    exptrans1_step.CVG_ATTR_CHCKSUM
  FROM exptrans1_step
  JOIN exptrans_step
    ON exptrans1_step.CVG_ATTR_CHCKSUM = exptrans_step.CVG_ATTR_CHCKSUM
),

exp_passthrough_step AS (
  SELECT 
    NISS_APRM_DETL_SK,
    CVG_ATTR_SK
  FROM jnrtrans_step
),

upd_cvg_attr_sk_step AS (
  SELECT 
    NISS_APRM_DETL_SK,
    CVG_ATTR_SK
  FROM exp_passthrough_step
)

SELECT *
FROM upd_cvg_attr_sk_step
