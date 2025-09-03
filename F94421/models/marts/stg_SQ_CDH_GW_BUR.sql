{{ config(materialized='view') }}

WITH sq_cdh_gw_bur AS (
    SELECT
        POLICY_STATE AS policy_state, -- State of the policy
        BUR AS bur,                   -- BUR value
        SOURCE_NAME AS source_name    -- Name of the source
    FROM {{ source('Snowflake_CDM', 'SQ_CDH_GW_BUR') }}
)
SELECT
    policy_state,
    bur,
    source_name
FROM sq_cdh_gw_bur