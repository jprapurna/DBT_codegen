{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "PLCY_ENH_SK" AS plcy_enh_sk, -- Surrogate key for policy enhancement
        "PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key
        "SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp
        "SRC_EFF_DT" AS src_eff_dt, -- Source effective date
        "ON_OFF_PREM_TYP_RECRD" AS on_off_prem_typ_recrd -- On/off premium type record
    FROM {{ source('AGDM', 'DIM_AG_PLCY_ENH') }}
)
SELECT
    plcy_enh_sk,
    plcy_id_sk,
    src_trans_tmsp,
    src_eff_dt,
    on_off_prem_typ_recrd
FROM source_data