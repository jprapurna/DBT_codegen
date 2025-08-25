-- Purpose: Segregates data based on operation type (Insert/Update).
SELECT *
FROM {{ ref('int_exp_flag') }}
WHERE o_Flag IN ('I', 'U')