{{ config(materialized='view') }}

SELECT
"POLICY_STATE" AS policy_state, -- Policy state information
"BUR" AS bur, -- BUR information
"SOURCE_NAME" AS source_name -- Source name information
FROM {{ source('wf_W_CLAIM_CD_SCD3_IU', 'SQ_CDH_GW_BUR') }}