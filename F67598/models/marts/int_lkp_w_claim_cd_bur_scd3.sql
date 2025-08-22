-- Purpose: Lookup transformation to fetch fields ROW_WID, INTEGRATION_ID, and NEW_BUR from source table CDM.W_CLAIM_CD_BUR_SCD3.
WITH lookup_data AS (
    SELECT 
        row_wid AS lkp_row_wid,
        integration_id AS lkp_integration_id,
        new_bur AS lkp_new_bur
    FROM {{ source('genai_power_bi', 'lkp_w_claim_cd_bur_scd3') }}
)
SELECT * FROM lookup_data