{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT *
  FROM {{ ref('int_claims__exp_flag') }}
),

rtr_clm_insert_upd AS (
  SELECT
    *,
    CASE
      WHEN o_flag = 'I' THEN 'Insert'
      WHEN o_flag = 'U' THEN 'Update'
      ELSE 'Reject'
    END AS action
  FROM source_data
)

SELECT *
FROM rtr_clm_insert_upd