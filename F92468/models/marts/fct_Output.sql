-- Purpose: Write data to target table
SELECT 
    *
FROM {{ ref('int_exp_ROW_WID') }}