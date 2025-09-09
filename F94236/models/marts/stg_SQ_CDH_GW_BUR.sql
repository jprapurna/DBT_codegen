{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        -- No columns available for aliasing
    FROM {{ source('GENAI_POWER_BI', 'SQ_CDH_GW_BUR') }}
)
SELECT
    -- No columns available for selection
FROM sq_cdh_gw_bur