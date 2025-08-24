{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "ON_OFF_PREM_SK" AS on_off_prem_sk, -- Surrogate key for on/off premium
        "WRITTN_PREM_AMT" AS writtn_prem_amt, -- Written premium amount
        "TTL_WRITTN_PREM_AMT" AS ttl_writtn_prem_amt -- Total written premium amount
    FROM {{ source('AGDM', 'FACT_AG_WRITTN_PREM_CVG_LVL') }}
)
SELECT
    on_off_prem_sk,
    writtn_prem_amt,
    ttl_writtn_prem_amt
FROM source_data