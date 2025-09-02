{{ config(materialized='view') }}

WITH transaction_type_policy AS (
    SELECT
        "TRANS_TYP_PLCY_SK" AS trans_typ_plcy_sk, -- Primary key for transaction type policy
        "TRANS_TYP_PLCY_CD" AS trans_typ_plcy_cd, -- Transaction type policy code
        "TRANS_TYP_PLCY_DESC" AS trans_typ_plcy_desc, -- Transaction type policy description
        "CR_BY_MAPNG_ID" AS cr_by_mapng_id, -- Created by mapping ID
        "DW_CR_TMSP" AS dw_cr_tmsp, -- Data warehouse creation timestamp
        "UPD_BY_MAPNG_ID" AS upd_by_mapng_id, -- Updated by mapping ID
        "DW_UPD_TMSP" AS dw_upd_tmsp, -- Data warehouse update timestamp
        "WRK_FLOW_RUN_ID" AS wrk_flow_run_id -- Workflow run ID
    FROM {{ source('GENAI_POWER_BI', 'DIM_AG_TRANS_TYP_PLCY') }}
)
SELECT
    trans_typ_plcy_sk,
    trans_typ_plcy_cd,
    trans_typ_plcy_desc,
    cr_by_mapng_id,
    dw_cr_tmsp,
    upd_by_mapng_id,
    dw_upd_tmsp,
    wrk_flow_run_id
FROM transaction_type_policy