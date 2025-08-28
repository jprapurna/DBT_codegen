WITH transformed_batch AS (
    SELECT 
        BATCH_ID,
        SOURCE_NAME
    FROM {{ ref('stg_cdm_batch_ctrlid') }}
)
SELECT * FROM transformed_batch