{{
  config(materialized='ephemeral')
}}

WITH source_fdr_lib_wrk_birp_niss_aprm_detl1 AS (
  -- Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL1
  SELECT * FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

source_fdr_lib_wrk_birp_niss_aprm_detl AS (
  -- Source: FDR_LIB_WRK_BIRP_NISS_APRM_DETL
  SELECT 
    *,
    D.NISS_APRM_DETL_SK, 
    D.CVG_ATTR_CHCKSUM
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }} D
),

source_wrk_birp_niss_aprm_detl AS (
  -- Source: WRK_BIRP_NISS_APRM_DETL
  SELECT *
  FROM {{ source('GENAI_POWER_BI', 'WRK_BIRP_NISS_APRM_DETL') }}
),

exptrans_step AS (
  -- Node: EXPTRANS
  SELECT 
    CVG_ATTR_CHCKSUM,
  FROM source_fdr_lib_wrk_birp_niss_aprm_detl1
),

exptrans1_step AS (
  -- Node: EXPTRANS1
  SELECT 
    NISS_APRM_DETL_SK,
    CVG_ATTR_CHCKSUM
  FROM source_fdr_lib_wrk_birp_niss_aprm_detl
),

jnrtrans_step AS (
  -- Node: JNRTRANS
  SELECT 
    exptrans1_step.NISS_APRM_DETL_SK,
    exptrans_step.CVG_ATTR_CHCKSUM AS CVG_ATTR_CHCKSUM1,
    exptrans1_step.CVG_ATTR_CHCKSUM,
  FROM exptrans1_step
  JOIN exptrans_step
    ON exptrans1_step.CVG_ATTR_CHCKSUM = exptrans_step.CVG_ATTR_CHCKSUM
),

exp_passthrough_step AS (
  -- Node: EXP_PassThrough
  SELECT 
    NISS_APRM_DETL_SK,
    CVG_ATTR_SK
  FROM jnrtrans_step
),

upd_cvg_attr_sk_step AS (
  -- Node: Upd_CVG_ATTR_SK
  SELECT 
    NISS_APRM_DETL_SK,
    CVG_ATTR_SK
  FROM exp_passthrough_step
  -- Update Strategy: DD_UPDATE
)

SELECT *
FROM upd_cvg_attr_sk_step