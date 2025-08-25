{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        "POLICY_STATE" AS policy_state, -- State of the policy
        "BUR" AS bur,                  -- BUR identifier
        "SOURCE_NAME" AS source_name   -- Source name for the data
    FROM {{ source('cdh_gw_bur', 'sq_cdh_gw_bur') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM sq_cdh_gw_bur