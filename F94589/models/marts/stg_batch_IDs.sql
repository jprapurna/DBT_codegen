{{ config(materialized='view') }}

WITH batch_ids AS (
    SELECT
        "ROW_WID" AS row_wid -- Unique row identifier
    FROM {{ source('genai_power_bi', 'batch_IDs') }}
)
SELECT
    row_wid
FROM batch_ids