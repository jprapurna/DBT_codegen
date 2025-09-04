{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT * 
  FROM {{ source('DBA_COMMON_UTILS', 'SQ_CDH_GW_BUR') }}
),

exp_bur AS (
  SELECT 
    *,
    CASE 
      WHEN POLICY_STATE = 'NJ' THEN 'New Jersey'
      ELSE 'Other'
    END AS INTEGRATION_ID
  FROM source_data
)

SELECT * 
FROM exp_bur