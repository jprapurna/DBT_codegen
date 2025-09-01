{{ config(materialized='view') }}

WITH stg_tfplcy_tran_result AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'STG_TFPLCY_TRAN_RESULT') }}
)
SELECT
    *
FROM stg_tfplcy_tran_result