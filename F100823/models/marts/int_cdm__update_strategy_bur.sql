{{
  config(materialized='ephemeral')
}}

WITH update_strategy_bur AS (
  SELECT 
    CASE 
      WHEN o_flag = 'U' THEN 'DD_UPDATE'
      ELSE 'DD_INSERT'
    END AS update_strategy_expression
  FROM {{ ref('int_cdm__router_insert_update') }}
)

SELECT *
FROM update_strategy_bur