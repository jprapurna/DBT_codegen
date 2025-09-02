{{ config(materialized='view') }}

WITH coverage_data AS (
    SELECT
        "CVG_SK" AS cvg_sk, -- Primary key for coverage
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "ACCTNG_LOB" AS acctng_lob, -- Accounting line of business
        "LOB" AS lob, -- Line of business
        "CVG_TYP_CD" AS cvg_typ_cd, -- Coverage type code
        "CVG_TYP_DESC" AS cvg_typ_desc, -- Coverage type description
        "DED_PCT" AS ded_pct, -- Deductible percentage
        "MINI_CVG_SK" AS mini_cvg_sk, -- Mini coverage SK
        "MINI_CVG_CHK_SUM" AS mini_cvg_chk_sum, -- Mini coverage checksum
        "CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
        "DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS wrk_flow_run_id -- Workflow run ID
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_CVG') }}
)
SELECT
    cvg_sk,
    chk_sum_attr,
    acctng_lob,
    lob,
    cvg_typ_cd,
    cvg_typ_desc,
    ded_pct,
    mini_cvg_sk,
    mini_cvg_chk_sum,
    cr_by_mapng_id,
    dw_cr_tmsp,
    upd_by_mapng_id,
    dw_upd_tmsp,
    wrk_flow_run_id
FROM coverage_data