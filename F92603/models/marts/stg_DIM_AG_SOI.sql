{{ config(materialized='view') }}

SELECT
"SOI_SK" AS soi_sk, -- Surrogate key for SOI.
"CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute.
"SOI_ID" AS soi_id, -- SOI ID.
"VIN" AS vin, -- Vehicle identification number.
"VEH_INCEPT_DT" AS veh_incept_dt, -- Vehicle inception date.
"UNIT_NUM" AS unit_num -- Unit number.
FROM {{ source('staging', 'DIM_AG_SOI') }}