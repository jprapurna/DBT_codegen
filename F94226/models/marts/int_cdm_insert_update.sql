{{ config(materialized='ephemeral') }}

WITH router_data AS (
  SELECT 
    o_Flag,
    CDM_INSERT_DT,
    CDM_UPDATE_DT,
    TGT_TABLE_NAME
  FROM {{ ref('int_cdm_flag') }}
),

update_strategy AS (
  SELECT 
    CASE 
      WHEN o_Flag = 'I' THEN 'INSERT'
      WHEN o_Flag = 'U' THEN 'UPDATE'
      ELSE 'REJECT'
    END AS update_action,
    *
  FROM router_data
)

SELECT *
FROM update_strategy