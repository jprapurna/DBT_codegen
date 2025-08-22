SELECT 
    NVL(MAX(ROW_WID), 0) AS ROW_WID, 
    '{{ tgt_table_name() }}' AS TABLE_NAME
FROM {{ schema_cdm() }}.{{ tgt_table_name() }}