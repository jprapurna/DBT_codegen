-- Purpose: Generates sequence values starting from 0, incrementing by 1
WITH sequence_cte AS (
    SELECT 
        9174512 AS currval,
        9174512 + 1 AS nextval
)
SELECT 
    currval,
    nextval
FROM sequence_cte