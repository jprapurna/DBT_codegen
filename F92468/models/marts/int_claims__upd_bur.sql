{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT *
  FROM {{ ref('int_claims__rtr_clm_insert_upd') }}
),

upd_bur AS (
  SELECT
    *,
    CASE
      WHEN action = 'Update' THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy_expression
  FROM source_data
)

SELECT *
FROM upd_bur