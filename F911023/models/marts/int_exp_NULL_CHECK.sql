-- Purpose: Check for null values in BATCH_ID.

WITH null_check AS (
    SELECT 
        batch_id, 
        source_name, 
        IIF(ISNULL(batch_id), -999, batch_id) AS o_batch_id
    FROM {{ ref('int_CDH_GW_BUR') }}
)

SELECT 
    batch_id, 
    source_name, 
    o_batch_id
FROM null_check