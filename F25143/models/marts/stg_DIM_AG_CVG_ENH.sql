{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ON_OFF_PREM_SK" AS on_off_prem_sk, -- Surrogate key for on/off premium
        "PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key
        "SOI_ID" AS soi_id, -- SOI ID
        "CVG_CD" AS cvg_cd, -- Coverage code
        "LOB" AS lob -- Line of business
    FROM {{ source('AGDM', 'DIM_AG_CVG_ENH') }}
)
SELECT
    on_off_prem_sk,
    plcy_id_sk,
    soi_id,
    cvg_cd,
    lob
FROM source_data