WITH source_data AS (
    SELECT
        CVG_AMT,
        REPLACE(CVG_AMT, ',', '') AS v_CVG_AMT
    FROM {{ ref('source_model') }}
),
split_data AS (
    SELECT
        v_CVG_AMT,
        LENGTH(v_CVG_AMT) - LENGTH(REPLACE(v_CVG_AMT, '/', '')) + 1 AS CVG_AMT_NO_OF_PARTS,
        {{ split_limit_parts('v_CVG_AMT', '/', 3) }} AS CVG_AMT_PARTS
    FROM source_data
)
SELECT
    v_CVG_AMT AS SRC_CVG_AMT,
    CVG_AMT_PARTS[0] AS CVG_AMT_1_DECIMAL,
    CVG_AMT_PARTS[1] AS CVG_AMT_2_DECIMAL,
    CVG_AMT_PARTS[2] AS CVG_AMT_3_DECIMAL,
    CVG_AMT_NO_OF_PARTS
FROM split_data;