{{ config(materialized='view') }}

WITH fdr_lib_abc_bal_detail_amts_source_update AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'FDR_LIB_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE') }}
)
SELECT
    *
FROM fdr_lib_abc_bal_detail_amts_source_update