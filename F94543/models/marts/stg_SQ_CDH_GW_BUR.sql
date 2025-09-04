{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        policy_state AS policy_state, -- State of the policy
        bur AS bur,                   -- Business unit reference
        source_name AS source_name    -- Name of the source
    FROM {{ source('DBA_COMMON_UTILS', 'SQ_CDH_GW_BUR') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM sq_cdh_gw_bur