{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "PLCY_SK" AS plcy_sk, -- Surrogate key for policy
        "CHK_SUM_ATTR" AS chk_sum_attr, -- Checksum attribute
        "PLCY_ID_SK" AS plcy_id_sk, -- Policy ID surrogate key
        "PLCY_CNTRCT_NUM" AS plcy_cntrct_num, -- Policy contract number
        "PLCY_INCEPT_DT" AS plcy_incept_dt -- Policy inception date
    FROM {{ source('AGDM', 'DIM_AG_PLCY') }}
)
SELECT
    plcy_sk,
    chk_sum_attr,
    plcy_id_sk,
    plcy_cntrct_num,
    plcy_incept_dt
FROM source_data