-- Purpose: Handles Slowly Changing Dimension Type 3 (SCD3) for W_CLAIM_CD_BUR_SCD3.
{{ config(materialized='table') }}
SELECT 
    ROW_WID, 
    INTEGRATION_ID, 
    NEW_BUR, 
    CDM_INSERT_DT, 
    CDM_UPDATE_DT
FROM {{ ref('int_exp_flag') }}
WHERE o_Flag IN ('I', 'U')