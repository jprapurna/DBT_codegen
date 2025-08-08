{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- State of the policy
BUR AS bur, -- Business unit reference
"SOURCE_NAME" AS source_name -- Name of the source
FROM {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}