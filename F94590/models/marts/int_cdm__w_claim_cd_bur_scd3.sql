{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT 
    *
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

exp_flag AS (
  SELECT 
    *,
    CASE 
      WHEN {{ isnull('LKP_ROW_WID', 'NULL') }} THEN 'I'
      WHEN {{ md5('BUR') }} = {{ md5('LKP_NEW_BUR') }} THEN 'NC'
      ELSE 'U'
    END AS o_Flag
  FROM source_data
),

rtr_clm_insert_upd AS (
  SELECT 
    *
  FROM exp_flag
  WHERE o_Flag IN ('I', 'U')
)

SELECT * FROM rtr_clm_insert_upd