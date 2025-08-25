{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SOI_SK" AS soi_sk, -- Surrogate key for SOI
        "SOI_ID" AS soi_id, -- SOI identifier
        "VIN" AS vin -- Vehicle identification number
    FROM {{ source('AGDM', 'DIM_AG_SOI') }}
)
SELECT
    soi_sk,
    soi_id,
    vin
FROM source_data
