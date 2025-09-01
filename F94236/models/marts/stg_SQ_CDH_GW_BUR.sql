{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        "POLICY_STATE" AS policy_state, -- State associated with the policy
        "BUR" AS bur,                   -- BUR identifier
        "SOURCE_NAME" AS source_name    -- Name of the source system
    FROM {{ source('GENAI_POWER_BI_CDM', 'SQ_CDH_GW_BUR') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM sq_cdh_gw_bur