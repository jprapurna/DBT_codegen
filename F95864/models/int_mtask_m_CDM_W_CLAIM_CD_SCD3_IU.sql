-- Source node: SQ_CDH_GW_BUR
WITH SQ_CDH_GW_BUR AS (
    SELECT 
        POLICY_STATE AS POLICY_STATE, -- State of the policy
        BUR AS BUR, -- Business unit region
        'GWCDH' AS SOURCE_NAME -- Name of the source system
    FROM {{ source('CDM', 'CDH_GW_BUR') }}
)


-- Transformation node: EXP_BUR
, EXP_BUR AS (
    SELECT 
        POLICY_STATE AS INTEGRATION_ID
    FROM <PREVIOUS_NODE_NAME>
)


-- Lookup transformation node: LKP_W_CLAIM_CD_BUR_SCD3
, LKP_W_CLAIM_CD_BUR_SCD3 AS (
    SELECT 
        W_CLAIM_CD_BUR_SCD3.ROW_WID AS lkp_ROW_WID,
        W_CLAIM_CD_BUR_SCD3.INTEGRATION_ID AS lkp_INTEGRATION_ID,
        W_CLAIM_CD_BUR_SCD3.NEW_BUR AS lkp_NEW_BUR
    FROM {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
    WHERE W_CLAIM_CD_BUR_SCD3.INTEGRATION_ID = in_INTEGRATION_ID
)


-- Transformation node: EXP_Flag
, EXP_Flag AS (
    SELECT 
        -- Derived fields with expressions
        CASE 
            WHEN LKP_ROW_WID IS NULL THEN 'I'
            WHEN MD5(BUR) = MD5(LKP_NEW_BUR) THEN 'NC'
            ELSE 'U'
        END AS o_Flag,
        SYSDATE AS CDM_INSERT_DT,
        SYSDATE AS CDM_UPDATE_DT,
        'W_CLAIM_CD_BUR_SCD3' AS TGT_TABLE_NAME
    FROM <PREVIOUS_NODE_NAME>
)


-- Router transformation: rtr_CLM_INSERT_UPD
, rtr_CLM_INSERT_UPD AS (
    SELECT 
        *,
        CASE 
            WHEN o_Flag = 'I' THEN CDM_INSERT_DT
            WHEN o_Flag = 'U' THEN NULL
        END AS CDM_INSERT_DT,
        CASE 
            WHEN o_Flag = 'U' THEN CDM_UPDATE_DT
            WHEN o_Flag = 'I' THEN NULL
        END AS CDM_UPDATE_DT,
        CASE 
            WHEN o_Flag = 'I' THEN TGT_TABLE_NAME
            WHEN o_Flag = 'U' THEN TGT_TABLE_NAME
        END AS TGT_TABLE_NAME
    FROM <PREVIOUS_NODE_NAME>
    WHERE o_Flag IN ('I', 'U')
)


-- Transformation node: UPD_BUR
, UPD_BUR AS (
    SELECT 
        'DD_UPDATE' AS Update_Strategy_Expression_78066
)


{{ config(
    materialized='incremental',
    alias='W_CLAIM_CD_BUR_SCD3_U',
    unique_key='ROW_WID',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=['ROW_WID', 'NEW_BUR', 'OLD_BUR', 'BATCH_ID']
) }}

final AS (
    SELECT
        *
    FROM UPD_BUR
)

SELECT * FROM final


{{ config(
    materialized='incremental',
    alias='W_CLAIM_CD_BUR_SCD3_I',
    unique_key='LKP_ROW_WID',
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    merge_update_columns=['BUR', 'LKP_NEW_BUR', 'o_Flag', 'in_INTEGRATION_ID', 'LKP_INTEGRATION_ID', 'LKP_ROW_WID']
) }}

final AS (
    SELECT
        *
    FROM rtr_CLM_INSERT_UPD
)

SELECT * FROM final