{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ON_OFF_PREM_SK" AS on_off_prem_sk, -- Surrogate key for on/off premium
        "REGSTR_PER_SK" AS regstr_per_sk, -- Registration period surrogate key
        "SRC_TRANS_TMSP" AS src_trans_tmsp, -- Source transaction timestamp
        "TRANS_DT_SK" AS trans_dt_sk, -- Transaction date surrogate key
        "DNSTRM_DT_SK" AS dnstrm_dt_sk -- Downstream date surrogate key
    FROM {{ source('AGDM', 'FACT_AG_WRITTN_PREM_CVG_LVL') }}
)
SELECT
    on_off_prem_sk,
    regstr_per_sk,
    src_trans_tmsp,
    trans_dt_sk,
    dnstrm_dt_sk
FROM source_data