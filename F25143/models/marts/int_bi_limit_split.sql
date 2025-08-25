WITH transformed_data AS (
    SELECT
        BI_LMT,
        {{ split_bi_limit(BI_LMT)['bi_lmt_1_decimal'] }} AS BI_LMT_1_Decimal,
        {{ split_bi_limit(BI_LMT)['bi_lmt_2_decimal'] }} AS BI_LMT_2_Decimal,
        {{ split_bi_limit(BI_LMT)['bi_lmt_3_decimal'] }} AS BI_LMT_3_Decimal,
        {{ split_bi_limit(BI_LMT)['bi_lmt_no_of_parts'] }} AS BI_LMT_NO_OF_PARTS,
        {{ split_bi_limit(BI_LMT)['src_bi_lmt'] }} AS SRC_BI_LMT
    FROM {{ source('AGDM', 'DIM_AG_TRANS_TYP_PLCY') }}
)
SELECT * FROM transformed_data;