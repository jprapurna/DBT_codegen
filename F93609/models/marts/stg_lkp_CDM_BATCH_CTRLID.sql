{{ config(materialized='view') }}

SELECT
"SOURCE_NAME" AS source_name, -- Source name
"BATCH_ID" AS batch_id, -- Batch identifier
"STATUS" AS status -- Status of the batch
FROM {{ source('Salesforce_Audit_Data_Integration', 'lkp_CDM_BATCH_CTRLID') }}