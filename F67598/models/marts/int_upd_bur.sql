-- Purpose: Represents an Update Strategy transformation.
WITH update_data AS (
    SELECT 
        in_integration_id,
        lkp_integration_id,
        o_flag,
        batch_id,
        'DD_UPDATE' AS update_strategy_expression_78066
    FROM {{ ref('int_rtr_clm_insert_upd') }}
)
SELECT * FROM update_data