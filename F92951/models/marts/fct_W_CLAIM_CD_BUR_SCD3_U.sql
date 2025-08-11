-- Purpose: Updates data in W_CLAIM_CD_BUR_SCD3_U based on Update Strategy Expression.
WITH claim_cd_bur_scd3_u AS (
    SELECT 
        *
    FROM 
        {{ ref('int_UPD_BUR') }}
    WHERE 
        update_strategy_expression_78066 = 'DD_UPDATE'
)
SELECT 
    *
FROM 
    claim_cd_bur_scd3_u