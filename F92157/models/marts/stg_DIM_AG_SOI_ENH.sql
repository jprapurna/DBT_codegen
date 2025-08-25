{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SOI_ENH_SK" AS soi_enh_sk, -- Surrogate key for SOI enhancement
        "SOI_ID" AS soi_id, -- SOI identifier
        "ADD_UNIT_IND" AS add_unit_ind -- Additional unit indicator
    FROM {{ source('AGDM', 'DIM_AG_SOI_ENH') }}
)
SELECT
    soi_enh_sk,
    soi_id,
    add_unit_ind
FROM source_data
