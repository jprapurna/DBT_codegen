-- Purpose: Generates sequence values starting from 0, incrementing by 1
WITH sequence_values AS (
  SELECT 
    9174512 + ROW_NUMBER() OVER () AS nextval,
    9174512 + ROW_NUMBER() OVER () - 1 AS currval
)
SELECT 
  nextval,
  currval
FROM sequence_values