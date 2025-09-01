{{ config(materialized='view') }}

SELECT
    "POLICY_STATE" AS policy_state, -- State of the policy
    "BUR" AS bur,                   -- BUR value
    "SOURCE_NAME" AS source_name    -- Name of the source
FROM {{ source('GENAI_POWER_BI_CDM', 'SQ_CDH_GW_BUR') }}