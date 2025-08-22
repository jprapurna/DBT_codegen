{{ config(materialized='view') }}

SELECT
    "lkp_CDM_BATCH_CTRLID" AS lkp_cdm_batch_ctrlid
FROM {{ source('genai_power_bi', 'lkp_cdm_batch_ctrlid') }}