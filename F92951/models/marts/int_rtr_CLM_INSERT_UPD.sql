-- Purpose: Routes data to INSERT or UPDATE paths based on flag value.
WITH rtr_clm_insert_upd AS (
    SELECT 
        *
    FROM 
        {{ ref('int_EXP_Flag') }}
)
SELECT 
    *
FROM 
    rtr_clm_insert_upd
WHERE 
    o_flag = 'I' OR o_flag = 'U'