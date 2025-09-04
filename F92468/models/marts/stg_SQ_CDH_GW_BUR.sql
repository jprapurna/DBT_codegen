{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        "POLICY_STATE" AS policy_state, -- State of the policy
        "BUR" AS bur,                   -- BUR information
        "SOURCE_NAME" AS source_name    -- Name of the source
    FROM {{ source('GENAI_POWER_BI_CDM', 'SQ_CDH_GW_BUR') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM cdh_gw_bur