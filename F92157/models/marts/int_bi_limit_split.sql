WITH source_data AS (
    SELECT
        BI_LMT,
        REPLACE(BI_LMT, ',', '') AS v_BI_LMT
    FROM {{ ref('source_model') }}
),
split_data AS (
    SELECT
        v_BI_LMT,
        LENGTH(v_BI_LMT) - LENGTH(REPLACE(v_BI_LMT, '/', '')) + 1 AS BI_LMT_NO_OF_PARTS,
        {{ split_limit_parts('v_BI_LMT', '/', 3) }} AS BI_LMT_PARTS
    FROM source_data
)
SELECT
    v_BI_LMT AS SRC_BI_LMT,
    BI_LMT_PARTS[0] AS BI_LMT_1_DECIMAL,
    BI_LMT_PARTS[1] AS BI_LMT_2_DECIMAL,
    BI_LMT_PARTS[2] AS BI_LMT_3_DECIMAL,
    BI_LMT_NO_OF_PARTS
FROM split_data;