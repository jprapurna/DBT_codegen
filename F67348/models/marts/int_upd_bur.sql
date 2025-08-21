-- Purpose: Expression transformation replacing Update Strategy Transformation.
SELECT 
    'DD_UPDATE' AS Update_Strategy_Expression_78066
FROM {{ ref('int_rtr_clm_insert_upd') }}
WHERE o_Flag = 'U'