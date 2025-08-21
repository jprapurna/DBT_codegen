{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- State of the policy
"BUR" AS bur, -- BUR value
"SOURCE_NAME" AS source_name -- Source name
FROM {{ source('Salesforce_Audit_Data_Integration', 'SQ_CDH_GW_BUR') }}