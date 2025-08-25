-- Purpose: Insert operations for W_CLAIM_CD_BUR_SCD3
{{ config(materialized='table') }}
WITH insert_data AS (
  SELECT *
  FROM {{ ref('int_rtr_logic') }}
  WHERE route_action = 'INSERT'
)
SELECT *
FROM insert_data