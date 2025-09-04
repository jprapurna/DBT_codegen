{{
  config(
    target_database='GENAI_POWER_BI',
    target_schema='CDM',
    unique_key='ROW_WID',
    strategy='timestamp',
    updated_at='CDM_UPDATE_DT'
  )
}}

SELECT 
  ROW_WID,
  BUR,
  LKP_NEW_BUR,
  CDM_INSERT_DT,
  CDM_UPDATE_DT
FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}