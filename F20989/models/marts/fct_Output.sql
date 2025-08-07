-- Purpose: Write data to the target table
WITH output_data AS (
    SELECT 
        * 
    FROM {{ ref('int_exp_ROW_WID') }}
)
SELECT 
    * 
FROM output_data