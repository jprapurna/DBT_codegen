{{ config(materialized='view') }}

SELECT
"policy_state" AS policy_state, -- State of the policy
"bur" AS bur -- BUR data
FROM {{ source('genai_power_bi', 'cdh_gw_bur') }}