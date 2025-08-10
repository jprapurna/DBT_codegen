{{ config(materialized='view') }}

SELECT
"SOI_SK" AS soi_sk,
"CHK_SUM_ATTR" AS chk_sum_attr,
"SOI_ID" AS soi_id,
"VIN" AS vin,
"VEH_INCEPT_DT" AS veh_incept_dt,
"UNIT_NUM" AS unit_num
FROM {{ source('staging', 'DIM_AG_SOI') }}