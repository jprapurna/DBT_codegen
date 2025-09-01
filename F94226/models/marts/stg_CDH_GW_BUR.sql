{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        -- No columns available for this table
    FROM {{ source('GENAI_POWER_BI_CDM', 'CDH_GW_BUR') }}
)
SELECT
    -- No columns available for this table
FROM cdh_gw_bur