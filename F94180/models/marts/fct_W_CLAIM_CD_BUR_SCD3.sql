-- Purpose: Represents the final model for reporting and analytics.
{{ config(materialized='table') }}

SELECT 
  ROW_WID,
  INTEGRATION_ID,
  NEW_BUR,
  CDM_INSERT_DT,
  CDM_UPDATE_DT,
  TGT_TABLE_NAME
FROM {{ ref('int_exp_ROW_WID') }}