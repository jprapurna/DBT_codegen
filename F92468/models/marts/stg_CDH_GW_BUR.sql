{{ config(materialized='view') }}

SELECT
    "POLICY_STATE" AS policy_state, -- State of the policy
    "BUR" AS bur, -- BUR data
    "SOURCE_NAME" AS source_name -- Source name for the data
FROM {{ source('W_CLAIM_CD_SCD3_IU', 'CDH_GW_BUR') }}