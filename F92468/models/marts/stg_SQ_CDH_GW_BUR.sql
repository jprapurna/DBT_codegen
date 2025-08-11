{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- State of the policy
"BUR" AS bur, -- Business Unit Reference
"SOURCE_NAME" AS source_name -- Source name for the data
FROM {{ source('W_CLAIM_CD_SCD3_IU', 'SQ_CDH_GW_BUR') }}