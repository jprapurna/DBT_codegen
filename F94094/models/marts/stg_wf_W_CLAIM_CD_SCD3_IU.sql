{{ config(materialized='view') }}

WITH workflow_data AS (
    SELECT
        "ROW_WID" AS row_wid,             -- ROW_WID for the workflow
        "INTEGRATION_ID" AS integration_id, -- Integration ID for the workflow
        "NEW_BUR" AS new_bur             -- NEW BUR for the workflow
    FROM {{ source('CDM', 'wf_W_CLAIM_CD_SCD3_IU') }}
)
SELECT
    row_wid,
    integration_id,
    new_bur
FROM workflow_data