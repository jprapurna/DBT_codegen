{{ config(materialized='view') }}

WITH fdr_lib_abc_bal_row_counts_target_insert AS (
    SELECT
        *
    FROM {{ source('genai_power_bi', 'FDR_LIB_ABC_BAL_ROW_COUNTS_TARGET_INSERT') }}
)
SELECT
    *
FROM fdr_lib_abc_bal_row_counts_target_insert