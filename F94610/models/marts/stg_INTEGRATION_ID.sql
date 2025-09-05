{{ config(materialized='view') }}

WITH integration_id_table AS (
    SELECT
        "INTEGRATION_ID" AS integration_id -- Integration identifier for claims
    FROM {{ source('CDH_GW_BUR', 'INTEGRATION_ID') }}
)
SELECT
    integration_id
FROM integration_id_table