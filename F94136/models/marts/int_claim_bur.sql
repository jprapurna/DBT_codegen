-- Purpose: Intermediate model for claim BUR transformations.
WITH lookup_data AS (
    SELECT 
        ROW_WID AS lkp_ROW_WID,
        INTEGRATION_ID AS lkp_INTEGRATION_ID,
        NEW_BUR AS lkp_NEW_BUR
    FROM {{ source('CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }}
),
transformed_data AS (
    SELECT 
        stg.POLICY_STATE,
        stg.BUR,
        stg.SOURCE_NAME,
        lookup_data.lkp_ROW_WID,
        lookup_data.lkp_INTEGRATION_ID,
        lookup_data.lkp_NEW_BUR,
        {{ flag_evaluation(is_null(lookup_data.lkp_ROW_WID), hash_compare(stg.BUR, lookup_data.lkp_NEW_BUR)) }} AS operation_flag
    FROM {{ ref('stg_cdh_gw_bur') }} stg
    LEFT JOIN lookup_data ON stg.INTEGRATION_ID = lookup_data.lkp_INTEGRATION_ID
)
SELECT * FROM transformed_data;