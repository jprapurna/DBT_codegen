WITH source_data AS (
    SELECT 
        CVG_AMT,
        REPLACE(CVG_AMT, ',', '') AS v_CVG_AMT
    FROM {{ ref('source_table') }}
),
split_data AS (
    SELECT 
        v_CVG_AMT,
        {{ calculate_parts_count('v_CVG_AMT', '/') }} AS v_CVG_AMT_Parts,
        INSTR(v_CVG_AMT, '/') AS v_CVG_AMT_Part1_Pos,
        INSTR(v_CVG_AMT, '/', INSTR(v_CVG_AMT, '/') + 1) AS v_CVG_AMT_Part2_Pos,
        DECODE(v_CVG_AMT_Parts, 1, v_CVG_AMT, SUBSTR(v_CVG_AMT, 1, v_CVG_AMT_Part1_Pos - 1)) AS v_AMOUNT_FIELD1,
        DECODE(v_CVG_AMT_Parts, 2, SUBSTR(v_CVG_AMT, v_CVG_AMT_Part1_Pos + 1), SUBSTR(v_CVG_AMT, v_CVG_AMT_Part1_Pos + 1, v_CVG_AMT_Part2_Pos - v_CVG_AMT_Part1_Pos - 1)) AS v_AMOUNT_FIELD2,
        DECODE(v_CVG_AMT_Parts, 3, SUBSTR(v_CVG_AMT, v_CVG_AMT_Part2_Pos + 1), NULL) AS v_AMOUNT_FIELD3
    FROM source_data
),
converted_data AS (
    SELECT 
        v_AMOUNT_FIELD1,
        v_AMOUNT_FIELD2,
        v_AMOUNT_FIELD3,
        {{ split_limit_parts('v_AMOUNT_FIELD1', '/') }} AS CVG_AMT_1_Decimal,
        {{ split_limit_parts('v_AMOUNT_FIELD2', '/') }} AS CVG_AMT_2_Decimal,
        {{ split_limit_parts('v_AMOUNT_FIELD3', '/') }} AS CVG_AMT_3_Decimal
    FROM split_data
)
SELECT * FROM converted_data;