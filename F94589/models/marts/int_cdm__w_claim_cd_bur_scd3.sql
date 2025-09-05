{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),
EXP_Flag AS (
  SELECT
    *,
    CASE 
      WHEN claim_status = 'ACTIVE' THEN 1
      ELSE 0
    END AS claim_flag
  FROM source_data
),
rtr_CLM_INSERT_UPD AS (
  SELECT
    *,
    CASE 
      WHEN claim_flag = 1 THEN 'INSERT'
      ELSE 'UPDATE'
    END AS operation_type
  FROM EXP_Flag
),
UPD_BUR AS (
  SELECT
    *,
    CASE 
      WHEN operation_type = 'INSERT' THEN 'NEW'
      ELSE 'EXISTING'
    END AS record_status
  FROM rtr_CLM_INSERT_UPD
)
SELECT * FROM UPD_BUR