{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- State of the policy
"BUR" AS bur, -- Business unit reference
"SOURCE_NAME" AS source_name -- Source name
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'SQ_CDH_GW_BUR') }}