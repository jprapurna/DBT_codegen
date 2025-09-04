{{
  config(materialized='ephemeral')
}}

WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    'GWCDH' AS SOURCE_NAME
  FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'CDH_GW_BUR') }}
),

exp_bur AS (
  SELECT 
    POLICY_STATE AS INTEGRATION_ID,
    BUR AS INTEGRATION_ID,
    SOURCE_NAME AS INTEGRATION_ID
  FROM source_data
),

lkp_cdm_batch_ctrlid AS (
  SELECT 
    MAX(BATCH_ID) AS BATCH_ID, 
    TRIM(SOURCE_NAME) AS SOURCE_NAME
  FROM {{ source('Snowflake_Cloud_Data_Warehouse_CDM', 'LKP_CDM_BATCH_CTRLID') }}
  WHERE STATUS = 'RUNNING'
  GROUP BY SOURCE_NAME
),

final AS (
  SELECT 
    exp_bur.INTEGRATION_ID,
    lkp_cdm_batch_ctrlid.BATCH_ID,
    lkp_cdm_batch_ctrlid.SOURCE_NAME
  FROM exp_bur
  LEFT JOIN lkp_cdm_batch_ctrlid
  ON exp_bur.SOURCE_NAME = lkp_cdm_batch_ctrlid.SOURCE_NAME
)

SELECT * FROM final