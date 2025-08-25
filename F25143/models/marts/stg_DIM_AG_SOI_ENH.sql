{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SOI_ENH_SK" AS soi_enh_sk, -- Surrogate key for SOI enhancement
        "PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key
        "SOI_ID" AS soi_id, -- SOI ID
        "SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp
        "SRC_EFF_DT" AS src_eff_dt -- Source effective date
    FROM {{ source('AGDM', 'DIM_AG_SOI_ENH') }}
)
SELECT
    soi_enh_sk,
    plcy_id_sk,
    soi_id,
    src_trans_tmsp,
    src_eff_dt
FROM source_data