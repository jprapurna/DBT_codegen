{{ config(materialized='ephemeral') }}

WITH source_data AS (
  SELECT 
    POLICY_STATE, 
    BUR, 
    {{ ref('source_name_gwcdm') }} AS SOURCE_NAME 
  FROM {{ source('Snowflake_Cloud_Data_Warehouse_V2', 'CDH_GW_BUR') }}
)

SELECT * FROM source_data