-- Source node: SQ_CDH_GW_BUR
WITH SQ_CDH_GW_BUR AS (
    SELECT 
        POLICY_STATE, -- string: State of the policy
        BUR,          -- string: BUR information
        'GWCDH' AS SOURCE_NAME -- string: Name of the source
    FROM {{ source('CDM', 'SQ_CDH_GW_BUR') }}
)


-- Source node: LKP_W_CLAIM_CD_BUR_SCD3
, LKP_W_CLAIM_CD_BUR_SCD3 AS (
    SELECT 
        W_CLAIM_CD_BUR_SCD3.ROW_WID AS LKP_ROW_WID, -- decimal
        W_CLAIM_CD_BUR_SCD3.INTEGRATION_ID AS LKP_INTEGRATION_ID, -- string
        W_CLAIM_CD_BUR_SCD3.NEW_BUR AS LKP_NEW_BUR -- string
    FROM 
        {{ source('CDM', 'W_CLAIM_CD_BUR_SCD3') }}
)


-- Transformation node: EXP_BUR
, EXP_BUR AS (
    SELECT 
        POLICY_STATE AS INTEGRATION_ID,  -- Mapping POLICY_STATE to INTEGRATION_ID
        BUR,                             -- Passing through BUR unchanged
        SOURCE_NAME                      -- Passing through SOURCE_NAME unchanged
    FROM <PREVIOUS_NODE_NAME>           -- Replace <PREVIOUS_NODE_NAME> with the actual previous node name
)


-- Lookup transformation: LKP_W_CLAIM_CD_BUR_SCD3
, LKP_W_CLAIM_CD_BUR_SCD3 AS (
    SELECT 
        LKP_INTEGRATION_ID AS LKP_INTEGRATION_ID,
        LKP_ROW_WID AS ROW_ID,
        LKP_NEW_BUR AS BUR,
        SOURCE_NAME AS SOURCE_NAME
    FROM {{ source('CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
    WHERE LKP_INTEGRATION_ID = in_INTEGRATION_ID
)


-- Transformation node: EXP_Flag
, EXP_Flag AS (
    SELECT 
        -- Derived fields with transformation expressions
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
        CASE 
            WHEN o_Flag = 'I' THEN 'I'
            WHEN o_Flag = 'U' THEN 'U'
            ELSE NULL
        END AS o_Flag,
        CASE 
            WHEN o_Flag = 'I' THEN CURRENT_TIMESTAMP
            ELSE NULL
        END AS CDM_INSERT_DT,
        CASE 
            WHEN o_Flag = 'U' THEN CURRENT_TIMESTAMP
            ELSE NULL
        END AS CDM_UPDATE_DT,
        CASE 
            WHEN o_Flag = 'I' OR o_Flag = 'U' THEN '{{ var("tgt_table_name") }}'
            ELSE NULL
        END AS TGT_TABLE_NAME
    FROM <PREVIOUS_NODE_NAME>
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
    merge_update_columns=['ROW_WID', 'BATCH_ID', 'NEW_BUR', 'OLD_BUR']
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
    incremental_strategy='insert',
    on_schema_change='append_new_columns',
    merge_update_columns=['BUR', 'LKP_NEW_BUR', 'o_Flag', 'in_INTEGRATION_ID', 'LKP_INTEGRATION_ID', 'LKP_ROW_WID']
) }}

final AS (
    SELECT
        *
    FROM rtr_CLM_INSERT_UPD
)

SELECT * FROM final