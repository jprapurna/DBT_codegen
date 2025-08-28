-- Purpose: Final model for claims data processing with SCD3 logic.
{{ config(materialized='table') }}

WITH base_data AS (
    SELECT 
        INTEGRATION_ID,
        BUR,
        SOURCE_NAME,
        {{ ref('int_cdm_batch_ctrlid') }}.BATCH_ID,
        {{ ref('int_max_row_wid') }}.ROW_WID
    FROM {{ ref('int_cdh_gw_bur') }}
    LEFT JOIN {{ ref('int_cdm_batch_ctrlid') }} ON {{ ref('int_cdh_gw_bur') }}.SOURCE_NAME = {{ ref('int_cdm_batch_ctrlid') }}.SOURCE_NAME
    LEFT JOIN {{ ref('int_max_row_wid') }} ON {{ ref('int_cdh_gw_bur') }}.SOURCE_NAME = {{ ref('int_max_row_wid') }}.TABLE_NAME
),
flagged_data AS (
    SELECT 
        *,
        CASE 
            WHEN ROW_WID IS NULL THEN 'I'
            WHEN {{ hash_compare('BUR', 'lkp_NEW_BUR') }} THEN 'NC'
            ELSE 'U'
        END AS operation_flag
    FROM base_data
)
SELECT * FROM flagged_data