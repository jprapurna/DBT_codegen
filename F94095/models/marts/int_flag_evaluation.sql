WITH flag_data AS (
    SELECT 
        INTEGRATION_ID,
        BUR,
        SOURCE_NAME,
        {{ ref('stg_batch_control') }}.BATCH_ID AS o_BATCH_ID,
        {{ ref('int_scd3_lookup') }}.lkp_ROW_WID,
        {{ ref('int_scd3_lookup') }}.lkp_NEW_BUR,
        {{ flag_evaluation('BUR', 'lkp_NEW_BUR', 'lkp_ROW_WID') }} AS o_Flag
    FROM {{ ref('int_cdh_gw_bur') }}
)
SELECT * FROM flag_data