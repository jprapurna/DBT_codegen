{{ config(materialized='view') }}

SELECT
    *
FROM {{ source('GENAI_POWER_BI_CDM', 'MPLT_CDM_BATCH_ID_LKP_CDM_BATCH_CTRLID') }}