{{ config(materialized='view') }}

WITH integration_ids AS (
    SELECT
        "ROW_WID" AS row_wid -- Unique row identifier
    FROM {{ source('genai_power_bi', 'integration_IDs') }}
)
SELECT
    row_wid
FROM integration_ids