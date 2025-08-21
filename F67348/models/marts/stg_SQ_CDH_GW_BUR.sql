{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "POLICY_STATE" AS policy_state, -- State of the policy
        "BUR" AS bur,                  -- BUR identifier
        "SOURCE_NAME" AS source_name   -- Source name for the data
    FROM {{ source('CDH_GW_BUR', 'SQ_CDH_GW_BUR') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM source_data