{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- State of the policy
"BUR" AS bur, -- BUR value
"SOURCE_NAME" AS source_name -- Source name
FROM {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}