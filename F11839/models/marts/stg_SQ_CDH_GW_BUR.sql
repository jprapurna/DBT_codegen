{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- State of the policy
"BUR" AS bur, -- Business unit reference
"SOURCE_NAME" AS source_name -- Source name
FROM {{ source('CDM', 'SQ_CDH_GW_BUR') }}