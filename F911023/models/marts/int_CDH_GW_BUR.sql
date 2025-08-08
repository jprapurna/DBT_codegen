-- Purpose: Extract data from CDH_GW_BUR with custom SQL query and perform various transformations.

WITH cdh_gw_bur AS (
    SELECT 
        POLICY_STATE, 
        BUR, 
        'GWCDH' AS source_name
    FROM {{ source('genai_power_bi', 'SQ_CDH_GW_BUR') }}
),
claim_cd_bur_scd3 AS (
    SELECT 
        ROW_WID AS lkp_row_wid, 
        INTEGRATION_ID AS lkp_integration_id, 
        NEW_BUR AS lkp_new_bur
    FROM {{ source('genai_power_bi', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
),
batch_ctrlid AS (
    SELECT 
        MAX(BATCH_ID) AS batch_id, 
        LTRIM(RTRIM(SOURCE_NAME)) AS source_name
    FROM {{ source('genai_power_bi', 'lkp_CDM_BATCH_CTRLID') }}
    WHERE STATUS = 'RUNNING'
    GROUP BY SOURCE_NAME
),
max_row_wid AS (
    SELECT 
        NVL(MAX(ROW_WID), 0) AS row_wid, 
        '{{ var("TGT_TABLE_NAME") }}' AS table_name
    FROM {{ source('genai_power_bi', 'lkp_MAX_ROW_WID') }}
),
mapped_policy_state AS (
    SELECT 
        POLICY_STATE, 
        POLICY_STATE AS integration_id
    FROM cdh_gw_bur
),
processed_batch_id AS (
    SELECT 
        source_name, 
        batch_id AS o_batch_id
    FROM batch_ctrlid
),
flags_and_timestamps AS (
    SELECT 
        integration_id, 
        o_batch_id, 
        lkp_row_wid, 
        lkp_integration_id, 
        lkp_new_bur,
        IIF(ISNULL(lkp_row_wid), 'I', IIF(MD5(BUR) = MD5(lkp_new_bur), 'NC', 'U')) AS o_flag,
        SYSDATE AS cdm_insert_dt,
        SYSDATE AS cdm_update_dt,
        'W_CLAIM_CD_BUR_SCD3' AS tgt_table_name
    FROM mapped_policy_state
    LEFT JOIN claim_cd_bur_scd3 ON mapped_policy_state.integration_id = claim_cd_bur_scd3.lkp_integration_id
),
router_logic AS (
    SELECT 
        o_flag, 
        cdm_insert_dt, 
        cdm_update_dt, 
        tgt_table_name,
        CASE WHEN o_flag = 'I' THEN TRUE ELSE FALSE END AS insert,
        CASE WHEN o_flag = 'U' THEN TRUE ELSE FALSE END AS update
    FROM flags_and_timestamps
),
update_strategy AS (
    SELECT 
        integration_id AS in_integration_id, 
        lkp_integration_id, 
        o_flag, 
        batch_id, 
        o_flag AS o_flag1,
        'DD_UPDATE' AS update_strategy_expression_78066
    FROM flags_and_timestamps
),
generated_row_wid AS (
    SELECT 
        tgt_table_name, 
        ROW_WID
    FROM max_row_wid
),
null_check AS (
    SELECT 
        batch_id, 
        source_name, 
        IIF(ISNULL(batch_id), -999, batch_id) AS o_batch_id
    FROM processed_batch_id
),
row_wid_calculation AS (
    SELECT 
        tgt_table_name, 
        IIF(v2 = 0, :LKP.lkp_MAX_ROW_WID(tgt_table_name), v2) AS v1, 
        v1 + 1 AS v2, 
        v2 AS row_wid
    FROM generated_row_wid
)

SELECT 
    cdh_gw_bur.policy_state,
    cdh_gw_bur.bur,
    claim_cd_bur_scd3.lkp_row_wid,
    claim_cd_bur_scd3.lkp_integration_id,
    claim_cd_bur_scd3.lkp_new_bur,
    batch_ctrlid.batch_id,
    batch_ctrlid.source_name,
    max_row_wid.row_wid,
    max_row_wid.table_name,
    mapped_policy_state.integration_id,
    processed_batch_id.o_batch_id,
    flags_and_timestamps.o_flag,
    flags_and_timestamps.cdm_insert_dt,
    flags_and_timestamps.cdm_update_dt,
    flags_and_timestamps.tgt_table_name,
    router_logic.insert,
    router_logic.update,
    update_strategy.update_strategy_expression_78066,
    generated_row_wid.row_wid,
    null_check.o_batch_id,
    row_wid_calculation.v1,
    row_wid_calculation.v2,
    row_wid_calculation.row_wid
FROM cdh_gw_bur
JOIN claim_cd_bur_scd3 ON cdh_gw_bur.policy_state = claim_cd_bur_scd3.lkp_integration_id
JOIN batch_ctrlid ON cdh_gw_bur.source_name = batch_ctrlid.source_name
JOIN max_row_wid ON cdh_gw_bur.source_name = max_row_wid.table_name
JOIN mapped_policy_state ON cdh_gw_bur.policy_state = mapped_policy_state.integration_id
JOIN processed_batch_id ON cdh_gw_bur.source_name = processed_batch_id.source_name
JOIN flags_and_timestamps ON cdh_gw_bur.policy_state = flags_and_timestamps.integration_id
JOIN router_logic ON cdh_gw_bur.policy_state = router_logic.o_flag
JOIN update_strategy ON cdh_gw_bur.policy_state = update_strategy.in_integration_id
JOIN generated_row_wid ON cdh_gw_bur.source_name = generated_row_wid.tgt_table_name
JOIN null_check ON cdh_gw_bur.source_name = null_check.source_name
JOIN row_wid_calculation ON cdh_gw_bur.source_name = row_wid_calculation.tgt_table_name