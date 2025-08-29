WITH lookup_data AS (
    SELECT
        ROW_WID AS lkp_ROW_WID,
        INTEGRATION_ID AS lkp_INTEGRATION_ID,
        NEW_BUR AS lkp_NEW_BUR
    FROM {{ source('W_CLAIM_CD_BUR_SCD3', 'W_CLAIM_CD_BUR_SCD3') }}
)
SELECT * FROM lookup_data;