-- Purpose: Routes data based on the operation flag (INSERT or UPDATE).
WITH routed_data AS (
    SELECT 
        o_flag,
        cdm_insert_dt,
        cdm_update_dt,
        tgt_table_name
    FROM {{ ref('int_exp_flag') }}
    WHERE o_flag IN ('I', 'U')
)
SELECT * FROM routed_data