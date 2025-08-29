{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "DUMMY_mplt_CDM_BATCH_ID_lkp_CDM_BATCH_CTRLID" AS dummy_mplt_cdm_batch_id_lkp_cdm_batch_ctrlid -- Error: Table does not exist or not authorized
    FROM {{ source('CDM', 'LKP_CDM_BATCH_CTRLID') }}
)
SELECT
    dummy_mplt_cdm_batch_id_lkp_cdm_batch_ctrlid
FROM source_data