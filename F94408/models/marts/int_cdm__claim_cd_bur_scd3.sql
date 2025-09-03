{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT * 
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
),

exp_flag AS (
  SELECT 
    CASE 
      WHEN INTEGRATION_ID IS NULL THEN 'I'
      ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    'TGT_TABLE_NAME' AS TGT_TABLE_NAME
  FROM source_data
)

SELECT *
FROM exp_flag