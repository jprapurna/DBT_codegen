{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ON_OFF_PREM_SK" AS on_off_prem_sk, -- Surrogate key for on/off premium
        "CVG_CD" AS cvg_cd, -- Coverage code
        "LOB" AS lob -- Line of business
    FROM {{ source('AGDM', 'DIM_AG_CVG_ENH') }}
)
SELECT
    on_off_prem_sk,
    cvg_cd,
    lob
FROM source_data