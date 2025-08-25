-- Purpose: Update operations for W_CLAIM_CD_BUR_SCD3
{{ config(materialized='table') }}
WITH update_data AS (
  SELECT *
  FROM {{ ref('int_rtr_logic') }}
  WHERE route_action = 'UPDATE'
)
SELECT *
FROM update_data