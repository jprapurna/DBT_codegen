-- Purpose: Router transformation routing data based on the value of 'o_Flag'.
SELECT *
FROM {{ ref('int_exp_flag') }}
WHERE o_Flag IN ('I', 'U')