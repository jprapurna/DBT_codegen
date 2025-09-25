{{
  config(materialized='ephemeral')
}}

WITH exp_bur_data AS (
  SELECT * FROM {{ ref('int_exp_bur') }}
),

exp_flag AS (
  SELECT
    POLICY_STATE,
    BUR_CLEANED,
    SOURCE_NAME,
    CASE 
      WHEN POLICY_STATE = 'NJ' THEN 'New Jersey'
      WHEN POLICY_STATE = 'NY' THEN 'New York'
      ELSE 'Other'
    END AS STATE_FLAG
  FROM exp_bur_data
)

SELECT * FROM exp_flag;