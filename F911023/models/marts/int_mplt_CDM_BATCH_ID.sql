-- Purpose: Process batch ID using mapplet.

WITH processed_batch_id AS (
    SELECT 
        source_name, 
        batch_id AS o_batch_id
    FROM {{ ref('int_CDH_GW_BUR') }}
)

SELECT 
    source_name, 
    o_batch_id
FROM processed_batch_id