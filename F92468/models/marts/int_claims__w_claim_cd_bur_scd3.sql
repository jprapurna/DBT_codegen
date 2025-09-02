{{
  config(materialized='incremental', unique_key='INTEGRATION_ID, BUR')
}}

WITH source_data AS (
  SELECT *
  FROM {{ ref('int_claims__cdh_gw_bur') }}
),

router_logic AS (
  SELECT
    *,
    CASE 
      WHEN o_Flag = 'I' THEN 'Insert'
      WHEN o_Flag = 'U' THEN 'Update'
      ELSE 'Reject'
    END AS action
  FROM source_data
),

upd_bur AS (
  SELECT
    *,
    CASE 
      WHEN action = 'Insert' THEN 'Insert Logic'
      WHEN action = 'Update' THEN 'Update Logic'
    END AS update_strategy
  FROM router_logic
)

SELECT *
FROM upd_bur