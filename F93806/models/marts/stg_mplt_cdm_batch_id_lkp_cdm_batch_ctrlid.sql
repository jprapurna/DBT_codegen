{{ config(materialized='view') }}

SELECT
    "MPLT_CDM_BATCH_ID_LKP_CDM_BATCH_CTRLID".*
FROM {{ source('genai_power_bi', 'mplt_cdm_batch_id_lkp_cdm_batch_ctrlid') }}