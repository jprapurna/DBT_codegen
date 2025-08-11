{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- State of the policy
"BUR" AS bur -- BUR data
FROM {{ source('CDH_GWODS', 'CDH_GW_BUR') }}