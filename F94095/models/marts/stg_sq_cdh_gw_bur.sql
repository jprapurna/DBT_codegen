{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "POLICY_STATE" AS policy_state, -- State of the policy
        "BUR" AS bur,                  -- Business unit region
        "SOURCE_NAME" AS source_name   -- Source name for the data
    FROM {{ source('genai_power_bi', 'sq_cdh_gw_bur') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM source_data