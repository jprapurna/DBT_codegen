-- Purpose: Generates sequence values starting from 0, incrementing by 1
WITH sequence_values AS (
  SELECT 
    0 AS start_value,
    1 AS increment_by,
    9223372036854775807 AS end_value,
    9174512 AS current_value,
    'NO' AS cycle,
    0 AS number_of_cached_values,
    'NO' AS reset
)
SELECT 
  start_value + increment_by * ROW_NUMBER() OVER() AS nextval,
  current_value AS currval
FROM sequence_values