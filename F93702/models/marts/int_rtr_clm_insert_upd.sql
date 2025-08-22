SELECT *
FROM {{ ref('int_exp_flag') }}
WHERE o_Flag IN ('I', 'U')