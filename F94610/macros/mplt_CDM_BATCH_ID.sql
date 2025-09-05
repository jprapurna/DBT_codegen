{% macro mplt_CDM_BATCH_ID(SOURCE_NAME, BUR, INTEGRATION_ID) %}
WITH lkp_w_claim_cd_bur_scd3 AS (
  SELECT 
    ROW_WID AS lkp_ROW_WID, 
    INTEGRATION_ID AS lkp_INTEGRATION_ID, 
    NEW_BUR AS lkp_NEW_BUR
  FROM {{ source('cdm', 'w_claim_cd_bur_scd3') }}
  WHERE INTEGRATION_ID = {{ INTEGRATION_ID }}
),
exp_flag AS (
  SELECT
    *,
    CASE 
      WHEN lkp_ROW_WID IS NULL THEN 'I'
      WHEN MD5(BUR) = MD5(lkp_NEW_BUR) THEN 'NC'
      ELSE 'U'
    END AS o_Flag,
    CURRENT_TIMESTAMP AS CDM_INSERT_DT,
    CURRENT_TIMESTAMP AS CDM_UPDATE_DT
  FROM lkp_w_claim_cd_bur_scd3
),
rtr_clm_insert_upd AS (
  SELECT *
  FROM exp_flag
  WHERE o_Flag IN ('I', 'U')
)
SELECT 
  o_Flag,
  CDM_INSERT_DT,
  CDM_UPDATE_DT,
  '{{ ref('w_claim_cd_bur_scd3_u') }}' AS TGT_TABLE_NAME
FROM rtr_clm_insert_upd
{% endmacro %}