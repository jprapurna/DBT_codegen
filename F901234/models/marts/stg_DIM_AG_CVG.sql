{{ config(materialized='view') }}

SELECT
"CVG_SK" AS cvg_sk, -- Coverage SK.
"CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute.
"ACCTNG_LOB" AS acctng_lob, -- Accounting line of business.
"LOB" AS lob, -- Line of business.
"CVG_TYP_CD" AS cvg_typ_cd, -- Coverage type code.
"CVG_TYP_DESC" AS cvg_typ_desc, -- Coverage type description.
"DED_PCT" AS ded_pct, -- Deductible percentage.
"MINI_CVG_SK" AS mini_cvg_sk, -- Mini coverage SK.
"MINI_CVG_CHK_SUM" AS mini_cvg_chk_sum, -- Mini coverage checksum.
"CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID.
"DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp.
"UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID.
"DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp.
"WRK_FLOW_RUN_ID" AS wrk_flow_run_id -- Workflow run ID.
FROM {{ source('DIM_AG_CVG', 'DIM_AG_CVG') }}