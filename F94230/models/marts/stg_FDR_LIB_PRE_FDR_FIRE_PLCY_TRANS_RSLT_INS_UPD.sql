{{ config(materialized='view') }}

WITH fdr_lib_pre_fdr_fire_plcy_trans_rslt_ins_upd AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'FDR_LIB_PRE_FDR_FIRE_PLCY_TRANS_RSLT_INS_UPD') }}
)
SELECT
    *
FROM fdr_lib_pre_fdr_fire_plcy_trans_rslt_ins_upd