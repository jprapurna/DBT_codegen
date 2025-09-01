{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    'GWCDH' AS SOURCE_NAME
  FROM {{ source('GENAI_POWER_BI_CDM', 'SQ_CDH_GW_BUR') }}
)
SELECT * FROM source_data