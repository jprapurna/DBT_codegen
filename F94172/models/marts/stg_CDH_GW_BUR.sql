{{ config(materialized='view') }}

WITH cdh_gw_bur AS (
    SELECT
        "POLICY_STATE" AS policy_state, -- State of the policy
        "BUR" AS bur,                  -- Burden data
        "SOURCE_NAME" AS source_name   -- Source name for the data
    FROM {{ source('CDH_GW_BUR', 'CDH_GW_BUR') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM cdh_gw_bur