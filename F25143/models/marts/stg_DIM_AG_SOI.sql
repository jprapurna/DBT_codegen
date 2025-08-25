{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "SOI_SK" AS soi_sk, -- Surrogate key for SOI
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "SOI_ID" AS soi_id, -- SOI ID
        "VIN" AS vin, -- Vehicle identification number
        "VEH_INCEPT_DT" AS veh_incept_dt -- Vehicle inception date
    FROM {{ source('AGDM', 'DIM_AG_SOI') }}
)
SELECT
    soi_sk,
    chk_sum_attr,
    soi_id,
    vin,
    veh_incept_dt
FROM source_data