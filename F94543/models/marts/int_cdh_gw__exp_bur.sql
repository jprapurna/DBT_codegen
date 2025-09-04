{{ config(materialized='ephemeral') }}

WITH exp_bur AS (
  SELECT 
    POLICY_STATE,
    BUR,
    SOURCE_NAME,
    CASE 
      WHEN POLICY_STATE = 'NJ' THEN 'New Jersey'
      ELSE 'Other'
    END AS INTEGRATION_ID
  FROM {{ source('DBA_COMMON_UTILS', 'SQ_CDH_GW_BUR') }}
)

SELECT * 
FROM exp_bur