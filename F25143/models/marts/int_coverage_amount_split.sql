WITH transformed_data AS (
    SELECT
        CVG_AMT,
        {{ split_coverage_amount(CVG_AMT)['cvg_amt_1_decimal'] }} AS CVG_AMT_1_Decimal,
        {{ split_coverage_amount(CVG_AMT)['cvg_amt_2_decimal'] }} AS CVG_AMT_2_Decimal,
        {{ split_coverage_amount(CVG_AMT)['cvg_amt_3_decimal'] }} AS CVG_AMT_3_Decimal,
        {{ split_coverage_amount(CVG_AMT)['cvg_amt_no_of_parts'] }} AS CVG_AMT_NO_OF_PARTS,
        {{ split_coverage_amount(CVG_AMT)['src_cvg_amt'] }} AS SRC_CVG_AMT
    FROM {{ source('AGDM', 'DIM_AG_CVG') }}
)
SELECT * FROM transformed_data;