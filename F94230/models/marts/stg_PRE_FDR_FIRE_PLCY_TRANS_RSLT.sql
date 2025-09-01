{{ config(materialized='view') }}

WITH pre_fdr_fire_plcy_trans_rslt AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'PRE_FDR_FIRE_PLCY_TRANS_RSLT') }}
)
SELECT
    *
FROM pre_fdr_fire_plcy_trans_rslt