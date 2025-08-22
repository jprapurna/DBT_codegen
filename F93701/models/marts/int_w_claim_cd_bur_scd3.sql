WITH transformed_lookup AS (
    SELECT 
        lkp_row_wid,
        lkp_integration_id,
        lkp_new_bur
    FROM {{ ref('stg_w_claim_cd_bur_scd3') }}
)
SELECT * FROM transformed_lookup