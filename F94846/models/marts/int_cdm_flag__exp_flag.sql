{{
  config(materialized='ephemeral')
}}

WITH flag_data AS (
  SELECT
    {{ macro_flag_logic('LKP_ROW_WID', 'BUR', 'LKP_NEW_BUR') }} AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT,
    'CDM_TABLE_NAME' AS TGT_TABLE_NAME
  FROM {{ source('cdm_claim_cd_bur_scd3') }}
)

SELECT * FROM flag_data