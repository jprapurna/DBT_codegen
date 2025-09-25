{{ config(materialized='ephemeral') }}

WITH lookup_data AS (
  SELECT 
    ROW_WID AS LKP_ROW_WID, 
    INTEGRATION_ID AS LKP_INTEGRATION_ID, 
    NEW_BUR AS LKP_NEW_BUR 
  FROM {{ source('Snowflake_Cloud_Data_Warehouse_V2', 'W_CLAIM_CD_BUR_SCD3') }}
  WHERE INTEGRATION_ID = in_INTEGRATION_ID
)

SELECT * FROM lookup_data