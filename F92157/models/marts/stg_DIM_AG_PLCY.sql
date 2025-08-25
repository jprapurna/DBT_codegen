{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "PLCY_SK" AS plcy_sk, -- Surrogate key for policy
        "PLCY_CNTRCT_NUM" AS plcy_cntrct_num, -- Policy contract number
        "TERM_STRT_DT" AS term_strt_dt -- Term start date
    FROM {{ source('AGDM', 'DIM_AG_PLCY') }}
)
SELECT
    plcy_sk,
    plcy_cntrct_num,
    term_strt_dt
FROM source_data
