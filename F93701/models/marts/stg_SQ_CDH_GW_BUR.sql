{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "POLICY_STATE" AS policy_state, -- State of the policy
        "BUR" AS bur,                  -- BUR information
        "SOURCE_NAME" AS source_name   -- Name of the source
    FROM {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM source_data