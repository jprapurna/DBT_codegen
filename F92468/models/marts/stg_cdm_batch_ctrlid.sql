{{ config(materialized='view') }}

SELECT
"batch_id" AS batch_id, -- Batch identifier
"source_name" AS source_name -- Source name
FROM {{ source('genai_power_bi', 'cdm_batch_ctrlid') }}